import 'package:flutte_book/Notes/NotesEntry.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
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
                model.noteBeingEdited = Note();
                model.setColor(null);
                model.setStackIndex(1);
              }),
          body: ListView.builder(
              itemCount: model.noteList.length,
              itemBuilder: (BuildContext context, int index) {
                Note note = model.noteList[index];
                Color color = _toColor(note.color);
                return Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Card(
                        elevation: 8,
                        color: color,
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Text(note.content),
                          onTap: () {
                            model.noteBeingEdited = note;
                            model.setColor(model.noteBeingEdited.color);
                            model.setStackIndex(1);
                          },
                        )));
              }));
    });
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

