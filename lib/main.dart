import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'dart:core';
import 'dart:async';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
      color: Colors.tealAccent,
      title: "Stopwatch",
      debugShowCheckedModeBanner: false,
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 20,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: img()),
            Container(
              padding: EdgeInsets.fromLTRB(10, 20, 5, 10),
              child: ListTile(
                leading: Icon(
                  Icons.alarm_on,
                  size: 45,
                  color: Colors.indigo,
                ),
                title: Text(
                  "Stopwatch",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                subtitle: Text("Optimized for Android"),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.developer_mode,
                color: Colors.pink,
              ),
              trailing: Icon(
                Icons.android,
                color: Colors.greenAccent.shade700,
                size: 25,
              ),
              title: Text("Developer"),
              subtitle: Text(
                "Masum Khan",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.help_outline,
                color: Colors.pink,
              ),
              title: Text("Help/Support E-mail"),
              subtitle: Text("masumkhancse@gmail.com"),
            ),
            GestureDetector(
              onLongPress: () {
                //  _launchURL();
              },
              onTap: () {
                // _launchURL();
              },
              child: ListTile(
                leading: Icon(
                  Icons.link,
                  color: Colors.pink,
                ),
                title: Text("Developer's Website"),
                subtitle: Text("https://masumkhan.com",
                    style: TextStyle(color: Colors.blue)),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Colors.pink,
              ),
              title: Text("App Version"),
              subtitle: Text("Version 1.0.0"),
            ),
          ],
        ),
      ),
//
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 5,
        backgroundColor: Colors.blue,
        title: Text(
          "STOPWATCH",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          tooltip: "App Drawer",
          icon: Icon(
            Icons.alarm_on,
            color: Colors.white,
          ),
          iconSize: 30,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      extendBody: true,
      body: sw(),
    );
  }

  Widget img() {
    var assetImage = AssetImage("assets/icon/sw.png");
    var image = Image(
      image: assetImage,
      width: 60,
      height: 60,
    );
    return image;
  }
}

class sw extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return swState();
  }
}

class swState extends State<sw> {
  static List laptime = [];
  static int hr = 0, min = 0;
  static String str_hr = "0", str_min = "0";
  static int elapsed = 3600000;
  static int i = 0;
  var displayTime;
  var value;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    onChange: (value) {
      var temp = value;
      min = ((temp - (i * elapsed)) / 60000).floor();
      hr = (value / 3600000).floor();
      if (min > 9) str_min = "";
      if (min > 59) {
        i += 1;
        min = 0;
        str_min = "0";
      }
      if (hr > 9) str_hr = "";
      print('onChange $value and $hr');
    },
    onChangeSecond: (value) => print('onChangeSecond $value'),
    onChangeMinute: (value) => print('onChangeMinute $value'),
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
        ),
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: img(),
            fit: BoxFit.contain,
