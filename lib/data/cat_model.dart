class Cat {
  final String imageUrl;
  final String breedName;
  final String breedDescription;

  Cat({
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    final breeds = json['breeds'] as List<dynamic>? ?? [];
    final imageUrl = json['url']?.toString() ?? '';

    if (imageUrl.isEmpty) {
      throw FormatException('Invalid image URL');
    }

    return Cat(
      imageUrl: imageUrl,
      breedName: breeds.isNotEmpty ? breeds[0]['name'] ?? 'Unknown' : 'Unknown',
      breedDescription: breeds.isNotEmpty ? breeds[0]['description'] ?? '' : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'breedName': breedName,
      'breedDescription': breedDescription,
    };
  }

  factory Cat.fromSavedJson(Map<String, dynamic> json) {
    return Cat(
      imageUrl: json['imageUrl'],
      breedName: json['breedName'],
      breedDescription: json['breedDescription'],
    );
  }
}

class LikedCat {
  final Cat cat;
  final DateTime likedAt;

  LikedCat({required this.cat, required this.likedAt});

  String get imageUrl => cat.imageUrl;
  String get breedName => cat.breedName;
  String get breedDescription => cat.breedDescription;

  Map<String, dynamic> toJson() {
    return {'cat': cat.toJson(), 'likedAt': likedAt.toIso8601String()};
  }

  factory LikedCat.fromJson(Map<String, dynamic> json) {
    return LikedCat(
      cat: Cat.fromSavedJson(json['cat']),
      likedAt: DateTime.parse(json['likedAt']),
    );
  }
}
