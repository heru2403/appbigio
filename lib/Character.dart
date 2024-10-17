class Character {
  final int id;
  final String name;
  final String species;
  final String gender;
  final String origin;
  final String location;
  final String image;

  Character({
    required this.id,
    required this.name,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      gender: json['gender'],
      origin: json['origin']['name'],
      location: json['location']['name'],
      image: json['image'],
    );
  }
}
