// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Printer with ChangeNotifier {
  static const headers = {
    "Content-Type": "text/vnd.star.markup",
    'Star-Api-Key': 'b8a5a7ef-0180-44c5-ac5d-d0b966637dc7'
  };
  Future<String> billPrinter(dynamic confirmation) async {
    try {
      final response = await http.post(
          Uri.parse(
              "https://api.starprinter.online/v1/a/layatech/d/35adc8ed/q"),
          headers: headers,
          body: confirmation);
      final body = json.decode(response.body);
      if (response.statusCode == 201) {
        confirmation = body;
        notifyListeners();
        return "success";
      } else {
        return "Une erreur est survenue";
      }
    } on SocketException {
      return "Impossible d'accéder à Internet!";
    } on FormatException {
      return "Une erreur est survenue";
    } catch (exception) {
      return exception.toString();
    }
  }
}
