import 'dart:async';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'episodes.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AlarmPage extends StatefulWidget {

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {

  var _time = DateTime.now();
  var _timeDifference = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = Provider.of<Podcast>(context).selectedItem;

    return Scaffold(
//      backgroundColor: Color(0xff1B2C57),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff1B2C57), Colors.black87])),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              Padding(
                padding: EdgeInsets.only(left: 40.0, top: 80),
                child: Row(
                  children: <Widget>[
                    Text('Alarm',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0)),
                    SizedBox(width: 10.0),
                    Text('Settings',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontSize: 25.0))
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 190.0,
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                  borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
//                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 80, right: 20),
                  child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
//                        Clock(),
                        Text("Alarm will ring in " + '$_timeDifference' + ' hours',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                        )),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 80, right: 20),
                          child: Column(
                          children: <Widget>[
                              Text('ALARM',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.orangeAccent,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text('$_time',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            SizedBox(height: 30),
                            Text('PODCAST SOUND',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.orangeAccent,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text(selectedItem != null ? selectedItem.title : 'EMPTY',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            SizedBox(height: 5),
                            Text(selectedItem != null ? selectedItem.description : '',
                                style: TextStyle(
                                  color: Colors.white70,
                                )),
                            SizedBox(height: 200),
                            Container(
                              color: Color(0xff1B2C57),
                              child:
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.orangeAccent,
                                onPressed: () {
                                  DatePicker.showDateTimePicker(context, theme: DatePickerTheme(containerHeight: 210.0,),
                                      showTitleActions: true, onConfirm: (time) {
                                        if(mounted){
                                          setState(() {
                                            _time = time;
                                            _timeDifference = time.difference(DateTime.now()).inHours;
                                          });
                                        }
                                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                                },
                              ),
                            ),
                          ],
                        ),
                        ),

                      ],
                    ),
                )
              )
            ]),
        )
    );
  }
}


class ChangedButton extends StatelessWidget {
  ChangedButton({@required this.icon, this.text, this.buttonText, this.onPressed});

  final IconData icon;
  final String text;
  final String buttonText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)),
      elevation: 4.0,
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        icon,
                        size: 18.0,
                        color: Color(0xff1B2C57),
                      ),
                      Text(
                        text,
                        style: TextStyle(
                            color: Color(0xff1B2C57),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
              buttonText,
              style: TextStyle(
                  color: Color(0xff1B2C57),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }
}

class Clock extends StatefulWidget {
//  Clock({Key key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();

}

class _ClockState extends State<Clock> {

  int seconds;

  _currentTime() {
    return "${DateTime
        .now()
        .hour} : ${DateTime
        .now()
        .minute} : ${seconds}";
  }

  _triggerUpdate() {
    Timer.periodic(
        Duration(seconds: 1),
            (Timer timer) =>
                setState(() {
                  seconds = DateTime.now().second;
                })
      );
    }

  // Tick the clock
  @override
  void initState() {
    super.initState();
    if (!mounted) {
      return; // Just do nothing if the widget is disposed.
    }
    seconds = DateTime.now().second;
    _triggerUpdate();
  }

  @override
  void dispose() {
    super.dispose();
    _currentTime().cancel();
    seconds = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Text(_currentTime(),
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 60,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),);
  }
}
