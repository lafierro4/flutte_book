import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'DrawingsDBWorker.dart';
import 'DrawingsModel.dart';

class DrawingsEntry extends StatefulWidget {
  final TextEditingController _titleEditingController = TextEditingController();
  DrawingsEntry({Key key}) : super(key: key){
    _titleEditingController.addListener(() {
      drawingsModel.entryBeingEdited.title = _titleEditingController.text;
    });
  }

  @override
  createState() => _DrawingEntry();
}

class _DrawingEntry extends State<DrawingsEntry> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  List<Points> points = [];
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.black,
    Colors.grey,
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.white10),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: getColorList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        child: Column( children: const <Widget>[
                            Icon(Icons.edit_off),
                          Text("Erase")
                        ],),
                        onPressed: (){
                          setState(() {
                            selectedColor = Colors.white60;
                          });
                        }),
                      ElevatedButton(
                          child: Column( children: const <Widget>[
                            Icon(Icons.clear),
                            Text("Clear")
                          ],),
                          onPressed: () {
                            setState(() {
                              points.clear();
                            });
                          }),
                      ElevatedButton(
                          child: Column( children: const <Widget>[
                            Icon(Icons.save),
                            Text("Save")
                          ],),
                          onPressed: () {
                            setState(() {
                              _save(context,drawingsModel);
                            });
                          }),
                      if(selectedColor != Colors.white60)...{
                        Container(color: selectedColor, width: 60, height: 40,)
                      }else...{
                        Container(color: Colors.white60, width: 60, height: 40,
                          child: const Text("Erasing",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,),
                        )
                      }
                    ],
                  ),

                ],
              ),
            )),
      body: Column( children: <Widget> [
        TextFormField(
          decoration: const InputDecoration(hintText: 'Title'),
          controller: widget._titleEditingController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },),
        Expanded( child:GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            points.add(Points(
                origins: renderBox.globalToLocal(details.globalPosition),
                paint: Paint()
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(1.0)
                  ..strokeWidth = 3.0));
          });
        },
        onPanStart: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            points.add(
                Points(
                origins: renderBox.globalToLocal(details.globalPosition),
                paint: Paint()
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(1.0)
                  ..strokeWidth = 3.0));
          });
        },
        onPanEnd: (details) {
          setState(() {
    points.add(null);
          });
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: MyScreenDrawer(
            drawingPoints: points,
          ),
        ),),
        )]
      ));
  }

  getColorList() {
    List<Widget> colorList = [];
    for (Color color in colors) {
      colorList.add(colorCircle(color));
    }
    return colorList;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
        child: Container(
          decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black) ),
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
        ),
      );
  }
}
void _save(BuildContext context, DrawingsModel model) async  {
  if(model.entryBeingEdited.id == null){
    await DrawingsDBWorker.db.create(drawingsModel.entryBeingEdited);
  } else {
    await DrawingsDBWorker.db.update(drawingsModel.entryBeingEdited);
  }
  drawingsModel.loadData(DrawingsDBWorker.db);
  model.setStackIndex(0);
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    backgroundColor: Colors.green,
    duration: Duration(seconds: 2),
    content: Text('Note saved'),
  ));
}

class MyScreenDrawer extends CustomPainter {
  MyScreenDrawer({this.drawingPoints});
  List<Points> drawingPoints;
  List<Offset> offsetPoints = [];
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i].origins, drawingPoints[i + 1].origins,
            drawingPoints[i].paint);
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(drawingPoints[i].origins);
        offsetPoints.add(Offset(
            drawingPoints[i].origins.dx + 0.1, drawingPoints[i].origins.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, drawingPoints[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(MyScreenDrawer oldDelegate) => true;
}

class Points{
  Paint paint;
  Offset origins;

  Points({this.paint, this.origins});
}
