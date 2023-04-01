import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teste/api_utils.dart';
import 'dart:async' show Future;

import './home.dart' show HomePage;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const LoginPage(),
      ),
      initialRoute: 'login',
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginPage(),
        '/home': (BuildContext context) => HomePage(
              userName: '',
            ),
      },
    );
  }
}

Future<void> loadAsset() async {
  final ByteData data = await rootBundle.load('assets/truck.png');
  final Uint8List bytes = data.buffer.asUint8List();
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/truck.png',
            height: 130,
            width: 130,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(horizontal: 80),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: 'Email',
                      contentPadding: EdgeInsets.only(left: 14)),
                  validator: (String? email) {
                    if (email == null || email.isEmpty) {
                      return 'Required Field';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Password',
                      contentPadding: EdgeInsets.only(left: 14)),
                  validator: (String? email) {
                    if (email == null || email.isEmpty) {
                      return 'Required Field';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          var email = emailController.text;
                          var password = passwordController.text;

                          User? user = await Login(email, password);
                          print('nome do usuario -> ${user?.name}');

                          if (user?.id != '') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(userName: user!.name),
                              ),
                            );
                          } else {
                            _showErrorDialog(context, user);
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}

Future _showErrorDialog(BuildContext context, User? user) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: user?.name != ''
            ? Text(user!.name.toString())
            : const Text(('Error')),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
