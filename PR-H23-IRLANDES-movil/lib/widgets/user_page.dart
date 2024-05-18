import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final String name;
  final String urlImage;

  const UserPage({
    super.key,
    required this.name,
    required this.urlImage,
  });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(widget.name),
          centerTitle: true,
        ),
        body: Image.network(
          widget.urlImage,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
}