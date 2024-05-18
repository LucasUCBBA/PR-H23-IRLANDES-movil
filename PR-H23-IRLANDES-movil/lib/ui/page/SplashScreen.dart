import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:irlandes_app/infraestructure/global/global_methods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        Timer(
            const Duration(seconds: 6),
                () =>
            Navigator.pushNamed(context, '/login_user'));
            // Navigator.pushNamed(context, '/home'));


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor:GlobalMethods.primaryColor,
        body:Center(
          child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Image(image: AssetImage('assets/ui/logo.png'),width: 182, height: 162),
            ),
            Padding(
              padding: const EdgeInsets.only(left:15, right: 15),
              child: SizedBox(
                width: 250,
                child: Text(
                  AppLocalizations.of(context)!.school_name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.barlow(textStyle: const TextStyle(color: Colors.white, decoration:TextDecoration.none, fontSize: 20, height: 1.5)),
                  //TextStyle(color: Colors.white, decoration:TextDecoration.none, fontSize: 20, fontFamily: GoogleFonts.barlow()),
                ),
              )
            ),
           const Padding(
              padding: EdgeInsets.only(top:100),
              child: SpinKitCircle(color: Colors.white, size: 40)
            )
          ],
        ),
        )
      )
    );
  }
}