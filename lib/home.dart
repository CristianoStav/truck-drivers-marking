import 'dart:async';

import 'package:flutter/material.dart';
import "./helper.dart";

const List<String> markPoints = [
  'Começo da Jornada',
  'Fim da jornada',
  'Entrada no cliente',
  'Saida do cliente',
  'Entrada almoço',
  'Volta Almoço'
];

class HomePage extends StatefulWidget {
  final String userName;

  HomePage({required this.userName});

  @override
  _HomePage createState() => _HomePage(userName: userName);
}

class _HomePage extends State<HomePage> {
  Timer _timer = Timer.periodic(Duration(minutes: 1), (timer) {});
  String now = Helper.formatDate(DateTime.now().toString(), 'HH:mm');

  late String userName;

  _HomePage({required this.userName});

  @override
  void initState() {
    super.initState();

    int seconds = 60 - DateTime.now().second;

    _timer = Timer.periodic(Duration(seconds: seconds), (timer) {
      setState(() {
        now = Helper.formatDate(DateTime.now().toString(), 'HH:mm');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: IconButton(
          //     onPressed: () => Navigator.of(context).pop(),
          //     icon: const Icon(Icons.menu)),
          ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // implementar ação
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 18),
                child: Text('Olá $userName, como está seu dia hoje?'),
              ),
              const DropdownButtonMarkPoint(),
              Container(
                margin: EdgeInsets.only(top: 18),
                child: SizedBox(
                  width: 80,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Hota Atual',
                    ),
                    controller: TextEditingController(text: now),
                    enabled: false,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 17),
                child: ElevatedButton(
                  onPressed: () => {
                    _showConfirmDialog(
                        context, _DropdownButtonMarkPoint.dropdownValue, now)
                  },
                  child: const Text('Registrar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownButtonMarkPoint extends StatefulWidget {
  const DropdownButtonMarkPoint({super.key});

  @override
  State<DropdownButtonMarkPoint> createState() => _DropdownButtonMarkPoint();
}

class _DropdownButtonMarkPoint extends State<DropdownButtonMarkPoint> {
  static String dropdownValue = markPoints.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: markPoints.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

Future _showConfirmDialog(BuildContext context, String type, String time) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Deseja confirmar a marcação?'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  child: RichText(
                    text: TextSpan(
                      text: 'Tipo de ponto: ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: type,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  child: RichText(
                    text: TextSpan(
                      text: 'Horario: ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: time,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Confirmar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
