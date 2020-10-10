import 'package:flutter/material.dart';
import 'package:sajiloschool/student/homework/download.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'field/service/homeworkget.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'field/service/getHomeList.dart';
import 'dart:convert';
import 'dart:async';
class HomeworkData extends StatefulWidget {
  @override
  _HomeworkDataState createState() => _HomeworkDataState();
}

class _HomeworkDataState extends State<HomeworkData> {
  String url;
  List data;
  bool processLoad = true;
  @override
  void initState(){
    super.initState();
    this.getHomeworkData();
  }
  Future<String> getHomeworkData()async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('homeworkReportUrl');
//    var studentId = prefs.getInt('studentId');
//    url = "http://192.168.1.89:88/Api/Login/GetAssignedHomework?schoolId=1&educationYearId=30&gradeId=3&streamId=3&classId=4&nepaliDate=2077-01-16&subjectId=null";

//    url = "${Urls.BASE_API_URL}/Login/GetHOmeworks?schoolId=$schoolId&studentId=$studentId&date=";
    print(url);
    var response = await http.get(url);
    setState(() {
      processLoad = false;
      data = jsonDecode(response.body);

    });
    return "success";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(top: false,
        child: Column(
          children: <Widget>[
            Container(height: 24, color: Pallate.Safearea,),
            Container(child:
            MainRow(),
              decoration: BoxDecoration(
                  gradient: purpleGradient
              ),),
            Expanded(child:
            FadeAnimation(
              0.2, processLoad ? Loader(): data.length > 0 ? ListView.builder(
//              itemCount: data.length,
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 2,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15,8,15,6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child: ChildTxt(title: '${index+1}'), flex: 1,),
                            Expanded(child: ChildTxt(title: '${data[index]['SubjectName']}'), flex: 2,),
                            Expanded(child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: <Widget>[
                                Expanded(child: ChildTxt(
                                    title: '${data[index]['HomeworkDetail']}'),
                                ),
                                data[index]['IsFileExist'] ? Container(
                                  width: 28,
                                  child: GestureDetector(
                                      onTap: () async{
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setInt('homeworkId', data[index]['HomeworkId']);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Download(subject:data[index]['SubjectName'],
                                              description:data[index]['HomeworkDetail'])), //JsonApiDropdown
                                        );
                                      },
                                      child: Icon(Icons.file_download,color: Colors.orange,size: 22,)

                                  ),
                                ): Container(width: 1,),

                                Container(
                                  width: 28,
                                  child: GestureDetector(
                                      onTap: () {
//

                                        showDialog<void>(
                                            context: context,
                                            barrierDismissible: true, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  backgroundColor: Color(0xfffbf9e7),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                                  contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                                  content: Container(
                                                      child: Container( width:10,
                                                          child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(20,35,20,30),
                                                            child: Text('Are You Sure to Delete ?',style: TextStyle(fontWeight: FontWeight.w500),),
                                                          
                                                          ))),elevation: 4,actions: <Widget>[
                                                Container(  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10)
                                                    ),
                                                    color: Colors.red[400].withOpacity(0.8)
                                                ),

                                                  child: InkWell(splashColor: Colors.white12,child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(13,8,13,8),
                                                    child:  Text('Yes',style: TextStyle(
                                                        color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600,
                                                        shadows: [
                                                          BoxShadow(
                                                            color: Colors.white30,
                                                            blurRadius: 2.0, // has the effect of softening the shadow
                                                            spreadRadius: 1.0, // has the effect of extending the shadow
                                                            offset: Offset(
                                                              2.0, // horizontal, move right 10
                                                              2.0, // vertical, move down 10
                                                            ),
                                                          )
                                                        ]
                                                    ),),
                                                  ),onTap: (){
                                                    editHomework(data[index]['HomeworkId']);
//
                                                  },),
                                                ),
                                                Container(  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10)
                                                    ),
                                                    color: Colors.orange[500].withOpacity(0.8)
                                                ),

                                                  child: InkWell(splashColor: Colors.white30,child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(13,8,13,8),
                                                    child:  Text('No',style: TextStyle(
                                                        color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600,
                                                        shadows: [
                                                          BoxShadow(
                                                            color: Colors.black12,
                                                            blurRadius: 2.0, // has the effect of softening the shadow
                                                            spreadRadius: 1.0, // has the effect of extending the shadow
                                                            offset: Offset(
                                                              2.0, // horizontal, move right 10
                                                              2.0, // vertical, move down 10
                                                            ),
                                                          )
                                                        ]
                                                    ),),
                                                  ),onTap: (){
                                                   Navigator.of(context).pop();
                                                  },),
                                                )
                                              ],); });
                                        
                                      },
                                      child: Icon(Icons.delete_forever,color: Colors.red[400],size: 22,)

                                  ),
                                )

                              ],
                            ), flex: 5,),

                          ],
                        ),
                      ),
                      Container(height: 1,color: Colors.black12,),
                    ],
                  );
                }
            ): FadeAnimation(
              0.3, Align(
                alignment: Alignment.center,
                child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                  letterSpacing: 0.4,),)
            ),
            ),
            ))
          ],
        ),
      ),
    );
  }
  editHomework(homeworkId) async {
    Navigator.of(context).pop();
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Wait();});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int schoolId = prefs.getInt('schoolId');
    int teacherId = prefs.getInt('teacherId');
    var url = "${Urls.BASE_API_URL}/Login/EditHomework?schoolId=$schoolId&HomeworkId=$homeworkId&userId=$teacherId";
    print(url);
    final response =
    await http.get(url);
    Navigator.of(context).pop();
    if (response.statusCode == 200) {
      final isResult = json.decode(response.body)['Success'];
      if(isResult == true) {
        getHomeworkData();
      }
      else {
        showSnack('Delete Failled! Please, Try Again');
      }
    }
    showSnack('Error Please, Contact to the Developer');
  }
//  downloadAlert() {
//    showDialog<void>(
//        context: context,
//        builder: (BuildContext context) {
//          return DownloadHomework();
//        }
//    );
//  }
  showSnack(message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$message'),
      backgroundColor: Colors.black26,
      duration: Duration(milliseconds: 800),
    ));
  }
}
class ChildTxt extends StatelessWidget {
  ChildTxt({this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
        letterSpacing: 0.4, fontSize: 14.5));
  }
}

class Test extends StatelessWidget {
  Test({this.link});
  final String link;
  String finalFileName;
  void initState() {
    var tt = link.split('/');
    var count=tt.length;
    var string = tt[count-1];
    var filename= string.split('_');
    var fileCount= filename.length;
    finalFileName= filename[fileCount-1];
  }
  @override
  Widget build(BuildContext context) {
    return Text('this is $finalFileName');
  }
}











class MainRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15,15,15,15),
      child: Row(
        children: <Widget>[
          Expanded(child: ModalTitle(txt:'Sn'),flex: 1,),
          Expanded(child: ModalTitle(txt:'Subject'),flex: 2,),
          Expanded(child: ModalTitle(txt:'Homework'),flex: 5,),
        ],
      ),
    );
  }
}