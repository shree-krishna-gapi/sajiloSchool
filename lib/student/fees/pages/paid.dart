import 'package:flutter/material.dart';
import 'package:sajiloschool/student/fees/service/paidDetail.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/paidFees.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';

class Paid extends StatefulWidget {
  @override
  _PaidState createState() => _PaidState();
}

class _PaidState extends State<Paid> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
//                      color: Colors.orange,
              gradient: purpleGradient,
              borderRadius: BorderRadius.only(
                topLeft:  Radius.circular(24),
                topRight: Radius.circular(24),
              )
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15,12,15,12),
            child: Row(
              children: <Widget>[
                Expanded(child: ModalTitle(txt:'S.N'),flex: 1,),
                Expanded(child: ModalTitle(txt: 'Bill No.',),flex: 3,),
                Expanded(child: ModalTitle(txt: 'Date',),flex: 3,),

                Expanded(child: ModalTitle(txt: 'Amount',),flex: 3,),
              ],
            ),
          ),
        ),
        Container(
          height: 440,
          padding: EdgeInsets.only(bottom: 40),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15,12,15,132),
            child: FutureBuilder<List<PaidFee>>(
                future: fetchfee(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError);
                  if(snapshot.hasData) {
                    return snapshot.data.length > 0 ?
                    FadeAnimation(
                      0.4, ListView.builder(
                        itemCount: (snapshot.data == null && snapshot.data.length==0) ? 0 : snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Padding(padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: _create1(context, snapshot.data[index].studentBillMasterId,'${index+1}',snapshot.data[index].billNumber,snapshot.data[index].billDateNepali,'${snapshot.data[index].amount}')),
                              Divider()
                            ],
                          );
                        }
                    ),
                    ) :
                    FadeAnimation(
                      0.4, Align(
                        alignment: Alignment.center,
                        child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                          letterSpacing: 0.4,),)
                    ),
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

    );
  }
  bool showGrandTotal = false;
  Row _create1(BuildContext context,int mId, String sn, String type,String billDate, String amt) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(sn,
          style: TextStyle(fontSize: 15,
            letterSpacing: 0.4,
          ),),flex: 1,),
        Expanded(child: Text(type == null ? 'Nothing': type,style: TextStyle(fontSize: 15,
          letterSpacing: 0.4, )),flex: 3,),
        Expanded(child: Text(billDate,style: TextStyle(fontSize: 15,
          letterSpacing: 0.4, )),flex: 3,),
        Expanded(child: Row(
          children: [
            Text(amt,style: TextStyle(fontSize: 15,
              letterSpacing: 0.4,)),

            InkWell(onTap: () async{
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('masterPaidId',mId);
              detailAlert(amt);
            },child: Row(
              children: [
                SizedBox(width: 8,),
                Icon(Icons.remove_red_eye, color: Colors.orange,),
                SizedBox(width: 4,),
              ],
            ))
          ],
        ),flex: 3,),
      ],
    );
  }
  detailAlert(String grandTotal) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Scaffold(
              backgroundColor: Color(0x000000),
              body: InkWell( onTap: (){Navigator.of(context).pop();},

                  child: Center(
                      child: Container(
                          height: 440,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Color(0xfffbf9e7),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
//                      color: Colors.orange,
                                      gradient: purpleGradient,
                                      borderRadius: BorderRadius.only(
                                        topLeft:  Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5,11,5,12),
                                    child: Row(
                                      children: <Widget>[
                                        Container(child: ModalTitle1(txt:'S.N'),width:35,),
                                        Expanded(child: ModalTitle1(txt: 'Fee Type ',),flex: 3,),
                                        Expanded(child: ModalTitle1(txt: 'Amount',),flex:2,),
                                        Expanded(child: ModalTitle1(txt: 'Discount',),flex:2,),
                                        Expanded(child: ModalTitle1(txt: 'Total',),flex:2,),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(

                                  padding: EdgeInsets.all(15.0),
                                  width: double.infinity,
                                  child: FutureBuilder<List<PaidDetailFee>>(
                                      future: fetchDetailFee(http.Client()),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError);
                                        if(snapshot.hasData) {

                                           showGrandTotal = true;


                                          return snapshot.data.length > 0 ?
                                          FadeAnimation(
                                            0.4, ListView.builder(
                                            shrinkWrap: true,
                                              itemCount: (snapshot.data == null && snapshot.data.length==0) ? 0 : snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: <Widget>[
                                                    snapshot.data[index].fromMonth == '' || snapshot.data[index].fromMonth == null ? Container() : Container( color: Colors.orange[400],
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(0,4,0,4),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: <Widget>[
//                  Text('From:'),
                                                                Text('       From:  ',style: TextStyle(color: Colors.white),),
                                                                Text('${snapshot.data[index].fromMonth}',style: TextStyle(fontSize: 14,
                                                                    letterSpacing: 0.4,fontWeight: FontWeight.w500,color: Colors.white )),
                                                                Text('   To   ',style: TextStyle(color: Colors.white),),
//                  Text('To:'),
                                                                Text('${snapshot.data[index].toMonth}',style: TextStyle(fontSize: 14,
                                                                    letterSpacing: 0.4, fontWeight: FontWeight.w500,color: Colors.white )),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 2,),
                                                    Row(
                                                      children: <Widget>[
                                                        Container(child: Text('${index+1}'),width:35,),
                                                        Expanded(child: Text('${snapshot.data[index].feeTypeEng}'),flex: 3,),
                                                        Expanded(child: Text('${snapshot.data[index].subTotal}'),flex:2,),
                                                        Expanded(child:snapshot.data[index].discount == null || snapshot.data[index].discount == ''?Text('-') : Text('${snapshot.data[index].discount}'),flex:2,),
                                                        Expanded(child: Text('${snapshot.data[index].total}'),flex:2,),
                                                      ],
                                                    ),

                                                    Divider(),
                                                    snapshot.data.length == index+1 ? Padding(
                                                      padding: const EdgeInsets.fromLTRB(0,10,5,12),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(child: Text(''),width:35,),
                                                          Expanded(child: Text('Grand Total',style: TextStyle(fontWeight: FontWeight.w600),),flex: 3,),
                                                          Expanded(child: Text('',),flex:2,),
                                                          Expanded(child: Text('',),flex:2,),
                                                          Expanded(child: showGrandTotal ? Text(  grandTotal,style: TextStyle(fontWeight: FontWeight.w600)): Text(''),flex:2,),
                                                        ],
                                                      ),
                                                    ) : Container(),
                                                  ],
                                                );
                                              }
                                          ),
                                          ) :
                                          FadeAnimation(
                                            0.4, Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top:10),
                                                child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                                                  letterSpacing: 0.4,),),
                                              )
                                          ),
                                          );
                                        } else {
                                          return Center(child: Padding(
                                            padding: const EdgeInsets.only(top:60.0),
                                            child: Loader(),
                                          ));
                                        }
                                      }),
                                ),

                              ],
                            ),


                          )))));
        });
  }
  ListTile _createTile(BuildContext context, String name, IconData icon, Function action){
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: (){
        Navigator.of(context).pop();
        _showDialog(context,'Under Construction');
      },
    );
  }

  void _showDialog(BuildContext context,txtmseg) {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              title: Row(
                children: <Widget>[
                  Container(width: 5, height: 22, color: Colors.green[400],),
                  SizedBox(width: 15,),
                  Expanded(child: Text('View $txtmseg'))
                ],
              ),
              elevation: 4,
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              content: Text('$txtmseg'));});
  }
}

