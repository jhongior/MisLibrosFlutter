import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mis_libros/models/user.dart';
import 'package:mis_libros/pages/my_books_page.dart';
import 'package:mis_libros/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/firebase_api.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    //_getUser();
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final FirebaseApi _firebaseApi = FirebaseApi();

  final _email = TextEditingController();
  final _password = TextEditingController();
  User userLoad = User.Empty();

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap = jsonDecode(prefs.getString("user")!);
    userLoad = User.fromJson(userMap);
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
              children: <Widget>[
                const Image(image: AssetImage("assets/images/logo.png")),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Correo Electronico'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _password,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Contraseña'),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      _validateUser();
                    },
                    child: const Text('Iniciar Sesión')),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.blue)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  child: const Text('Registrese'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateUser() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _showMsg("Debe digitar correo y contraseña");
    } else {
      var result = await _firebaseApi.logInUser(_email.text, _password.text);
      String msg = "";
      if (result == "invalid-email") {
        msg = "El correo electronico esta mal escrito";
      } else if (result == "wrong-password") {
        msg = "Correo o contraseña invalida";
      } else if (result == "network-request-failed") {
        msg = "Revise su conexión a internet";
      } else if (result == "user-not-found") {
        msg = "Usuario no encontrado";
      } else {
        msg = "Bienvenido";
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      _showMsg(msg);
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
}
