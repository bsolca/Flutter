import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

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
    const url = 'https://flutter-udemy-42.firebaseio.com/products.json';
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
      _items = tempProducts;
      notifyListeners();
    });
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-udemy-42.firebaseio.com/products.json';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
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
    debugPrint('TestyStart\t[1]:\n$id\nTestyEnd\t[1]\n');
    final url = 'https://flutter-udemy-42.firebaseio.com/products/$id.json';

    if (index == -1) return null;
    return http.patch(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }),
    ).then((value) {
      _items[index] = product;
      notifyListeners();
    });
  }

  void deleteProduct(String id) {
    final url = 'https://flutter-udemy-42.firebaseio.com/products/$id.json';
    final _productIndex = _items.indexWhere((element) => element.id == id);
    final _product = _items[_productIndex];
    _items.removeAt(_productIndex);
    http.delete(url).catchError((_) {
      _items.insert(_productIndex, _product);
    });
    notifyListeners();
  }
}
