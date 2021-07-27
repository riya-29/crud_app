import 'dart:async';

import 'package:crud_app/Model/Data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'UI/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DataAdapter());
  await Hive.openBox<Data>('data');

  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.indigo,
      home: Home())
  );
}
