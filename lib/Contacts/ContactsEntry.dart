import 'dart:io';
import 'package:flutte_book/Contacts/Avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import '../utils.dart';
import 'ContactsModel.dart';

class ContactsEntry extends StatelessWidget with Avatar {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: contactsModel,
        child: ScopedModelDescendant<ContactsModel>(
            builder: (BuildContext context, Widget child, ContactsModel model) {
          File avatarFile = File(avatarTempFileName());
          if (avatarFile.existsSync() == false) {
            if (model.entryBeingEdited != null &&
                model.entryBeingEdited.id != null) {
              avatarFile = File(avatarFileName(model.entryBeingEdited.id));
            }
          }
          return Scaffold(
              bottomNavigationBar: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(children: [
                    TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          File avatarFile = File(avatarTempFileName());
                          if (avatarFile.existsSync()) {
                            avatarFile.deleteSync();
                          }
                          FocusScope.of(context).requestFocus(FocusNode());
                          model.setStackIndex(0);
                        }),
                    const Spacer(),
                    TextButton(
                        child: const Text("Save"),
                        onPressed: () {
                          _save(context, model);
                        })
                  ])),
              body: Form(
                  key: key,
                  child: ListView(children: [
                    ListTile(
                        title: avatarFile.existsSync()
                            ?
                            // Image.file(avatarFile)
                            Image.memory(
                                Uint8List.fromList(
                                    avatarFile.readAsBytesSync()),
                                alignment: Alignment.center,
                                height: 200,
                                width: 200,
                                fit: BoxFit.contain,
                              )
                            : const Text("No avatar image for this contact"),
                        trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () => _selectAvatar(context))),
                    ListTile(
                        leading: const Icon(Icons.person),
                        title: TextFormField(
                            decoration: const InputDecoration(hintText: "Name"),
                            controller: _nameEditingController,
                            validator: (String inValue) {
                              if (inValue.isEmpty) {
                                return "Please enter a name";
                              }
                              return null;
                            })),
                    ListTile(
                        leading: const Icon(Icons.phone),
                        title: TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration:
                                const InputDecoration(hintText: "Phone"),
                            controller: _phoneEditingController)),
                    ListTile(
                        leading: const Icon(Icons.email),
                        title: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                const InputDecoration(hintText: "Email"),
                            controller: _emailEditingController)),
                    ListTile(
                        leading: const Icon(Icons.today),
                        title: const Text("Birthday"),
                        subtitle: Text(contactsModel.chosenDate ?? ""),
                        trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () async {
                              String chosenDate = await selectDate(
                                  context,
                                  contactsModel,
                                  contactsModel.entryBeingEdited.birthday);
                              if (chosenDate != null) {
                                contactsModel.entryBeingEdited.birthday =
                                    chosenDate;
                              }
                            }))
                  ])));
        }));
  }

  Future<void> _selectAvatar(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    child: const Text("Take A Picture"),
                    onTap: () async {
                      var cameraImage = await ImagePicker().getImage(source: ImageSource.camera);
                      if (cameraImage != null) {
                        //cameraImage.copySync(avatarTempFileName());
                        contactsModel.triggerRebuild();
                      }
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  const Divider(),
              GestureDetector(
              child: const Text("Select From Gallery"),
              onTap: () async {
    var galleryImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (galleryImage != null) {
    //galleryImage.copySync(avatarTempFileName());
    imageCache.clear();
    contactsModel.triggerRebuild();
    }
    Navigator.of(dialogContext).pop();
              } ) ]
              ) ) ); },
    ); }
  _save(BuildContext context, ContactsModel model){
        print("saved");
    }


}
