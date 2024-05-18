import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pr_h23_irlandes_web/data/model/person_model.dart';
import 'package:pr_h23_irlandes_web/data/remote/user_remote_datasource.dart';
import 'package:pr_h23_irlandes_web/infraestructure/global/global_methods.dart';
import 'package:pr_h23_irlandes_web/ui/pages/admin/edit_user.dart';
import 'package:pr_h23_irlandes_web/ui/widgets/app_bar_custom.dart';
import 'package:data_table_2/data_table_2.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

const List<String> list = <String>['Padre', 'Administrador', 'Docente', "Estudiante"];

class _AdminDashboardState extends State<AdminDashboard> {
  void onSearchTextChanged(String text) {
    setState(() {
      filteredData = text.isEmpty
          ? orderedData
          : orderedData
            .where((item) =>  item.name.toLowerCase().contains(text.toLowerCase())||
                              item.surname.toLowerCase().contains(text.toLowerCase())||
                              item.lastname.toLowerCase().contains(text.toLowerCase()))
            .toList();
    });
  }

  String dropdownValue = list.first;
  PersonaDataSourceImpl personDataSource = PersonaDataSourceImpl();
  bool isForeign = false;
  List<PersonaModel> orderedData = [];
  List<PersonaModel> filteredData = [];

  final controllerName = TextEditingController();
  final controllerFirstSurname = TextEditingController();
  final controllerSecondSurname = TextEditingController();
  final controllerCI = TextEditingController();
  final controllerCellphone = TextEditingController();
  final controllerPhone = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerRole = TextEditingController();
  final controllerDirection = TextEditingController();
  final controllerFather = TextEditingController();
  final controllerMother = TextEditingController();
  final controllerGrade = TextEditingController();
  final searchController = TextEditingController();


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

  String checkNationality(){
    if(isForeign){
      return "E-${controllerCI.text}";
    }
    else{
      return controllerCI.text;
    }
  }

  Future<void> refreshUsers() async {
    orderedData = await personDataSource.readPeople();
    orderedData = orderedData..sort((item1, item2) => item1.lastname.toLowerCase().compareTo(item2.lastname.toLowerCase()));
    filteredData = orderedData;
  }

