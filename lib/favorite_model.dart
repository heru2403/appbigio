import 'Character.dart';

class FavoriteCharacter {
  final int id;
  final String name;
  final String species;
  final String gender;
  final String origin;
  final String location;
  final String image;

  FavoriteCharacter({
    required this.id,
    required this.name,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'gender': gender,
      'origin': origin,
      'location': location,
      'image': image,
    };
  }

  Character toCharacter() {
    return Character(
      id: id,
      name: name,
      species: species,
      gender: gender,
      origin: origin,
      location: location,
      image: image,
    );
  }
}
