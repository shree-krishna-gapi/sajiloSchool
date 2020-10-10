import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'dart:async';
import 'studentattendance.dart';
import 'field/service/grade.dart';
import 'field/service/classget.dart';
import 'field/service/getYear.dart';
import 'field/service/stream.dart';
import 'package:sajiloschool/teacher/generic/textStyle.dart';
import 'package:flutter_offline/flutter_offline.dart';
class GetStudents extends StatefulWidget {
  @override
  _GetStudentsState createState() => _GetStudentsState();
}

class _GetStudentsState extends State<GetStudents> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  // Grade
  int changedGradeId;
  String changedNowGrade;
  int selectedGradeId = 0;
  String selectedGrade = '';
  // Stream
  int changedNowStreamId;
  String changedNowStream;
  int selectedStreamId = 0;
  String selectedStream = '';
  // Class
  int changedNowClassId;
  String changedNowClass;
  int selectedClassId;
  String selectedClass = '';
  int schoolId;
  // Date
  bool connected = false;

  String date =('${NepaliDateFormat("y-MM-dd",).format(NepaliDateTime.now())}');
  // End
  _submit(BuildContext context)async {
    if (selectedClassId == 0) {
      _showSnackBar(context,'Please, Select The Field!');
    }
    else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return Wait();
          });
      schoolId = prefs.getInt('schoolId');
      var yearId = prefs.getInt('educationalYearIdHwA');
      try {
        var url = '${Urls.BASE_API_URL}/login/GetStudentsListForAttendance?'
            'schoolId=$schoolId&EducationYearId=$yearId&GradeId=$selectedGradeId&StreamId=$selectedStreamId&ClassId=$selectedClassId&DateOfYear'
            '=$date';
        print(url);
        final response =
        await http.get(url);
        Navigator.of(context).pop();
        if (response.statusCode == 200) {
          prefs.setInt('totalAttendance1', response.body.length); //todo totalAttendance count
          var responseJson = jsonDecode(response.body);
          int count = responseJson.length;
          prefs.setInt('totalStudent', count);
          if(count>0) {
            prefs.setString('getStudentForAttendance',response.body);

//            Timer(Duration(milliseconds: 500), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentAttendance(selectedDate:date,classId:selectedClassId)),
              );
//            });
          }
          else {
            showDialog<void>(
                context: context,
                barrierDismissible: true, // user must tap button!
                builder: (BuildContext context) {
                  return Error(txt: 'Data Not Found',subTxt: 'Please, Try Again',);
                }
            );
          }
        } else {
          showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return Error(txt: 'Error',subTxt: 'Please, Contact to the Developer',);
              }
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return Error(txt: 'Something Wrong!',subTxt: 'Please, Contact to the developer',);
            }
        );
      }
    }
  }
  @override
  void initState() {
//    getDate();
    super.initState();
  }

