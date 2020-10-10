import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Album> fetchAlbum() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var studentId = prefs.getInt('studentId');
  var examId = prefs.getInt('examId');
  String url = "${Urls.BASE_API_URL}/Login/GetPeriodExamMarks?schoolId=$schoolId&examId=$examId&studentId=$studentId";

  final response =
  await http.get(url);

  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}


class Album {
  final double obtainedMarks;
  final double fullMarks;
  final String percentage;
  final String gpa;
  final String grades;
  Album({this.obtainedMarks, this.fullMarks,this.percentage,this.gpa,this.grades});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        obtainedMarks: json['ObtainedMarks'],
        fullMarks: json['FullMarks'],
        percentage: json['Percentage'],
        gpa:json['Gpa'],
        grades:json['Grades']
    );
  }
}
