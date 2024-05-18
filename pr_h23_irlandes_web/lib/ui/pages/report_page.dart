import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pr_h23_irlandes_web/data/model/report_model.dart';
import 'package:pr_h23_irlandes_web/data/remote/reports_remote_datasource.dart';
import 'package:pr_h23_irlandes_web/ui/widgets/custom_drawer_psico.dart';
import 'package:pr_h23_irlandes_web/ui/widgets/custom_text_field.dart';

/*
    Pagina donde se listan los reportes psicologicos, de manera similar a las postulaciones.
    Falta un boton para editar y otro para el pdf.
    Tambien añadir boton de cambiar estado del reporte (si sigue en psicologia o ya pasa a siguiente fase)
*/


class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPage();
}

class _ReportPage extends State<ReportPage> {
  ReportRemoteDatasourceImpl reportRemoteDatasourceImpl =
      ReportRemoteDatasourceImpl();
  List<ReportModel> reports = [], filterList = [];
  bool isLoading = true;
  bool isSelected = true;
  TextEditingController searchController = TextEditingController();
  String level = '', grade = '', status = '';
  List<String> gradeList = ['Cualquiera'];

  @override
  void initState() {
    status = 'Pendiente';
    reportRemoteDatasourceImpl.getReport().then((value) => {
          isLoading = true,
          reports = value,
          filterList = FilterReportsList(
              status, level, grade, searchController.text.trim()),
          if (mounted)
            {
              setState(() {
                isLoading = false;
              })
            }
        });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  InputDecoration customDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      counter: const SizedBox.shrink(),
      labelStyle: const TextStyle(color: Color(0xFF044086)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF044086)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  List<ReportModel> FilterReportsList(
    String status,
    String? level,
    String? grade,
    String? searchValue,
  ) {
    return reports.where((report) {
      bool matchesLevel =
          level == null || level.isEmpty || report.level == level;
      bool matchesGrade =
          grade == null || grade.isEmpty || report.grade == grade;
      bool matchesStudent = true;

      if (searchValue != null && searchValue.isNotEmpty) {
        matchesStudent =
            ("${report.fullname}")
                    .toUpperCase()
                    .contains(searchValue.toUpperCase());
                
      }

      return matchesLevel && matchesGrade && matchesStudent;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Administración de Informes - Psicología',
            style: GoogleFonts.barlow(
                textStyle: const TextStyle(
                    color: Color(0xFF3D5269),
                    fontSize: 24,
                    fontWeight: FontWeight.bold))),
        backgroundColor: Colors.white,
        toolbarHeight: 75,
        elevation: 0,
        leading: Center(
          child: Builder(
            builder: (context) => IconButton(
              iconSize: 50,
              icon: const Image(
                  image: AssetImage('assets/ui/barra-de-menus.png')),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ),
        actions: [
          IconButton(
              iconSize: 2,
              icon: Image.asset(
                'assets/ui/home.png',
                width: 50,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/notice_main');
              })
        ],
      ),
      drawer: CustomDrawerPsico(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.6,
                    constraints: const BoxConstraints(
                      minWidth: 700.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3E9F4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    iconSize: 2,
                                    icon: Image.asset(
                                      'assets/ui/reserva.png',
                                      width: 50,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/register_report');
                                    }),
                                const Text('Registrar Informe',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Informes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF044086),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                            padding: const EdgeInsets.only(left: 50, right: 50),
                            child: Row(
                              children: [
                                Flexible(
                                  flex:
                                      2, // Ajusta el flex para controlar el ancho
                                  child: CustomTextField(
                                    label: 'Buscar',
                                    controller: searchController,
                                    type: TextInputType.name,
                                    onChanged: (value) => {
                                      filterList = FilterReportsList(
                                          status,
                                          level,
                                          grade,
                                          searchController.text.trim()),
                                      setState(() {})
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: customDecoration('Nivel'),
                                    value: 'Cualquiera',
                                    isDense: true,
                                    items: [
                                      'Cualquiera',
                                      'Inicial',
                                      'Primaria',
                                      'Secundaria'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      grade = '';
                                      switch (value) {
                                        case 'Cualquiera':
                                          gradeList = ['Cualquiera'];
                                          level = '';
                                          break;
                                        case 'Inicial':
                                          gradeList = [ 'Cualquiera', '1ra sección','2da sección'];
                                          level = value!;
                                          break;
                                        default: 
                                          gradeList = ['Cualquiera', '1er','2do','3er','4to','5to', '6to'];                                          
                                          level = value!;
                                      }
                                      setState(() {});
                                      filterList = FilterReportsList(
                                          status,
                                          level,
                                          grade,
                                          searchController.text.trim());
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: grade == '' ? 'Cualquiera': grade,
                                    isDense: true,
                                    decoration: customDecoration('Curso'),
                                    items: gradeList.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value! == 'Cualquiera') {
                                        grade = '';
                                      } else {
                                        grade = value;
                                      }
                                      setState(() {});
                                      filterList = FilterReportsList(
                                          status,
                                          level,
                                          grade,
                                          searchController.text.trim());
                                    },
                                  ),
                                ),
                              ],
                            )
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                            width: constraints.maxWidth * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 600.0,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: filterList.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No hay informes',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF044086),
                                          fontSize: 18),
                                    ),
                                  )
                                : Center(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(
                                            label: Text('Postulante',
                                                style: TextStyle(
                                                    color: Color(0xFF044086),
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text('Nivel',
                                                style: TextStyle(
                                                    color: Color(0xFF044086),
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text('Grado',
                                                style: TextStyle(
                                                    color: Color(0xFF044086),
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text('Fecha de entrevista',
                                                style: TextStyle(
                                                    color: Color(0xFF044086),
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(label: Text('')),
                                      ],
                                      rows: filterList.map((report) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(
                                                '${report.fullname}')),
                                            DataCell(Text(report.level)),
                                            DataCell(Text(report.grade)),
                                            DataCell(Text(
                                                DateFormat('dd/MM/yyyy')
                                                    .format(report
                                                        .interview_date))),
                                            DataCell(
                                              ElevatedButton(
                                                onPressed: () async {
                                                  final recargar =
                                                      await Navigator.of(
                                                              context)
                                                          .pushNamed(
                                                              '/report_details',
                                                              arguments: {
                                                        'id': report.id
                                                      });
                                                  if (recargar != null) {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    reportRemoteDatasourceImpl
                                                        .getReport()
                                                        .then((value) => {
                                                              reports =
                                                                  value,
                                                              level = '',
                                                              grade = '',
                                                              searchController
                                                                  .text = '',
                                                              filterList = FilterReportsList(
                                                                  status,
                                                                  level,
                                                                  grade,
                                                                  searchController
                                                                      .text
                                                                      .trim()),
                                                              if (mounted)
                                                                {
                                                                  setState(
                                                                      () {
                                                                    isLoading =
                                                                        false;
                                                                  })
                                                                }
                                                            });
                                                  }
                                                },
                                                child: const Text('Ver'),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )                                  
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
