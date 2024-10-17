import 'package:flutter/material.dart';
import 'Character.dart';
import 'database_helper.dart';
import 'favorite_model.dart';

class DetailPage extends StatelessWidget {
  final Character character;
  final dbHelper = DatabaseHelper();
  DetailPage({super.key, required this.character});

  Future<void> _addToFavorites(BuildContext context) async {
    FavoriteCharacter favoriteCharacter = FavoriteCharacter(
      id: character.id,
      name: character.name,
      species: character.species,
      gender: character.gender,
      origin: character.origin,
      location: character.location,
      image: character.image,
    );

    await dbHelper.insertFavorite(favoriteCharacter);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${character.name} added to favorites!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => _addToFavorites(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    character.image,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                character.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDescriptionSection(
                title: 'Species',
                value: character.species,
              ),
              _buildDescriptionSection(
                title: 'Gender',
                value: character.gender,
              ),
              _buildDescriptionSection(
                title: 'Origin',
                value: character.origin,
              ),
              _buildDescriptionSection(
                title: 'Location',
                value: character.location,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(
      {required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
