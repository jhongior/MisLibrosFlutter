import 'package:hive/hive.dart';

part 'local_book.g.dart'; //se crea adaptador para que se reconozca el modelo a continuación

@HiveType(typeId: 0)
class LocalBook extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? author;

  @HiveField(3)
  String? publishedData;

  @HiveField(4)
  String? description;

  @HiveField(5)
  String? imageLink;
}
