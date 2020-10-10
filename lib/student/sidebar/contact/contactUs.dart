import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/student/student.dart';
import 'dart:async';
import 'dart:convert';
class ContactUS extends StatefulWidget {
  @override
  _ContactUSState createState() => _ContactUSState();
}

class _ContactUSState extends State<ContactUS> {
  bool calenderSearch = true;

  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
  final _contactUsForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Contact US'),
          backgroundColor: Pallate.appBar,
        ),
        backgroundColor: Color(0xfffbf9e7),
        body:Container(
            decoration: BoxDecoration(
              color: Color(0xfffbf9e7),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _contactUsForm,
              child: FadeAnimation(
                0.3, Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _text('Subject'),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(12,0,0,0),
                        hintText: "Subject",
                        border: OutlineInputBorder(),
                      ),
                      controller: subject,
                      validator: (value){
                        if(value.isEmpty) {
                          return '* Insert the Subject for Inquiry';
                        }
                        else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 15,),
                    _text('Message'),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      maxLength: 300,
                      decoration: InputDecoration(
                        //Add th Hint text here.
                        hintText: "message",
                        border: OutlineInputBorder(),
                      ),
                      controller: message,
                      validator: (value){
                        if(value.isEmpty) {
                          return '* Insert the Message for Inquiry';
                        }
                        else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 15,),
                    Align(alignment: Alignment.topRight,
                      child: Container(  decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)
                          ),
                          color: Colors.orange[500].withOpacity(0.8)
                      ),

                            child: InkWell(splashColor: Colors.deepPurpleAccent,child: Padding(
                              padding: const EdgeInsets.fromLTRB(13,10,13,10),
                              child:  Text('Send Message',style: TextStyle(
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

                              if (_contactUsForm.currentState.validate()) {
                                submitContact();
                              }
                              else {
                                showSnack('Please, Select Input Field the Field.');
                              }

                            },),
                          )
                    ),
                  ],
                ),
              ),
            ))



    );
  }
  submitContact() async{
    String s = subject.text;
    String m = message.text;
   final SharedPreferences prefs = await SharedPreferences.getInstance();
    int schoolId = prefs.getInt('schoolId');
    int studentId = prefs.getInt('studentId');
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Wait();});
    String url = '${Urls.BASE_API_URL}/login/SaveContactForm?schoolId=$schoolId&studentId=$studentId&subject=$s&message=$m';
    print(url);
    final response =
        await http.get(url);
    Navigator.of(context).pop();
    if (response.statusCode == 200) {
      final isReturn = json.decode(response.body)['Success'];
      if(isReturn == true) {
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return Success(txt:'Send Message Success!');});

        Timer(Duration(milliseconds: 800), () {
          Navigator.of(context).pop();
                    Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Student()),
          );
        });
      }
      else {
        showSnack('Inquiry Failed! Please, Try Again');
//        showDialog<void>(
//            context: context,
//            barrierDismissible: true, // user must tap button!
//            builder: (BuildContext context) {
//              return Error(txt: 'Error',subTxt: 'Please, Contact to the Developer',);
//            }
//        );
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
  }

   _text(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(text,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
    );
  }
  showSnack(message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$message'),
      backgroundColor: Colors.black26,
      duration: Duration(milliseconds: 800),
    ));
  }
}



