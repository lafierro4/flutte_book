

import 'package:flutte_book/Appointments/AppointmentsModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import"package:flutter_calendar_carousel/""flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";

import '../utils.dart';

class AppointmentsList extends StatelessWidget{
  const AppointmentsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  EventList<Event> markedDateMap = EventList<Event>(events: Map());
  for (Appointment app in appointmentsModel.entryList) {
  DateTime date = toDate(app.date);
  markedDateMap.add(date, Event(date: date,
  icon: Container(decoration: const BoxDecoration(color: Colors.black))));
  }
  return ScopedModel<AppointmentsModel>(
  body: Column(
  children: <Widget>[
  Expanded(
  child: Container(
  margin: EdgeInsets.symmetric(horizontal: 10),
  child: CalendarCarousel<Event>(
  thisMonthDayBorderColor: Colors.grey,
  daysHaveCircularBorder: false,
  markedDatesMap: markedDateMap,
  onDayPressed: (DateTime date, List<Event> events) {
  _showAppointments(date, context);
  },
  …
  }
void _showAppointments(DateTime date, BuildContext context) async {

  showModalBottomSheet(

  builder: (BuildContext context, Widget child, AppointmentsModel model) {



  Column(children: <Widget>[
  Text(…), // date, e.g., February 8, 2020

  Expanded(child:
  ListView.builder(
  itemCount: appointmentsModel.entityList.length,
  itemBuilder: (BuildContext context, int index) {
  Appointment app = appointmentsModel.entityList[index];

  if (app.date != "${date.year},${date.month},${date.day}") {

  return Container(height: 0);

  }

  return Slidable( …

  child: Container( …
  child: ListTile( …
  onTap: () async => _editAppointment(context, app);
  )
  ),
  endActionPane: …
  onPressed: (ctx) => _deleteAppointment(context, app),
}