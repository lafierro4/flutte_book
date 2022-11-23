import 'dart:io';
import 'package:flutte_book/Contacts/Avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'ContactsDBWorker.dart';
import 'ContactsModel.dart';

class ContactsList extends StatelessWidget with Avatar {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ContactsModel>(
        model: contactsModel,
        child: ScopedModelDescendant<ContactsModel>(
            builder: (BuildContext context, Widget child, ContactsModel model) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    File avatarFile = File(avatarTempFileName());
                    if (avatarFile.existsSync()) {
                      avatarFile.deleteSync();
                    }
                    contactsModel.entryBeingEdited = Contact();
                    contactsModel.setChosenDate(null);
                    contactsModel.setStackIndex(1);
                  }),
              body: ListView.builder(
                  itemCount: contactsModel.entryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Contact contact = contactsModel.entryList[index];
                    File avatarFile = File(avatarFileName(contact.id));
                    bool avatarFileExists = avatarFile.existsSync();
                    return Column(children: [
                      Slidable(
                          endActionPane: ActionPane(
                            motion: null,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    _deleteContact(context, contact),
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                              )
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.indigoAccent,
                                foregroundColor: Colors.white,
                                backgroundImage: avatarFileExists
                                    ? FileImage(avatarFile)
                                    : null,
                                child: avatarFileExists
                                    ? null
                                    : Text(contact.name
                                        .substring(0, 1)
                                        .toUpperCase())),
                            title: Text(contact.name),
                            subtitle: contact.phone == null
                                ? Null
                                : Text(contact.phone),
                            onTap: () async {
                              File avatarFile = File(avatarTempFileName());
                              if (avatarFile.existsSync()) {
                                avatarFile.deleteSync();
                              }
                              contactsModel.entryBeingEdited =
                                  await ContactsDBWorker.db.get(contact.id);
                              if (contactsModel.entryBeingEdited.birthday ==
                                  null) {
                                contactsModel.setChosenDate(null);
                              } else {
                                List dateParts = contactsModel
                                    .entryBeingEdited.birthday
                                    .split(",");
                                DateTime birthday = DateTime(
                                    int.parse(dateParts[0]),
                                    int.parse(dateParts[1]),
                                    int.parse(dateParts[2]));
                                contactsModel.setChosenDate(
                                    DateFormat.yMMMMd("en_US")
                                        .format(birthday.toLocal()));
                              }
                              contactsModel.setStackIndex(1);
                            },
                          )),
                      const Divider(),
                    ]);
                  }));
        }));
  }

  Future _deleteContact(BuildContext context, Contact contact) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: const Text("Delete Contact"),
              content: Text("Are you sure you want to delete ${contact.name}?"),
              actions: [
                TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(inAlertContext).pop();
                    }),
                TextButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      File avatarFile = File(avatarFileName(contact.id));
                      if (avatarFile.existsSync()) {
                        avatarFile.deleteSync();
                      }
                      await ContactsDBWorker.db.delete(contact.id);
                      Navigator.of(inAlertContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("Contact deleted")));
                      contactsModel.loadData(ContactsDBWorker.db);
                    })
              ]);
        });
  }
}
