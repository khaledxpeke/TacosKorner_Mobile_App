// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/http_exceptions.dart';

class Deserts with ChangeNotifier {
  List<dynamic> deserts = [];
  List<dynamic> desert = [];

  final url = Uri.parse("http://192.168.1.24:3000/api");

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

  setDessert(List<dynamic> desert1) {
    desert = desert1;
    notifyListeners();
  }
}