//  void getDate()async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//  }
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
//      backgroundColor: Colors.blue[800],
      body:  OfflineBuilder(
        connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
            )
        {
          connected = connectivity != ConnectivityResult.none;
          return Stack(
            children: <Widget>[
              Container(
//          height: double.infinity, width: double.infinity,
                decoration: BoxDecoration(
                    gradient: purpleGradient
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      TitleText(txt:'Attendance'),

                      FadeAnimation(0.2, GetYear()),
                      SizedBox(height: 18,),
                      FadeAnimation(0.3, _hwDate(context,'Date','date')),
                      SizedBox(height: 16,),
                      FadeAnimation(
                        0.3, Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(child: LabelText(labelTitle:'Grade'),flex: 3,),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child:  selectedGrade == '' ?
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4.0,
                                      color: Colors.black12,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                                readOnly: true,
                                onTap: (){_showGradeDialog();},
//                  textAlign: TextAlign.center,
                                decoration: InputDecoration(hintText: "Grade",hintStyle: TextStyle(
                                    fontSize: 15, color: Colors.white60
                                ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                  ),

                                ),
                              ):
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4.0,
                                      color: Colors.black12,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                                readOnly: true,
                                onTap: (){_showGradeDialog();},
                                textAlign: TextAlign.left,
                                initialValue: selectedGrade,
                                decoration: InputDecoration(hintText: "$selectedGrade",hintStyle: TextStyle(
                                    fontSize: 15, color: Colors.white
                                ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                  ),

                                ),
                              ),
                            )
                            ,flex: 5,
                          ),
                        ],
                      ),
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(
                        0.4, Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(child: LabelText(labelTitle: 'Stream',),flex: 3,),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child:  selectedStream == '' ?
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4.0,
                                      color: Colors.black12,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                                readOnly: true,
                                onTap: (){_showStreamDialog();},
//                  textAlign: TextAlign.center,
                                decoration: InputDecoration(hintText: "Stream",hintStyle: TextStyle(
                                    fontSize: 15, color: Colors.white60
                                ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                  ),

                                ),
                              ):
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4.0,
                                      color: Colors.black12,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                                readOnly: true,
                                onTap: (){_showStreamDialog();},
                                textAlign: TextAlign.left,
                                initialValue: selectedStream,
                                decoration: InputDecoration(hintText: "$selectedStream",hintStyle: TextStyle(
                                    fontSize: 15, color: Colors.white
                                ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                  ),

                                ),
                              ),
                            )
                            ,flex: 5,
                          ),
                        ],
                      ),
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(
                        0.5, Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(child: LabelText(labelTitle: 'Class',),flex: 3,),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child:  selectedClass == '' ?
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.black12,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  readOnly: true,
                                  onTap: (){_showClassDialog();},
//                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(hintText: "Class",hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white60
                                  ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                    ),

                                  ),
                                ):
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.black12,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  readOnly: true,
                                  onTap: (){_showClassDialog();},
                                  textAlign: TextAlign.left,
                                  initialValue: selectedClass,
                                  decoration: InputDecoration(hintText: selectedClass,hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white
                                  ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                    ),

                                  ),
                                ),
                              )
                              ,flex: 5,
                            )
                          ]
                      ),
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(
                        0.5, Row(
                        children: <Widget>[
                          Expanded(child: Text(''),flex: 1,),
                          Expanded(child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 20,top: 40),
                            child: Material(
                              color: Color(0x00000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.75),width: 1.5
                                ),
                              ),
                              child: InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(22,8,7.5,11),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text('Get Students',style: TextStyle(
                                      color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500,
                                      letterSpacing: 0.8,shadows:[
                                      Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.black26,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                    ),),
                                  ),
                                ),
                                splashColor: Colors.orange,
                                onTap: (){
                                  if (formKey.currentState.validate()) {
                                    _submit(context);
                                  }


                                },
                              ),
                            ),
                          ),flex: 2,),
                          Expanded(child: Text(''),flex: 1,),

                        ],
                      ),
                      ),
                      SizedBox(height: 5,),
