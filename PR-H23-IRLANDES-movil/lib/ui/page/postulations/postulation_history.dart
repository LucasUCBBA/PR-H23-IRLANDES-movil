import 'package:flutter/material.dart';
import 'package:irlandes_app/data/model/postulation_model.dart';
import 'package:irlandes_app/data/remote/postulation_remote_datasource.dart';
import 'package:irlandes_app/ui/widgets/custom_card_postulation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPostulation extends StatefulWidget {
  const HistoryPostulation({super.key});

  @override
  State<HistoryPostulation> createState() => _HistoryPostulationState();
}

class _HistoryPostulationState extends State<HistoryPostulation> {
  String? selectedStudentId;
  final PostulationRemoteDatasourceImpl postulationDatasource = PostulationRemoteDatasourceImpl();

  List<PostulationModel> postulationList = [];
  bool isLoading  =  true;
  String personaId = '';



  @override
  void initState() {
    SharedPreferences.getInstance().then((value) => {
      personaId = value.getString('personId')!,
      postulationDatasource.getPostulationsByUserID(personaId).then((value) => { 
        isLoading = true,
        postulationList = value,      
        if (mounted)
        {
          setState(() {
            isLoading = false;
          })
        }
      }),
    });     
    super.initState();
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
      body: isLoading ? const Center(child: CircularProgressIndicator())
      : Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(
                  top: 5,
                  bottom: 30,
                  left: leftPadding,
                  right: rightPadding),
              itemCount: postulationList.length,
              itemBuilder: (context, index) {
                final postulation = postulationList[index];
                return CustomCardPostulacion(
                  studentName: '${postulation.student_name} ${postulation.student_lastname}',
                  date: postulation.interview_date.toString(),
                  hour: postulation.interview_hour,
                  id: postulation.id.toString(),
                );
              },
            ),
          ),          
        ],
      ),
    );
  }
}
