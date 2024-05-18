import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:irlandes_app/data/model/person_model.dart';

class PersonaDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  get sha256 => null;

  final CollectionReference<PersonaModel> personFirestoreRef = FirebaseFirestore
      .instance
      .collection('Person')
      .withConverter<PersonaModel>(
          fromFirestore: (snapshot, options) =>
              PersonaModel.fromJson(snapshot.data()!),
          toFirestore: (persona, options) => persona.toJson());

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

  Future<PersonaModel?> getPersonFromId(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('Person').doc(id).get();
      Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      PersonaModel persona = PersonaModel.fromJson(map);
      print(persona.id);
      return persona;
    } catch (e) {
      print("Error al iniciar sesión: $e");
    }
    return null;
  }

  Future<List<PersonaModel>> getPersonsFromParentId(String id) async {
    List<PersonaModel> personas = [];
    List<PersonaModel> students = [];

    QuerySnapshot<Map<String, dynamic>> docs = await _firestore
        .collection('Person')
        .where('rol' , isEqualTo: 'estudiante')
        .get();
    for (var doc in docs.docs) {
      personas.add(PersonaModel.fromJson(doc.data()));
    }   
   
    for(var student in personas)  {
      if (student.fatherId == id || student.motherId == id) {
        students.add(student);
      }
    }
    return students;
  }

  Future<void> updateUserToken(PersonaModel persona) async {
    String? token = await _messaging.getToken();
    persona.token = token.toString();
    // Utilizamos el método `set` para actualizar un documento existente en Firestore
    await personFirestoreRef.doc(persona.id).update(persona.toJson());
  }

  Future<void> updateUserPassword(PersonaModel persona) async {
    await personFirestoreRef.doc(persona.id).update(persona.toJson());
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
}
