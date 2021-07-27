import 'package:hive/hive.dart';
part 'Data.g.dart';

@HiveType(typeId: 0)
class Data extends HiveObject{
  @HiveField(0)
  late String name;
  @HiveField(1)
  late int age;

}