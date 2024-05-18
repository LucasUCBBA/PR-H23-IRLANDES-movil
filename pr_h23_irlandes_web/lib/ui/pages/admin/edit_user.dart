import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pr_h23_irlandes_web/data/model/person_model.dart';
import 'package:pr_h23_irlandes_web/data/remote/user_remote_datasource.dart';
import 'package:pr_h23_irlandes_web/infraestructure/global/global_methods.dart';
import 'package:pr_h23_irlandes_web/ui/widgets/app_bar_custom.dart';

class EditUserPage extends StatefulWidget {
  final PersonaModel personModel;
  const EditUserPage({super.key, required this.personModel});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

const List<String> list = <String>['Padre', 'Administrador', 'Docente', "Estudiante"];
PersonaDataSourceImpl personDataSource = PersonaDataSourceImpl();



class _EditUserPageState extends State<EditUserPage> {
  final controllerName = TextEditingController();
  final controllerFirstSurname = TextEditingController();
  final controllerSecondSurname = TextEditingController();
  final controllerCI = TextEditingController();
  final controllerCellphone = TextEditingController();
  final controllerPhone = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerDirection = TextEditingController();
  final controllerRole = TextEditingController();
  final controllerGrade = TextEditingController();

  bool validationCheck(){
    if(controllerName.text != "" &&
      controllerFirstSurname.text != "" &&
      controllerSecondSurname.text != "" &&
      controllerCI.text != "" &&
      controllerCellphone.text != "" && controllerCellphone.text.length == 8 &&
      isValidEmail(controllerEmail.text) &&
      controllerDirection.text != ""){
        return true;
      }
    else{
      return false;
    }
  }

  bool isValidEmail(String value){
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
    .hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    controllerName.text=widget.personModel.name;
    controllerFirstSurname.text = widget.personModel.lastname;
    controllerSecondSurname.text = widget.personModel.surname;
    controllerCI.text = widget.personModel.ci;
    controllerCellphone.text = widget.personModel.cellphone;
    controllerPhone.text = widget.personModel.telephone;
    controllerEmail.text = widget.personModel.mail;
    controllerDirection.text = widget.personModel.direction;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 233, 244),
      appBar: const AppBarCustom(
        title: ""
      ),
      body: Column(
        children: [ 
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nombre:", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: controllerName,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white
                                    )
                                  )
                                )
                              ]
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Apellido Paterno:", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: controllerFirstSurname,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    )
                                  )
                                )
                              ]
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Apellido Materno:", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: controllerSecondSurname,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    )
                                  )
                                )
                              ]
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Carnet de Identidad:", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(
                                          "[0-9]",
                                        ),
                                      ),
                                    ],
                                    controller: controllerCI,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    )
                                  )
                                )
                              ]
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Celular:", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    maxLength: 8,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(
                                          "[0-9]",
                                        ),
                                      ),
                                    ],
                                    controller: controllerCellphone,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    )
                                  )
                                )
                              ]
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Teléfono:", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    maxLength: 10,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(
                                          "[0-9]",
                                        ),
                                      ),
                                    ],
                                    controller: controllerPhone,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    )
                                  )
                                )
                              ]
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dirección:", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: controllerDirection,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    )
                                  )
                                )
                              ]
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Correo:", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: controllerEmail,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    )
                                  )
                                )
                              ]
                            )
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900],
                              elevation: 0,
                            ),
                            onPressed: () {
                              if(validationCheck()){
                                final person = PersonaModel(
                                  username: widget.personModel.username, 
                                  password: widget.personModel.password, 
                                  rol: controllerRole.text, 
                                  cellphone: controllerCellphone.text, 
                                  ci: controllerCI.text,
                                  direction: controllerDirection.text, 
                                  id: widget.personModel.id, 
                                  fatherId: widget.personModel.fatherId, 
                                  motherId: widget.personModel.motherId, 
                                  lastname: controllerSecondSurname.text, 
                                  grade: controllerGrade.text, 
                                  mail: controllerEmail.text, 
                                  name: controllerName.text, 
                                  resgisterdate: widget.personModel.resgisterdate, 
                                  status: widget.personModel.status, 
                                  surname: controllerFirstSurname.text, 
                                  telephone: controllerPhone.text, 
                                  updatedate: DateTime.now());
                                try{
                                  personDataSource.updatePerson(widget.personModel.id, person);
                                  GlobalMethods.showSuccessSnackBar(context, "Usuario actualizado con éxito");
                                  //Navigator.pop(context);
                                  Navigator.pushNamed(context, '/admin_dashboard');
                                }
                                catch(error){
                                  GlobalMethods.showSuccessSnackBar(context, error.toString());
                                }
                              }
                              else{
                                GlobalMethods.showErrorSnackBar(context, "Datos no válidos. Asegúrese de haber ingresado los datos correctamente.");
                              }
                            },
                            child: const Text("Actualizar",
                                style: TextStyle(
                                    color: Colors.white,
                                  ))
                          ),
                          const SizedBox(height: 20)
                        ]
                      )
                    ]
                  )
                )])          
              )]
            )
          );
  }
}