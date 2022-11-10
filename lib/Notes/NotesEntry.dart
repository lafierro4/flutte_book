
import 'package:flutte_book/Notes/NotesDBWorker.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NotesModel.dart';

class NotesEntry extends StatelessWidget {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NotesEntry({Key key}) : super(key: key) {
    _titleEditingController.addListener(() {
      notesModel.entryBeingEdited.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      notesModel.entryBeingEdited.content = _contentEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NotesModel>(
        builder: (BuildContext context, Widget child, NotesModel model) {
      _titleEditingController.text = model.entryBeingEdited?.title;
      _contentEditingController.text = model.entryBeingEdited?.content;
      return Scaffold(
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: _buildControlButtons(context, model)),
          body: Form(
              key: _formKey,
              child: ListView(children: [
                _buildTitleListTile(),
                _buildContentListTile(),
                _buildColorListTile(context)
              ])));
    });
  }

  ListTile _buildTitleListTile() {
    return ListTile(
        leading: const Icon(Icons.title),
        title: TextFormField(
          decoration: const InputDecoration(hintText: 'Title'),
          controller: _titleEditingController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ));
  }

  ListTile _buildContentListTile() {
    return ListTile(
        leading: const Icon(Icons.content_paste),
        title: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            decoration: const InputDecoration(hintText: 'Content'),
            controller: _contentEditingController,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter content';
              }
              return null;
            }));
  }

  ListTile _buildColorListTile(BuildContext context) {
    const colors = ['red', 'green', 'blue', 'yellow', 'grey', 'purple'];
    print("colors is happening");
    return ListTile(
        leading: const Icon(Icons.color_lens),
        title: Row(children: colors.expand((c) => [_buildColorBox(context, c),
          const Spacer()]).toList()..removeLast()));
  }

  GestureDetector _buildColorBox(BuildContext context, String color) {
    final Color colorValue = _toColor(color);
    return GestureDetector(
        child: Container(
            decoration: ShapeDecoration(
                shape: Border.all(width: 16, color: colorValue) +
                    Border.all( width: 4,
                        color: notesModel.color == color ? colorValue
                            : Theme.of(context).canvasColor))
        ),
        onTap: () {
          notesModel.entryBeingEdited.color = color;
          notesModel.setColor(color);
        });
  }

  Row _buildControlButtons(BuildContext context, NotesModel model) {
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
          _save(context, notesModel);
        },
      )
    ]);
  }

  void _save(BuildContext context, NotesModel model) async  {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if(model.entryBeingEdited.id == null){
      await NotesDBWorker.db.create(notesModel.entryBeingEdited);
    } else {
      await NotesDBWorker.db.update(notesModel.entryBeingEdited);
    }
    notesModel.loadData(NotesDBWorker.db);
    model.setStackIndex(0);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
      content: Text('Note saved'),
    ));
  }
}
MaterialColor _toColor(String color) {
  switch(color){
    case 'red': return Colors.red;
    case 'green': return Colors.green;
    case 'blue': return Colors.blue;
    case 'yellow': return Colors.yellow;
    case 'purple': return Colors.purple;
    case 'grey': return Colors.grey;
    default: return Colors.white;
  }
}