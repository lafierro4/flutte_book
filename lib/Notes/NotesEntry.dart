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
      notesModel.noteBeingEdited.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      notesModel.noteBeingEdited.content = _contentEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NotesModel>(
        builder: (BuildContext context, Widget child, NotesModel model) {
      _titleEditingController.text = model.noteBeingEdited?.title;
      _contentEditingController.text = model.noteBeingEdited?.content;
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
    return ListTile(
        leading: const Icon(Icons.color_lens),
        title: Row(
            children: colors.expand((c) => [_buildColorBox(context, c), const Spacer()])
                .toList()
              ..removeLast()));
  }

  GestureDetector _buildColorBox(BuildContext context, String color) {
    final Color colorValue = _toColor(color);
    return GestureDetector(
        child: Container(
            decoration: ShapeDecoration(
                shape: Border.all(width: 16, color: colorValue) +
                    Border.all(
                        width: 4,
                        color: notesModel.color == color
                            ? colorValue
                            : Theme.of(context).canvasColor))),
        onTap: () {
          notesModel.noteBeingEdited.color = color;
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

  void _save(BuildContext context, NotesModel model) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (!model.noteList.contains(model.noteBeingEdited)) {
      model.noteList.add(model.noteBeingEdited);
    }
    model.setStackIndex(0);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
      content: Text('Note saved'),
    ));
  }
}
Color _toColor(String color) {
  switch(color){
    case 'red':
      return const Color(0x00fc2803);
    case 'green':
      return const Color(0x0008bd47);
    case 'blue':
      return const Color(0x001212cc);
    case 'yellow':
      return const Color(0x00cce320);
    case 'purple':
      return const Color(0x00b41ae8);
    case 'gray':
      return const Color(0x006b6868);
    default:
      return const Color(0xffffffff);
  }
}
