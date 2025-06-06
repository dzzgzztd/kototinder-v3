import 'package:flutter/material.dart';

// Кнопки лайка и дизлайка (и счетчик)
class CatActionButtons extends StatelessWidget {
  final int likeCount;
  final void Function()? onLike;
  final void Function()? onDislike;

  const CatActionButtons({
    super.key,
    required this.likeCount,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.thumb_down), onPressed: onDislike),
          Text('Likes: $likeCount', style: const TextStyle(fontSize: 18)),
          IconButton(icon: const Icon(Icons.thumb_up), onPressed: onLike),
        ],
      ),
    );
  }
}
