import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../data/cat_model.dart';
import '../data/liked_cats_storage.dart';

class LikedCatsNotifier extends ChangeNotifier {
  final LikedCatsStorage _storage;
  final List<LikedCat> _likedCats = [];

  LikedCatsNotifier(this._storage);

  Future<void> load() async {
    final loaded = await _storage.loadLikedCats();
    _likedCats.addAll(loaded);
    notifyListeners();
  }

  List<LikedCat> get likedCats => List.unmodifiable(_likedCats);

  void likeCat(Cat cat) {
    if (!_likedCats.any((c) => c.imageUrl == cat.imageUrl)) {
      _likedCats.add(LikedCat(cat: cat, likedAt: DateTime.now()));
      _saveToStorage();
      notifyListeners();
    }
  }

  void removeCat(String imageUrl) {
    _likedCats.removeWhere((c) => c.imageUrl == imageUrl);
    _saveToStorage();
    notifyListeners();
  }

  void clear() {
    _likedCats.clear();
    _saveToStorage();
    notifyListeners();
  }

  List<LikedCat> filterByBreed(String breed) {
    return _likedCats.where((cat) => cat.breedName == breed).toList();
  }

  List<String> getBreeds() {
    return _likedCats.map((cat) => cat.breedName).toSet().toList();
  }

  Future<void> _saveToStorage() async {
    final jsonList = _likedCats.map((cat) => jsonEncode(cat.toJson())).toList();
    await _storage.saveLikedCats(jsonList);
  }
}
