import 'package:flutter/material.dart';
import 'DetailPage.dart';
import 'Character.dart';
import 'database_helper.dart';
import 'favorite_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Character> _characters = [];
  Set<int> _favoriteCharacterIds = {};
  final dbHelper = DatabaseHelper();
  String? _nextPageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCharacters();
    _loadFavoriteIds();
  }

  Future<void> fetchCharacters() async {
    if (_isLoading || _nextPageUrl == 'end') return;

    setState(() {
      _isLoading = true;
    });

    // Tentukan URL untuk mengambil data, mulai dari URL API pertama atau halaman berikutnya
    final url = _nextPageUrl ?? 'https://rickandmortyapi.com/api/character';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Character> newCharacters = [];
      for (var character in data['results']) {
        newCharacters.add(Character.fromJson(character));
      }

      setState(() {
        _characters
            .addAll(newCharacters); // Tambahkan data baru ke daftar karakter
        _nextPageUrl = data['info']['next']; // Dapatkan URL halaman berikutnya
        _nextPageUrl ??= 'end';
      });
    } else {
      throw Exception('Failed to load characters');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadFavoriteIds() async {
    final favorites = await dbHelper.getFavorites();
    setState(() {
      _favoriteCharacterIds = favorites.map((fav) => fav.id).toSet();
    });
  }

  void _toggleFavorite(Character character) {
    if (_favoriteCharacterIds.contains(character.id)) {
      dbHelper.deleteFavorite(character.id);
      _favoriteCharacterIds.remove(character.id);
    } else {
      dbHelper.insertFavorite(FavoriteCharacter(
        id: character.id,
        name: character.name,
        species: character.species,
        gender: character.gender,
        origin: character.origin,
        location: character.location,
        image: character.image,
      ));
      _favoriteCharacterIds.add(character.id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Characters'),
        backgroundColor: const Color.fromARGB(255, 24, 195, 230),
      ),
      body: _characters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  fetchCharacters(); // Memuat data tambahan saat mendekati akhir scroll
                }
                return false;
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: _characters.length,
                  itemBuilder: (context, index) {
                    var character = _characters[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade200],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(character: character),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Column(
                            children: [
                              Hero(
                                tag: character.id,
                                child: Image.network(
                                  character.image,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      character.name,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      character.species,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      character.gender,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey[400],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            _favoriteCharacterIds
                                                    .contains(character.id)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: _favoriteCharacterIds
                                                    .contains(character.id)
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () =>
                                              _toggleFavorite(character),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailPage(
                                                        character: character),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            'View Details',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