//            colorFilter: ColorFilter.linearToSrgbGamma(),
          )),
          child:

              /// Display stop watch time
              Container(
            padding: const EdgeInsets.only(bottom: 80, top: 100),
            child: StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snap) {
                value = snap.data;
                displayTime = StopWatchTimer.getDisplayTime(value);
                return Column(
                  ///
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            elevation: 10,
                            child: Text(
                              "$str_hr$hr",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          GlowingProgressIndicator(
                            child: Text(
                              ":",
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            child: Text(
                              "$str_min$min",
//                              "$displayTime".split(".")[0].split(":")[0],
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          GlowingProgressIndicator(
                            child: Text(
                              ":",
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            child: Text(
                              "$displayTime".split(".")[0].split(":")[1],
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          GlowingProgressIndicator(
                            child: Text(
                              ":",
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            child: Text(
                              "$displayTime".split(".")[1],
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "  HH   ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            ": ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "  MM  ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            ": ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "   SS   ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            " : ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "   ms  ",
                            style: TextStyle(fontSize: 15),
                          ),
                        ]),

                    ///
                  ],
                );
              },
            ),
          ),
        ),

        /// Buttons
        //PAUSE Button
        Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ButtonTheme(
                          minWidth: 60,
                          height: 60,
                          child: RaisedButton(
                            elevation: 5,
                            padding: const EdgeInsets.all(4),
                            color: Colors.white,
                            shape: const StadiumBorder(),
                            onPressed: () async {
                              _stopWatchTimer.onExecute
                                  .add(StopWatchExecute.stop);
                            },
                            child: Icon(
                              Icons.pause,
                              color: Colors.blue,
                              size: 45,
                            ),
                          ),
                        ),
                      ),
//PLAY START Button
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ButtonTheme(
                          minWidth: 75,
                          height: 75,
                          child: RaisedButton(
                            elevation: 5,
                            padding: const EdgeInsets.all(4),
                            color: Colors.white,
                            shape: const StadiumBorder(),
                            onPressed: () async {
                              _stopWatchTimer.onExecute
                                  .add(StopWatchExecute.start);
                            },
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.green,
                              size: 65,
                            ),
                          ),
                        ),
                      ),

                      //RESET BUTTON
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ButtonTheme(
                          minWidth: 60,
                          height: 60,
                          child: RaisedButton(
                            elevation: 5,
                            padding: const EdgeInsets.all(4),
                            color: Colors.white,
                            shape: const StadiumBorder(),
                            onPressed: () async {
                              min = 0;
                              i = 0;
                              str_hr = "0";
                              str_min = "0";
                              _stopWatchTimer.onExecute
                                  .add(StopWatchExecute.reset);
                              laptime.clear();
                            },
                            child: Icon(
                              Icons.stop,
                              color: Colors.red,
                              size: 45,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: ButtonTheme(
                          minWidth: 60,
                          height: 60,
                          child: RaisedButton(
                            elevation: 5,
                            padding: const EdgeInsets.all(4),
                            color: Colors.white,
                            shape: const StadiumBorder(),
                            onPressed: () async {
                              if (_stopWatchTimer.isRunning()) {
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.lap);
                                laptime.add(
                                    "$str_hr$hr:$str_min$min:${displayTime.split(".")[0].split(":")[1]}:${displayTime.split(".")[1]}");
                              }
                            },
                            child: Icon(
                              Icons.outlined_flag,
                              color: Colors.amber,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),

        /// Lap time.
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 0),
          height: 100,
          margin: const EdgeInsets.all(8),
          child: StreamBuilder<List<StopWatchRecord>>(
            stream: _stopWatchTimer.records,
            initialData: _stopWatchTimer.records.value,
            builder: (context, snap) {
              final value = snap.data;
              if (laptime.isEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CollectionScaleTransition(
                      repeat: false,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Center(
                            child: HeartbeatProgressIndicator(
                              child: Icon(
                                Icons.fiber_manual_record,
                                size: 10,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Center(
                            child: HeartbeatProgressIndicator(
                              child: Icon(
                                Icons.fiber_manual_record,
                                size: 10,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Center(
                            child: HeartbeatProgressIndicator(
                              child: Icon(
                                Icons.fiber_manual_record,
                                size: 10,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Center(
                            child: HeartbeatProgressIndicator(
                              child: Icon(
                                Icons.fiber_manual_record,
                                size: 10,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              Future.delayed(const Duration(milliseconds: 100), () {
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut);
              });
              print('Listen laptime. $laptime');
              return ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  final data = laptime[index];
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'LAP ${index + 1}     ${laptime[index]}',
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: laptime.length,
              );
            },
          ),
        ),
      ],
    );
  }

  ImageProvider img() {
    var assetImage = AssetImage("assets/icon/sw.png");
    var image = Image(
      image: assetImage,
      width: 60,
      height: 60,
    );
    return assetImage;
  }
}
