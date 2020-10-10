class StudentModel {
  int studentId;
  String studentName;
  int rollNo;
  String imageLocation;
  String emailAddress;
  StudentModel({this.studentId,this.studentName,this.rollNo,this.imageLocation,this.emailAddress});


  factory StudentModel.fromJson(Map<String, dynamic> parsedJson) {
    return StudentModel(
      studentId: parsedJson["ProfileId"],
      studentName: parsedJson["StudentName"] as String,
      rollNo: parsedJson["RollNo"] as int,
      imageLocation: parsedJson["ImageLocation"] as String,
      emailAddress: parsedJson["EmailAddress"] as String,
    );
  }
}
