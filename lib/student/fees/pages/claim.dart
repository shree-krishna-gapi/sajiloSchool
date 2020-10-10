import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:sajiloschool/utils/pallate.dart';
import '../service/claimFees.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';


class Claim extends StatelessWidget {
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
            child:Padding(
              padding: const EdgeInsets.fromLTRB(15,12,15,12),
              child: Row(
                children: <Widget>[
                  Container(child: Text('S.N',
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.4, shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black38,
                            offset: Offset(2.0, 2.0),
                          ),
                        ]
                    ),),width: 38,),
                  Expanded(child: Text(' Fee Type',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.white,
                      letterSpacing: 0.4, shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ])),flex: 3,),
                  Expanded(child: Text('Rate',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.white,
                      letterSpacing: 0.4, shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ])),flex: 2,),
                  Expanded(child: Text('Total',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.white,
                      letterSpacing: 0.4, shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ])),flex: 2,),
                ],
              ),
            ),

          ),
          Container(
            height: 484,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15,12,15,132),
              child: FutureBuilder<List<FeeClaimGet>>(
                  future: fetchClaimFee(http.Client()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError);
                    if(snapshot.hasData) {
                      return snapshot.data.length > 0 ?
                      ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return FadeAnimation(
                              0.3,  _create1(context,
                                index+1,
                                snapshot.data.length,
                                snapshot.data[index].rate,
                                snapshot.data[index].total,
                                snapshot.data[index].feeTypeName,
                                snapshot.data[index].fromMonthName,
                                snapshot.data[index].toMonthName,
                                snapshot.data[index].upToMonthName
                            )



                            );
                          }
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
  double totalAmount = 0.0;
  Column _create1(BuildContext context, int sn, int length,
      double rate, double total,
      String feeTypeName,String fromMonthName,String toMonthName,String upToMonthName,

      ) {
    totalAmount +=total;
    return Column(
        children: [
          sn == 1 ?  Padding(
            padding: const EdgeInsets.fromLTRB(0,4,0,10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Up To Month : ',style: TextStyle(fontWeight: FontWeight.w600),),
                Text(upToMonthName,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
              ],
            )
          ): Container(),
          Container( color: Colors.orange[400],
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
                      Text('$fromMonthName',style: TextStyle(fontSize: 14,
                          letterSpacing: 0.4,fontWeight: FontWeight.w500,color: Colors.white )),
                      Text('   To   ',style: TextStyle(color: Colors.white),),
//                  Text('To:'),
                      Text('$toMonthName',style: TextStyle(fontSize: 14,
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
              Container(child: Text('$sn',
                style: TextStyle(fontSize: 15,
                  letterSpacing: 0.4,
                ),),width: 38, ),
              Expanded(child: Text(  feeTypeName,style: TextStyle(fontSize: 15,
                letterSpacing: 0.2, )),flex: 3,),
              Expanded(child: Text('$rate',style: TextStyle(fontSize: 15,
                letterSpacing: 0.4, )),flex: 2,),
              Expanded(child: Text('$total',style: TextStyle(fontSize: 15,
                letterSpacing: 0.4, )),flex: 2,),

            ],
          ),
          SizedBox(height: 5,),
          Container(height: 1, color: Colors.black12,),SizedBox(height: 10,),
          sn == length ? Padding(
            padding: const EdgeInsets.only(top:4.0,bottom: 20),
            child: Row(
    children: <Widget>[
    Container(child: Text('',
    style: TextStyle(fontSize: 15,
    letterSpacing: 0.4,
    ),),width: 38, ),
    Expanded(child: Text(  'Grand Total',style: TextStyle(fontSize: 15,
    letterSpacing: 0.2,fontWeight: FontWeight.w600 )),flex: 3,),
      Expanded(child: Text(  '',style: TextStyle(fontSize: 15,
          letterSpacing: 0.2,fontWeight: FontWeight.w600 )),flex: 2,),
    Expanded(child: Text('$totalAmount',style: TextStyle(fontSize: 15,
    letterSpacing: 0.4,fontWeight: FontWeight.w600 )),flex: 2,),

    ],
    ),
          ) : Container()
        ],
    );
  }



}
