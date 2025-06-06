import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cat_model.dart';

const String _apiKey = String.fromEnvironment('CAT_API_KEY');

Future<Cat> fetchCatWithBreed() async {
  if (_apiKey.isEmpty) {
    throw Exception(
      'CAT_API_KEY не передан. Используйте --dart-define при запуске.',
    );
  }

  final response = await http.get(
    Uri.parse(
      'https://api.thecatapi.com/v1/images/search?limit=10&has_breeds=1',
    ),
    headers: {'x-api-key': _apiKey},
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    if (data.isNotEmpty &&
        data[0]['breeds'] != null &&
        (data[0]['breeds'] as List).isNotEmpty &&
        data[0]['breeds'][0]['name'] != null) {
      return Cat.fromJson(data[0]);
    } else {
      // Повторяем запрос, пока не найдём кота с породой
      return fetchCatWithBreed();
    }
  } else {
    throw Exception('Failed to load cat image');
  }
}