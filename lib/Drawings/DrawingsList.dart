import 'Drawings.dart';
import 'DrawingsDBWorker.dart';
import 'DrawingsModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class DrawingsList extends StatelessWidget{
  const DrawingsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DrawingsModel>(
        builder: (BuildContext context, Widget child, DrawingsModel model){
          return Scaffold(
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  model.entryBeingEdited = Drawing();
                  model.setStackIndex(1);
                }),
            body: ListView.builder(
                itemCount: model.entryList.length,
                itemBuilder: (BuildContext context, int index){
                  Drawing drawing = model.entryList[index];
                  return Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Slidable(
                      endActionPane: ActionPane(
                        extentRatio: .25,
                        motion: const ScrollMotion(),
                        children: <Widget>[
                          SlidableAction(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            label: "Delete",
                            icon: Icons.delete,
                            onPressed: (ctx) =>
                                _deleteDrawing(context, model, drawing),
                          )
                        ],
                      ),
                      child: Card(
                        elevation: 8,
                        child: ListTile(
                          title: Text(drawing.title),
                          onTap: () {
                            model.entryBeingEdited = drawing;
                            model.setStackIndex(1);
                          },
                        ),
                      ),
                    ),
                  );
                }
            ),
          );
        }
    );
  }}

_deleteDrawing(BuildContext context, DrawingsModel model, Drawing drawing){
  return showDialog(context: context,
      builder: (BuildContext alertContext){
    return AlertDialog(
      title: const Text("Deleting Drawing"),
      content: Text('Are you sure tou want to delete ${drawing.title}?'),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(alertContext).pop(),
          ),
          TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                await DrawingsDBWorker.db.delete(drawing.id);
                Navigator.of(alertContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    content: Text("Note deleted")
                )
                );
                print('deleted $drawing');
                model.loadData(DrawingsDBWorker.db);
              })
        ]);
      });
}