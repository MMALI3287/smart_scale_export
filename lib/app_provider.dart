import 'package:flutter/material.dart';

class app_provider with ChangeNotifier {
  double weight = 10.0;
  double get getWeight => weight;
  void setWeight(double value) {
    weight = value;
    notifyListeners();
  }
}
