import 'package:flutter/material.dart';

class ConfigurationData extends ChangeNotifier {
  Color _mainColor = Colors.green;
  int _gridSize = 8;

  Color get mainColor => _mainColor;
  int get gridSize => _gridSize;

  String get mainColorString => _mainColor.toString().split('(')[1].split(')')[0];

  void setMainColor(Color color) {
    _mainColor = color;
    notifyListeners();
  }

  void setGridSize(int size) {
    _gridSize = size;
    notifyListeners();
  }
}
