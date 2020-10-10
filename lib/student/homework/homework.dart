import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/student/sidebar/sideBar.dart';
import '../../utils/fadeAnimation.dart';
import '../../utils/pallate.dart';
import 'homeworkData.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:sajiloschool/student/notification/notificationBoard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sajiloschool/utils/api.dart';
import 'dart:io';
import 'package:sajiloschool/student/student.dart';
class BodySection extends StatefulWidget {
  final String notificationDate;
  BodySection({this.notificationDate});
  @override
  _BodySectionState createState() => _BodySectionState();
}
class _BodySectionState extends State<BodySection> {
  bool loadDate = false;
  String logoImage;
  String date =('${NepaliDateFormat("y-MM-dd",).format(NepaliDateTime.now())}');
  void initState() {
//    setDate();
//    getImageLink();
    if(widget.notificationDate != null) {
      setState(() {
        date = widget.notificationDate;
      });
      setDate();
    }
    super.initState();
  }
  setDate() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('hwDate',date);
  }
  DateTime backPressTime;
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = backPressTime == null ||
        currentTime.difference(backPressTime) > Duration(seconds: 3);
    if (backButton) {
      backPressTime = currentTime;
      return false;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => Student()));
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
//        floatingActionButton: FloatingActionButton(
//          onPressed: (){
//          setState(() {
//            loadDate = ! loadDate;
//          });
//          },
//          child: Icon(Icons.refresh),
//        ),
        body: WillPopScope(
          onWillPop : onWillPop,
          child: Stack(
            children: <Widget>[

              Column(
                children: <Widget>[
                  SizedBox(height: 70,), SizedBox(height: 30,),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text('Date:',style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 15,fontWeight: FontWeight.w600),),
                          SizedBox(width: 15,),
                          InkWell(
                            onTap: () async{
                              SharedPreferences prefs= await SharedPreferences.getInstance();
                              String old = prefs.getString('hwDate');
                              NepaliDateTime _selectedDateTime = await showMaterialDatePicker(
                                context: context,
                                initialDate: NepaliDateTime.now(),  //NepaliDateTime.now(),
                                firstDate: NepaliDateTime(2000),
                                lastDate: NepaliDateTime(2090),
                                language: Language.english,
                                initialDatePickerMode: DatePickerMode.day,
                              );
                              setState(() {
                                date=NepaliDateFormat("y-MM-dd").format(_selectedDateTime);
                              });
                              prefs.setString('hwDate',date);
                              if(old != date) {
                               setState(() {
                                 loadDate =! loadDate;
                               });
                              }

                            },
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text('$date',style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.8,
                                            fontSize: 14.5,
                                            fontStyle: FontStyle.italic
                                        ),),
                                        SizedBox(width: 5,),
                                        Icon(Icons.arrow_downward,size: 16,),
                                      ],
                                    ),
                                    SizedBox(height: 3,),
                                    Container(
                                      height: 2,
                                      width: 105,
                                      decoration: BoxDecoration(
                                          gradient: purpleGradient
                                      ),
                                    )
                                  ],
                                )

                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: 14,),
                  FadeAnimation(
                    0.5, Container(child:
                  MainRow(),
                    decoration: BoxDecoration(
                        gradient: purpleGradient
                    ),),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
//                    color: Color(0xfffbf9e7).withOpacity(0.5)
                      color: Color(0xfffdf9f7),
                      ),
                      child: loadDate ? HomeworkData( date: date) :HomeworkData1(date: date),
                    ),
                  ),



                ],
              ),
              Positioned(child: ClipOval(
                child: Material(
                  color: Pallate.Safearea, // button color
                  child: InkWell(
                    splashColor: Colors.orange, // inkwell color
                    child: SizedBox(width: 44, height: 44, child: Icon(Icons.refresh,color: Colors.white,size: 22,)),
                    onTap: () {
                      setState(() {
                        loadDate = ! loadDate;
                      });
                    },
                  ),shadowColor: Colors.black,elevation: 4.0,
                ),
              ),bottom: 20, right: 20,),
            ],
          ),
        ),

    );
  }

}


class HomeWork extends StatefulWidget {
  final String notificationDate;
  HomeWork({this.notificationDate});
  @override
  _HomeWorkState createState() => _HomeWorkState();
}

class _HomeWorkState extends State<HomeWork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          BodySection(notificationDate:widget.notificationDate),
          Positioned(child: InkWell(onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationBoard()), //StudentAttendance
            );
          }
              ,child: Icon(Icons.notifications,size: 22,color: Colors.orange[700],)),
            top: 40, right: 20,
          ),
          SideBar(),
        ],
      ),
    );
  }
}


class MainRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15,12,15,12),
      child: Row(
        children: <Widget>[
          Container(child: ModalTitle(txt:'S.N'),width:34,),
          Expanded(child: ModalTitle(txt:'Subject'),flex: 2,),
          Expanded(child: ModalTitle(txt:'Homework'),flex: 5,),
        ],
      ),
    );
  }
}



