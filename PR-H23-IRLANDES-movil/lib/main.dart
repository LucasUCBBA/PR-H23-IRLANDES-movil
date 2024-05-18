import 'package:flutter/material.dart';
import 'package:irlandes_app/api/firebase_api.dart';
import 'package:irlandes_app/ui/page/Login_User/first_login_page.dart';
import 'package:irlandes_app/ui/page/attentioncalls.dart';
import 'package:irlandes_app/ui/page/editpicture.dart';
import 'package:irlandes_app/ui/page/licenses/licences.dart';
import 'package:irlandes_app/ui/page/Login_User/login_page.dart';
import 'package:irlandes_app/ui/page/licenses/history_licences_page.dart';
import 'package:irlandes_app/ui/page/licenses/licences_verifiation.dart';
import 'package:irlandes_app/ui/page/notice_main_page.dart';
import 'package:irlandes_app/ui/page/notifications/notification_screen.dart';
import 'package:irlandes_app/ui/page/options_menu.dart';
import 'package:irlandes_app/ui/page/interviews.dart';
import 'package:irlandes_app/infraestructure/global/global_methods.dart';
import 'package:irlandes_app/ui/page/SplashScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:irlandes_app/ui/page/postulations/postulation_details.dart';
import 'package:irlandes_app/ui/page/postulations/postulation_history.dart';
import 'package:irlandes_app/ui/page/postulations/register_postulation.dart';
import 'package:irlandes_app/ui/page/userpage.dart';
import 'package:irlandes_app/widgets/estado_economico.dart';

//Conexion Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// final navigatorKey=GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //inyectamos todas la depencias en el main para usarla en todo el proyecto
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale.fromSubtags(languageCode: "es"),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es')],
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: GlobalMethods.primaryColor),
          primaryColor: GlobalMethods.primaryColor),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      // navigatorKey: navigatorKey,
      routes: {
        // '/':(context) => const SplashScreen(),
        '/': (context) => const SplashScreen(),

        //'/':(context) => const PersonPage(),
        '/home': (context) =>
            const NoticeMainPage(), //nombrando la ruta a la va a redireccionarse
        //'/home':(context) => RegistroScreen(),//nombrando la ruta a la va a redireccionarse

        '/notification-screen': (context) => const NotificationScreen(),
        '/optionmenu': (context) => const OptionsMenu(),
        //'/login_user': (context) => const LoginUsername(),
        '/login_user': (context) => const LoginPage(),
        '/first_login_user': (context) => const FirstLoginPage(),

        '/estado_economico': (context) => const MenuDashboardPage(),
        '/user_profile': (context) => const ProfilePage(),
        '/edit_profile_picture': (context) => const EditPicturePage(),
        '/attention_calls': (context) => const AttentionCallsPage(),
        '/licences': (context) => const Licenses(),
        '/history_licences': (context) => const HistoryLicenses(),
        '/license_verification': (context) {
          final Map<String, dynamic> arguments = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          final String licenseId = arguments['id'];
          return LicenseVerification(
            id: licenseId,
          );
        },
        '/interviews': (context) => const InterviewsPage(),
        '/notification': (context) => const NotificationScreen(),
        '/register_postulation': (context) => const RegisterPostulation(),
        '/postulation_history': (context) => const HistoryPostulation(),
        '/postulation_details': (context) {
          final Map<String, dynamic> arguments = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          final String postulationID = arguments['id'];
          return PostulationDetails(
            id: postulationID,
          );
        },
      },
    );
  }
}
