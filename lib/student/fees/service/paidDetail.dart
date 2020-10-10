import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<PaidDetailFee>>fetchDetailFee(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var mId = prefs.getInt('masterPaidId');
  final response =
  await http.get("${Urls.BASE_API_URL}/login/StudentBillDetail?schoolId=$schoolId&billmasterId=$mId");
  print('${Urls.BASE_API_URL}/login/StudentBillDetail?schoolId=$schoolId&billmasterId=$mId');
  if (response.statusCode == 200) {


    final decodeResponseData = json.decode(response.body)['StudentBillDetailList'];
    final stringData = json.encode(decodeResponseData);
    return compute(parseData, stringData);
  } else {

    print("Error getting users.1");

  }
}

List<PaidDetailFee> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<PaidDetailFee>((json) => PaidDetailFee.fromJson(json)).toList();

}
class PaidDetailFee {
  String fromMonth;
  String toMonth;
  double amount;
  double total;
  double subTotal;
  double discount;
  String feeTypeEng;
  PaidDetailFee({
    this.fromMonth,this.toMonth,this.amount,this.total,this.subTotal,this.discount,this.feeTypeEng
  });
  factory PaidDetailFee.fromJson(Map<String, dynamic> json) {
    return PaidDetailFee(
      fromMonth: json['FromMonthName'] as String,
      toMonth: json['ToMonthName'] as String,
      amount: json['Amount'] as double,
      total: json['Total'] as double,
      subTotal: json['SubTotal'] as double,
      discount: json['Discount'] as double,
      feeTypeEng:json['FeeTypeEng'] as String,

    );}
}

