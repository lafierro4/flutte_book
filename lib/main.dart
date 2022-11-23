import 'package:flutte_book/Notes/Notes.dart';
import 'package:flutte_book/Tasks/Tasks.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'Contacts/Avatar.dart';
import 'Contacts/Contacts.dart';
import 'Drawings/DrawEntry.dart';


class ConfigModel extends Model {
  Color _color = Colors.red;

  Color get color => _color;

  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }
}

class ScopedModelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scoped Model')),
      body: ScopedModel<ConfigModel>(
        model: ConfigModel(),
        child: Column(
          children: const <Widget>[
            ScopedModelUpdater(),
            ScopedModelText('Luis Fierro')
          ],
        ),
      ),
    );
  }
}

class ScopedModelText extends StatelessWidget {
  final text;
  const ScopedModelText(this.text, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConfigModel>(
        builder: (BuildContext context, Widget child, ConfigModel config) =>
            Text('$text', style: TextStyle(color: config.color))
            );
  }
}

class ScopedModelUpdater extends StatelessWidget {
  static const _colors = [Colors.red, Colors.green, Colors.blue];
  const ScopedModelUpdater({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConfigModel>(
        builder: (BuildContext context, Widget child, ConfigModel config) =>
            DropdownButton(
                value: config.color,
                items: _colors.map((Color color) =>
                    DropdownMenuItem(
                      value: color,
                      child: Container(width: 100, height: 20, color: color),)).toList(),
                onChanged: (Color color) => config.setColor(color)
            )
    );
  }
}

void main() async{
  startMeUp() async{
    WidgetsFlutterBinding.ensureInitialized();
    Avatar.docsDir = await getApplicationDocumentsDirectory();
    runApp(const FlutterBook());
  }
  startMeUp();
}

class _Dummy extends StatelessWidget {
  final String _title;
  const _Dummy(this._title);
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Luis Fierro\'s $_title'));
  }
}


class FlutterBook extends StatelessWidget {
  const FlutterBook({Key key}) : super(key: key);
  static const _TABS = [
    {'icon': Icons.date_range, 'name': 'Appointments',},
    {'icon': Icons.contacts, 'name': 'Contacts',},
    {'icon': Icons.note, 'name': 'Notes',},
    {'icon': Icons.assignment_turned_in,'name': 'Tasks',},
    {'icon': Icons.draw, 'name':'Drawings'}
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.cyan,),
        home: DefaultTabController(
            length: _TABS.length,
            child: Scaffold(
                appBar: AppBar(
                    title: const Text('FlutterBook'),
                    bottom: TabBar(
                        indicatorColor: Colors.purple,
                        tabs: _TABS.map((tab) =>
                            Tab(icon: Icon(tab['icon']),
                                text: tab['name'])).toList()
                    )
                ),
                body: TabBarView(
                  children: <Widget> [
                    const _Dummy('Appointments'),
                    Contacts(),
                    Notes(),
                    Tasks(),
                    const Draw(),
    ]
            )
        )
    ));
  }
}

