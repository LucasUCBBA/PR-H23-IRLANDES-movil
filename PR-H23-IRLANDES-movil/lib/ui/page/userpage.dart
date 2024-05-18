import 'package:flutter/material.dart';
import 'package:irlandes_app/data/model/person_model.dart';
import 'package:irlandes_app/data/remote/user_remote_datasource.dart';
import 'package:irlandes_app/infraestructure/global/global_methods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:irlandes_app/ui/page/editinfo.dart';
import 'package:irlandes_app/ui/page/options_menu.dart';
import 'package:irlandes_app/ui/widgets/app_bar_custom_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  PersonaModel? persona;
  String personaId = '';
  final PersonaDataSource _usuarioDataSource = PersonaDataSource();

  @override
  void initState() {
    super.initState();
    getId();
  }

  void getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      personaId = prefs.getString('personId')!;
    });

    // Luego, puedes llamar a la función para obtener los datos del usuario
    loadUserData();
  }

  void loadUserData() async {
    try {
      PersonaModel? loadedPersona =
          await _usuarioDataSource.getPersonFromId(personaId);

      // Verifica que loadedPersona no sea nulo antes de asignar a persona
      if (loadedPersona != null) {
        setState(() {
          persona = loadedPersona;
        });
      } else {
        // Manejar el caso donde loadedPersona es nulo
        print('Error: loadedPersona es nulo');
      }
    } catch (error) {
      // Manejar el error si ocurre durante la carga de datos del usuario
      print('Error al cargar datos del usuario: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (persona == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    getId();
    Future.delayed(Duration(seconds: 2), () async {
      persona =
          await _usuarioDataSource.getPersonFromId(personaId) as PersonaModel;
    });
    return Scaffold(
        backgroundColor: GlobalMethods.secondaryColor,
        appBar: const AppBarCustomProfile(
          title: 'Perfil de Usuario',
        ),
        drawer: const OptionsMenu(),
        body: Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(children: [
                  Container(
                      //width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(140),
                      ),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/edit_profile_picture');
                          },
                          child: CircleAvatar(
                            radius: 100,
                            //backgroundImage:AssetImage("assets/ui/usuario.png"),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/ui/usuario.png', // Ruta de la imagen dentro de la carpeta
                                fit:
                                    BoxFit.cover, // Ajusta la imagen al círculo
                                width: 180, // Ancho deseado de la imagen
                                height: 180, // Alto deseado de la imagen
                              ),
                            ),
                          ))),
                  const SizedBox(height: 20),
                  Text(
                    persona!.username,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        child: SizedBox(
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Nombre: ',
                                          style: const TextStyle(fontSize: 20)),
                                      Text(
                                          persona!.name +
                                              ' ' +
                                              persona!.lastname +
                                              ' ' +
                                              persona!.surname,
                                          style: const TextStyle(fontSize: 20))
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Teléfono: ',
                                          style: TextStyle(fontSize: 20)),
                                      Text(persona!.telephone,
                                          style: const TextStyle(fontSize: 20))
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Celular: ',
                                          style: TextStyle(fontSize: 20)),
                                      Text(persona!.cellphone,
                                          style: const TextStyle(fontSize: 20))
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Correo: ',
                                            style: TextStyle(fontSize: 20)),
                                        Text(persona!.mail,
                                            style:
                                                const TextStyle(fontSize: 20))
                                      ]),
                                  const SizedBox(height: 9),
                                  Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Dirección: ',
                                            style: TextStyle(fontSize: 20)),
                                        Text(persona!.direction,
                                            style:
                                                const TextStyle(fontSize: 20))
                                      ]),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.greenAccent,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0)),
                                        minimumSize: const Size(200, 40)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfilePage(
                                                      currentUser: persona!)));
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.edit_btn),
                                  )
                                ])))),
                  )),
                  const SizedBox(height: 50),
                ]))));
  }
}