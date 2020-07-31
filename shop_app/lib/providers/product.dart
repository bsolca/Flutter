import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exeption.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token) {
    final url = 'https://flutter-udemy-42.firebaseio.com/products/$id.json?auth=$token';

    return http
        .patch(url,
            body: json.encode({
              'isFavorite': !isFavorite,
            }))
        .then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('Could not toggle favorite.');
      }
      isFavorite = !isFavorite;
      notifyListeners();
    }).catchError((err) {
      throw err;
    });
  }
}
