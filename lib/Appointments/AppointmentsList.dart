import 'package:flutte_book/Appointments/AppointmentsDBWorker.dart';
import 'package:flutte_book/Appointments/AppointmentsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import"package:flutter_calendar_carousel/""flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import '../utils.dart';

class AppointmentsList extends StatelessWidget {
  const AppointmentsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventList<Event> markedDateMap = EventList<Event>(events: Map());
    for (Appointment app in appointmentsModel.entryList) {
      DateTime date = toDate(app.date);
      markedDateMap.add(date, Event(date: date,
          icon: Container(
              decoration: const BoxDecoration(color: Colors.black))));
    }
    return ScopedModel<AppointmentsModel>(
        model: appointmentsModel,
        child: ScopedModelDescendant<AppointmentsModel>(
            builder: (inContext, inChild, inModel) {
              return Scaffold(
                  floatingActionButton: FloatingActionButton(
                      child: const Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        appointmentsModel.entryBeingEdited =
                            Appointment();
                        DateTime now = DateTime.now();
                        appointmentsModel.entryBeingEdited.date =
                        "${now.year},${now.month},${now.day}";
                        appointmentsModel.setChosenDate(
                            DateFormat.yMMMMd("en_US").format(
                                now.toLocal()));
                        appointmentsModel.setTime(null);
                        appointmentsModel.setStackIndex(1);
                      }
                  ),
                  body: Column(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: CalendarCarousel<Event>(
                                  thisMonthDayBorderColor: Colors.grey,
                                  daysHaveCircularBorder: false,
                                  markedDatesMap: markedDateMap,
                                  onDayPressed: (DateTime date, List<
                                      Event> events) {
                                    _showAppointments(date, context);
                                  },
                                )
                            )
                        )
                      ]
                  ));
            }));
  }

  void _showAppointments(DateTime date, BuildContext context) async {
    showModalBottomSheet(context: context,
        builder: (BuildContext context){
      return ScopedModel<AppointmentsModel>(
          model : appointmentsModel,
          child : ScopedModelDescendant<AppointmentsModel>(
          builder: (BuildContext context, Widget child, AppointmentsModel model)
      {
        return Scaffold(
            body: Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
            child: Column(children: <Widget>[
            Text(DateFormat.yMMMMd("en_US").format(date.toLocal()),
            textAlign: TextAlign.center,
            style: TextStyle(color:
            Theme.of(context).canvasColor, fontSize: 24)), // date, e.g., February 8, 2020
            Expanded(child:
            ListView.builder(
                itemCount: appointmentsModel.entryList.length,
                itemBuilder: (BuildContext context, int index) {
                  Appointment app = appointmentsModel.entryList[index];
                  if (app.date != "${date.year},${date.month},${date.day}") {
                    return Container(height: 0);
                  }
                  return Slidable(
                     // endActionPane: ActionPane
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          color: Colors.grey.shade300,
                          child: ListTile(
                              title: Text("${app.title} ${app.time}"),
                              subtitle: app.description == null ?
                              null : Text(app.description),
                              onTap: () async => _editAppointment(context, app),
                          )
                      )
                  );
                }),
            )])
        )));
  }));
  });
}

void _editAppointment(BuildContext context, Appointment appointment) async {
  appointmentsModel.entryBeingEdited = await AppointmentsDBWorker.db.get(appointment.id);
  if (appointmentsModel.entryBeingEdited.date == null) {
    appointmentsModel.setChosenDate(null);
  } else {
    List dateParts =
    appointmentsModel.entryBeingEdited.date.split(",");
    DateTime apptDate = DateTime(
        int.parse(dateParts[0]), int.parse(dateParts[1]),
        int.parse(dateParts[2]));
    appointmentsModel.setChosenDate(
        DateFormat.yMMMMd("en_US").format(apptDate.toLocal()));
  }
  if (appointmentsModel.entryBeingEdited.time == null) {
    appointmentsModel.setTime(null);
  } else {
    List timeParts =
    appointmentsModel.entryBeingEdited.time.split(",");
    TimeOfDay appTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]));
    appointmentsModel.setTime(appTime.format(context));
  }
  appointmentsModel.setStackIndex(1);
  Navigator.pop(context);
}

_deleteAppointment(BuildContext context,AppointmentsModel model, Appointment appointment){
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
            title: const Text("Deleting Appointment"),
            content: Text("Are you sure you want to delete ${appointment.title}?"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.of(alertContext).pop(),
              ),
              TextButton(
                  child: const Text("Delete"),
                  onPressed: () async {
                    await AppointmentsDBWorker.db.delete(appointment.id);
                    Navigator.of(alertContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                        content: Text("Note deleted")
                    )
                    );
                    model.loadData(AppointmentsDBWorker.db);
                  })
            ]);
      });
}

}