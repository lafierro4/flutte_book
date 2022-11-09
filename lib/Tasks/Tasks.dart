import 'package:flutte_book/Tasks/TasksDBWorker.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'TasksList.dart';
import 'TasksModel.dart' show TasksModel, tasksModel;
import 'TasksEntry.dart';

class Tasks extends StatelessWidget {
  Tasks({Key key}) : super(key: key){
    tasksModel.loadData(TasksDBWorker.db);
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModel<TasksModel>(
        model: tasksModel,
        child: ScopedModelDescendant<TasksModel>(
            builder: (BuildContext context, Widget child, TasksModel model) {
              return IndexedStack(
                index: model.stackIndex,
                children: <Widget>[TasksList(), TasksEntry()],
              );
            }));
  }
}