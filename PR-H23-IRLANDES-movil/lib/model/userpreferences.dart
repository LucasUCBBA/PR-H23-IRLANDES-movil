import 'package:flutter/foundation.dart';
import 'package:irlandes_app/model/user.dart';

class UserPreferences {
  static var loggedUser = User(
    imagePath: "assets/ui/usuario.png",
    name: 'Pedro Pan',
    email: 'ppan@gmail.com',
    phone: '69696969',
    cellphone: '360360360',
    isInWeb: kIsWeb ? true : false
  );
}