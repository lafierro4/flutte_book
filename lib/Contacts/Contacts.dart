import 'package:flutte_book/Contacts/ContactsDBWorker.dart';
import 'package:flutte_book/Contacts/ContactsEntry.dart';
import 'package:flutte_book/Contacts/ContactsList.dart';
import 'package:flutte_book/Contacts/ContactsModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Contacts extends StatelessWidget {
  Contacts({Key key}) :  super(key: key){
    contactsModel.loadData(ContactsDBWorker.db);
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ContactsModel>(
        model: contactsModel,
        child: ScopedModelDescendant<ContactsModel>(
            builder: (BuildContext context, Widget child, ContactsModel model) {
              return IndexedStack(
                index: model.stackIndex,
                children: <Widget>[ContactsList(), ContactsEntry()],
              );
            }));
  }
}