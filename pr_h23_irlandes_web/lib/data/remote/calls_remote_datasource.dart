import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pr_h23_irlandes_web/data/model/calls_model.dart';
import 'package:pr_h23_irlandes_web/data/remote/user_remote_datasource.dart';

class AttentionCallsRemoteDataSource{
  final PersonaDataSource personaDataSource = PersonaDataSourceImpl();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future createAttentionCall(AttentionCallsModel callsModel) async {
    final docCall = FirebaseFirestore.instance.collection("AttentionCalls").doc();
    final call = AttentionCallsModel(id: docCall.id, student: callsModel.student, teacher: callsModel.teacher, motive: callsModel.motive, studentId: callsModel.studentId, registrationDate: callsModel.registrationDate).toJson();
    await docCall.set(call);
  }

  Future<List<AttentionCallsModel>> getAttentionCallsByParentId(
      String id) async {
    List<AttentionCallsModel> attentioncalls = [];
    //List<String> ids = await personaDataSource.getIdsFromParentId(id);
    QuerySnapshot<Map<String, dynamic>> tempAttentionCalls = await firestore
        .collection('AttentionCalls')
        .where('studentId', isEqualTo: id)
        .get();
    for (var doc in tempAttentionCalls.docs) {
      AttentionCallsModel attentionCall =
          AttentionCallsModel.fromJson(doc.data());
      attentioncalls.add(attentionCall);
    }
    return attentioncalls;
  }

  Future<List<AttentionCallsModel>> getAttentionCalls() async {
    List<AttentionCallsModel> attentioncalls = [];
    QuerySnapshot<Map<String, dynamic>> tempAttentionCalls = await firestore
        .collection('AttentionCalls')
        .get();
    for (var doc in tempAttentionCalls.docs) {
      AttentionCallsModel attentionCall =
          AttentionCallsModel.fromJson(doc.data());
      attentioncalls.add(attentionCall);
    }
    return attentioncalls;
  }

  void updateCall(String id, AttentionCallsModel newCall) async {
    final docCall = FirebaseFirestore.instance
      .collection("AttentionCalls")
      .doc(id); 
    docCall.update({
      'student': newCall.student,
      'teacher': newCall.teacher,
      'motive': newCall.motive
    });
  }

  void deleteCall(String id) async {
    await FirebaseFirestore.instance
      .collection("AttentionCalls")
      .doc(id).delete();
  }
}