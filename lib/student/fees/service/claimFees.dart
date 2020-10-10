import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
String url;
Future<List<FeeClaimGet>>fetchClaimFee(http.Client client) async {

  print('screen/fees/service/remaningFees');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var educationalYearId = prefs.getInt('educationalYearIdFees');
  var studentId = prefs.getInt('studentId');
  url = "${Urls.BASE_API_URL}/login/GetClaimBill?schoolId=$schoolId&educationYearId=$educationalYearId&studentId=$studentId";
  http://mobileapp.karmathalo.com/Api/login/GetClaimBill?schoolid=3&educationYear=34&studentId=2
  // String kk = 'http://mobileapp.karmathalo.com/api/login/GetClaimBill?schoolId=3&educationYearId=30&studentId=319';
  final response =
  await http.get(url);
  print('$url');
  if (response.statusCode == 200) {
    final stringData = response.body;
    return compute(parseData, stringData);
  } else {
    print("Error getting users.1");

  }
}

List<FeeClaimGet> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<FeeClaimGet>((json) => FeeClaimGet.fromJson(json)).toList();

}
class FeeClaimGet {
  final String feeTypeName;
  final double rate;
  final double total;
  final String fromMonthName;
  final String toMonthName;
  final String upToMonthName;

  FeeClaimGet({
   this.feeTypeName,this.rate,this.total,this.fromMonthName,this.toMonthName,this.upToMonthName
  });
  factory FeeClaimGet.fromJson(Map<String, dynamic> json) {
    return FeeClaimGet(
      feeTypeName: json['FeeTypeName'] as String,
      rate: json['Rate'] as double,
      total: json['Total'] as double,
      fromMonthName: json['FromMonthName'] as String,
      toMonthName: json['ToMonthName'] as String,
      upToMonthName: json['UpToMonthName'] as String,

    );}
}

