import "package:flutter/material.dart";
import 'dart:async';

import 'package:connectivity/connectivity.dart';

import 'package:alexsmarthome/lights.dart';
import './waterTank.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.lightBlue,
        accentColor: Colors.black87,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int ROUTE_HOME = 0;

  static const int ROUTE_WATERTANK = 11;
  static const int ROUTE_LIGHTS = 12;

  int _connectionStatus = 0;
  int _currentRoute = ROUTE_WATERTANK; //ROUTE_HOME;
  bool fillingOn = false;
  int _currentSutoFillConfig = 2;

  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> _connSub;

  @override
  void initState() {
    connectivity = new Connectivity();
    _connSub = connectivity.onConnectivityChanged
        .listen((ConnectivityResult conResult) {
      if (conResult == ConnectivityResult.mobile ||
          conResult == ConnectivityResult.wifi) {
        print("connected to the internet");
        setState(() {
          _connectionStatus = 2;
        });
      } else {
        setState(() {
          _connectionStatus = 1;
        });

        print("no internet connection");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var listView = new ListView(children: <Widget>[
      new Column(
        children: <Widget>[
          GestureDetector(
              child: Card(
                child: Column(
                  children: <Widget>[
                    Image.asset('./assets/images/smartlights.png'),
                    Text(
                      "Lights",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 45.0),
                    ),
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  _currentRoute = ROUTE_LIGHTS;
                });
                print("lights taped.");
              }),
          GestureDetector(
              child: Card(
                child: Column(
                  children: <Widget>[
                    Image.asset('./assets/images/9684514.jpg'),
                    Text(
                      "Water Tank",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 45.0),
                    ),
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  _currentRoute = ROUTE_WATERTANK;
                });
                print("water tank taped.");
              }),
        ],
      )
    ]);

    var routeBody;
    if (_connectionStatus != 2) {
      routeBody = Center(
        child: new CircularProgressIndicator(),
      );
    } else if (this._currentRoute == ROUTE_HOME) {
      routeBody = listView;
    } else if (this._currentRoute == ROUTE_WATERTANK) {
      routeBody = new WaterTank();
    } else if (this._currentRoute == ROUTE_LIGHTS) {
      routeBody = new Lights();
    }
    return new Scaffold(
      appBar: AppBar(
        title: new Text("SmartHome"),
      ),
      body: routeBody,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.wb_incandescent),
            title: new Text('Lights'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('About'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    print(index);
    if (index == 0) {
      setState(() {
        this._currentRoute = ROUTE_HOME;
      });
    } else if (index == 1) {
      setState(() {
        this._currentRoute = ROUTE_LIGHTS;
      });
    }
  }
}
