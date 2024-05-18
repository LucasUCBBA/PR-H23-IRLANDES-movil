import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return  Drawer(
      backgroundColor: Color(0xFFE3E9F4),
      child: Column(
        children: [
          Card(
            child: Container(
              child: ListTile(
                leading: Icon(Icons.person, color: Color(0xFF044086)),
              )
            ),
          )
        ],
      )
    );
  }
}