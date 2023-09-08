// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Deserts with ChangeNotifier {
  List<dynamic> deserts = [];

  final url = dotenv.env['API_URL'];

  Future<String> getDeserts() async {
    try {
      final response = await http.get(Uri.parse("$url/desert"));
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        deserts = body;
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
