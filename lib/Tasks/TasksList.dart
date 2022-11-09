import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

import 'TasksDBWorker.dart';
import 'TasksModel.dart';

class TasksList extends StatelessWidget {
  const TasksList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
        builder: (BuildContext context, Widget child, TasksModel model) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                model.entryBeingEdited = Task();
                model.setStackIndex(1);
              }),
          body: ListView.builder(
              // a ScopedModel wrapping a Scaffold
              itemCount: tasksModel.entryList.length,
              itemBuilder: (BuildContext context, int index) {
                Task task = tasksModel.entryList[index];
                String sDueDate;
                return Slidable(
                    // delete
                    endActionPane: _deleteTask(context, model, task), // delete
                    child: ListTile(
                        leading: Checkbox(
                            value: task.completed,
                            onChanged: (value) async {
                              task.completed = value;
                              await TasksDBWorker.db.update(task);
                              tasksModel.loadData(TasksDBWorker.db);
                            }),
                        title: Text(task.description,
                            style: task.completed == true
                                ? TextStyle(
                                    color: Theme.of(context).disabledColor,
                                    decoration: TextDecoration.lineThrough)
                                : TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .color)),
                        subtitle: task.dueDate == null
                            ? null
                            : Text(sDueDate,
                                style: task.completed == true
                                    ? TextStyle(
                                        color: Theme.of(context).disabledColor,
                                        decoration: TextDecoration.lineThrough)
                                    : TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color)),
                        onTap: () async {
                          if (task.completed == true) {
                            return;
                          }
                          tasksModel.entryBeingEdited =
                              await TasksDBWorker.db.get(task.id);
                          if (tasksModel.entryBeingEdited.dueDate == null) {
                            tasksModel.setChosenDate(null);
                          } else {
                            tasksModel.setChosenDate(sDueDate);
                          }
                          tasksModel.setStackIndex(1);
                        }));
              }));
    });
  }
}

_deleteTask(BuildContext context, TasksModel model, Task task) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
            title: const Text("Deleting Task"),
            content:
                Text("Are you sure you want to delete ${task.description}?"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.of(alertContext).pop(),
              ),
              TextButton(
                  child: const Text("Delete"),
                  onPressed: () async {
                    await TasksDBWorker.db.delete(task.id);
                    Navigator.of(alertContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                        content: Text("Task deleted")));
                    model.loadData(TasksDBWorker.db);
                  })
            ]);
      });
}
