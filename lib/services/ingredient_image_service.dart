import 'dart:convert';
import 'package:http/http.dart' as http;

class IngredientImageService {
  static const String _apiKey = '49822851-7b6a80d088eda3ca9ab996031';

  static Future<String?> fetchImageUrl(String ingredientName) async {
    final url = Uri.parse(
      'https://pixabay.com/api/?key=$_apiKey&q=${Uri.encodeComponent(ingredientName)}&image_type=photo&category=food&per_page=3',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['hits'] != null && data['hits'].isNotEmpty) {
        return data['hits'][0]['webformatURL'] as String;
      }
    }
    return null; // No image found
  }
}
