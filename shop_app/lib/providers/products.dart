import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/models/http_exeption.dart';
import 'package:shopapp/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> getProducts() {
    var url = 'https://flutter-udemy-42.firebaseio.com/products.json?auth=$authToken';

    List<Product> tempProducts = [];
    return http.get(url).then((response) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, prodData) {
        tempProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
        ));
      });
    }).then((response) {
      url = 'https://flutter-udemy-42.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      return http.get(url).then((response) {
        final favoriteResponse = json.decode(response.body);
        tempProducts.forEach((element) {
          if (favoriteResponse == null || favoriteResponse[element.id] == null) {
            element.toggleFavoriteStatus(authToken, userId);
          } else {
            element.isFavorite = favoriteResponse[element.id];
          }
        });
        _items = tempProducts;
        notifyListeners();
      });
    });
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://flutter-udemy-42.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );
      final _newProduct = Product(
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          id: json.decode(response.body)['name']);
      _items.add(_newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) {
    final index = _items.indexWhere((element) => element.id == id);
    final url = 'https://flutter-udemy-42.firebaseio.com/products/$id.json?auth=$authToken';

    if (index == -1) return null;
    return http
        .patch(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }),
    )
        .then((value) {
      _items[index] = product;
      notifyListeners();
    });
  }

  Future<void> deleteProduct(String id) {
    final url = 'https://flutter-udemy-42.firebaseio.com/products/$id.json&authi=$authToken';
    final _productIndex = _items.indexWhere((element) => element.id == id);
    final _product = _items[_productIndex];

    return http.delete(url).then((response) {
      _items.removeAt(_productIndex);
      if (response.statusCode >= 400) {
        _items.insert(_productIndex, _product);
        notifyListeners();
        throw HttpException('Could not delete product.').toString();
      }
      notifyListeners();
    }).catchError((err) {
      throw err;
    });
  }
}
