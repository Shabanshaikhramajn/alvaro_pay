import 'package:flutter/material.dart';

import 'package:alvaro_pay/app.dart';
import 'package:alvaro_pay/core/di/injection_container.dart';

void main() {
  setupInjection();
  runApp(const AlvaroPayApp());
}
