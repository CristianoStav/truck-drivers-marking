import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class User {
  String id;
  String name;
  String email;
  int age;

  User({
    required this.id,
    required this.age,
    required this.name,
    required this.email,
  });

  @override
  String toString() {
    return 'User {id: $id, name: $name}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      age: json['age'],
      name: json['name'],
      email: json['email'],
    );
  }
}

final HTTP_OK_CODES = [200, 201];

Future<User?> Login(String email, String password) async {
  try {
    final response = await http.post(
        Uri.parse('http://192.168.15.145:3000/auth'),
        headers: {'Contet-Type': 'application/json'},
        body: {"email": email, "password": password});

    print('respose -> ${response.statusCode}');

    if (HTTP_OK_CODES.contains(response.statusCode)) {
      final dynamic data = jsonDecode(response.body);
      final User user = User.fromJson(data);

      return user;
    } else {
      throw HttpException(response.body);
    }
  } on HttpException catch (e) {
    final errorMessage = json.decode(e.message);
    final errorDescription = errorMessage['message'];
    return User(id: '', age: 0, name: errorDescription, email: email);
  }
}
