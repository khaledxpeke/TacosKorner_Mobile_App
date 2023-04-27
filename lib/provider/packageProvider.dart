// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/http_exceptions.dart';

class Package with ChangeNotifier {
  List<dynamic> packages = [];

  final url = Uri.parse("http://192.168.1.24:3000/api");

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

  setDessert(List<dynamic> packages1) {
    packages = packages1;
    notifyListeners();
  }
}
