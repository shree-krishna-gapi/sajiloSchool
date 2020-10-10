import 'package:flutter/material.dart';
import 'package:sajiloschool/student/fees/pages/claim.dart';
import 'pages/paid.dart';
import 'pages/remaining.dart';
import 'pages/assigned.dart';
import '../../utils/fadeAnimation.dart';
class Modal{
  mainBottomSheet(BuildContext context,action){
    if(action == 'paid') {
//      showModalBottomSheet(
//          context: context,
//          builder: (BuildContext context){
//            return FadeAnimation(0.2, Paid());
//          }
//      );
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context){
            return Container(height: 400,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft:  Radius.circular(24),
                      topRight: Radius.circular(24),
                    )
                ),child:Paid());
          }
      );
    }
    else if (action == 'unpaid') {
//      showModalBottomSheet(
//          context: context,
//          builder: (BuildContext context){
//            return FadeAnimation(0.2, Assigned());
//          }
//      );
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context){
            return Container(height: 400,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft:  Radius.circular(24),
                      topRight: Radius.circular(24),
                    )
                ),child:Assigned());
          }
      );
    }
    else if (action == 'remaining') {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context){
            return Container(height: 400,
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:  Radius.circular(24),
                  topRight: Radius.circular(24),
                )
            ),child:Remaining());
          }
      );
    }
    else if (action == 'claim') {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context){
            return Container(height: 400,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft:  Radius.circular(24),
                      topRight: Radius.circular(24),
                    )
                ),child:Claim());
          }
      );
    }
  }
}

