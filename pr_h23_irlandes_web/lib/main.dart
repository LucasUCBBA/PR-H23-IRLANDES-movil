import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pr_h23_irlandes_web/infraestructure/global/global_methods.dart';
import 'package:pr_h23_irlandes_web/ui/pages/admin/dashboard.dart';
import 'package:pr_h23_irlandes_web/ui/pages/atention_calls/attention_calls.dart';
import 'package:pr_h23_irlandes_web/ui/pages/atention_calls/create_call.dart';
import 'package:pr_h23_irlandes_web/ui/pages/atention_calls/history_calls.dart';
import 'package:pr_h23_irlandes_web/ui/pages/login_user/loginuser_page.dart';
import 'package:pr_h23_irlandes_web/ui/pages/edit_password.dart';
import 'package:pr_h23_irlandes_web/ui/pages/interview/interview_management.dart';
import 'package:pr_h23_irlandes_web/ui/pages/interview/interview_schedule.dart';
import 'package:pr_h23_irlandes_web/ui/pages/license/history_licenses_page.dart';
import 'package:pr_h23_irlandes_web/ui/pages/license/license_verification.dart';
import 'package:pr_h23_irlandes_web/ui/pages/license/licenses.dart';
import 'package:pr_h23_irlandes_web/ui/pages/menu_options.dart';
import 'package:pr_h23_irlandes_web/ui/pages/user_profile.dart';
import 'package:pr_h23_irlandes_web/ui/pages/PsychologistHomePage.dart';
import 'package:pr_h23_irlandes_web/ui/pages/menu_options_psico.dart';
import 'package:pr_h23_irlandes_web/ui/pages/report_page.dart';
import 'package:pr_h23_irlandes_web/ui/pages/report_register.dart';
import 'package:pr_h23_irlandes_web/ui/pages/report_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//Conexion Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:pr_h23_irlandes_web/ui/pages/notice/notice_main_page.dart';
import 'package:pr_h23_irlandes_web/ui/pages/notice/notice_management_page.dart';
import 'package:pr_h23_irlandes_web/ui/pages/postulations/postulation_details.dart';
import 'package:pr_h23_irlandes_web/ui/pages/postulations/register_postulation.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Deshabilitar la manipulación de la URL
  SystemChannels.navigation.setMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'url') {
      return null;
    }
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        colorScheme: ColorScheme.fromSeed(seedColor: GlobalMethods.primaryColor),
        primaryColor: GlobalMethods.primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginUserPage(),
        '/optionmenu': (context) => const OptionsMenuPage(),
        '/optionmenu_psico': (context) => const OptionsMenuPagePsico(),
        '/admin_dashboard': (context) => const AdminDashboard(),
        '/notice_main': (context) => const NoticeMainPage(),
        '/register_notice': (context) => ManagementNoticePage(),
        '/register_postulation': (context) => const RegisterPostulation(),
        '/interview_management': (context) => const InterviewManagement(),
        '/licences': (context) => const Licenses(),
        '/history_licences': (context) => const HistoryLicenses(),
        '/interview_schedule': (context) => const InterviewSchedule(),
        '/attention_calls': (context) => const AttentionCallsPage(),
        '/edit_password': (context) => const EditPassword(),
        '/create_call': (context) => const CreateCallsPage(),
        '/user_profile': (context) => const UserProfilePage(),
        '/calls_history': (context) => const CallsHistory(),
        '/license_verification': (context) {
          final Map<String, dynamic> arguments = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          final String productId = arguments['id'];
          return LicenseVerification(
            id: productId,
          );
        },
        '/postulation_details': (context) {
          final Map<String, dynamic> arguments = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          final String postulationID = arguments['id'];
          return PostulationDetails(
            id: postulationID,
          );
        },
        '/psicologia_page': (context) => const PsychologistHomePage(),
        '/report_management': (context) => const ReportPage(),
        '/report_details': (context) {
          final Map<String, dynamic> arguments = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          final String reportID = arguments['id'];
          return ReportDetails(
            id: reportID,
          );
        },
        '/register_report': (context) => const RegisterReport(),
        
      },
    );
  }
}
