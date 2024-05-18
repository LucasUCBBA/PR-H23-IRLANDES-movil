import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:irlandes_app/data/model/person_model.dart';
import 'package:irlandes_app/data/remote/user_remote_datasource.dart';
import 'package:irlandes_app/infraestructure/global/global_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstLoginPage extends StatefulWidget {
  const FirstLoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FirstLoginPage> createState() => LoginState();
}

class LoginState extends State<FirstLoginPage> {
  late PersonaModel persona;
  String personaId = '';
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final PersonaDataSource _usuarioDataSource = PersonaDataSource();

  @override
  Widget build(BuildContext context) {
    getId();
    Future.delayed(Duration(seconds: 2), () async {
      persona =
          await _usuarioDataSource.getPersonFromId(personaId) as PersonaModel;
    });
    return Scaffold(
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
              const Text(
                'Cambio de Contraseña',
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 20),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: newPasswordController,
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Nueva Contraseña',
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
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Confirmar Contraseña',
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                    icon: obscureConfirmPassword
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  String newPassword = newPasswordController.text.trim();
                  if (confirmPasswordController.text.trim() == newPassword) {
                    if (await changePassword(newPassword)) {
                      Navigator.pushNamed(context, '/login_user');
                    } else {
                      GlobalMethods.showToast("Error al cambiar la contraseña");
                    }
                  } else {
                    GlobalMethods.showToast("Las contraseñas no coinciden");
                  }
                },
                child: const Text('Confirmar Cambio de contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> changePassword(String newPassword) async {
    try {
      var bytes = utf8.encode(newPassword);
      var digest = sha256.convert(bytes);
      persona?.password = digest.toString();
      persona?.status = 1;
      _usuarioDataSource.updateUserPassword(persona!);
      return true;
    } catch (e) {
      return false;
    }
  }

  void getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    personaId = prefs.getString('personId')!;
  }
}
