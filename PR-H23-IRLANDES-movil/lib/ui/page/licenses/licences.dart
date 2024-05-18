import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:irlandes_app/data/model/person_model.dart';
import 'package:irlandes_app/data/remote/license_remote_datasource.dart';
import 'package:irlandes_app/data/remote/user_remote_datasource.dart';
import 'package:irlandes_app/ui/widgets/app_bar_custom_history.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Licenses extends StatefulWidget {
  const Licenses({super.key});

  @override
  State<Licenses> createState() => _LicensesState();
}

class _LicensesState extends State<Licenses> {
  LicenseRemoteDatasourceImpl licenseRemoteDatasourceImpl =
      LicenseRemoteDatasourceImpl();
  String? selectedStudentId;
  bool isReady = false;
  String selectedReason = 'Enfermedad';
  TextEditingController dateController = TextEditingController();
  TextEditingController controllerOtros = TextEditingController();
  String imagePath = '';
  final PersonaDataSource _personaDataSource = PersonaDataSource();

  String startTime = "08:30", endTime = "09:30";
  String dateMessage = '';
  bool isLoading  =  true;
  String personaId = '';

  List<String> startTimes = [], endTimes = [];
  List<String> reasonsList = [
    'Enfermedad',
    'Viaje',
    'Accidente',
    'EMERGENCIA',
    'Otros'
  ];
  List<PersonaModel> students = [];

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Aceptar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  List<String> generateTimeSlots(
      String startTime, String endTime, int intervalInHours) {
    final start = TimeOfDay(
        hour: int.parse(startTime.split(':')[0]),
        minute: int.parse(startTime.split(':')[1]));
    final end = TimeOfDay(
        hour: int.parse(endTime.split(':')[0]),
        minute: int.parse(endTime.split(':')[1]));

    final List<String> times = [];

    var currentHour = start.hour;
    var currentMinute = start.minute;

    while (currentHour < end.hour ||
        (currentHour == end.hour && currentMinute <= end.minute)) {
      times.add(
          '${currentHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}');

      currentHour += intervalInHours;
      if (currentHour >= 24) {
        currentHour -= 24;
        currentMinute += (intervalInHours - (currentHour / 24).floor()) * 60;
        currentMinute %= 60;
      }
    }

    return times;
  }

  String getNextHour(String time) {
    List<String> parts = time.split(':');

    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    hour = (hour + 1) % 24; 

    return "${hour.toString().padLeft(2, '0')}:$minute";
  }

  void clearForm() {
    selectedStudentId = students[0].id;
    startTimes = generateTimeSlots("08:30", "15:30", 1);
    endTimes = generateTimeSlots(getNextHour(startTime), "16:30", 1);
    imagePath = '';
    selectedReason = 'Enfermedad';
    dateController.text == '';
    controllerOtros.text == '';
    dateMessage = '';
    setState(() {});
  }

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

    startTimes = generateTimeSlots("08:30", "15:30", 1);

    super.initState();    

    controllerOtros.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controllerOtros.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final leftPadding = screenWidth * 0.075;
    final rightPadding = screenWidth * 0.075;

    endTimes = generateTimeSlots(getNextHour(startTime), "16:30", 1);
    if (!endTimes.contains(endTime)) endTime = endTimes[0];

