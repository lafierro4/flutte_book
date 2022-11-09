import 'package:flutte_book/Notes/NotesDBWorker.dart';
import 'package:flutte_book/Notes/NotesEntry.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'NotesModel.dart';

class NotesList extends StatelessWidget {
  const NotesList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NotesModel>(
        builder: (BuildContext context, Widget child, NotesModel model) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                model.entryBeingEdited = Note();
                model.setColor(null);
                model.setStackIndex(1);
              }),
          body: ListView.builder(
              itemCount: model.entryList.length,
              itemBuilder: (BuildContext context, int index) {
                Note note = model.entryList[index];
                Color color = _toColor(note.color);
                return Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Slidable(
                        child: Slidable(
                            endActionPane: ActionPane(
                              extentRatio: .25,
                              motion: ScrollMotion(),
                              children: <Widget>[
                                SlidableAction(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  label: "Delete",
                                  icon: Icons.delete,
                                  onPressed: (ctx) =>
                                      _deleteNote(context, model, note),
                                )
                              ],
                            ),
                            child: Card(
                                elevation: 8,
                                color: color,
                                child: ListTile(
                                  title: Text(note.title),
                                  subtitle: Text(note.content),
                                  onTap: () {
                                    model.entryBeingEdited = note;
                                    model
                                        .setColor(model.entryBeingEdited.color);
                                    model.setStackIndex(1);
                                  },
                                )))));
              }));
    });
  }
}

_deleteNote(BuildContext context, NotesModel model, Note note) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
            title: const Text("Deleting Note"),
            content: Text("Are you sure you want to delete ${note.title}?"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.of(alertContext).pop(),
              ),
              TextButton(
                  child: const Text("Delete"),
                  onPressed: () async {
                    await NotesDBWorker.db.delete(note.id);
                    Navigator.of(alertContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                        content: Text("Note deleted")));
                    model.loadData(NotesDBWorker.db);
                  })
            ]);
      });
}

MaterialColor _toColor(String color) {
  switch (color) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'blue':
      return Colors.blue;
    case 'yellow':
      return Colors.yellow;
    case 'purple':
      return Colors.purple;
    case 'grey':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}
