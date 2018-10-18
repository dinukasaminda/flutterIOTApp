import "package:flutter/material.dart";
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class Lights extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LightsState();
}

class _LightsState extends State<Lights> {
  static const int ROUTE_WATERTANK = 11;

  int _SmartLED1_STATE = 0;
  static const String dbCollToLights = "lights";
  final DatabaseReference database =
      FirebaseDatabase.instance.reference().child("" + dbCollToLights);

  @override
  void initState() {
    super.initState();

    database.child("SmartLED1_STATE").once().then(_onDataInit);

    database.onChildChanged.listen(_onDataChanged);
  }

  void _onDataInit(DataSnapshot snapshot) {
    print("function called");
    print(snapshot.value.toString());
    var v = int.tryParse(snapshot.value.toString());
    setState(() {
      _SmartLED1_STATE = v;
    });
  }

  void _onDataChanged(Event event) {
    DataSnapshot datasnapshot = event.snapshot;

    if (datasnapshot.key == "SmartLED1_STATE") {
      var v = int.tryParse(datasnapshot.value.toString());
      if (_SmartLED1_STATE != v) {
        setState(() {
          _SmartLED1_STATE = v;
        });
      }
    }
  }

  Future<void> _SmartLED1_STATE_Changed(double e) async {
    database.child("SmartLED1_STATE").set((e).toInt());
    setState(() {
      _SmartLED1_STATE = (e).toInt();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headline.copyWith(color: Colors.green);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: DefaultTextStyle(
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: descriptionStyle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "SmartLED1 :${_SmartLED1_STATE} Brightness",
                        style: titleStyle,
                      ),
                      // three line description

                      Slider(
                        value: 0.0 + _SmartLED1_STATE,
                        onChanged: (double e) => _SmartLED1_STATE_Changed(e),
                        divisions: 255,
                        min: 0.0,
                        max: 255.0,
                      ),
                      Text("Switch:"),
                      Switch(
                          value: _SmartLED1_STATE > 0,
                          activeColor: Colors.redAccent,
                          onChanged: (bool value) {
                            _SmartLED1_STATE_Changed(
                                value == true ? 100.0 : 0.0);
                          })
                    ],
                  ),
                ),
              ),
            ),
            // share, explore buttons
            ButtonTheme.bar(
              child: ButtonBar(
                alignment: MainAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    child: const Text('RESET'),
                    textColor: Colors.black26,
                    onPressed: () {/* do nothing */},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
