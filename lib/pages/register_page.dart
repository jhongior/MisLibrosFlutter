import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mis_libros/models/user.dart';
import 'package:mis_libros/pages/login_page.dart';
import 'package:mis_libros/repository/firebase_api.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum Genre { masculimo, femenino }

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final FirebaseApi _firebaseApi = FirebaseApi();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repPassword = TextEditingController();

  Genre? _genre = Genre.masculimo;
  bool _aventure = false;
  bool _terror = false;
  bool _fantasia = false;
  String buttonMsg = "Fecha de Nacimiento";
  String _date = "";

  String _dateConverter(DateTime newDate) {
    final DateFormat formatter = DateFormat("yyyy-MM-dd");
    final String dateFormatted = formatter.format(newDate);
    return dateFormatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(image: AssetImage('assets/images/logo.png')),
                const SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Nombre'),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Correo Electronico'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: _password,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Contraseña'),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: _repPassword,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirmar Contraseña'),
                  keyboardType: TextInputType.text,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Masculino'),
                        leading: Radio<Genre>(
                            value: Genre.masculimo,
                            groupValue: _genre,
                            onChanged: (Genre? value) {
                              setState(() {
                                _genre = value;
                              });
                            }),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Femenino'),
                        leading: Radio<Genre>(
                            value: Genre.femenino,
                            groupValue: _genre,
                            onChanged: (Genre? value) {
                              setState(() {
                                _genre = value;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Generos Favoritos',
                  style: TextStyle(fontSize: 20),
                ),
                CheckboxListTile(
                  title: const Text('Aventura'),
                  value: _aventure,
                  selected: _aventure,
                  onChanged: (bool? value) {
                    setState(() {
                      _aventure = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Fantasia'),
                  value: _fantasia,
                  selected: _fantasia,
                  onChanged: (bool? value) {
                    setState(() {
                      _fantasia = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Terror'),
                  value: _terror,
                  selected: _terror,
                  onChanged: (bool? value) {
                    setState(() {
                      _terror = value!;
                    });
                  },
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16)),
                  onPressed: () {
                    _showSelectDate();
                  },
                  child: Text(buttonMsg),
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16)),
                  onPressed: () {
                    _onRegisterButtonClicked();
                  },
                  child: const Text('Registrar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser(User user) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString('user', jsonEncode(user));
    var result = await _firebaseApi.registerUser(user.email, user.password);
    String msg = "";
    if (result == "invalid-email") {
      msg = "El correo electronico esta mal escrito";
    } else if (result == "weak-password") {
      msg = "La contraseña debe tener minimo 6 caracteres";
    } else if (result == "email-already-in-use") {
      msg = "El correo electronico ya existe";
    } else if (result == "network-request-failed") {
      msg = "Revise su conexión a internet";
    } else {
      msg = "Usuario registrado con exito";

      user.uid = result;
      _saveUser(user);
    }
    _showMsg(msg);
  }

  void _onRegisterButtonClicked() {
    setState(() {
      if (_password.text == _repPassword.text) {
        String genre = "Masculino";
        String favoritos = "";
        if (_genre == Genre.femenino) genre = "Femenino";

        if (_aventure) favoritos = "$favoritos Aventura";
        if (_fantasia) favoritos = "$favoritos Fantasia";
        if (_terror) favoritos = "$favoritos Terror";

        var user = User("", _name.text, _email.text, _password.text, genre,
            favoritos, _date);

        _registerUser(user);
      } else {
        _showMsg("Las contraseñas deben ser iguales");
      }
    });
  }

  void _showSelectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      locale: const Locale("es", "CO"),
      initialDate: DateTime(2022, 8),
      firstDate: DateTime(1980, 1),
      lastDate: DateTime(2022, 12),
      helpText: "Fecha de Nacimiento",
    );
    if (newDate != null) {
      setState(() {
        _date = _dateConverter(newDate);
        buttonMsg = "Fecha de Nacimiento: ${_date.toString()}";
      });
    }
  }

  void _showMsg(String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(
          label: 'Aceptar', onPressed: scaffold.hideCurrentSnackBar),
    ));
  }

  void _saveUser(User user) async {
    var result = await _firebaseApi.createUser(user);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
