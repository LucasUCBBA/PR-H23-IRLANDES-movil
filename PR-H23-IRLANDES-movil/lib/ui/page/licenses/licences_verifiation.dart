import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:irlandes_app/data/model/License_model.dart';
import 'package:irlandes_app/data/remote/license_remote_datasource.dart';
import 'package:screenshot/screenshot.dart';

class LicenseVerification extends StatefulWidget {
  final String id;
  final String? action;
  const LicenseVerification({super.key, required this.id, this.action});

  @override
  State<LicenseVerification> createState() => _LicenseVerification();
}

class _LicenseVerification extends State<LicenseVerification> {
  LicenseRemoteDatasourceImpl licenseRemoteDatasourceImpl =
      LicenseRemoteDatasourceImpl();
  final _screenshotController = ScreenshotController();

  Future<LicenseModel> refreshLicenses(String id) async {
    return licenseRemoteDatasourceImpl.getLicenseByID(id);
  }

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
    super.initState();
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

    String formatDate(String date) {
      DateFormat inputFormat = DateFormat("MMM d, yyyy", "en_US");
      DateTime inputDate = inputFormat.parse(date);

      // Formateando la fecha al formato deseado
      String formattedDate =
          DateFormat("dd 'de' MMMM 'de' yyyy", 'es_ES').format(inputDate);
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
                FutureBuilder<LicenseModel>(
                  future: refreshLicenses(widget.id),
                  builder: (context, snapshot) {
                    if (!(snapshot.connectionState ==
                            ConnectionState.waiting) &&
                        !snapshot.hasError &&
                        !(!snapshot.hasData || snapshot.data == null)) {
                      // Si el Future todavía está corriendo, muestra un CircularProgressIndicator.
                      return IconButton(
                          iconSize: 2,
                          icon: Image.asset(
                            'assets/ui/disco.png',
                            width: 30,
                          ),
                          onPressed: () async {
                            takeScreenshot(context);
                          });
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              ],
            )
          ],
        ),
        body: FutureBuilder<LicenseModel>(
          future: refreshLicenses(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar la licencia.'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No se encontró la licencia.'));
            } else {
              LicenseModel? license = snapshot.data;
              return Screenshot(
                controller: _screenshotController,
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: EdgeInsets.only(
                          top: 20,
                          bottom: 10,
                          left: leftPadding,
                          right: rightPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Center(
                            child: Image(
                                image: AssetImage('assets/ui/logo.png'),
                                width: 100),
                          ),
                          const Text('Detalles de la licencia',
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
                              CustomRow('Estudiante: ', '${license!.user!.name} ${license.user!.lastname} ${license.user!.surname}'),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomRow('Curso: ', license.user!.grade),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomRow(
                                  'Fecha: ', formatDate(license.license_date)),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomRow('De: ', license.departure_time),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomRow('Hasta: ', license.return_time),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomRow('Motivo: ', license.reason),
                              const SizedBox(
                                height: 5,
                              ),
                              const Align(
                                alignment: Alignment.center,
                                child: Text('Justificativo:',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xFF044086),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              if( license.justification != '')
                              Center(
                                child: Image.network(
                                  license.justification,
                                  height: 300,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              if(license.justification == '')
                                const Text('El usuario no subio un justificativo')
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
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
