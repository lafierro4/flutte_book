import 'dart:io';

mixin Avatar{
  static Directory docsDir;
  File avatarTempFile(){
    return File(avatarTempFileName());
  }

}