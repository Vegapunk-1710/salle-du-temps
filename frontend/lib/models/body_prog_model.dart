import 'dart:convert';

class BodyProgression {
  String id;
  DateTime createdAt;
  List<String> imagesPaths;
  num currentWeight;

  BodyProgression({
    required this.id,
    required this.createdAt,
    required this.imagesPaths,
    required this.currentWeight,
  });

  @override
  String toString() {
    return 'id : ${id}\ncreatedAt : ${createdAt}\nimagesPaths : ${imagesPaths}\ncurrentWeight: ${currentWeight}\n';
  }

  BodyProgression.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = DateTime.parse(json['createdAt']),
        imagesPaths = json['imagesPaths'].toString().replaceAll('"', '').substring(1,json['imagesPaths'].toString().length-1).split(","),
        currentWeight = double.parse(json['currentWeight']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'imagesPaths': jsonEncode(imagesPaths, toEncodable: (c)=> c.toString()),
        'currentWeight' : currentWeight.toString()
      };
}
