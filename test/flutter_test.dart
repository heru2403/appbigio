import 'package:flutter_test/flutter_test.dart';
import 'package:appbigio/Character.dart';
import 'package:appbigio/favorite_model.dart';

void main() {
  group('Character Class', () {
    test('Character fromJson should parse JSON correctly', () {
      final json = {
        'id': 1,
        'name': 'Armothy',
        'species': 'unknown',
        'gender': 'Male',
        'origin': {'name': 'Post-Apocalyptic Earth'},
        'location': {'name': 'Post-Apocalyptic Earth'},
        'image': 'https://example.com/armothy.png',
      };

      final character = Character.fromJson(json);

      expect(character.id, 1);
      expect(character.name, 'Armothy');
      expect(character.species, 'unknown');
      expect(character.gender, 'Male');
      expect(character.origin, 'Post-Apocalyptic Earth');
      expect(character.location, 'Post-Apocalyptic Earth');
      expect(character.image, 'https://example.com/armothy.png');
    });

    test('Character should have all required properties', () {
      final character = Character(
        id: 1,
        name: 'Armothy',
        species: 'unknown',
        gender: 'Male',
        origin: 'Post-Apocalyptic Earth',
        location: 'Post-Apocalyptic Earth',
        image: 'https://example.com/armothy.png',
      );

      expect(character.id, isA<int>());
      expect(character.name, isA<String>());
      expect(character.species, isA<String>());
      expect(character.gender, isA<String>());
      expect(character.origin, isA<String>());
      expect(character.location, isA<String>());
      expect(character.image, isA<String>());
    });
  });

  group('FavoriteCharacter Class', () {
    test('FavoriteCharacter toMap should convert properties to a map', () {
      final favoriteCharacter = FavoriteCharacter(
        id: 1,
        name: 'Armothy',
        species: 'unknown',
        gender: 'Male',
        origin: 'Post-Apocalyptic Earth',
        location: 'Post-Apocalyptic Earth',
        image: 'https://example.com/armothy.png',
      );

      final map = favoriteCharacter.toMap();

      expect(map['id'], 1);
      expect(map['name'], 'Armothy');
      expect(map['species'], 'unknown');
      expect(map['gender'], 'Male');
      expect(map['origin'], 'Post-Apocalyptic Earth');
      expect(map['location'], 'Post-Apocalyptic Earth');
      expect(map['image'], 'https://example.com/armothy.png');
    });
  });
}