  late final Future userFuture = refreshUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 233, 244),
      appBar: const AppBarCustom(
        title: ""
      ),
      body: FutureBuilder(
        future: userFuture,
        builder: (context, snapshot){
          if(filteredData.isEmpty && searchController.text.isEmpty){
            return const Center(
              child: CircularProgressIndicator()
            );
          }
          else{
            return Column(
              children: [ 
                SizedBox(
                  width:350,
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Ingrese un nombre o apellido para filtrar",
                      hintText: "Ingrese un nombre o apellido para filtrar"
                    ),
                    onChanged: (value){
                      onSearchTextChanged(value);
                    }
                  )
                ),
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
                                      Text("Nombre: *", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 250,
                                        child: TextField(
                                          controller: controllerName,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Nombre',
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
                                      Text("Apellido Paterno: *", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 250,
                                        child: TextField(
                                          controller: controllerSecondSurname,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Apellido Paterno',
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
                                      Text("Apellido Materno: *", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 250,
                                        child: TextField(
                                          controller: controllerFirstSurname,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Apellido Materno',
                                          )
                                        )
                                      )
                                    ]
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20, left: 50),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Carnet de Identidad: *", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
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
                                          controller: controllerCI,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Carnet de Identidad',
                                          )
                                        )
                                      ),
                                      CheckboxListTile(
                                        title: const Text("¿Es extranjero?"),
                                        value: isForeign,
                                        onChanged: (newValue) {
                                          setState(() {
                                            isForeign = newValue!;
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity.leading
                                      )
                                    ]
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Celular: *", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
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
                                            labelText: 'Celular',
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
                                          maxLength: 7,
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
                                            labelText: 'Teléfono',
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
                                      Text("Dirección: *", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 250,
                                        child: TextField(
                                          controller: controllerDirection,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Dirección',
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
                                      Text("Correo: *", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 250,
                                        child: TextField(                        
                                          controller: controllerEmail,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Correo',
                                          )
                                        )
                                      )
                                    ]
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Rol: *", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 250,
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: dropdownValue,
                                          icon: const Icon(Icons.arrow_downward),
                                          elevation: 16,
                                          onChanged: (String? value) {
                                            setState(() {
                                              dropdownValue = value!;
                                              controllerRole.text = value;
                                            });
                                          },
                                          items: list.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                      )
                                    ]
                                  )
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[900],
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    if(validationCheck()){
                                      var bytes = utf8.encode(controllerName.text+controllerFirstSurname.text+controllerCI.text);
                                      var digest = sha256.convert(bytes);
                                      final person = PersonaModel(
                                        username: controllerFirstSurname.text[0].toUpperCase()+ controllerSecondSurname.text[0].toUpperCase()+ controllerName.text[0].toUpperCase(), 
                                        password: digest.toString(), 
                                        rol: controllerRole.text, 
                                        cellphone: controllerCellphone.text, 
                                        ci: checkNationality(), 
                                        direction: controllerDirection.text, 
                                        id: UniqueKey().toString(), 
                                        fatherId: "", 
                                        motherId: "", 
                                        lastname: controllerSecondSurname.text, 
                                        grade: "", 
                                        mail: controllerEmail.text, 
                                        name: controllerName.text,
                                        resgisterdate: DateTime.now(), 
                                        status: 2, 
                                        surname: controllerFirstSurname.text, 
                                        telephone: controllerPhone.text,
                                        updatedate: DateTime.now());
                                      try{
                                        personDataSource.registrarUsuario(person);
                                        GlobalMethods.showSuccessSnackBar(context, "Usuario añadido con éxito");
                                        Navigator.pushNamed(context, '/admin_dashboard');
                                      }
                                      catch(error){
                                        GlobalMethods.showErrorSnackBar(context, error.toString());
                                      }
                                    }
                                    else{
                                      GlobalMethods.showErrorSnackBar(context, "Datos no válidos. Asegúrese de haber ingresado los datos correctamente.");
                                    }
                                  },
                                  child: const Text("Registrar",
                                style: TextStyle(
                                    color: Colors.white,
                                  ))
                                ),
                                const SizedBox(height: 20)
                              ]
                            )
                          ]
                        )
                      ),
                      Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: DataTable2(
                              columns: const [
                                DataColumn2(
                                  label: Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text('Apellido\nPaterno', style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                                DataColumn(
                                  label: Text('Apellido\nMaterno', style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                                DataColumn(
                                  label: Text('Celular', style: TextStyle(fontWeight: FontWeight.bold)),
                                  numeric: true
                                ),
                                DataColumn(
                                  label: Text('Teléfono', style: TextStyle(fontWeight: FontWeight.bold)),
                                  numeric: true
                                ),
                                DataColumn(
                                  label: Text('Correo', style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                                DataColumn(
                                  label: Text('Editar', style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                                DataColumn(
                                  label: Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold))
                                )
                              ],
                              rows: List.generate(filteredData.length,(index) {
                                final item = filteredData[index];
                                return DataRow(cells: [
                                DataCell(Text(item.name)),
                                DataCell(Text(item.lastname)),
                                DataCell(Text(item.surname)),
                                DataCell(Text(item.cellphone)),
                                DataCell(Text(item.telephone)),
                                DataCell(Text(item.mail)),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.edit_document),
                                    color: Colors.blue[900],
                                    onPressed: () {
                                      searchController.text = "";
                                      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditUserPage(personModel: item)
                                      ));
                                    }
                                  )
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.blue[900],
                                    onPressed: () {
                                      searchController.text = "";
                                      personDataSource.deletePerson(item.id);
                                      GlobalMethods.showSuccessSnackBar(context, "Usuario eliminado con éxito");
                                      Navigator.pushNamed(context, '/admin_dashboard');
                                    }
                                  )
                                )              
                              ]);
                              }
                            )
                          )
                        )
                      )
                    ]
                  )          
                )
              ]
            );
          }
        }
      )
    );
  }
}