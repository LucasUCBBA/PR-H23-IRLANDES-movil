import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:irlandes_app/ui/page/Login_User/login_page.dart';

class AppBarCustomProfile extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustomProfile({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: GoogleFonts.barlow(
          textStyle: const TextStyle(
            color: Color(0xFF3D5269),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE3E9F4),
      toolbarHeight: 75,
      elevation: 0,
      leading: Center(
        child: IconButton(
          iconSize: 50,
          icon: const Image(image: AssetImage('assets/ui/barra-de-menus.png')),
          onPressed: () {
            Navigator.pushNamed(context, '/optionmenu');
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
      actions: <Widget>[
        IconButton(
          iconSize: 50,
          icon: const Image(image: AssetImage('assets/ui/home.png')),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        IconButton(
          iconSize:50, icon: const Image(image: AssetImage('assets/ui/cerrarsesion.png') ),
          onPressed: () {
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar Sesión'),
          content: Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _signOut(context);
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
 
  @override
  Size get preferredSize => const Size.fromHeight(50);
}
