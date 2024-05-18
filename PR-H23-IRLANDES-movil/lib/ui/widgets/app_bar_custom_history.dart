import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarCustomHistory extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustomHistory({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title, style: GoogleFonts.barlow(textStyle: const TextStyle(color: Color(0xFF3D5269), fontSize: 24))),
      backgroundColor: const Color(0xFFE3E9F4),
      toolbarHeight: 75,
      elevation: 0,
      leading: Center(
        child: IconButton(iconSize:50, icon: const Image(image: AssetImage('assets/ui/barra-de-menus.png')), 
        
        onPressed: 
        () {
          Navigator.pushNamed(context, '/optionmenu'); 
        },
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,

        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Image.asset(
            'assets/ui/home.png',
            width: 30,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          }
        ),
        IconButton(
          icon: Image.asset(
            'assets/ui/clock-solid2.png',
            width: 30,
          ), 
          onPressed: 
          () {
            Navigator.pushNamed(context,'/history_licences');
          }
        )]
      );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(50);
}