//                FadeAnimation(
//                  0.8, Row(
//                    children: <Widget>[
//                      Expanded(child: Text(''),flex: 1,),
//                      Expanded(child: Container(
//                        width: double.infinity,
//                        padding: EdgeInsets.only(left: 20,top: 40),
//                        child: Material(
//                          color: Color(0x00000000),
//                          shape: RoundedRectangleBorder(
//                            borderRadius: new BorderRadius.circular(10.0),
//                            side: BorderSide(
//                                color: Colors.white.withOpacity(0.75),width: 1.5
//                            ),
//                          ),
//                          child: InkWell(
//                            child: Padding(
//                              padding: const EdgeInsets.fromLTRB(22,8,7.5,11),
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  Icon(Icons.arrow_back,size: 20, color: Colors.white,),
//                                  SizedBox(width: 5,),
//                                  Text('Back',style: TextStyle(
//                                    color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500,
//                                    letterSpacing: 0.8,shadows:[
//                                    Shadow(
//                                      blurRadius: 4.0,
//                                      color: Colors.black26,
//                                      offset: Offset(2.0, 2.0),
//                                    ),
//                                  ],
//                                  ),),
//                                ],
//                              ),
//                            ),
//                            splashColor: Colors.orange,
//                            onTap: (){
//                              Navigator.pop(context);
//                            },
//                          ),
//                        ),
//                      ),flex: 2,),
//                      Expanded(child: Text(''),flex: 1,),
//
//                    ],
//                  ),
//                ),
                      SizedBox(height: 20,),
                      FadeAnimation(
                        0.6, Center(
                        child: Center(
                          child: FlatButton( onPressed:() {Navigator.of(context).pop();},
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
                              height: 5,
                              width: 90,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.65),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(4)
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                      ),

                    ],
                  ),
                ),
              ),
              connected?Container(height: 1,) :NoNetwork()
            ],
          )

            ;
        },child: Center(child: Text('Please, Contact to Developer.'),),),

    );
  }

  Row _hwDate(BuildContext context,String title, String value) {
    return Row(
      children: <Widget>[
        Expanded(child: LabelText(labelTitle: 'Date',),flex: 3,),
        Expanded(child: InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20,),
               Text(date,style: TextStyle(fontStyle: FontStyle.italic,
                      fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),),
                Container(color: Colors.black38,
                  margin: EdgeInsets.only(top: 10),
                  height: 1.4,)
              ],
            ),
          ),
          onTap: () async{
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
          },
        ),flex: 5,),

      ],
    );
  }
  int indexGrade;
  Future<void> _showGradeDialog() {

      return showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xfffbf9e7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              content: Container(
                  child: Container(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20,10,20,0),
                        child: FutureBuilder<List<Grade>>(
                          future: Fetch(http.Client()),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) ;
                            if(snapshot.hasData) {
                              return snapshot.data.length > 0 ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return
                                      index == indexGrade ? FadeAnimation(
                                        0.2, Container(
                                          color: Colors.orange[400],
                                          child: InkWell(
                                            onTap: () async {
                                              changedNowGrade =
                                                  snapshot.data[index].gradeNameEng;
                                              changedGradeId =
                                                  snapshot.data[index].gradeId;
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              prefs.setInt('tempChangedGradeId',changedGradeId);
                                              if(selectedGradeId != changedGradeId) {
                                                selectedStreamId = 0;
                                                selectedStream = '';
                                                selectedClassId = 0;
                                                selectedClass = '';
                                              }
                                              setState(() {
                                                selectedGrade = changedNowGrade;
                                              });
                                              selectedGradeId = changedGradeId;
                                              indexGrade = index;
                                              Duration(milliseconds: 100);
                                              Navigator.of(context).pop();
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.5),
                                                  child: Center(child: Text(
                                                    snapshot.data[index]
                                                        .gradeNameEng,
                                                    style: TextStyle(
                                                        color: Colors.white
                                                    ),)),
//                                    color: Colors.black12,
                                                ),
                                                Container(
                                                  height: 1,
                                                  color: Colors.black.withOpacity(
                                                      0.05),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ) :
                                      FadeAnimation(
                                        0.2, Container(
                                          child: InkWell(
                                            onTap: () async {
                                              changedNowGrade =
                                                  snapshot.data[index].gradeNameEng;
                                              changedGradeId =
                                                  snapshot.data[index].gradeId;
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              prefs.setInt('tempChangedGradeId',changedGradeId);
                                              if(selectedGradeId != changedGradeId) {
                                                selectedStreamId = 0;
                                                selectedStream = '';
                                                selectedClassId = 0;
                                                selectedClass = '';
                                              }
                                              setState(() {
                                                selectedGrade = changedNowGrade;
                                              });
                                              selectedGradeId = changedGradeId;
                                              indexGrade = index;
                                              Duration(milliseconds: 100);
                                              Navigator.of(context).pop();
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.5),
                                                  child: Center(child: Text(
                                                      snapshot.data[index]
                                                          .gradeNameEng)),
//                                    color: Colors.black12,
                                                ),
                                                Container(
                                                  height: 1,
                                                  color: Colors.black.withOpacity(
                                                      0.05),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                  }
                              )
                                  :
                              Empty                          (
                              );


                            } else { return Loader(); }
                          },
                        )
                    ),
                  ),
                ),

              elevation: 4,
            );} );

  }

  int indexStream;
  _showStreamDialog() {
    if(selectedGradeId == 0) {
      _showSnackBar(context,'Please, Select The Grade.');
    }
    else {
      return showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xfffbf9e7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              content: Container(
                child: Container(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: FutureBuilder<List<GetStream>>(
                        future: FetchStream(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError);
                          if(snapshot.hasData) {

                            return snapshot.data.length > 0 ? Center(
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int index)
                                  {
                                    return index == indexGrade ? FadeAnimation(
                                      0.2, Container(
                                      color: Colors.orange[400],
                                      child: InkWell(
                                        onTap: () async {
                                          changedNowStream =
                                              snapshot.data[index].streamName;
                                          changedNowStreamId =
                                              snapshot.data[index].streamId;
                                          SharedPreferences prefs = await SharedPreferences
                                              .getInstance();
                                          prefs.setInt('tempChangedClassId', changedGradeId);
                                          if (selectedGradeId != changedGradeId) {
                                            selectedStreamId = 0;
                                            selectedStream = '';
                                            selectedClassId = 0;
                                            selectedClass = '';
                                          }
                                          setState(() {
                                            selectedStream = changedNowStream;
                                          });
                                          selectedStreamId = changedNowStreamId;
                                          indexStream = index;
                                          Duration(milliseconds: 100);
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.5),
                                              child: Center(child: Text(
                                                snapshot.data[index]
                                                    .streamName,
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),)),
//                                    color: Colors.black12,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.black.withOpacity(
                                                  0.05),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    ) :
                                    FadeAnimation(
                                      0.2, Container(
                                      child: InkWell(
                                        onTap: () async {
                                          changedNowStream =
                                              snapshot.data[index].streamName;
                                          changedNowStreamId =
                                              snapshot.data[index].streamId;
                                          SharedPreferences prefs = await SharedPreferences
                                              .getInstance();
                                          prefs.setInt('tempChangedClassId', changedGradeId);
                                          if (selectedGradeId != changedGradeId) {
                                            selectedStreamId = 0;
                                            selectedStream = '';
                                            selectedClassId = 0;
                                            selectedClass = '';
                                          }
                                          setState(() {
                                            selectedStream = changedNowStream;
                                          });
                                          selectedStreamId = changedNowStreamId;
                                          indexStream = index;
                                          Duration(milliseconds: 100);
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.5),
                                              child: Center(child: Text(
                                                  snapshot.data[index]
                                                      .streamName)),
//                                    color: Colors.black12,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.black.withOpacity(
                                                  0.05),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    );
                                  }
                              ),
                            )
                                :
                            Empty                          (
                            );


                          } else { return Loader(); }
                        },
                      )
                  ),
                ),
              ),

              elevation: 4,
            );
          });
    }
  }
  int indexClass;
  _showClassDialog() {
    if(selectedStreamId == 0) {
      _showSnackBar(context,'Please, Select The Stream.');
    }
    else {
      return showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xfffbf9e7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              content: Container(
                child: Container(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: FutureBuilder<List<GetClass>>(
                        future: FetchClass(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError);
                          if(snapshot.hasData) {
                            return snapshot.data.length > 0 ? Center(
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int index)
                                  {
                                    return index == indexClass ? FadeAnimation(
                                      0.2, Container(
                                      color: Colors.orange[400],
                                      child: InkWell(
                                        onTap: () async {
                                          changedNowClass =
                                              snapshot.data[index].className;
                                          changedNowClassId =
                                              snapshot.data[index].classId;
                                          setState(() {
                                            selectedClass = changedNowClass;

                                          });
                                          selectedClassId = changedNowClassId;
                                          indexClass = index;
                                          Duration(milliseconds: 100);
                                          Navigator.of(context).pop();

                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.5),
                                              child: Center(child: Text(
                                                snapshot.data[index]
                                                    .className,
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),)),
//                                    color: Colors.black12,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.black.withOpacity(
                                                  0.05),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    ) :
                                    FadeAnimation(
                                      0.2, Container(
                                      child: InkWell(
                                        onTap: () async {
                                          changedNowClass =
                                              snapshot.data[index].className;
                                          changedNowClassId =
                                              snapshot.data[index].classId;
                                          setState(() {
                                            selectedClass = changedNowClass;

                                          });
                                          selectedClassId = changedNowClassId;
                                          indexClass = index;
                                          Duration(milliseconds: 100);
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.5),
                                              child: Center(child: Text(
                                                  snapshot.data[index]
                                                      .className)),
//                                    color: Colors.black12,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.black.withOpacity(
                                                  0.05),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    );
                                  }
                              ),
                            )
                                :
                            Empty                          (
                            );


                          } else { return Loader(); }

                        },
                      )
                  ),
                ),
              ),

              elevation: 4,
            );
          });
    }
  }
  _showSnackBar(BuildContext context,title) {
    final snackBar = SnackBar(content: Text(title),
      backgroundColor: Colors.black38,
      duration: Duration(milliseconds: 800),);
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}







class LabelText extends StatelessWidget {
  LabelText({this.labelTitle});
  final String labelTitle;
  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.centerRight,child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(labelTitle,style: TextStyle(
          color: Colors.white,
          letterSpacing: 0.6,
          fontSize: 15,
          shadows: [
            Shadow(
              color: Colors.black12,
              blurRadius: 4.0,
            )
          ]
      ),),
    ));
  }
}