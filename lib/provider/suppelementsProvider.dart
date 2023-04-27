// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class Supplements with ChangeNotifier {
  List<dynamic> supplements = [];

  setSupplements(List<dynamic> supplements1) {
    supplements = supplements1;
    notifyListeners();
  }
}
