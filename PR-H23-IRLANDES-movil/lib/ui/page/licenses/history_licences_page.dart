import 'package:flutter/material.dart';
import 'package:irlandes_app/data/model/License_model.dart';
import 'package:irlandes_app/data/model/person_model.dart';
import 'package:irlandes_app/data/remote/license_remote_datasource.dart';
import 'package:irlandes_app/data/remote/user_remote_datasource.dart';
import 'package:irlandes_app/ui/widgets/custom_card_license.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryLicenses extends StatefulWidget {
  const HistoryLicenses({super.key});

  @override
  State<HistoryLicenses> createState() => _HistoryLicensesState();

  static Future<List<LicenseModel>> refreshLicenses(String user_id) async {
    LicenseRemoteDatasourceImpl licenseRemoteDatasourceImpl =
        LicenseRemoteDatasourceImpl();
    return await licenseRemoteDatasourceImpl.getLicensesByStudentID(user_id);
  }
}

class _HistoryLicensesState extends State<HistoryLicenses> {
  String? selectedStudentId;
  final PersonaDataSource _personaDataSource = PersonaDataSource();

  List<PersonaModel> students = [];
  bool isLoading  =  true;
  String personaId = '';

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) => {
      personaId = value.getString('personId')!,
      _personaDataSource.getPersonsFromParentId(personaId).then((value) => {      
        isLoading = true,
        students = value,
        selectedStudentId = students[0].id,        
        if (mounted)
          {
            setState(() {
              isLoading = false;
            })
          }
      }),
    }); 
    
    super.initState();

    if (students.isNotEmpty) selectedStudentId = students[0].id;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final leftPadding = screenWidth * 0.075;
    final rightPadding = screenWidth * 0.075;

    return Scaffold(
      backgroundColor: const Color(0xFFE3E9F4),
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: const Color(0xFFE3E9F4),
        elevation: 0,
        centerTitle: true,
        title: const Text('Historial de licencias',
            style: TextStyle(
                color: Color(0xFF3D5269),
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),)
      : Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 5,
                bottom: 2,
                left: leftPadding * 1.5,
                right: rightPadding * 1.5),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white),
                  )),
              isDense: true,
              value: selectedStudentId,
              onChanged: (String? value) {
                selectedStudentId = value;
                setState(() {});
              },
              items: students.map<DropdownMenuItem<String>>(
                  (PersonaModel student) {
                return DropdownMenuItem<String>(
                  value: student.id,
                  child: Text('${student.name} ${student.lastname} ${student.surname}'),
                );
              }).toList(),
            )
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<List<LicenseModel>>(
            future: HistoryLicenses.refreshLicenses(selectedStudentId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error al cargar.');
              } else if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No hay licencias.'),
                );
              } else {
                List<LicenseModel>? licenses = snapshot.data;
                return Expanded(
                    child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                        top: 5,
                        bottom: 30,
                        left: leftPadding,
                        right: rightPadding),
                    itemCount: licenses!.length,
                    itemBuilder: (context, index) {
                      final license = licenses[index];
                      return CustomCardLicense(
                        date: license.license_date,
                        departure_time: license.departure_time,
                        return_time: license.return_time,
                        reason: license.reason,
                        id: license.id.toString(),
                        user_id: license.user!.id
                      );
                    },
                  ),
                ));
              }
            },
          )
        ],
      ),
    );
  }
}
