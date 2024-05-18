import 'package:flutter/material.dart';
import 'package:irlandes_app/infraestructure/global/global_methods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:irlandes_app/ui/page/options_menu.dart';
import 'package:irlandes_app/ui/widgets/app_bar_custom.dart';

class EditPicturePage extends StatefulWidget {
  const EditPicturePage({Key? key}) : super(key: key);

  @override
  EditPicturePageState createState() => EditPicturePageState();
}

class EditPicturePageState extends State<EditPicturePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalMethods.secondaryColor,
      appBar: const AppBarCustom(
        title: '',
      ),
      drawer: const OptionsMenu(),
      body: Center(
        child: Card(
          elevation: 50,
          color:Theme.of(context).cardColor,
          child: SizedBox(
          width: 300,
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  size: 55,
                ),
                label: Text(AppLocalizations.of(context)!.take_user_picture_prompt, style: const TextStyle(fontSize: 20))
              ),
              const SizedBox(height: 50),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete_outline,
                  size: 55,
                ),
                label: Text(AppLocalizations.of(context)!.delete_user_picture_prompt, style: const TextStyle(fontSize: 20))
              )
            ]
          )))
        )
      )
    );
  }
}