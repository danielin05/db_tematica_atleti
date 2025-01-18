class Trophy {
  final String name;
  final String description;
  final int amount;
  final List<int> years;
  final String type;
  final String image;

  Trophy({
    required this.name,
    required this.description,
    required this.amount,
    required this.years,
    required this.type,
    required this.image,
  });

  String get getName => name;
  String get getDescription => description;
  int get getAmount => amount;
  List<int> get getYears => years;
  String get getType => type;
  String get getImage => image;

  factory Trophy.fromJson(Map<String, dynamic> json) {
    return Trophy(
      name: json['name'] as String,
      description: json['description'] as String,
      amount: json['amount'] as int,
      years: List<int>.from(json['years'] as List),
      type: json['type'] as String,
      image: json['image'] as String,
    );
  }
}
