import 'package:flutte_book/Tasks/TasksDBWorker.dart';
import 'package:flutte_book/Tasks/TasksModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../utils.dart';

class TasksEntry extends StatelessWidget {
  final TextEditingController _contentEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TasksEntry({Key key}) : super(key: key) {
    _contentEditingController.addListener(() {
      tasksModel.entryBeingEdited.description = _contentEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
        builder: (BuildContext context, Widget child, TasksModel model) {
      _contentEditingController.text = model.entryBeingEdited?.description;
      return Scaffold(
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: _buildControlButtons(context, model)),
          body: Form(
              key: _formKey,
              child: ListView(children: [
                _buildContentListTile(),
                ListTile(
                  leading: const Icon(Icons.today),
                  title: const Text("Due Date"),
                  subtitle: Text(_dueDate()),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    color: Colors.blue,
                    onPressed: () async {
                      String chosenDate = await selectDate(context, tasksModel,
                          tasksModel.entryBeingEdited.dueDate);
                      if (chosenDate != null) {
                        tasksModel.entryBeingEdited.dueDate = chosenDate;
                      }
                    },
                  ),
                )
              ])));
    });
  }

  ListTile _buildContentListTile() {
    return ListTile(
        leading: const Icon(Icons.description),
        title: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            decoration: const InputDecoration(hintText: 'Description'),
            controller: _contentEditingController,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            }));
  }

  Row _buildControlButtons(BuildContext context, TasksModel model) {
    return Row(children: [
      TextButton(
        child: const Text('Cancel'),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          model.setStackIndex(0);
        },
      ),
      const Spacer(),
      TextButton(
        child: const Text('Save'),
        onPressed: () {
          _save(context, tasksModel);
        },
      )
    ]);
  }

  void _save(BuildContext context, TasksModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (model.entryBeingEdited.id == null) {
      await TasksDBWorker.db.create(tasksModel.entryBeingEdited);
    } else {
      await TasksDBWorker.db.update(tasksModel.entryBeingEdited);
    }
    tasksModel.loadData(TasksDBWorker.db);
    model.setStackIndex(0);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
      content: Text('Task saved'),
    ));
  }
}

String _dueDate() {
  if (tasksModel.entryBeingEdited != null &&
      tasksModel.entryBeingEdited.hasDueDate()) {
    return tasksModel.entryBeingEdited.dueDate;
  }
  return '';
}
