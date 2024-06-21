import 'dart:convert';
import 'dart:async';
import 'package:faceapp/model/model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'https://dummyjson.com/products/10';

  static Future<List<String>> uploadImage(String imagePath) async {
    try {
      // Make a GET request to the dummy API
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final ImageModel imageModel = ImageModel.fromJson(json.decode(response.body));

        // Extract image URL from the responsea
        final imageUrl = imageModel.imageUrls;

        return imageUrl;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print('Error fetching image: $e');
      throw Exception('Failed to load image');
    }
  }
}