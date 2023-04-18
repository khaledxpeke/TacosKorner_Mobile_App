// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/http_exceptions.dart';

class Sauces with ChangeNotifier {
  List<dynamic> sauces = [];
  List<dynamic> sauce = [];

  final url = Uri.parse("http://192.168.1.24:3000/api");

  Future<void> getSauces() async {
    try {
      final response = await http.get(Uri.parse("$url/desert"));
      if (response.statusCode == 200) {
        sauces = json.decode(response.body);
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

  setSauce(List<dynamic> sauce1) {
    sauce = sauce1;
    notifyListeners();
  }
}
