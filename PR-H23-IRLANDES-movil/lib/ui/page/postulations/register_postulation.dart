import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:irlandes_app/data/model/person_model.dart';
import 'package:irlandes_app/data/model/postulation_model.dart';
import 'package:irlandes_app/data/remote/interview_schedule_remote_datasource.dart';
import 'package:irlandes_app/data/remote/postulation_remote_datasource.dart';
import 'package:irlandes_app/data/remote/user_remote_datasource.dart';
import 'package:irlandes_app/ui/widgets/custom_text_filed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPostulation extends StatefulWidget {
  const RegisterPostulation({super.key});

  @override
  State<RegisterPostulation> createState() => _RegisterPostulation();
}

class _RegisterPostulation extends State<RegisterPostulation> {
  List<PostulationModel> postulationsList = [];

  InterviewScheduleRemoteDatasourceImpl scheduleRemoteDatasourceImpl = InterviewScheduleRemoteDatasourceImpl();
  PostulationRemoteDatasourceImpl postulationRemoteDatasourceImpl = PostulationRemoteDatasourceImpl();
  TextEditingController dateController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController studentLastnameController = TextEditingController();
  TextEditingController studentCIController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String level = '', grade = '', gender = '', foreign = '';
  final PersonaDataSource _usuarioDataSource = PersonaDataSource();

  DateFormat format = DateFormat("dd/MM/yyyy");
  DateTime startDate = DateTime.now().add(const Duration(days: 1)), endDate = DateTime(2023, 11, 1), selectedDay = DateTime(1999, 11, 1);
  late List<String> days, times;
  final CarouselController _carouselController = CarouselController();
  String startTime = '08:30', endTime = '16:30', selectedHour = '';
  bool isLoading = true, isScheduleActive = false, needColorHelp = false;
  late PersonaModel padre;
  String personaId = '';
  List<String> gradeList = [];

  InputDecoration customDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
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

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getData() {
    scheduleRemoteDatasourceImpl.getActiveInterviewSchedule().then((value) => {
      isLoading = true,
      if (value != null) {
        endDate = format.parse(value.limit_date),
        if (endDate.isAfter(startDate)){
          startTime = value.start_time,
          endTime = value.end_time,
          times =
              generateTimeSlots(value.start_time, value.end_time, 1),
          days = value.days,
          isScheduleActive = true,
        }
      },
      if (mounted){
        setState(() {
          isLoading = false;
        })
      }
    });
    postulationRemoteDatasourceImpl.getPostulationsAfterDate(startDate).then((value) => {
      isLoading = true,
      postulationsList = value,
      if (mounted) {
        setState(() {
          isLoading = false;
        })
      }
    });
  }

  DateTime resetTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  List<List<DateTime>> getWeeks(DateTime startDate, DateTime endDate) {
    List<List<DateTime>> weeks = [];

    startDate = resetTime(startDate);
    endDate = resetTime(endDate);

    // Si startDate es sábado (6) o domingo (7), ajusta al próximo lunes
    if (startDate.weekday == 6) {
      startDate = startDate.add(const Duration(days: 2));
    } else if (startDate.weekday == 7) {
      startDate = startDate.add(const Duration(days: 1));
    }

    DateTime currentMonday = resetTime(startDate.subtract(Duration(days: startDate.weekday - 1)));

    while (currentMonday.isBefore(endDate)) {
      List<DateTime> week = [];
      for (int i = 0; i < 5; i++) {
        week.add(currentMonday.add(Duration(days: i)));
      }
      weeks.add(week);
      currentMonday = currentMonday.add(const Duration(days: 7));
    }

    return weeks;
  }

