import 'package:flutte_book/BaseModel.dart';

ContactsModel contactsModel = ContactsModel();

class Contact{
  int id;

}

class ContactsModel extends BaseModel<Contact> with DateSelection{
  void setBirthday(String date){
    super.setChosenDate(date);
  }
  void triggerRebuild(){
    notifyListeners();
  }
}