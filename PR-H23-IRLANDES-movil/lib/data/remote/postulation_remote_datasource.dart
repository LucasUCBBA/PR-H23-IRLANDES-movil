import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:irlandes_app/data/model/postulation_model.dart';

abstract class PostulationRemoteDatasource{
  Future<List<PostulationModel>> getPostulations();
  Future<String> createPostulations(PostulationModel postulation);
  Future<PostulationModel> getPostulationByID(String postulatioID);
  Future<List<PostulationModel>> getPostulationsAfterDate(DateTime date);
  Future<List<PostulationModel>> getPostulationsByUserID(String userID);
  Future<void> updatePostulationStatus(String postulatioID, String status);
  Future<void> deletePostulation(String postulatioID);
}

class PostulationRemoteDatasourceImpl extends PostulationRemoteDatasource {
  final CollectionReference<PostulationModel> postulationFirestoreRef =FirebaseFirestore.instance.collection('Postulations').withConverter<PostulationModel>(fromFirestore: (snapshot, options) =>PostulationModel.fromJson(snapshot.data()!,snapshot.id),toFirestore: (postulation, options) => postulation.toJson());
  
  @override
  Future<String> createPostulations(PostulationModel postulation) async {
    DocumentReference docRef = await postulationFirestoreRef.add(postulation);
    return docRef.id;
  }
  
  @override
  Future<PostulationModel> getPostulationByID(String postulatioID) async {
    final postulationDoc = await postulationFirestoreRef.doc(postulatioID).get();
    final postulation = postulationDoc.data();
    
    await Future.delayed(const Duration(seconds: 4));
    return postulation!;
  }
  
  @override
  Future<List<PostulationModel>> getPostulations() async {
    final psotulationDocs = await postulationFirestoreRef.get();

    final potulations = psotulationDocs.docs.map((e) {
      return e.data();
    });

    final listPostulations=potulations.toList();

    listPostulations.sort((a, b) {
      DateTime dateA = a.interview_date;
      DateTime dateB = b.interview_date;
      return dateA.compareTo(dateB);
    });

    await Future.delayed(const Duration(seconds: 4));
    return listPostulations;
  }

  @override
  Future<List<PostulationModel>> getPostulationsByUserID(String userID) async {
    final psotulationDocs = await postulationFirestoreRef.where('userID', isEqualTo: userID).get();

    final potulations = psotulationDocs.docs.map((e) {
      return e.data();
    });

    final listPostulations=potulations.toList();

    listPostulations.sort((a, b) {
      DateTime dateA = a.interview_date;
      DateTime dateB = b.interview_date;
      return dateA.compareTo(dateB);
    });

    await Future.delayed(const Duration(seconds: 4));
    return listPostulations.reversed.toList();
  }
  
  @override
  Future<List<PostulationModel>> getPostulationsAfterDate(DateTime date) async {
    final psotulationDocs = await postulationFirestoreRef.get();

    final potulations = psotulationDocs.docs.map((e) {
      return e.data();
    });

    final listPostulations=potulations.toList();

    final pendingPostulations = listPostulations.where((postulation) {
      return postulation.interview_date.isAfter(date);
    }).toList();

    await Future.delayed(const Duration(seconds: 4));
    return pendingPostulations.reversed.toList();    
  }
  
  @override
  Future<void> updatePostulationStatus(String postulatioID, String status) async {
    final postulationDoc = postulationFirestoreRef.doc(postulatioID);
    await postulationDoc.update({'status': status});
  }
  
  @override
  Future<void> deletePostulation(String postulatioID) async {
    final postulationDoc = postulationFirestoreRef.doc(postulatioID);
    await postulationDoc.delete();
  }
}