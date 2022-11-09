import 'package:flutte_book/BaseModel.dart';
import 'package:scoped_model/scoped_model.dart';

NotesModel notesModel = NotesModel();

class Note {
  int id;
  String title;
  String content;
  String color;

  Note();

  @override
  String toString() => "{title=$title, content=$content, color=$color }";
}

class NotesModel extends BaseModel<Note> {

  String color;

  void setColor(String color) {
    this.color = color;
    notifyListeners();
  }


}

