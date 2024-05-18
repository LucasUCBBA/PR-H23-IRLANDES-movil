import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:irlandes_app/infraestructure/global/global_methods.dart';
import 'package:irlandes_app/ui/page/options_menu.dart';
import 'package:irlandes_app/ui/widgets/app_bar_custom.dart';

class InterviewsPage extends StatefulWidget {
  const InterviewsPage({Key? key}) : super(key: key);

  @override
  InterviewsPageState createState() => InterviewsPageState();
}

class InterviewsPageState extends State<InterviewsPage> {
  @override
  Widget build(BuildContext context) {
    List<String> list = <String>['One', 'Two', 'Three', 'Four'];
    String dropdownValue = list.first;
    DateTime now = DateTime.now();

    return Scaffold(
        backgroundColor: GlobalMethods.secondaryColor,
        appBar: const AppBarCustom(
          title: 'Solicitud de Entrevista',
        ),
        drawer: const OptionsMenu(),
        body: Column(children: [
          Center(
              child: Card(
                  elevation: 50,
                  color: Theme.of(context).cardColor,
                  child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(children: <Widget>[
                            Row(children: [
                              Text(
                                  AppLocalizations.of(context)!.student_prompt),
                              DropdownButton<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                underline: Container(
                                  height: 2,
                                  color: GlobalMethods.primaryColor,
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    dropdownValue = value!;
                                  });
                                },
                                items: list.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                            ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!
                                    .parents_prompt),
                                DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                    color: GlobalMethods.primaryColor,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!
                                    .teacher_prompt),
                                DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                    color: GlobalMethods.primaryColor,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    AppLocalizations.of(context)!.date_prompt,
                                    style: TextStyle(color: Colors.black))),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shadowColor: Colors.transparent,
                                  minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2002),
                                      lastDate: DateTime.now());
                                },
                                child:
                                    Text(DateFormat('dd-MM-yyyy').format(now)))
                          ]))))),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: GlobalMethods.primaryColor,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              GlobalMethods.showAlertDialog(
                  context, "Solicitud enviada con éxito");
            },
            child: Text(AppLocalizations.of(context)!.request_button),
          ),
          SizedBox(height: 20),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(AppLocalizations.of(context)!.requests_prompt,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: GlobalMethods.primaryColor))),
          Card(
            color: GlobalMethods.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(DateFormat('dd-MM-yyyy').format(now),
                        style: TextStyle(color: Colors.white)),
                    Text("Juan", style: TextStyle(color: Colors.white))
                  ],
                ),
                Text("8vo", style: TextStyle(color: Colors.white)),
                Row(
                  children: [
                    Text("A", style: TextStyle(color: Colors.white)),
                    CircleAvatar(
                      radius: 10, // Image radius
                      backgroundColor: Colors.red,
                    )
                  ],
                )
              ],
            ),
          ),
          Card(
            color: GlobalMethods.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(DateFormat('dd-MM-yyyy').format(now),
                        style: TextStyle(color: Colors.white)),
                    Text("Juan", style: TextStyle(color: Colors.white))
                  ],
                ),
                Text("8vo", style: TextStyle(color: Colors.white)),
                Row(
                  children: [
                    Text("A", style: TextStyle(color: Colors.white)),
                    CircleAvatar(
                      radius: 10, // Image radius
                      backgroundColor: Colors.green,
                    )
                  ],
                )
              ],
            ),
          )
        ]));
  }
}
