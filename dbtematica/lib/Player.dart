class Player {
  final String name;
  final int age;
  final String height;
  final String weight;
  final String position;
  final String image;

  Player({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.position,
    required this.image,
  });

  String get getName => name;
  int get getAge => age;
  String get getHeight => height;
  String get getWeight => weight;
  String get getPosition => position;
  String get getImage => image;

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
      age: json['age'] as int,
      height: json['height'] as String,
      weight: json['weight'] as String,
      position: json['position'] as String,
      image: json['image'] as String,
    );
  }
}
