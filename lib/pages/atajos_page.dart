import 'package:flutter/material.dart';

class AtajosPage extends StatefulWidget {
  const AtajosPage({Key? key}) : super(key: key);

  @override
  State<AtajosPage> createState() => _AtajosPageState();
}

class _AtajosPageState extends State<AtajosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text('data'),
        ],
      )),
    );
  }
}
