import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'service/modalService.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/fadeAnimation.dart';

// note roll no display sn to change real data roll no
class Modal{
  mainBottomSheet(BuildContext context,name,roll,isMonthly,selectedMonth,fromDate,toDate){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context){
          return FadeAnimation(
            0.6, Container(
              height: 500,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:  Radius.circular(24),
                  topRight: Radius.circular(24),
                )
            ),
            child: ListView(
              children: <Widget>[
                Container(
//                    height: 60,
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 7),
                    child: isMonthly ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(child: keyText(context,"Name :"),width: 58,),
                                  valueText(context,"$name"),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: <Widget>[
                                  Container(child: keyText(context,"Roll No :"),width: 58,),
                                  valueText(context,"$roll"),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end ,
                                children: <Widget>[
                                  keyTextHead(context,'Report of: '),
                                  keyTextHead(context,' $selectedMonth'),
                                ],
                              ),
                            ],
                          ),
                        ),

                      ],
                    ):
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(child: keyText(context,"Name :"),width: 80,),
                            valueText(context,"$name"),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Container(child: keyText(context,"Roll No. :"),width: 80,),
                            valueText(context,"$roll"),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Align( alignment: Alignment.centerRight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  keyText(context,'From : '),
                                  keyTextHead(context,'$fromDate'),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Row(
                                children: <Widget>[
                                  keyText(context,'To : '),
                                  keyTextHead(context,'$toDate'),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: purpleGradient,
//                      borderRadius: BorderRadius.only(
//                        topLeft:  Radius.circular(24),
//                        topRight: Radius.circular(24),
//                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15,12,15,12),
                    child: Row(
                      children: <Widget>[
                        Container(child: ModalTitle(txt:'S.N'),width: 34,),
                        Container(child: ModalTitle(txt: 'Date',),width: 100,),
                        Expanded(child: ModalTitle(txt: 'Day',),flex: 1,),
                        Expanded(child: ModalTitle(txt: 'Status',),flex: 1,),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 380,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: FutureBuilder<List<AttendancePerStudents>>(
                        future: fetchService(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError);
                          if(snapshot.hasData) {
                            return snapshot.data.length > 0 ?
                            ListView.builder(
                                padding: EdgeInsets.all(0),
                                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                itemBuilder: (context, index) {
//                              return Text('${snapshot.data[index].monthName}');
                                  return FadeAnimation(
                                    0.2, Column(
                                    children: <Widget>[
                                      snapshot.data[index].isWorkingDay ? Container(

                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(15,8,15,8),
                                          child: Row(
                                            children: <Widget>[
                                              Container(child: ChildTxt(title: '${index+1}'), width: 34,),
                                              Expanded(child: ChildTxt(title: '${snapshot.data[index].dateOfYearNepali}'), flex: 1,),
                                              Expanded(child: ChildTxt(title: '${snapshot.data[index].dayName}'), flex: 1,),
                                              Expanded(child: snapshot.data[index].isPresent ? ChildTxt(title: 'Present'):
                                              ChildTxt1(title:'Absent'),
                                                flex: 1,),
                                            ],
                                          ),
                                        ),
                                      ):
                                      Container(
                                        color: Colors.orange[400],
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(15,8,15,8),
                                          child: Row(
                                            children: <Widget>[
                                              Container(child: ChildTxtWhite(title: '${index+1}'), width: 28,),
                                              Expanded(child: ChildTxtWhite(title: '${snapshot.data[index].dateOfYearNepali}'), flex: 1,),
                                              Expanded(child: ChildTxtWhite(title: '${snapshot.data[index].dayName}'), flex: 1,),
                                              Expanded(child: ChildTxtWhite(title: 'Holiday'),
                                                flex: 1,),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(height: 1, color: Colors.black12,),
                                    ],
                                  ),
                                  );
                                }
                            ) :
                            Align(
                                alignment: Alignment.center,
                                child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                                  letterSpacing: 0.4,),)
                            );
                          } else {
                            return Loader();
                          }
                        }),

//                            ],
//                          ),
                  ),
                ),
              ],
            ),
          ),
          );
        }
    );
  }
  Text keyTextHead(BuildContext context,String txt) {
    return Text(txt,style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 13,fontStyle: FontStyle.italic
    ),);
  }
  Text keyText(BuildContext context,String txt) {
    return Text(txt,style: TextStyle(
        fontWeight: FontWeight.w500
    ),);
  }
  Text valueText(BuildContext context,String txt) {
    return Text(txt,style: TextStyle(
        fontWeight: FontWeight.w500
    ),);
  }
}



class ChildTxt extends StatelessWidget {
  ChildTxt({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
      letterSpacing: 0.4,));
  }
}
class ChildTxtWhite extends StatelessWidget {
  ChildTxtWhite({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
        letterSpacing: 0.4,color: Colors.white));
  }
}
class ChildTxt1 extends StatelessWidget {
  ChildTxt1({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
        letterSpacing: 0.4,color: Colors.red[300]));
  }
}

class SubModalTitle extends StatelessWidget {
  SubModalTitle({this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Text(txt,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,
      letterSpacing: 0.4, ));
  }
}

