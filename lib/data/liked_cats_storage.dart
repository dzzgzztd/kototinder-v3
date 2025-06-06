import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'cat_model.dart';

class LikedCatsStorage {
  static const _likedKey = 'liked_cats';
  static const _dislikedKey = 'disliked_cats';
  static const _likeCounterKey = 'like_counter';

  Future<void> saveLikeCounter(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_likeCounterKey, count);
  }

  Future<int> loadLikeCounter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_likeCounterKey) ?? 0;
  }

  Future<void> saveLikedCats(List<String> jsonList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_likedKey, jsonList);
    await prefs.reload();
  }

  Future<List<LikedCat>> loadLikedCats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_likedKey) ?? [];
    return jsonList.map((str) => LikedCat.fromJson(jsonDecode(str))).toList();
  }

  Future<void> saveDislikedCats(List<String> dislikedCatIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_dislikedKey, dislikedCatIds);
  }

  Future<List<String>> loadDislikedCats() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_dislikedKey) ?? [];
  }
}