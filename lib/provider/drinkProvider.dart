// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Drinks with ChangeNotifier {
  List<dynamic> drinks = [];

  final url = dotenv.env['API_URL'];

  Future<String> getDrinks() async {
    try {
      final response = await http.get(Uri.parse("$url/drink"));
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        drinks = body;
        notifyListeners();
        return "success";
      } else {
        return body['message'];
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
