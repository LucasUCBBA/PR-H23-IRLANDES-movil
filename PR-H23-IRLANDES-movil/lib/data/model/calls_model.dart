class AttentionCallsModel {
  final String id;
  final String student;
  final String teacher;
  final String motive;
  final String studentId;
  final String registrationDate;

  AttentionCallsModel({
  required this.id,
  required this.student, 
  required this.teacher, 
  required this.motive,
  required this.studentId,
  required this.registrationDate
  });

  static AttentionCallsModel fromJson(Map<String, dynamic> json) => 
    AttentionCallsModel(
      id: json["id"],
      student: json['student'],
      teacher: json['teacher'],
      motive: json['motive'],
      studentId: json['studentId'],
      registrationDate: json['registrationDate']
    );

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': student,
      'teacher': teacher,
      'motive': motive,
      'studentId': studentId,
      'registrationDate': registrationDate
    };
  }
}