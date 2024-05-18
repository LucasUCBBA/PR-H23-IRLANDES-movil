import 'package:flutter/material.dart';
import 'package:irlandes_app/infraestructure/global/global_methods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginUsername extends StatefulWidget {
  const LoginUsername({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginUsername> createState() => LoginState();
}

class LoginState extends State<LoginUsername> {
  bool obscurePassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalMethods.primaryColor,
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Center(
                child: Image(image: AssetImage('assets/ui/logo.png'), width: 300, height: 300),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.login_prompt,
                style: const TextStyle(color: Colors.white, decoration: TextDecoration.none, fontSize: 20),
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress, // Cambiado a TextInputType.emailAddress
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
                      final email = emailController.text;
                      final password = passwordController.text;
                      try {
                        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        final user = userCredential.user;
                        if (user != null) {
                          // Usuario inició sesión con éxito
                          Navigator.pushNamed(context, '/home');
                        } else {
                          // Error al iniciar sesión
                          GlobalMethods.showToast("Error al iniciar sesión");
                        }
                      } catch (e) {
                        // Error al iniciar sesión
                        GlobalMethods.showToast("Error al iniciar sesión: $e");
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.login_btn),
                  ),
                  
                  
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Text(AppLocalizations.of(context)!.login_guest_button),
                  ),
                  
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.fingerprint_prompt, style: const TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          GlobalMethods.showToast("Soon™");
                        },
                        child: Text(
                          AppLocalizations.of(context)!.fingerprint_text,
                          style: const TextStyle(color: Colors.red, decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
