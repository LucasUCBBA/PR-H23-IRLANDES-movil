import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pr_h23_irlandes_web/data/model/Coordinacion_Reports_model.dart';

abstract class CordinacionRemoteDatasource {
  Future<List<CoordinacionModel>> getReportCord();
  Future<String> createReportCord(CoordinacionModel reportCord);
  Future<CoordinacionModel> getReportCordByID(String reportCordID);
  Future<List<CoordinacionModel>> getReportCordAfterDate(DateTime date);
  Future<void> updateReportCordStatus(String reportCordID, String status);
  Future<void> deleteReportCord(String reportCordID);
}

class CordinacionRemoteDatasourceImpl extends CordinacionRemoteDatasource {
  final CollectionReference<CoordinacionModel> reportCordFirestoreRef =
      FirebaseFirestore.instance.collection('Coordinacion_Reports').withConverter<CoordinacionModel>(
            fromFirestore: (snapshot, options) => CoordinacionModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (reportCord, options) => reportCord.toJson(),
          );


  @override
  Future<String> createReportCord(CoordinacionModel reportCord) async {
    DocumentReference docRef = await reportCordFirestoreRef.add(reportCord);
    return docRef.id;
  }

  
  Future<void> updateReportCoord(CoordinacionModel reportCoord) async {
    // Utilizamos el método `set` para actualizar un documento existente en Firestore
    await reportCordFirestoreRef.doc(reportCoord.id).update(reportCoord.toJson());
  }

  @override
  Future<void> deleteReportCord(String reportCordID) async {
    final reportCordDoc = reportCordFirestoreRef.doc(reportCordID);
    await reportCordDoc.delete();
  }

  @override
  Future<List<CoordinacionModel>> getReportCord() async {
    final reportCordDocs = await reportCordFirestoreRef.get();
    final reportsCord = reportCordDocs.docs.map((e) {
      return e.data();
    });

    final listReports = reportsCord.toList();

    listReports.sort((a, b) {
      DateTime dateA = a.interview_date_cord;
      DateTime dateB = b.interview_date_cord;
      return dateA.compareTo(dateB);
    });

    await Future.delayed(const Duration(seconds: 4));
    return listReports;
  }

  @override
  Future<List<CoordinacionModel>> getReportCordAfterDate(DateTime date) async {
    final reportCordDocs = await reportCordFirestoreRef.get();
    final reportsCord = reportCordDocs.docs.map((e) => e.data()).toList();

    final pendingReportsCord = reportsCord.where((reportCord) => reportCord.interview_date_cord.isAfter(date)).toList();

    await Future.delayed(const Duration(seconds: 4));
    return pendingReportsCord.reversed.toList();
  }

  @override
  Future<CoordinacionModel> getReportCordByID(String reportCordID) async {
    final reportCordDoc = await reportCordFirestoreRef.doc(reportCordID).get();
    final reportCord = reportCordDoc.data();

    await Future.delayed(const Duration(seconds: 4));
    return reportCord!;
  }

  @override
  Future<void> updateReportCordStatus(String reportCordID, String status) async {
    final reportCordDoc = reportCordFirestoreRef.doc(reportCordID);
    await reportCordDoc.update({'estadoRevisado': status});
  }

  Future<void> updateInterviewCordDateTime(String postulationId, DateTime newDateTime, String newTime) async {
    try {
      await FirebaseFirestore.instance
          .collection('Coordinacion_Reports')
          .doc(postulationId)
          .update({
            'interview_date_cord': Timestamp.fromDate(newDateTime),
            'interview_hour_cord': newTime,
          });
    } catch (e) {
      //throw Exception('Error al actualizar la fecha y hora de la entrevista');
      throw Exception(e);
    }
  }
}
