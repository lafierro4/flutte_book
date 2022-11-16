import 'dart:html';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactsEntry extends StatelessWidget{
  File avatarFile;

  @override
  Widget build(BuildContext context) {
    return
  }


  Future<void> _selectAvatar(BuildContext context){
    showDialog(context: context, builder: (BuildContext dialogContext){
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListView(
            children: <Widget>[
              GestureDetector(
                child: Text("Take A Picture"),
                onTap: () async{
                  var cameraImage = await ImagePicker.pickImage(source: ImageSource.camera);
                  if (cameraImage != null) {
                    cameraImage.copySync(_avatarTempFileName());
                    contactsModel.triggerRebuild();
                  }
                  Navigator.of(dialogContext).pop();
                },
              )
            ],
          ),
        ),
      );
    }
    );
  }

}