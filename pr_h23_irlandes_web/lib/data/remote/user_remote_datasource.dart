import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pr_h23_irlandes_web/data/model/person_model.dart';

abstract class PersonaDataSource {
  Future<void> registrarUsuario(PersonaModel persona);
  Future<PersonaModel?> iniciarSesion(String username, String password);
  Future<void> updateUserToken(PersonaModel persona);
  Future<void> updateUserPassword(PersonaModel persona);
  Future<void> updatePerson(String id, PersonaModel newPerson);
  Future<String> getToken(String id);
  Future<PersonaModel?> getPersonFromId(String id);
  Future<List<PersonaModel>> readPeople();
  Future<List<String>> getIdsFromParentId(String id);
  Future<List<PersonaModel>> getStudents();
  Future<void> deletePerson(String id);
}

class PersonaDataSourceImpl extends PersonaDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final CollectionReference<PersonaModel> personFirestoreRef = FirebaseFirestore
      .instance
      .collection('Person')
      .withConverter<PersonaModel>(
          fromFirestore: (snapshot, options) =>
              PersonaModel.fromJson(snapshot.data()!),
          toFirestore: (persona, options) => persona.toJson());

  @override
  Future<void> registrarUsuario(PersonaModel persona) async {
    try {
      await _firestore
          .collection('Person')
          .doc(persona.id)
          .set(persona.toJson());
    } catch (e) {
      print("Error al registrar usuario: $e");
    }
  }

  @override
  Future<List<PersonaModel>> getStudents() async {
    List<PersonaModel> personas = [];

    QuerySnapshot<Map<String, dynamic>> docs = await _firestore
        .collection('Person')
        .where('rol' , isEqualTo: 'estudiante')
        .get();
    for (var doc in docs.docs) {
      personas.add(PersonaModel.fromJson(doc.data()));
    }
    return personas;
  }

  @override
  Future<List<PersonaModel>> readPeople() async {
    final noticeDoc = await personFirestoreRef.get();
    final notice = noticeDoc.docs.map((e) {
      return e.data();
    });
    final listNotice = notice.toList();
    await Future.delayed(const Duration(seconds: 4));
    return listNotice;
  }

  @override
  Future<PersonaModel?> iniciarSesion(String username, String password) async {
    try {
      // Recuperar información del usuario desde Firestore
      List<DocumentSnapshot> userDocument = [];
      QuerySnapshot userDoc2 = await _firestore
          .collection('Person')
          .where('username', isEqualTo: username)
          .get();
      userDocument.addAll(userDoc2.docs);
      DocumentSnapshot userDoc = userDocument[0];
      if (userDoc.exists) {
        Map<String, dynamic> mapa = userDoc.data() as Map<String, dynamic>;
        PersonaModel persona = PersonaModel.fromJson(mapa);
        print(persona.username);
        // Verificar la contraseña
        if (persona.password == password) {
          updateUserToken(persona);
          return persona;
        } else {
          print("Contraseña incorrecta");
        }
      } else {
        print("Usuario no encontrado");
      }
    } catch (e) {
      print("Error al iniciar sesión: $e");
    }

    return null;
  }

  Future<List<String>> getIdsFromParentId(String id) async {
    List<String> ids = [];
    QuerySnapshot<Map<String, dynamic>> docs = await _firestore
        .collection('Person')
        .where('fatherId', isEqualTo: id)
        .get();
    QuerySnapshot<Map<String, dynamic>> docsM = await _firestore
        .collection('Person')
        .where('motherId', isEqualTo: id)
        .get();
    for (var doc in docs.docs) {
      ids.add(doc.data()['id']);
    }
    for (var doc in docsM.docs) {
      ids.add(doc.data()['id']);
    }
    return ids;
  }

  /*String hashPassword(String password) {
    // Encriptar la contraseña con SHA-256
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  */

  Future<void> updateUserToken(PersonaModel persona) async {
    String? token = await _messaging.getToken();
    persona.token = token.toString();
    // Utilizamos el método `set` para actualizar un documento existente en Firestore
    await personFirestoreRef.doc(persona.id).update(persona.toJson());
  }

  Future<PersonaModel?> getPersonFromId(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('Person').doc(id).get();
      Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      PersonaModel persona = PersonaModel.fromJson(map);
      print(persona.id);
      return persona;
    } catch (e) {
      print("Error al recuperar registro: $e");
    }
    return null;
  }

  Future<void> updateUserPassword(PersonaModel persona) async {
    await personFirestoreRef.doc(persona.id).update(persona.toJson());
  }

  Future<void> updatePerson(String id, PersonaModel newPerson) async {
    final docUser = FirebaseFirestore.instance
      .collection("Person")
      .doc(id); 
    docUser.update({
      'username': newPerson.username,
      'password': newPerson.password,
      'rol': newPerson.rol,
      'token': newPerson.token,
      'cellphone': newPerson.cellphone,
      'ci': newPerson.ci,
      'direction': newPerson.direction,
      'id': newPerson.id,
      'fatherId': newPerson.fatherId,
      'motherId': newPerson.motherId,
      'lastname': newPerson.lastname,
      'mail': newPerson.mail,
      'grade': newPerson.grade,
      'name': newPerson.name,
      'registerdate': newPerson.resgisterdate.toIso8601String(),
      'status': newPerson.status,
      'surname': newPerson.surname,
      'telephone': newPerson.telephone,
      'updatedate': newPerson.updatedate.toIso8601String(),
    });
  }

  @override
  Future<String> getToken(String id) async {
    List<DocumentSnapshot> userDocument = [];
    QuerySnapshot userSnap =
        await _firestore.collection('Person').where('id', isEqualTo: id).get();
    print(userSnap.docs);

    userDocument.addAll(userSnap.docs);
    DocumentSnapshot userDoc = userDocument[0];
    if (userDoc.exists) {
      Map<String, dynamic> mapa = userDoc.data() as Map<String, dynamic>;
      PersonaModel usuario = PersonaModel.fromJson(mapa);
      return usuario.token;
    } else {
      return '';
    }
  }

  @override
  Future<void> deletePerson(String id) async {
    FirebaseFirestore.instance
      .collection("Person")
      .doc(id)
      .delete(); 
  }
  
}