import 'package:flutter/material.dart';
import 'package:sajiloschool/student/homework/download.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'field/service/homeworkget.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'dart:convert';
import 'dart:async';
class HomeworkData extends StatefulWidget {
  final String date;
  HomeworkData({this.date});
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
    var schoolId = prefs.getInt('schoolId');
    var studentId = prefs.getInt('studentId');
    String hwDate = widget.date;
    print(hwDate);
    url = "${Urls.BASE_API_URL}/Login/GetHOmeworks?schoolId=$schoolId&studentId=$studentId&date=$hwDate";
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
    return processLoad ?Loader(): data.length > 0  ? ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return Column(
            children: <Widget>[
              SizedBox(height: 2,),
              Padding(
                padding: const EdgeInsets.fromLTRB(7,8,7,6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(child: ChildTxt(title: '${index+1}'), width: 27,),
                    Expanded(child: ChildTxt(title: '${data[index]['SubjectName']}'), flex: 2,),
                    Expanded(child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        Expanded(child: ChildTxt(
                            title: '${data[index]['HomeworkDetail']}'),
                        ),
                        data[index]['IsFileExist'] ?
                        Container(
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
                        )
                            : Container(width: 1,),
                      ],
                    ), flex: 5,),

                  ],
                ),
              ),
              Container(height: 1,color: Colors.black12,),
            ],
          );
        }): FadeAnimation(
                      0.3, Align(
                        alignment: Alignment.center,
                        child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                          letterSpacing: 0.4,),)
                    ),
                    );
  }
}
class HomeworkData1 extends StatefulWidget {
  final String date;
  HomeworkData1({this.date});
  @override
  _HomeworkData1State createState() => _HomeworkData1State();
}

class _HomeworkData1State extends State<HomeworkData1> {
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
    var schoolId = prefs.getInt('schoolId');
    var studentId = prefs.getInt('studentId');
    String hwDate = widget.date;
    print(hwDate);
    url = "${Urls.BASE_API_URL}/Login/GetHOmeworks?schoolId=$schoolId&studentId=$studentId&date=$hwDate";
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
    return processLoad ?Loader(): data.length > 0  ? ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return Column(
            children: <Widget>[
              SizedBox(height: 2,),
              Padding(
                padding: const EdgeInsets.fromLTRB(7,8,7,6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(child: ChildTxt(title: '${index+1}'), width: 34,),
                    Expanded(child: ChildTxt(title: '${data[index]['SubjectName']}'), flex: 2,),
                    Expanded(child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        Expanded(child: ChildTxt(
                            title: '${data[index]['HomeworkDetail']}'),
                        ),
                        data[index]['IsFileExist'] ?
                        Container(
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
                        )
                            : Container(width: 1,),
                      ],
                    ), flex: 5,),

                  ],
                ),
              ),
              Container(height: 1,color: Colors.black12,),
            ],
          );
        }): FadeAnimation(
      0.4, Align(
        alignment: Alignment.center,
        child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
          letterSpacing: 0.4,),)
    ),
    );
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

//class DownloadHomework extends StatefulWidget {
//  @override
//  _DownloadHomeworkState createState() => _DownloadHomeworkState();
//}
//
//class _DownloadHomeworkState extends State<DownloadHomework> {
//  @override
//  Widget build(BuildContext context) {
//    return AlertDialog(
//      backgroundColor: Color(0xfffbfbef),
//      shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.all(
//              Radius.circular(15.0))),
//      content: Container( height: 300,
//        child: Column(
//          children: <Widget>[
//            Align(child: Text('Download File'),alignment: Alignment.center,),
//            Divider(height: 12,),
//            FutureBuilder<List<DownloadFile>>(
//                future: FetchDownload(http.Client()),
//                builder: (context, snapshot) {
//                  if (snapshot.hasError) ;
//                  if(snapshot.hasData) {
//                    return snapshot.data.length > 0 ?
//
//
//                    ListView.builder(
//                        itemCount: snapshot.data == null ? 0 : snapshot.data.length,
//                        itemBuilder: (context, index) {
//                          return Column(
//                              children: <Widget>[
//                                Row(
//                                  children: <Widget>[
//                                    Text('sfsf')
////                                    Expanded(child: Text('${index+1}.',style: TextStyle(color: Colors.black),),flex: 1,),
//////                                    Expanded(child: Test(link:'${snapshot.data[index].homeworkText}'),flex: 4,),
////                                    Expanded(child: Icon(Icons.file_download,color: Colors.blue[700],),flex: 1,)                           ],
//                                  ],
//                                )
//                              ]
//
//                          );
//                        }
//
//                    ) : FadeAnimation(
//                      0.4, Align(
//                        alignment: Alignment.center,
//                        child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
//                          letterSpacing: 0.4,),)
//                    ),
//                    );
//                  }
//                  else {
//                    return Align(child: Loader(),alignment: Alignment.center,);
//                  }
//                })
//          ],
//        ),
//      ),
//      actions: <Widget>[
//        FlatButton(
//          child: Text('Close'),
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//        ),
//      ],
//
//    );
//  }
//}
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









//
//class HomeworkData1 extends StatefulWidget {
//  @override
//  _HomeworkData1State createState() => _HomeworkData1State();
//}
//
//class _HomeworkData1State extends State<HomeworkData1> {
//
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder<List<Hw1>>(
//        future: FetchHw1(http.Client()),
//        builder: (context, snapshot) {
//          if (snapshot.hasError) ;
//          if(snapshot.hasData) {
//            return snapshot.data.length > 0 ?
//            FadeAnimation(
//              0.2, ListView.builder(
//                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
//                itemBuilder: (context, index) {
//                  return Column(
//                    children: <Widget>[
//                      SizedBox(height: 2,),
//                      Padding(
//                        padding: const EdgeInsets.fromLTRB(15,8,15,6),
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Expanded(child: ChildTxt(title: '${index+1}'), flex: 1,),
//                            Expanded(child: ChildTxt(title: '${snapshot.data[index].subjectName}'), flex: 2,),
//                            Expanded(child: Row(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//
//                              children: <Widget>[
//                                Expanded(child: ChildTxt(
//                                    title: '${snapshot.data[index].homeworkDetail}'),
//                                ),
//                                snapshot.data[index].isFileExist ?
//                                Container(
//                                  width: 28,
//                                  child: GestureDetector(
//                                      onTap: () async{
//                                        SharedPreferences prefs = await SharedPreferences.getInstance();
//                                        prefs.setInt('homeworkId', snapshot.data[index].homeworkId);
//                                        Navigator.push(
//                                          context,
//                                          MaterialPageRoute(builder: (context) => Download(subject:snapshot.data[index].subjectName,
//                                          description:snapshot.data[index].homeworkDetail)), //JsonApiDropdown
//                                        );
//                                      },
//                                      child: Icon(Icons.file_download,color: Colors.orange,size: 22,)
//
//                                  ),
//                                )
//                                    : Container(width: 1,),
//                              ],
//                            ), flex: 5,),
//
//                          ],
//                        ),
//                      ),
//                      Container(height: 1,color: Colors.black12,),
//                    ],
//                  );
//                }
//            ),
//            ) : FadeAnimation(
//              0.2, Align(
//                alignment: Alignment.center,
//                child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
//                  letterSpacing: 0.4,),)
//            ),
//            );
//          }
//          else {
//            return Loader();
//          }
//        });
//  }
//  downloadAlert() {
//    showDialog<void>(
//        context: context,
//        builder: (BuildContext context) {
//          return DownloadHomework();
//        }
//    );
//  }
//}