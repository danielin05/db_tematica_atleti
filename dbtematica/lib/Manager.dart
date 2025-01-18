class Manager {
  final String name;
  final String years;
  final String style;
  final int trophies;
  final String image;

  Manager(
    {
      required this.name,
      required this.years,
      required this.style,
      required this.trophies,
      required this.image,
    });

  String get getName => name;
  String get getYears => years;
  String get getStyle => style;
  int get getTrophies => trophies;
  String get getImage => image;

  factory Manager.fromJson(Map<String, dynamic> json){
    return Manager(
      name: json['name'] as String, 
      years: json['years'] as String, 
      style: json['style'] as String, 
      trophies: json['trophies'] as int, 
      image: json['image'] as String);
  }
}