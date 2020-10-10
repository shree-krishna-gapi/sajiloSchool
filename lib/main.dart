import 'package:flutter/material.dart';
import 'package:sajiloschool/auth/grade/studentGrade.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'student/student.dart';
import 'utils/fadeAnimation.dart';
import 'teacher/teacher.dart';
import 'auth/Test.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:package_info/package_info.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'package:firebase_remote_config/firebase_remote_config.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_database/firebase_database.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: false);
  runApp(
    MyApp(),
  );
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sajilo School',
        theme: ThemeData(
//          primarySwatch: Colors.blueGrey,
        primaryColor: Color(0xFF117aac), //0xFF28588e
          accentColor: Color(0xFF35739f),
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
        ),
        home:LoginStatus()
    );
  }
}


class LoginStatus extends StatefulWidget {

  @override
  _LoginStatusState createState() => _LoginStatusState();
}

class _LoginStatusState extends State<LoginStatus> {
  int indexYear;
  String url;
  String yearName;
  int yearId;
  int schoolId;
  int i;
  bool connected = false;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  String firebaseData1;
  String notificationTitle;
  String notificationBody;
  String notificationDate;
  String notificationType;
  int k=0;
  Future<void> _demoNotification(mseg) async{
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name','channel description',
        importance:  Importance.Max,
        priority:  Priority.High,
        ticker: 'test ticker'
    );
    notificationTitle=  mseg['notification']['title'];
    notificationBody=  mseg['notification']['body'];
    notificationType=  mseg['data']['notificationType'];
    notificationDate=  mseg['data']['date'];
//    notificationBody=  mseg['notification']['body'];
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(k+1,notificationTitle, notificationBody, platformChannelSpecifics, payload:'$notificationType');
  }


//  https://medium.com/@naumanahmed19/prompt-update-app-dialog-in-flutter-application-4fe7a18f47f2

//  CollectionReference foodRef = Firestore.instance.collection('sajiloschool');
  DatabaseReference ref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
//    ref.child("1").set({
//      'version': '3.0.0+3'
//    });
//    ref.child('').set({
//      'version': 1
//    });

    initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification
    );
//    versionCheck(context);

//    print(foodRef);
//    try {
//      versionCheck(context);
//    } catch (e) {
//      print(e);
//    }
//    https://www.youtube.com/watch?v=Foj2wwN5XQI&t=431s
//     print('+++++++++++++++++');
    checkVersion();
//    checkStatus();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");
//        firebaseData1 = message['notification']['title'];
        await _demoNotification(message);
