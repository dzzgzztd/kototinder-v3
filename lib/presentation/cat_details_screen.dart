import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Страница с детальной информацией о котике
class CatDetailsScreen extends StatelessWidget {
  final String imageUrl;
  final String breedName;
  final String breedDescription;

  const CatDetailsScreen({
    super.key,
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(breedName)),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder:
                (context, url) =>
                    const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(breedDescription),
          ),
        ],
      ),
    );
  }
}
