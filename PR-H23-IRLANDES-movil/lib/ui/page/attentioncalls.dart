import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:irlandes_app/data/model/calls_model.dart';
import 'package:irlandes_app/data/model/person_model.dart';
import 'package:irlandes_app/data/remote/attention_calls_remote_datasource.dart';
import 'package:irlandes_app/data/remote/user_remote_datasource.dart';
import 'package:irlandes_app/ui/widgets/app_bar_custom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttentionCallsPage extends StatefulWidget {
  const AttentionCallsPage({Key? key}) : super(key: key);

  @override
  AttentionCallsPageState createState() => AttentionCallsPageState();
}

final AttentionCallsDataSource _attentionCallsDataSource = AttentionCallsDataSource();
final PersonaDataSource personaDataSource = PersonaDataSource();
List<AttentionCallsModel> attentionCalls = [];
PersonaModel? usuario;

Future<List<AttentionCallsModel>> refreshAttentionCalls() async {
  await getId();
  attentionCalls = await _attentionCallsDataSource.getAttentionCallsByParentId(personaId);
  attentionCalls = attentionCalls..sort((item1, item2) => item2.registrationDate.compareTo(item1.registrationDate));
  return attentionCalls;
}

String personaId = '';
Future<void> getId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  personaId = prefs.getString('personId')!;
  usuario = await personaDataSource.getPersonFromId(personaId);
}

class AttentionCallsPageState extends State<AttentionCallsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 233, 244),
      appBar: const AppBarCustom(
        title: 'Notificación estudiantil',
      ),
      body: Center(
        child: FutureBuilder(
        future: refreshAttentionCalls(),
        builder: (context, snapshot) {
          if (attentionCalls.isNotEmpty){
              return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: attentionCalls.length,
                    itemBuilder: (context, int index) {
                      return Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        const Column(children: [
                          Text("Docente",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Estudiante",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Motivo",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Fecha de creación",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                        Column(children: [
                          Text(attentionCalls[index].teacher),
                          Text(attentionCalls[index].student),
                          Text(attentionCalls[index].motive),
                          Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(attentionCalls[index].registrationDate)))
                        ])
                      ])
                      ));
                    }
                  )
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: const Text("Volver al menú principal",style: TextStyle(
                                    color: Colors.white,
                                  ))
                      )
                  ]
                )
              ]
            );
          }
          else{
            return const CircularProgressIndicator();
          }
        }
      ))
    );
  }
}