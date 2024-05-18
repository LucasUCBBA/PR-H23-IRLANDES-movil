import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:irlandes_app/data/model/person_model.dart';
import 'package:irlandes_app/data/remote/user_remote_datasource.dart';
import 'package:irlandes_app/infraestructure/global/global_methods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  late PersonaModel persona;
  bool obscurePassword = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final PersonaDataSource _usuarioDataSource = PersonaDataSource();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Deshabilitamos el botón de volver atrás
        return false;
      },
      child: Scaffold(
        backgroundColor: GlobalMethods.primaryColor,
        body: Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const Center(
                  child: Image(
                      image: AssetImage('assets/ui/logo.png'),
                      width: 300,
                      height: 300),
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.login_prompt,
                  style: const TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontSize: 20),
                ),
                const SizedBox(height: 60),
                TextFormField(
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: AppLocalizations.of(context)!.user_prompt,
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: AppLocalizations.of(context)!.passwd_prompt,
                    prefixIcon: const Icon(Icons.password_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        String username = usernameController.text.trim();
                        String password = passwordController.text.trim();

                        // Validar que los campos no estén vacíos
                        if (username.isNotEmpty && password.isNotEmpty) {
                          // Autenticar con tu fuente de datos
                          PersonaModel? persona =
                              await _authenticate(username, password);

                          if (persona != null) {
                            // Credenciales correctas, navegar a la pantalla principal
                            if (persona.status == 2) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('personId', persona.id);
                              Navigator.pushNamed(context, '/first_login_user');
                            } else if (persona.status == 1) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('personId', persona.id);
                              Navigator.pushNamed(context, '/home');
                            } else {
                              GlobalMethods.showToast("Usuario Deshabilitado");
                            }
                          } else {
                            // Credenciales incorrectas, muestra un mensaje al usuario
                            GlobalMethods.showToast("Credenciales incorrectas");
                          }
                        } else {
                          // Muestra un mensaje si los campos están vacíos
                          GlobalMethods.showToast(
                              "Por favor, completa ambos campos");
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.login_btn),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('¿Desea cerrar la aplicación?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Cerrar aplicación'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    SystemNavigator.pop(); // Cierra la aplicación
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.close_btn, style: TextStyle(color: Colors.blue[900])),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<PersonaModel?> _authenticate(String username, String password) async {
    try {
      var bytes = utf8.encode(password);
      var digest = sha256.convert(bytes);

      PersonaModel? persona = await _usuarioDataSource.iniciarSesion(
          username, digest.toString());

      if (persona != null) {
        // Verificar el rol del usuario
        if (persona.rol == 'padre' || persona.rol == 'madre') {
          // El usuario tiene el rol de padres, permitir el acceso
          return persona;
        } else {
          // El usuario no tiene el rol de padres, denegar el acceso
          GlobalMethods.showToast("Usuario sin permiso de acceso");
          return null;
        }
      }

      return null;
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return null;
    }
  }
}