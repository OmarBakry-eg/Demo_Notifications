import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SnackBar snackBar = SnackBar(
    content: Text(
      'Not Completed! it just a tool from firebase and to work should go to FCM and publish a new message',
      style: TextStyle(color: Colors.white),
    ),
  );

  @override
  void initState() {
    //FCM tool in firebase console
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg) {
        print(msg);
        return;
      },
      onResume: (msg) {
        print(msg);
        return;
      },
      // Don't forget to add Key and Value while using android ..
    );
    super.initState();
    flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin(); //initialize the plugin
    var android =
        new AndroidInitializationSettings('@mipmap/ic_launcher'); // app Icon
    var iOS = new IOSInitializationSettings();
    var initSettings =
        new InitializationSettings(android, iOS); //initialize full setting
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification:
            onSelectNotification); //now initialize the message by full setting and what happen on clicking
  }

  Future onSelectNotification(String payload) {
    //on select take default string as usual that is message will appear after clicking
    debugPrint("payload : $payload");
    return showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'), //here
      ),
    );
  }

  void showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,
        importance: Importance.Max); //android message details
    var iOS = new IOSNotificationDetails();
    var platform =
        new NotificationDetails(android, iOS); // notification details
    await flutterLocalNotificationsPlugin.show(
        0,
        'New Message Is Coming Up !',
        'Flutter Local Notification',
        platform, // id , title , body , notification details , payload(after Clicking)
        payload: 'Hey ! I\'m Omar Bakry Working as Flutter Developer ');
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Flutter Notification'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: size.width * 0.4,
          height: size.height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: showNotification,
                child: Center(
                  child: Text('Local Notification'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () {
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                },
                child: Center(
                  child: Text('Firebase Notification'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