//        _showNotification();
//        if(firebaseData1 == 'attendance') {
//          _currentIndex = 3;
//        }
//        else {
//          _currentIndex = 2;
//        }
      },


    );
    super.initState();

  }


  checkVersion() {
    // print('-------------');
    ref.once().then((DataSnapshot snapshot) {
      // print('apple 3137-> ${snapshot.value['version'].runtimeType}');
     // int i = int.parse(snapshot.value['version1']);
      // if(snapshot.value['version'] > 1) {

      int beforeValue = 3159;
      if(snapshot.value['version'] > beforeValue) {
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                  backgroundColor: Color(0xfffbf9e7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  content: Container(

                      child: Container( width:10, height: 120,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20,10,20,0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Newer version is available'),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  color: Colors.black12, height: 1,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    color: Colors.orange,
                                  ),
                                  padding: EdgeInsets.fromLTRB(11,7,11,7),

                                  child: InkWell(child: Text('Update',
                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),),onTap: _launchURL,),),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  padding: EdgeInsets.fromLTRB(11,7,11,7),

                                  child: InkWell(child: Text('Skip For Now',
                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,fontStyle: FontStyle.italic),),onTap: checkStatus,),)
                              ],
                            ),
                          )))
              );

            });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Student()),
        );
        checkStatus();
      }
      else {
        // print('go to login Status');
        checkStatus();
      }

    });
  }
  _launchURL() async {
    String url = 'https://play.google.com/store/apps/details?id=com.mininginfosys.sajiloschool';
      await launch(url);
  }

  Future onSelectNotification(String payload) async {
    // print('********************** this is payload-> $payload');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final studentLogin = prefs.getBool('studentStatus');
    if(studentLogin == true) {
      if(notificationType == 'attendance') {
        // print('this is widget index no. 3');
        Navigator.push(context, MaterialPageRoute(builder: (context) => Student(forceIndex: 3)));
      }
      else {
        // print('this is widget index no. 2');
        Navigator.push(context, MaterialPageRoute(builder: (context) => Student(forceIndex: 2,notificationDate:notificationDate )));
      }
    }else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }

  }
  Future onDidReceiveLocalNotification(
      int id, String title, String body,String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title:  Text(notificationTitle),
          content: Text(notificationBody),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                final studentLogin = prefs.getBool('studentStatus');
                if(studentLogin == true) {
                  if(notificationTitle == 'attendance') {
                    // print('this is widget index no. 3');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Student(forceIndex: 1)));
                  }
                  else {
                    // print('this is widget index no. 2');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Student(forceIndex: 0,notificationDate:notificationDate)));
                  }
                }else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                }

              },
            )
          ],
        )
    );
  }

  checkStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final teacherLogin = prefs.getBool('teacherStatus');
    final studentLogin = prefs.getBool('studentStatus');
    schoolId = prefs.getInt('schoolId');
    url = "${Urls.BASE_API_URL}/login/GetEducationalYear?schoolid=$schoolId";
    if(teacherLogin == true) {
      // print('Teacher Login ----');
      // print(url);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // todo: shared preference saved
        for (i = 0; i < response.body.length; i++) {
          if (jsonDecode(response.body)[i]['isCurrent'] == true) {
            yearId = jsonDecode(response.body)[i]['EducationalYearID'];
            yearName = jsonDecode(response.body)[i]['sYearName'];
            indexYear = i;
            //todo : attenendanceEducationalYearId
            break;
          }
        }
        //Homework
        prefs.setInt('indexYearHw', i);
        prefs.setInt('educationalYearIdHw', yearId);
        prefs.setString('educationalYearNameHw', yearName);
        // end of Homework
        //Homework
        prefs.setInt('indexYearHwR', i);
        prefs.setInt('educationalYearIdHwR', yearId);
        prefs.setString('educationalYearNameHwR', yearName);
        // end of Homework

        //Attendance
        prefs.setInt('indexYearHwA', i);
        prefs.setInt('educationalYearIdHwA', yearId);
        prefs.setString('educationalYearNameHwA', yearName);
        // end of Attendance

        //Attendance report
        prefs.setInt('indexYearHwAR', i);
        prefs.setInt('educationalYearIdHwAR', yearId);
        prefs.setString('educationalYearNameHwAR', yearName);
        // end of Attendance Report
        //Teacher
        prefs.setInt('indexYearCalenderT', i);
        prefs.setInt('educationalYearIdCalenderT', yearId);
        prefs.setString('educationalYearNameCalenderT', yearName);
        // end of Teacher
        //todo : attendanceEducationalYearData
        prefs.setString('getEducationalYearData', response.body);
        // todo: GetEducationalYear save
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Teacher()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    }
    else if (studentLogin == true) {
      final response = await http.get(url);
      // print('Home Page Educational Year * screen/home -> $url');
      if (response.statusCode == 200) {
        // todo: shared preference saved
        for (i = 0; i < response.body.length; i++) {
          if (jsonDecode(response.body)[i]['isCurrent'] == true) {
            yearId = jsonDecode(response.body)[i]['EducationalYearID'];
            yearName = jsonDecode(response.body)[i]['sYearName'];
            indexYear = i;
            //todo : attenendanceEducationalYearId
            break;
          }
        }
        //exam
        prefs.setInt('indexYearExam', i);
        prefs.setInt('educationalYearIdExam', yearId);
        prefs.setString('educationalYearNameExam', yearName);
        // end of exam

        //Fees
        prefs.setInt('indexYearFees', i);
        prefs.setInt('educationalYearIdFees', yearId);
        prefs.setString('educationalYearNameFees', yearName);
        // end of Fees

        //Attendance
        prefs.setInt('indexYearAttendance', i);
        prefs.setInt('educationalYearIdAttendance', yearId);
        prefs.setString('educationalYearNameAttendance', yearName);
        // end of Attendance

        //Attendance
        prefs.setInt('indexYearAttendance', i);
        prefs.setInt('educationalYearIdAttendance', yearId);
        prefs.setString('educationalYearNameAttendance', yearName);
        // end of Attendance

        //Calender
        prefs.setInt('indexYearCalender', i);
        prefs.setInt('educationalYearIdCalender', yearId);
        prefs.setString('educationalYearNameCalender', yearName);
        // end of Calender
        //todo : attendanceEducationalYearData
        prefs.setString('getEducationalYearData', response.body);
        // todo: GetEducationalYear save
//      alreadyLoadYear = true;
//      getMonthData(schoolId);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Student()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    }

    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
          connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,

              Widget child,
              ) {
            connected = connectivity != ConnectivityResult.none;
            if(connected == false) {
              checkVersion();
            }
            return Stack(
              children: <Widget>[
//                InkWell(
//                  onTap: () {
//                    checkStatus();
//                  },
//                  child:
                  new Container(
                    decoration: BoxDecoration(
                        gradient: purpleGradient
                    ),
                    child: Center(
                      child: Container(child: FadeAnimation(1.0,

                         InkWell(
    onTap: () {
      checkVersion();
                  },
                           child: Image.asset('assets/logo/logo.png',
                            fit: BoxFit.cover,),
                         ),
                      ),
                        height: 85,
                      ),
                    ),
//                  ),
                ),
                connected? new Container(height: 1,) : new NoNetwork()
              ],
            );
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: purpleGradient
            ),
            child: Center(
              child: Container(child: FadeAnimation(1.0,

                 Image.asset('assets/logo/logo.png',
                  fit: BoxFit.cover,),
              ),
                height: 80,
              ),
            ),
          )
      ),
    );
  }
}


