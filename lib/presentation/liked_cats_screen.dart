import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/liked_cats_provider.dart';
import 'cat_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LikedCatsScreen extends StatefulWidget {
  const LikedCatsScreen({super.key});

  @override
  State<LikedCatsScreen> createState() => _LikedCatsScreenState();
}

class _LikedCatsScreenState extends State<LikedCatsScreen> {
  String? _selectedBreed;

  @override
  Widget build(BuildContext context) {
    final likedCatsNotifier = context.watch<LikedCatsNotifier>();
    final breeds = likedCatsNotifier.getBreeds();

    final cats =
        _selectedBreed == null
            ? likedCatsNotifier.likedCats
            : likedCatsNotifier.filterByBreed(_selectedBreed!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Cats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (breeds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: _selectedBreed,
                hint: const Text('Фильтр по породе'),
                onChanged: (value) {
                  setState(() {
                    _selectedBreed = value;
                  });
                },
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Все породы'),
                  ),
                  ...breeds.map(
                    (breed) =>
                        DropdownMenuItem(value: breed, child: Text(breed)),
                  ),
                ],
              ),
            ),
          Expanded(
            child:
                cats.isEmpty
                    ? const Center(child: Text('Пока нет лайкнутых котов'))
                    : ListView.builder(
                      itemCount: cats.length,
                      itemBuilder: (context, index) {
                        final cat = cats[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => CatDetailsScreen(
                                      imageUrl: cat.imageUrl,
                                      breedName: cat.breedName,
                                      breedDescription: cat.breedDescription,
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: cat.imageUrl,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                              title: Text(cat.breedName),
                              subtitle: Text(
                                'Лайкнут: ${cat.likedAt.toLocal().toString().split('.').first}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context.read<LikedCatsNotifier>().removeCat(
                                    cat.imageUrl,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
