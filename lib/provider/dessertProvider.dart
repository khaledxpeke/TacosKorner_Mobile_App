// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/http_exceptions.dart';

class Deserts with ChangeNotifier {
  List<dynamic> deserts = [];

  final url = dotenv.env['API_URL'];

  Future<void> getDeserts() async {
    try {
      final response = await http.get(Uri.parse("$url/desert"));
      if (response.statusCode == 200) {
        deserts = json.decode(response.body);
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
