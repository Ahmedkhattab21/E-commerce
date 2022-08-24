import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/Material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValur(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteState(String token, String userId) async {
    final oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shop-e72d8-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';

    try {
      final res = await http.put(Uri.parse(url), body: json.encode(isFavorite));
      if (res.statusCode >= 400) {
        _setFavValur(oldFavorite);
      }
    } catch (e) {
      _setFavValur(oldFavorite);
    }
  }
}
