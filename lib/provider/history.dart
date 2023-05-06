// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Histories {
  final url = dotenv.env['API_URL'];

  Future<String> addHistory(
      List<dynamic> products, String pack, String total) async {
    try {
      final response = await http.post(Uri.parse("$url/history"), body: {
        "product": json.encode(products),
        "pack": pack,
        "total": total
      });
      final body = json.decode(response.body);
      if (response.statusCode == 201) {
        return "success";
      } else {
        return body['message'];
      }
    } on SocketException catch (e) {
      print('SocketException: $e');
      return "Impossible d'accéder à Internet!";
    } on FormatException catch (e) {
      print('FormatException: $e');
      return "Une erreur s'est produite";
    } catch (exception) {
      print('Exception: $exception');
      return exception.toString();
    }
  }
}
