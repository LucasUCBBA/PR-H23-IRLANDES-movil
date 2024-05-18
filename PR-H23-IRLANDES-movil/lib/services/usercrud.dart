import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:irlandes_app/models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference collection = firestore.collection('User');

class UserCrud {
  static Future<Response> addUser({
      required String username,
      required String password
  }) async {

    Response response = Response();
    DocumentReference documentReferencer = collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "username": username,
      "password": password
    };

    var result = await documentReferencer
      .set(data)
      .whenComplete(() {
        response.code = 200;
        response.message = "Sucessfully added to the database";
      })
      .catchError((e) {
          response.code = 500;
          response.message = e;
      });

    return response;
  }

  static Stream<QuerySnapshot> readUser() {
    CollectionReference notesItemCollection = collection;
    return notesItemCollection.snapshots();
  }

  static Future<Response> updateUser({
    required String username,
    required String password,
    required String id,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = collection.doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      "username": username,
      "password": password
    };

    await documentReferencer
      .update(data)
      .whenComplete(() {
          response.code = 200;
        response.message = "Sucessfully updated User";
      })
      .catchError((e) {
          response.code = 500;
          response.message = e;
      });

    return response;
  }

  static Future<Response> deleteUser({
    required String id,
  }) async {
     Response response = Response();
    DocumentReference documentReferencer =
        collection.doc(id);

    await documentReferencer
        .delete()
        .whenComplete((){
          response.code = 200;
          response.message = "Sucessfully Deleted User";
        })
        .catchError((e) {
           response.code = 500;
            response.message = e;
        });

    return response;
  }
}