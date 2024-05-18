import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:irlandes_app/data/model/postulation_model.dart';
import 'package:irlandes_app/data/remote/postulation_remote_datasource.dart';
import 'package:screenshot/screenshot.dart';

class PostulationDetails extends StatefulWidget {
  final String id;
  const PostulationDetails({super.key, required this.id});

  @override
  State<PostulationDetails> createState() => _PostulationDetails();
}

class _PostulationDetails extends State<PostulationDetails> {
  PostulationRemoteDatasourceImpl postulationRemoteDatasourceImpl = PostulationRemoteDatasourceImpl();
  late PostulationModel postulation;
  bool isLoading = true;
  final _screenshotController = ScreenshotController();

  void showMessageDialog(
      BuildContext context, String iconSource, String title, String message) {
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
              Navigator.of(context).pop();
              if (title == 'Correcto') {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void takeScreenshot(BuildContext context) async {
    Uint8List? image = await _screenshotController.capture();
    if (image != null) {
      // Generar un nombre de archivo único con extensión .png
      String fileName =
          'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';

      // Guardar la imagen con el nombre de archivo único
      final result = await ImageGallerySaver.saveImage(image, name: fileName);

      if (result['isSuccess']) {
        // ignore: use_build_context_synchronously
        showMessageDialog(context, 'assets/ui/marque-el-circulo.png',
            'Correcto', 'Se guardo la imagen en su galeria');
      } else {
        // ignore: use_build_context_synchronously
        showMessageDialog(context, 'assets/ui/circulo-cruzado.png', 'Error',
            'Error al guardar la imagen');
      }
    } else {
      // ignore: use_build_context_synchronously
      showMessageDialog(context, 'assets/ui/circulo-cruzado.png', 'Error',
          'Error al capturar la imagen');
    }
  }

  @override
  void initState() {
    postulationRemoteDatasourceImpl.getPostulationByID(widget.id).then((value) => {
      isLoading = true,
      postulation = value,
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final leftPadding = screenWidth * 0.075;
    final rightPadding = screenWidth * 0.075;

    String formatDate(String date) {
      DateFormat inputFormat = DateFormat("yyyy-mm-dd", "en_US");
      DateTime inputDate = inputFormat.parse(date);

      // Formateando la fecha al formato deseado
      String formattedDate = DateFormat("dd/mm/yyyy", 'es_ES').format(inputDate);
      return formattedDate; 
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE3E9F4),
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!isLoading)
              IconButton(
                iconSize: 2,
                icon: Image.asset(
                  'assets/ui/disco.png',
                  width: 30,
                ),
                onPressed: () async {
                  takeScreenshot(context);
                }
              )
            ],
          )
        ],
      ),
      body: isLoading? const Center(child: CircularProgressIndicator(),) 
      :Container(
        height:400,
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.only(
          top: 20,
          bottom: 10,
          left: leftPadding,
          right: rightPadding
        ),
        child:Screenshot(
          controller: _screenshotController,
          child:Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child:Column(
              children: [
                const Center(
                  child: Image(
                      image: AssetImage('assets/ui/logo.png'),
                      width: 100),
                ),
                const Text('Detalles de la postulación',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF044086),
                        fontWeight: FontWeight.bold,
                        fontSize: 25)),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    CustomRow('Estudiante: ', '${postulation.student_name} ${postulation.student_lastname}'),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomRow('Curso: ', postulation.grade),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomRow(
                      'Fecha: ', formatDate(postulation.interview_date.toString())),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomRow('Hora: ', postulation.interview_hour),
                    const SizedBox(
                      height: 5,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text('Unidad educativa de procedencia:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF044086),
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        )
                      )
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(postulation.institutional_unit, style: const TextStyle(color: Colors.black87, fontSize: 16))
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomRow('Estado: ', postulation.status),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                )
              ],
            ),
          )
        )
      )
    );
  }
}

class CustomRow extends StatelessWidget {
  const CustomRow(this.label, this.text, {super.key});
  final String label;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF044086),
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        Text(text, style: const TextStyle(color: Colors.black87, fontSize: 16)),
      ],
    );
  }
}