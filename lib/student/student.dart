import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:sajiloschool/student/attendance/attendance.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'exam/exam.dart';
import '../utils/pallate.dart';
import 'fees/fees.dart';
import 'homework/homework.dart';
import 'attendance/attendance.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sajiloschool/auth/login.dart';

class Student extends StatefulWidget {
  final int forceIndex;
  final String notificationDate;
  Student({Key key, @required this.forceIndex,this.notificationDate}) : super(key: key);

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  int _currentIndex=0;
  PageController _pageController;
  bool connected = false;
  String url;
  bool force = false;
  bool forceAttendance = false;
  @override
  void initState() {
    super.initState();
    if(widget.forceIndex != null) {
      runOnce();
    }

    _pageController = PageController();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  runOnce() {

      if(widget.forceIndex == 1) {
        setState(() {
          _currentIndex = widget.forceIndex;
          force = true;
          forceAttendance = true;
        });
      }
     else {
        setState(() {
          _currentIndex = widget.forceIndex;
          force = true;
        });
      }
    }


  final double itemHeight = double.infinity;
  final double itemWidth = double.infinity/2;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: purpleGradient,
        ),
        child: FadeAnimation(
          0.4, BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          }),
          backgroundColor: Color(0x0000000), //0xFF117aac
          items: [


            BottomNavyBarItem(
                icon: Icon(Icons.chrome_reader_mode),
                title: Text('Homework'),
                activeColor: TabColor.aColor,
                inactiveColor: TabColor.inColor
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.verified_user),
                title: Text('Attendance'),
                activeColor: TabColor.aColor,
                inactiveColor: TabColor.inColor
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.payment),
                title: Text('Fees'),
                activeColor: TabColor.aColor,
                inactiveColor: TabColor.inColor
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.border_color),
                title: Text('Exam'),
                activeColor: TabColor.aColor,
                inactiveColor: TabColor.inColor

            ),
          ],

        ),
        ),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
            ) {
          connected = connectivity != ConnectivityResult.none;
          return SafeArea(
            top: false,
            child: Column(
              children: <Widget>[
                Container(height: 24,color: Pallate.Safearea,),
                Expanded(
                  child: Stack(
                    children: <Widget>[

                      FadeAnimation(
                        0.1, SizedBox.expand(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState((){
                               force = false;
                              _currentIndex = index;
                            });

                          },
                          children: <Widget>[
                            force ? FadeAnimation(0.3, forceAttendance ?  Attendance() : HomeWork(notificationDate:widget.notificationDate)):  HomeWork(),
                             Attendance(),
                             Fees(),
                             Exam(),

                          ],
                        ),
                      ),
                      ),
                      connected? new Container(height: 1,) : new NoNetwork()
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        child: Text(''),
      ),
    );
  }
}
class TabColor {
  static Color aColor = Colors.white;
  static Color inColor = Colors.white70;

}
