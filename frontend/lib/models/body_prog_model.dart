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
        imagesPaths = json['imagesPaths'].cast<String>(),
        currentWeight = json['currentWeight'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'imagesPaths': imagesPaths,
        'currentWeight' : currentWeight
      };
}
