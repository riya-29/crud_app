import 'package:crud_app/Model/Data.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Data> getData()=> Hive.box<Data>('data');

}