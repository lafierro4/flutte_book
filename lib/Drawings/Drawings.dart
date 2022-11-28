

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'DrawingsDBWorker.dart';
import 'DrawingsEntry.dart';
import 'DrawingsList.dart';
import 'DrawingsModel.dart';

class Drawings extends StatelessWidget {
  Drawings({Key key}) :  super(key: key){
    drawingsModel.loadData(DrawingsDBWorker.db);
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModel<DrawingsModel>(
        model: drawingsModel,
        child: ScopedModelDescendant<DrawingsModel>(
            builder: (BuildContext context, Widget child, DrawingsModel model) {
              return IndexedStack(
                index: model.stackIndex,
                children: <Widget>[const DrawingsList(), DrawingsEntry()],
              );
            }));
  }
}