import 'package:scoped_model/scoped_model.dart';

NotesModel notesModel = NotesModel();

class Note {
  String title;
  String content;
  String color;

  Note();

  @override
  String toString() => "{title=$title, content=$content, color=$color }";
}

class NotesModel extends Model {

  List<Note> noteList = [];
  Note noteBeingEdited;
  String color;
  var _stackIndex = 0;

  int get stackIndex => _stackIndex;

  void setColor(String color) {
    this.color = color;
    notifyListeners();
  }

  void setStackIndex(int i) {
    _stackIndex = stackIndex;
    notifyListeners();
  }
}

