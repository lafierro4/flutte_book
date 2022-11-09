import 'package:flutter/material.dart';
import "dart:io";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:intl/intl.dart";
import "BaseModel.dart";

Directory docsDir;
Future<String> selectDate(BuildContext context, dynamic model, String date) async {
  DateTime initialDate = date != null ?  toDate(date) : DateTime.now();
  DateTime picked = await showDatePicker(
  context: context,
  initialDate: initialDate,
  firstDate: DateTime(1900),
  lastDate: DateTime(2100));
  if (picked != null) {
  model.setChosenDate(DateFormat.yMMMMd('en_US').format(picked.toLocal()));
  }
  return "${picked.year},${picked.month},${picked.day}";
}

DateTime toDate(String date) {
  List<String> parts = date.split(",");
  return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}