class SimpleRecipe {
  String id;
  String dishImage;
  String title;
  String duration;
  String source;
  List<String> information;

  SimpleRecipe({
    required this.id,
    required this.dishImage,
    required this.title,
    required this.duration,
    required this.source,
    required this.information,
  });

  factory SimpleRecipe.fromJson(Map<String, dynamic> json) {
    return SimpleRecipe(
      id: json['id'] ?? '',
      dishImage: json['dishImage'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      source: json['source'] ?? '',
      information: json['information'].cast<String>() as List<String>,
    );
  }
}
