import "package:flutter/material.dart";

import 'package:firebase_database/firebase_database.dart';

class WaterTank extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _WaterTankState();
}

class _WaterTankState extends State<WaterTank> {
  static const int ROUTE_WATERTANK = 11;

  double _liveWaterLevel = 0.0;
  bool fillingOn = false;
  int _currentSutoFillConfig = 2;
//last_distance_state
  static const String dbCollToWaterTank = "watertank";
  final DatabaseReference database =
      FirebaseDatabase.instance.reference().child("" + dbCollToWaterTank);

  static const List<String> AutoFillgConfigList = [
    "1%",
    "10%",
    "25%",
    "50%",
    "75%",
    "90%",
    "Disable"
  ];

  @override
  void initState() {
    super.initState();

    database.child("last_distance_state").once().then(_onDataInit);

    database.onChildChanged.listen(_onDataChanged);
  }

  void _onDataInit(DataSnapshot snapshot) {
    print("function called");
    print(snapshot.value.toString());
    var waterLevel = double.tryParse(snapshot.value.toString());
    setState(() {
      _liveWaterLevel = waterLevel;
    });
  }

  void _onDataChanged(Event event) {
    DataSnapshot datasnapshot = event.snapshot;

    if (datasnapshot.key == "last_distance_state") {
      var waterLevel = double.tryParse(datasnapshot.value.toString());
      setState(() {
        _liveWaterLevel = waterLevel;
      });
    }
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
    final int LastliveWaterLavel = _liveWaterLevel.round();
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
                        "Water Level :-${LastliveWaterLavel} cm",
                        style: titleStyle,
                      ),
                      // three line description
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Capacity : 300/500 l",
                          style:
                              descriptionStyle.copyWith(color: Colors.black54),
                        ),
                      ),
                      Text("enough for : 1 Day "),
                      Text("State : + 50 l/minute"),
                      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text("Filling Valv:"),
                        Switch(
                            value: fillingOn,
                            activeColor: Colors.redAccent,
                            onChanged: (bool value) {
                              setState(() {
                                fillingOn = value;
                                print(value);
                              });
                            })
                      ]),
                      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text("Auto Filling when : "),
                        DropdownButton<String>(
                            value: AutoFillgConfigList[_currentSutoFillConfig],
                            items: AutoFillgConfigList.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (v) {
                              setState(() {
                                _currentSutoFillConfig =
                                    AutoFillgConfigList.indexOf(v);
                              });
                            })
                      ]),
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
