import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pr_h23_irlandes_web/data/model/calls_model.dart';
import 'package:pr_h23_irlandes_web/data/model/person_model.dart';
import 'package:pr_h23_irlandes_web/data/remote/calls_remote_datasource.dart';
import 'package:pr_h23_irlandes_web/data/remote/user_remote_datasource.dart';
import 'package:pr_h23_irlandes_web/infraestructure/global/global_methods.dart';
import 'package:pr_h23_irlandes_web/ui/widgets/app_bar_custom.dart';

class CreateCallsPage extends StatefulWidget {
  const CreateCallsPage({Key? key}) : super(key: key);

  @override
  _CreateCallsPageState createState() => _CreateCallsPageState();
}

final PersonaDataSourceImpl personDataSource = PersonaDataSourceImpl();
late List<PersonaModel> users = [];
Future<void> refreshUsers() async {
  users = await personDataSource.readPeople();
  users = users..sort((item1, item2) => item1.lastname.toLowerCase().compareTo(item2.lastname.toLowerCase()));
}

class _CreateCallsPageState extends State<CreateCallsPage> {
  
  AttentionCallsRemoteDataSource callsRemoteDataSource = AttentionCallsRemoteDataSource();

  final controllerStudentName = TextEditingController();
  final controllerTeacherName = TextEditingController();
  final controllerMotive = TextEditingController();
  var studentId = "";

  bool validationCheck() {
    if (controllerStudentName.text != "" &&
        controllerTeacherName.text != "" &&
        controllerMotive.text != "") {
      return true;
    } else {
      return false;
    }
  }

  var teacher;
  var student;
  late final Future userFuture = refreshUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 233, 244),
      appBar: const AppBarCustom(title: "Registro de notificaciones estudiantiles"),
      body: FutureBuilder(
        future: userFuture,
        builder: (context, snapshot){
          if(users.isEmpty){
            return const Center(
              child: CircularProgressIndicator()
            );
          }
          else {
            final List<DropdownMenuEntry<PersonaModel>> iconEntries = <DropdownMenuEntry<PersonaModel>>[];
            for (final PersonaModel user in users) {
              iconEntries.add(DropdownMenuEntry<PersonaModel>(
              value: user,
              label:"${user.name} ${user.lastname} ${user.surname}"));
            }

            return Center(
              child: Column(
                children: [
                  Column(
                    children: [
                      Text("Nombre del Estudiante:", 
                        style: TextStyle(fontSize: 15, color: Colors.blue[900])
                      ),
                      const SizedBox(height: 10),
                      DropdownMenu<PersonaModel>(
                        controller: controllerStudentName,
                        enableFilter: true,
                        leadingIcon: const Icon(Icons.search),
                        dropdownMenuEntries: iconEntries,
                        inputDecorationTheme:
                          const InputDecorationTheme(
                          filled: true,
                          contentPadding:
                            EdgeInsets.symmetric(vertical: 5.0),
                        ),
                        onSelected: (PersonaModel? icon) {
                          setState(() {
                            student = "${icon!.name} ${icon.lastname} ${icon.surname}";
                            studentId = icon.fatherId;
                          }
                        );
                      })
                    ]
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Text("Nombre del Docente:", 
                        style: TextStyle(fontSize: 15, color: Colors.blue[900])
                      ),
                      const SizedBox(height: 10),
                      DropdownMenu<PersonaModel>(
                        controller: controllerTeacherName,
                        enableFilter: true,
                        leadingIcon: const Icon(Icons.search),
                        dropdownMenuEntries: iconEntries,
                        inputDecorationTheme:
                          const InputDecorationTheme(
                          filled: true,
                          contentPadding:
                            EdgeInsets.symmetric(vertical: 5.0),
                        ),
                        onSelected: (PersonaModel? icon) {
                          setState(() {
                            teacher = "${icon!.name} ${icon.lastname} ${icon.surname}";
                          }
                        );
                      })
                    ]
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Text("Motivo:", 
                        style: TextStyle(fontSize: 15, color: Colors.blue[900])
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          maxLength: 100,
                          maxLines: 4,
                          controller: controllerMotive,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white)
                        )
                      )
                    ]
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      elevation: 0),
                      onPressed: () {
                      if (validationCheck()) {
                        final call = AttentionCallsModel(
                          id: "",
                          student: student,
                          teacher: teacher,
                          motive: controllerMotive.text,
                          studentId: studentId,
                          registrationDate: DateTime.now().toString()
                        );
                        callsRemoteDataSource.createAttentionCall(call);
                        GlobalMethods.showSuccessSnackBar(context, "Notificación agregada con éxito");
                        Navigator.pushNamed(context, '/attention_calls');
                      } else {
                        GlobalMethods.showErrorSnackBar(context, "Asegúrese de haber llenado todos los campos correctamente.");
                      }
                    },
                    child: const Text("Añadir",
                    style: TextStyle(
                                    color: Colors
                                        .white,
                                  ))
                  )
                ]
              )
            );
          }
        }
      )
    );
  }
}