    return Scaffold(
        backgroundColor: const Color(0xFFE3E9F4),
        appBar: const AppBarCustomHistory(
          title: '',
        ),
        body: isLoading ? const Center(child: CircularProgressIndicator(),)  
        :SingleChildScrollView(
          padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text('Solicitud de licencia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF3D5269),
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Estudiante:',
                    style: TextStyle(
                        color: Color(0xFF3D5269),
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 2, left: 8, right: 8),
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Motivo:',
                    style: TextStyle(
                        color: Color(0xFF3D5269),
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 2, left: 8, right: 8),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        isDense: true,
                        value: selectedReason,
                        onChanged: (String? newValue) {
                          selectedReason = newValue!;
                          controllerOtros.clear();
                          dateMessage = '';

                          if (dateController.text != '') {
                            DateTime currentDate = DateTime.now();
                            DateTime justDate = DateTime(currentDate.year,
                                currentDate.month, currentDate.day);
                            DateFormat format = DateFormat("MMM d, yyyy");
                            DateTime date = format.parse(dateController.text);

                            if (date.isAtSameMomentAs(justDate)) {
                              dateController.text = '';
                            }
                          }
                          if (newValue == 'EMERGENCIA') {
                            String formatedDate =
                                DateFormat('yMMMd').format(DateTime.now());
                            dateController.text = formatedDate.toString();
                            dateMessage = 'Fecha establecida automaticamente';
                          }
                          setState(() {});
                        },
                        items: reasonsList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      if (selectedReason == 'Otros')
                        TextField(
                          maxLength: 15,
                          controller: controllerOtros,
                          decoration: InputDecoration(
                            hintText: 'Escribe tu razón',
                            counterText: '${controllerOtros.text.length}/15',
                          ),
                        ),
                      if (selectedReason == 'EMERGENCIA')
                        const Text('Motivo de EMERGENCIA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFFC00707),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Justificativo:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color(0xFF3D5269),
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              IconButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['png', 'jpg', 'jpeg']);
                  if (result != null) {
                    final pickedFile = result.files.single;
                    const maxSize = 2 * 1024 * 1024;
                    if (pickedFile.size > maxSize) {
                      // ignore: use_build_context_synchronously
                      showErrorDialog(context,
                          "El archivo seleccionado es demasiado grande.");
                    } else {
                      imagePath = pickedFile.path!;
                      setState(() {});
                    }
                  } else {
                    // ignore: use_build_context_synchronously
                    showErrorDialog(
                        context, "No olvide subir el justificativo.");
                  }
                },
                icon: Image(
                  image: const AssetImage('assets/ui/carga-de-carpeta.png'),
                  width: screenWidth * 0.1,
                ),
              ),
              const Text(
                'Cargar',
                style: TextStyle(
                    color: Color(0xFF3D5269),
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              if(imagePath != '')
              Image.file(
                File(imagePath),
                width: screenWidth * 0.7,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Fecha:',
                    style: TextStyle(
                        color: Color(0xFF3D5269),
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFffffff),
                    icon: const Image(
                        image: AssetImage('assets/ui/calendar.png'), width: 20),
                    hintText: 'Ingrese la fecha',
                  ),
                  readOnly: true,
                  onTap: () async {
                    if (selectedReason != 'EMERGENCIA') {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 20),
                      );
                      if (pickedDate != null) {
                        // Obtener la fecha actual sin la parte de la hora (sólo año, mes y día).
                        DateTime currentDate = DateTime.now();
                        DateTime justDate = DateTime(currentDate.year,
                            currentDate.month, currentDate.day);

                        dateMessage = '';
                        if (pickedDate.isAtSameMomentAs(justDate)) {
                          dateController.text = '';
                          // ignore: use_build_context_synchronously
                          showErrorDialog(context,
                              "Debe solicitar la licencia minimamente con un día de anticipación.\nEn caso quiera solicitar una licencia para el dia de hoy debe marcar como motivo de EMERGENCIA.");
                        } else {
                          String formattedDate =
                              DateFormat('yMMMd').format(pickedDate);
                          dateController.text = formattedDate.toString();
                        }
                      } else {
                        if (dateController.text == '') {
                          dateMessage = 'DEBE MARCAR UNA FECHA';
                        }
                      }
                      setState(() {});
                    }
                  },
                ),
              ),
              if (selectedReason == 'EMERGENCIA' || dateMessage != '')
                Text(dateMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0xFFC00707),
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Hora:',
                    style: TextStyle(
                        color: Color(0xFF3D5269),
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('De:',
                          style: TextStyle(
                              color: Color(0xFF3D5269), fontSize: 18)),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                            ),
                            value: startTime,
                            onChanged: (String? newValue) {
                              startTime = newValue.toString();
                              setState(() {});
                            },
                            items: startTimes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text('a',
                          style: TextStyle(
                              color: Color(0xFF3D5269), fontSize: 18)),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                            ),
                            value: endTime,
                            onChanged: (String? newValue) {
                              endTime = newValue.toString();
                              setState(() {});
                            },
                            items: endTimes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    if ((imagePath.trim() != '' || selectedReason == 'EMERGENCIA') && dateController.text != '') {
                      if ((controllerOtros.text.trim() != '' || selectedReason != 'Otros')) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                alignment: Alignment.center,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                        '¿Estás seguro de que quieres enviar el formulario?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF3D5269),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                PersonaModel user = students
                                                    .firstWhere((student) =>
                                                        student.id ==
                                                        selectedStudentId);
                                                String reason =
                                                    (selectedReason == 'Otros')
                                                        ? controllerOtros.text
                                                            .trim()
                                                        : selectedReason;
                                                File? imageFile;
                                                if (imagePath != '') {
                                                  imageFile = File(imagePath.toString());
                                                }                                                    

                                                String result =
                                                    await licenseRemoteDatasourceImpl
                                                        .addLicense(
                                                            user,
                                                            reason,
                                                            imageFile,
                                                            dateController.text,
                                                            startTime, 
                                                            endTime,
                                                            'ACTIVE',
                                                            personaId,
                                                            DateTime.now());
                                                clearForm();
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pushNamed(
                                                  '/license_verification',
                                                  arguments: {'id': result},
                                                );
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color(0xFF044086))),
                                              child: const Text('Si',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color(0xFF044086))),
                                              child: const Text('No',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                      } else {
                        showErrorDialog(context, 'No olvide señalar el motivo');
                      }
                    } else {
                      showErrorDialog(context,
                          'No olvide subir el justificativo y marcar la fecha');
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF044086))),
                  child: const Text('Enviar',
                      style: TextStyle(color: Colors.white))),
              const SizedBox(
                height: 40,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                icon: Image(
                  image: const AssetImage('assets/ui/home.png'),
                  width: screenWidth * 0.2,
                ),
              ),
              const Text(
                'Inicio',
                style: TextStyle(
                    color: Color(0xFF3D5269),
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              )
            ],
          ),
        ));
  }
}
