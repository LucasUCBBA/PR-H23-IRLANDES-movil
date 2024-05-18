import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:irlandes_app/data/model/calls_model.dart';
import 'package:irlandes_app/data/remote/user_remote_datasource.dart';

class AttentionCallsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AttentionCallsModel>> getAttentionCallsByParentId(
      String id) async {
    List<AttentionCallsModel> attentioncalls = [];
    //List<String> ids = await _personaDataSource.getIdsFromParentId(id);
    QuerySnapshot<Map<String, dynamic>> tempAttentionCalls = await _firestore
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
}
