import 'package:flutter/material.dart';
import '../utils/fadeAnimation.dart';
import 'package:flutter/cupertino.dart';
import 'loginBody.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/student/student.dart';
import 'package:sajiloschool/teacher/teacher.dart';
import 'dart:io';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:sajiloschool/utils/pallate.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {



  DateTime backPressTime;
  bool loader;
  Future<bool> onWillPop() async {  //  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = backPressTime == null ||
        currentTime.difference(backPressTime) > Duration(seconds: 3);
    if (backButton) {
      backPressTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Tap to Exit App",
          backgroundColor: Colors.black54,
          textColor: Colors.white);
      return false;
    }
    exit(0);
  }
  bool connected = false;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xFF1a7aa8), Color(0xFF28588e)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      body: OfflineBuilder(
          connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
              ) {
            connected = connectivity != ConnectivityResult.none;
            return new SafeArea(
              top: false,
              child: WillPopScope(
                onWillPop: onWillPop,
                child:  Column(
                  children: <Widget>[
                    Container(height: 24, color: Pallate.Safearea,),
                    Expanded(child: Container(
                      color: Colors.yellow.withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(child:
                         Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             SizedBox(height: 10,),
                             Text('Sajilo School Management',
                               style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,
//                           color: Pallate.Safearea
                                   foreground: Paint()..shader = linearGradient
                               ),
                             ),
                             SizedBox(height: 4,),
                             Text('System',
                               style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,
//                           color: Pallate.Safearea
                                   foreground: Paint()..shader = linearGradient
                               ),
                             )
                           ],
                         ),
//                          Container(
//                            child: Row(
//                              children: <Widget>[
//                                Expanded(child: Text(''),flex: 1,),
//                                Expanded(child: Padding(
//                                  padding: const EdgeInsets.only(top:40),
//                                  child: FadeAnimation(1.0, Image.asset('assets/logo/logo.png')),
//                                ),flex: 1,),
//                                Expanded(child: Text(''),flex: 1,),
//                              ],
//                            ),
//                          ),
                            flex: 1,),
                          Expanded(
                            flex: 4,
                            child: LoginBody(connected:connected),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            );
          },
          child: Center(
            child: WillPopScope(
              onWillPop: onWillPop,
              child:  Container(
                color: Colors.yellow.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Text(''),flex: 1,),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.only(top:40),
                            child: FadeAnimation(1.0, Image.asset('assets/logo/logo.png')),
                          ),flex: 1,),
                          Expanded(child: Text(''),flex: 1,),
                        ],
                      ),
                    ),flex: 1,),
                    Expanded(
                      flex: 3,
                      child: LoginBody(connected:connected),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),

    );
  }

}
