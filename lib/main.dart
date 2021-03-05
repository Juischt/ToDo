import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_automation/flutter_automation.dart';

void main() => runApp(MaterialApp(home: ToDoList()));

class SingleToDo extends StatelessWidget {
  final String title;
  final String short_title;
  final bool done;
  final bool chosen;
  final Function remove;
  final Function toggleDone;
  final Function hover;

  const SingleToDo(this.title, this.short_title, this.done, this.chosen,
      this.remove, this.toggleDone, this.hover);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () => Navigator.of(context).push(DetailScreen(title, done)),
        onDoubleTap: () => remove(),
        //onHorizontalDragDown: (e) => ,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: chosen ? Colors.teal : Colors.black12,
            border: Border.all(color: Colors.black45, width: 2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 22,
          ),
          child: ListTile(
              leading: Checkbox(
                value: done,
                onChanged: (bool value) => toggleDone(),
                checkColor: chosen ? Colors.teal : Colors.white,
                activeColor: chosen ? Colors.white : Colors.teal,
              ),
              title: Text(
                short_title,
                style: TextStyle(
                  fontSize: 22.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: done ? "Lucida" : "Arial",
                  fontStyle: done ? FontStyle.italic : FontStyle.normal,
                  color: chosen ? Colors.white : Colors.teal,
                  decoration:
                  done ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_forever_outlined,
                  color: chosen ? Colors.white : Colors.teal,
                ),
                onPressed: () => remove(),
              )),
        ));
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  Map<String, bool> ToDos = {};
  Map<String, bool> chosenToDo = {};
  Map<String, bool> switchToDos = {};

  String short_title(String key) {
    String short = key;
    if (key.length > 10) {
      short = key.substring(10);
      short = "...";
      short = key.substring(0, 9) + short;
    }

    return short;
  }

  void addToDo(String item) {
    setState(() {
      ToDos[item] = false;
      chosenToDo[item] = false;
    });
    Navigator.of(context).pop();
  }

  void deleteToDo(key) {
    setState(() {
      ToDos.remove(key);
      chosenToDo.remove(key);
    });
  }

  void toggleDone(String key) {
    setState(() {
      ToDos.update(key, (bool done) => !done);
    });
  }

  void hover(String key) {
    setState(() {
      chosenToDo.update(key, (bool chosen) => !chosen);
    });
  }

  /*void dragToDo(String key, String key2) {
    setState(() {
      switchToDos[1] = ToDos[key];
      ToDos[key] = ToDos[key2];
      ToDos[key2] = switchToDos[1];

      ToDos.update(key, (bool done) => !done);
      ToDos.update(key2, (bool done) => done);
    });
  }*/

  void newEntry() {
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  onSubmitted: addToDo,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Neuer ToDo Eintrag',
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ToDo Liste',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Arial",
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: ToDos.length,
        itemBuilder: (context, i) {
          String key = ToDos.keys.elementAt(i);
          String key2 = ToDos.keys.elementAt(i++);

          return SingleToDo(
            key,
            short_title(key),
            ToDos[key],
            chosenToDo[key],
                () => deleteToDo(key),
                () => toggleDone(key),
                () => hover(key),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: newEntry,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

Route DetailScreen(String title, bool done) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        DetailScreenWidget(title, done),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class DetailScreenWidget extends StatelessWidget {
  const DetailScreenWidget(this.title, this.done);
  final String title;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: done ? Colors.teal : Color.fromRGBO(153, 53, 53, 100),
      appBar: AppBar(
        title: Text(
          'Detail Screen',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(20),
                    //alignment: Alignment.center,
                    child: Text(
                      done
                          ? 'Das hast du schon erledigt:'
                          : 'Das musst du noch machen:',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: "Arial",
                          fontWeight: FontWeight.w600),
                    ))),
            Expanded(
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, i) {

                  return Container(
                    alignment: Alignment.center,
                    child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.white)
                            ),
                  );
                  }
                ),
            ),

            Expanded(
              child: IconButton(
                iconSize: 60,
                onPressed: () => Navigator.pop(context),
                icon:
                Icon(done ? Icons.check : Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
