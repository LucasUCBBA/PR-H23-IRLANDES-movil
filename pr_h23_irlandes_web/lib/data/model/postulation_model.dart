import 'package:cloud_firestore/cloud_firestore.dart';

class PostulationModel {
  String? id;
  String level;
  String grade;
  String institutional_unit;
  String city;
  int amount_brothers;
  String student_name;
  String student_lastname;
  String student_ci;
  DateTime birth_day;
  String gender;
  String father_name;
  String father_lastname;
  String father_cellphone;
  String mother_name;
  String mother_lastname;
  String mother_cellphone;
  String telephone;
  String email;
  DateTime interview_date;
  String interview_hour;   
  String userID;
  String status;
  DateTime register_date;

  PostulationModel({
    this.id,
    required this.level,
    required this.grade,
    required this.institutional_unit,
    required this.city,
    required this.amount_brothers,
    required this.student_name,
    required this.student_lastname,
    required this.student_ci,
    required this.birth_day,
    required this.gender,
    required this.father_name,
    required this.father_lastname,
    required this.father_cellphone,
    required this.mother_name,
    required this.mother_lastname,
    required this.mother_cellphone,
    required this.telephone,
    required this.email,
    required this.interview_date,
    required this.interview_hour,
    required this.userID,
    required this.status,
    required this.register_date,
  });

  factory PostulationModel.fromJson(Map<String, dynamic> json, String id) {
    return PostulationModel(
      id: id,
      level: json['level'] as String,
      grade: json['grade'] as String,
      institutional_unit: json['institutional_unit'] as String,
      city: json['city'] as String,
      amount_brothers: json['amount_brothers'] as int,
      student_name: json['student_name'] as String,
      student_lastname: json['student_lastname'] as String,
      student_ci: json['student_ci'] as String,
      birth_day: (json['birth_day'] as Timestamp).toDate(),
      gender: json['gender'] as String,
      father_name: json['father_name'] as String,
      father_lastname: json['father_lastname'] as String,
      father_cellphone: json['father_cellphone'] as String,
      mother_name: json['mother_name'] as String,
      mother_lastname: json['mother_lastname'] as String,
      mother_cellphone: json['mother_cellphone'] as String,
      telephone: json['telephone'] as String,
      email: json['email'] as String,
      interview_date: (json['interview_date'] as Timestamp).toDate(),
      interview_hour: json['interview_hour'] as String,
      userID: json['userID'] as String,
      status: json['status'] as String,
      register_date: (json['register_date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'level': level,
      'grade': grade,
      'institutional_unit': institutional_unit,
      'city': city,
      'amount_brothers': amount_brothers,
      'student_name': student_name,
      'student_lastname': student_lastname,
      'student_ci': student_ci,
      'birth_day': Timestamp.fromDate(birth_day),
      'gender': gender,
      'father_name': father_name,
      'father_lastname': father_lastname,
      'father_cellphone': father_cellphone,
      'mother_name': mother_name,
      'mother_lastname': mother_lastname,
      'mother_cellphone': mother_cellphone,
      'telephone': telephone,
      'email': email,
      'interview_date': Timestamp.fromDate(interview_date),
      'interview_hour': interview_hour,
      'userID': userID,
      'status': status,
      'register_date': Timestamp.fromDate(register_date),
    };
  }
}
