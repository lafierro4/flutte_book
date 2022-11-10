import 'package:flutte_book/Appointments/AppointmentsDBWorker.dart';
import 'package:flutte_book/Appointments/AppointmentsList.dart';
import 'package:flutte_book/Appointments/AppointmentsModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Appointments extends StatelessWidget {
  Appointments({Key key}) :  super(key: key){
    appointmentsModel.loadData(AppointmentsDBWorker().db);
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppointmentsModel>(
        model: appointmentsModel,
        child: ScopedModelDescendant<AppointmentsModel>(
            builder: (BuildContext context, Widget child, AppointmentsModel model) {
              return IndexedStack(
                index: model.stackIndex,
                children: <Widget>[const AppointmentsList(), AppointmentsEntry()],
              );
            }));
  }
}