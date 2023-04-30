// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/http_exceptions.dart';

class Package with ChangeNotifier {
  List<dynamic> packages = [];

  final url = dotenv.env['API_URL'];

  Future<void> getPackage() async {
    try {
      final response = await http.get(Uri.parse("$url/pack"));
      if (response.statusCode == 200) {
        packages = json.decode(response.body);
        notifyListeners();
      } else {
        throw HttpException(
            "il n'y a pas de depot encore, réessayer plus tard");
      }
    } catch (e) {
      print('error: $e');
      throw HttpException("il n'y a pas de depot encore, réessayer plus tard");
    }
  }
}
