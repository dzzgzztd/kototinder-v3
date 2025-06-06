import 'package:flutter/material.dart';
import 'cat_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatCard extends StatelessWidget {
  final String imageUrl;
  final String breedName;
  final String breedDescription;
  final void Function()? onLike;
  final void Function()? onDislike;
  final bool swipeEnabled;
  final bool interactionDisabled;

  const CatCard({
    super.key,
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
    required this.onLike,
    required this.onDislike,
    this.swipeEnabled = true,
    required this.interactionDisabled,
  });

  @override
  Widget build(BuildContext context) {
    final image = Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        return SizedBox(
          width: screenWidth,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, size: 40),
          ),
        );
      },
    );

    return Column(
      children: [
        Text(
          breedName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        swipeEnabled
            ? Dismissible(
                key: ValueKey(imageUrl),
                direction: DismissDirection.horizontal,
                // Блокировка свайпов при отсутствии интернета
                confirmDismiss: (direction) async {
                  return !interactionDisabled;
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    onLike?.call();
                  } else {
                    onDislike?.call();
                  }
                },
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.thumb_up, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.thumb_down, color: Colors.white),
                ),
                child: _buildGesture(context, image),
              )
            : _buildGesture(context, image),
      ],
    );
  }

  Widget _buildGesture(BuildContext context, Widget child) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CatDetailsScreen(
              imageUrl: imageUrl,
              breedName: breedName,
              breedDescription: breedDescription,
            ),
          ),
        );
      },
      child: child,
    );
  }
}