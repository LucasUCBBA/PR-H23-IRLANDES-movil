import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCardPostulacion extends StatelessWidget {
  // ignore: non_constant_identifier_names
  const CustomCardPostulacion({
    super.key, 
    required this.date, 
    required this.studentName, 
    required this.id, 
    required this.hour,}
  );

  final String date;
  final String hour;
  final String studentName;
  final String id;


  String formatDate(String date) {
    DateFormat inputFormat = DateFormat("yyyy-mm-dd", "en_US");
    DateTime inputDate = inputFormat.parse(date);
  
    // Formateando la fecha al formato deseado
    String formattedDate = DateFormat("dd/mm/yyyy", 'es_ES').format(inputDate);
    return formattedDate; 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(studentName, style: const TextStyle(color:Color(0xFF044086), fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Fecha', style: TextStyle(color: Colors.black87, fontSize: 16)),
              Text(formatDate(date), style: const TextStyle(color: Colors.black87, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Hora', style: TextStyle(color: Colors.black87, fontSize: 16)),
              Text(hour, style: const TextStyle(color: Colors.black87, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment:MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/postulation_details',
                    arguments: {'id': id}
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(0xFF044086)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Ajusta el valor del radio como desees
                    ),
                  ),
                ),
                child: const Text(
                  'Detalles',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }  
}