  List<String> generateTimeSlots(
    String startTime, String endTime, int intervalInHours) {
    final start = TimeOfDay(hour: int.parse(startTime.split(':')[0]), minute: int.parse(startTime.split(':')[1]));
    final end = TimeOfDay( hour: int.parse(endTime.split(':')[0]), minute: int.parse(endTime.split(':')[1]));

    final List<String> times = [''];

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

  bool areTextControllersNotEmpty(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    if (level == '' || grade == '' || gender == '') {
      return false;
    }
    return true;
  }

  bool areAllFieldsFilled() {
    List<TextEditingController> allControllers = [
      dateController,
      schoolController,
      cityController,
      studentNameController,
      studentLastnameController,
      studentCIController,
      phoneController,
      emailController,
    ];
    return areTextControllersNotEmpty(allControllers);
  }

  void showMessageDialog(BuildContext context, String iconSource, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Image.asset(
              iconSource,
              width: 30,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF044086),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text(
              "Aceptar",
              style: TextStyle(
                color: Color(0xFF044086),
                fontSize: 15,
              ),
            ),
            onPressed: () {
              if (title == 'Correcto') {
                Navigator.of(context).pop();
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    personaId = prefs.getString('personId')!;
  }

  void clearForm() {
    dateController.text = '';
    schoolController.text = '';
    cityController.text = '';
    studentNameController.text = '';
    studentLastnameController.text = '';
    studentCIController.text = '';
    complementController.text = '';
    phoneController.text = '';
    emailController.text = '';
    foreign = '';
    selectedHour = '';
    selectedDay = DateTime(1999, 11, 1);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    getId();
    Future.delayed(const Duration(seconds: 2), () async {
      padre = await _usuarioDataSource.getPersonFromId(personaId) as PersonaModel;
    });
    List<List<DateTime>> weeks = getWeeks(startDate, endDate);
    return Scaffold(
      backgroundColor: const Color(0xFFE3E9F4),
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: const Color(0xFFE3E9F4),
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/ui/home.png',
              width: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            }
          ),
          IconButton(
            icon: Image.asset(
              'assets/ui/clock-solid2.png',
              width: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/postulation_history');
            }
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : !isScheduleActive
              ? const Center(
                  child: Text(
                    'Las postulaciones no estan activas',
                    style: TextStyle(
                      color: Color(0xFF044086),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              : Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth * 0.9,
                        constraints: const BoxConstraints(
                          minWidth: 700.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3E9F4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text('Registrar postulación',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF3D5269),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child:DropdownButtonFormField<String>(
                                            decoration:
                                                customDecoration('Nivel'),
                                            isDense: true,
                                            items: ['Inicial', 'Primaria', 'Secundaria']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              level = value!;                                              
                                              switch (value) {
                                                case 'Inicial':
                                                  gradeList = ['1ra sección','2da sección'];
                                                  grade = gradeList[0];
                                                  break;
                                                default: 
                                                  gradeList = ['1er','2do','3er','4to','5to', '6to'];
                                                  grade = gradeList[0];
                                              }
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child:DropdownButtonFormField<String>(
                                            isDense: true,
                                            decoration:customDecoration('Curso'),       
                                            value: gradeList.isNotEmpty ? grade:'',                        
                                            items: gradeList.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              grade = value!;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextField(
                                      label: 'Unidad educativa de procedencia',
                                      controller: schoolController,
                                      maxLength: 40,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9áéíóúÁÉÍÓÚñÑüÜ'.\s-]")),
                                        FilteringTextInputFormatter.deny(RegExp(r'\s\s+')),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextField(
                                      label: 'Ciudad',
                                      controller: cityController,
                                      maxLength: 20,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.deny(RegExp(r'[^A-Za-záéíóúÁÉÍÓÚñÑüÜ\s]')),
                                        FilteringTextInputFormatter.deny(RegExp(r'\s\s+')),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Postulante',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(0xFF044086),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    CustomTextField(
                                      label: 'Nombres',
                                      controller: studentNameController,
                                      maxLength: 40,
                                      type: TextInputType.name,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.deny(RegExp(r'[^A-Za-záéíóúÁÉÍÓÚñÑüÜ\s]')),
                                        FilteringTextInputFormatter.deny( RegExp(r'\s\s+')),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextField(
                                      label: 'Apellidos',
                                      controller: studentLastnameController,
                                      type: TextInputType.name,
                                      maxLength: 40,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.deny(RegExp(r'[^A-Za-záéíóúÁÉÍÓÚñÑüÜ\s]')),
                                        FilteringTextInputFormatter.deny(RegExp(r'\s\s+')),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 25),
                                            child: GestureDetector(
                                              onTap:() {
                                                foreign ==''? foreign = 'E-' : foreign = '';
                                                setState(() {});
                                              },
                                              child: MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: foreign !='' ? const Color(0xFF044086) : Colors.grey,
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'E',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ) 
                                          ), 
                                        ), 
                                        const SizedBox(width: 3),
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 25),
                                          child: const Text('-', style: TextStyle(color: Colors.black, fontSize: 24)),   
                                        ),
                                        const SizedBox(width: 5),
                                        Flexible(
                                          flex: 7,
                                          child: CustomTextField(
                                            label: 'CI',
                                            controller: studentCIController,
                                            maxLength: 10,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Flexible(
                                          flex: 5,
                                          child: CustomTextField(
                                            label: 'Complemento',
                                            controller: complementController,
                                            maxLength: 3,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[a-z]')),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child:DropdownButtonFormField<String>(
                                            isDense: true,
                                            decoration: customDecoration('Género'),
                                            items: ['Masculino', 'Femenino'].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              gender = value!;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: dateController,
                                            decoration: customDecoration('Fecha de nacimiento'),
                                            readOnly: true,
                                            onTap: () async {
                                              DateTime? pickedDate = await showDatePicker(
                                                context: context,
                                                initialDate:  DateTime(DateTime.now().year - 5),
                                                firstDate: DateTime(DateTime.now().year - 25),
                                                lastDate: DateTime.now(),
                                              );
                                              if (pickedDate != null) {
                                                DateTime currentDate = DateTime.now();
                                                DateTime justDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
                                                if (pickedDate.isAtSameMomentAs(justDate)) {
                                                  dateController.text = '';
                                                } else {
                                                  String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                                                  dateController.text = formattedDate.toString();
                                                }
                                              } else {
                                                if (dateController.text == '') {
                                                  // ignore: use_build_context_synchronously
                                                  showMessageDialog(context, 'assets/ui/circulo-cruzado.png', 'Error', 'Debe marcar una fecha');
                                                }
                                              }
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Datos de contacto',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(0xFF044086),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    CustomTextField(
                                      label: 'Teléfono',
                                      type: TextInputType.phone,
                                      controller: phoneController,
                                      maxLength: 10,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextField(
                                      label: 'Correo electrónico',
                                      controller: emailController,
                                      type: TextInputType.emailAddress,
                                      maxLength: 30,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.deny(RegExp(r"[&=_\s\'\-+,<>]")),
                                        FilteringTextInputFormatter.deny(RegExp(r'\.\.+')),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Fecha de entrevista',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Color(0xFF044086),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Image.asset(
                                            'assets/ui/interrogatorio.png',
                                            width: 20,
                                          ),
                                          onPressed: () {
                                            needColorHelp = !needColorHelp;
                                            setState(() {});
                                          }
                                        ),
                                      ],
                                    ),
                                    if(needColorHelp)                                    
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 60.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Significado de los colores',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: Color(0xFF044086), fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5,),
                                          ColorHelp(color: Color(0x5F9E9E9E), text: 'No disponible'),
                                          SizedBox(height: 5,),
                                          ColorHelp(color: Color(0xFF9E9E9E), text: 'Disponible'),
                                          SizedBox(height: 5,),
                                          ColorHelp(color: Color(0xFFd9534f), text: 'Ocupado'),
                                          SizedBox(height: 5,),
                                          ColorHelp(color: Color(0xFF198754), text: 'Seleccionado'),
                                          SizedBox(height: 5,),
                                        ],
                                      )
                                    ),
                                  ],
                                ),
                              ),
                              if (selectedHour.isNotEmpty)
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  ('${DateFormat('dd/MM/yyyy').format(selectedDay)} $selectedHour'),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle( color: Color(0xFF044086), fontSize: 18),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                child: CarouselSlider.builder(
                                  carouselController: _carouselController,
                                  itemCount: weeks.length,
                                  itemBuilder: (context, carouselIndex, realIndex) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: GridView.builder(
                                          gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 6,
                                          ),
                                          itemBuilder: (context, gridIndex) {
                                            int rowIndex = gridIndex ~/ 6;
                                            int columnIndex = gridIndex % 6;
                                            if (columnIndex == 0) {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(times[rowIndex],
                                                    style: const TextStyle(
                                                      fontWeight:FontWeight.bold,
                                                      color: Color(0xFF044086)
                                                    )
                                                  ),
                                                ],
                                              );
                                            } else {
                                              if (rowIndex == 0) {
                                                DateTime day = weeks[carouselIndex][columnIndex - 1];
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      DateFormat('E', 'ES_es').format(day),
                                                      style: const TextStyle(
                                                        fontWeight:FontWeight.bold,
                                                        color: Color( 0xFF044086)
                                                      )
                                                    ),
                                                    Text(
                                                      DateFormat('d/MM', 'ES_es').format(day),
                                                      style: const TextStyle(
                                                        fontWeight:FontWeight.bold,
                                                        color: Color(0xFF044086)
                                                      )
                                                    ),
                                                    const Divider(
                                                      height: 2,
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                DateTime day = weeks[carouselIndex] [columnIndex - 1];
                                                String formattedDay = DateFormat('EEEE', 'ES_es').format(day).toLowerCase();
                                                bool isSelected = selectedDay == day && selectedHour == times[rowIndex];

                                                int status = postulationsList.any((d) => DateTime( d.interview_date.year, d.interview_date.month, d.interview_date.day) == day && d.interview_hour == times[rowIndex]) ? 1 : 2;

                                                if (endDate.isBefore(day) || startDate.isAfter(day) || !days.any((d) => d.toLowerCase() == formattedDay)) {
                                                  status = 0;
                                                }
                                                return HourButton(
                                                  isSelected: isSelected,
                                                  status: status,
                                                  onTap: () {
                                                    if (status == 2) {
                                                      selectedDay = day;
                                                      selectedHour = times[rowIndex];
                                                      setState(() {});
                                                    }
                                                  },
                                                );
                                              }
                                            }
                                          },
                                          itemCount: times.length * 6,
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: 300,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: false,
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () {
                                      _carouselController.previousPage();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      _carouselController.nextPage();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(const Color(0xFF044086)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  final bool emailValid = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(emailController.text);
                                  if (areAllFieldsFilled()) {
                                    if (emailValid) {
                                      if (selectedHour.trim().isNotEmpty) {
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
                                                        fontWeight:FontWeight.bold,
                                                        fontSize: 18
                                                      )
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only( left: 5, right: 5),
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              DateFormat format = DateFormat("dd/MM/yyyy");
                                                              DateTime birthDay = format.parse(dateController.text);
                                                              try {
                                                                PostulationModel postulation = PostulationModel(
                                                                  level: level,
                                                                  grade: grade,
                                                                  institutional_unit: schoolController.text.trim(),
                                                                  city: cityController.text.trim(),
                                                                  amount_brothers: 1,
                                                                  student_name: studentNameController.text.trim(),
                                                                  student_lastname: studentLastnameController.text.trim(),
                                                                  student_ci: '$foreign${studentCIController.text.trim()} ${complementController.text.trim()}'.trim(),
                                                                  birth_day: birthDay,
                                                                  gender: gender,
                                                                  father_name: padre.name,
                                                                  father_lastname: padre.lastname,
                                                                  father_cellphone: padre.cellphone,
                                                                  mother_name: '',
                                                                  mother_lastname: '',
                                                                  mother_cellphone: '',
                                                                  telephone: phoneController.text.trim(),
                                                                  email: emailController.text.trim(),
                                                                  interview_date: selectedDay,
                                                                  interview_hour: selectedHour,
                                                                  userID: padre.id,
                                                                  status: 'Pendiente',
                                                                  register_date: DateTime.now()
                                                                );
                                                                final result = await postulationRemoteDatasourceImpl.createPostulations(postulation);
                                                                clearForm();
                                                                // ignore: use_build_context_synchronously
                                                                showMessageDialog(context, 'assets/ui/marque-el-circulo.png', 'Correcto', 'Accion realizada con éxito');
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.of(context).pushNamed( '/postulation_details', arguments: {'id': result} );
                                                              } catch (e) {
                                                                // ignore: use_build_context_synchronously
                                                                showMessageDialog(context, 'assets/ui/circulo-cruzado.png', 'Error', 'Ha ocurrido un error inesperado $e');
                                                              }
                                                            },
                                                            style: ButtonStyle( backgroundColor: MaterialStateProperty.all(const Color(0xFF044086))),
                                                            child: const Text('Si', style: TextStyle( color: Colors.white))
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 5,right: 5),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of( context).pop();
                                                            },
                                                            style: ButtonStyle( backgroundColor: MaterialStateProperty.all( const Color( 0xFF044086) ) ),
                                                            child: const Text( 'No', style: TextStyle( color: Colors.white))
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      } else {
                                        showMessageDialog( context,'assets/ui/circulo-cruzado.png', 'Error', 'No olvide seleccionar una fecha para la entrevista');
                                      }
                                    } else {
                                      showMessageDialog( context, 'assets/ui/circulo-cruzado.png', 'Error', 'El correo no tiene un formato valido');
                                    }
                                  } else {
                                    showMessageDialog(context, 'assets/ui/circulo-cruzado.png', 'Error', 'No debe dejar campos vacios');
                                  }
                                },
                                child: const Text('Enviar',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class HourButton extends StatelessWidget {
  final bool isSelected;
  final int status;
  final void Function()? onTap;

  const HourButton({
    super.key,
    required this.isSelected,
    this.onTap,
    required this.status,
  });

  Color getColor() {
    return status == 0
        ? const Color.fromARGB(95, 158, 158, 158)
        : status == 1
            ? const Color(0xFFd9534f)
            : isSelected
                ? const Color(0xFF198754)
                : const Color(0xFF9E9E9E);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor:
          status < 2 ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: getColor(),
            borderRadius: BorderRadius.circular(5),
          )
        ),
      ),
    );
  }
}

class ColorHelp extends StatelessWidget {
  final String text;
  final Color color;

  const ColorHelp({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [                                              
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          )
        ),
        Text(text)
      ],
    );
  }
}
