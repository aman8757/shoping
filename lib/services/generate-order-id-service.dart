// ignore_for_file: unused_local_variable

import 'dart:math';

String generateOrder() {
  DateTime now = DateTime.now();
  
  int randomNumbers = Random().nextInt(99999);
  String id= '{now.microsecondsSinceEpoch}_$randomNumbers';
  return id;
}