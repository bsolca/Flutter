import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getOrders() {
    final url = 'https://flutter-udemy-42.firebaseio.com/orders.json?auth=$authToken';

    return http.get(url).then((response) {
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                ),
              )
              .toList(),
        ));
        _orders = loadedOrders.reversed.toList();
        notifyListeners();
      });
    }).catchError((err) {
      throw err;
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) {
    final url = 'https://flutter-udemy-42.firebaseio.com/orders.json?auth=$authToken';
    final timestamp = DateTime.now();

    return http
        .post(url,
            body: json.encode({
              'amount': total,
              'dateTime': timestamp.toIso8601String(),
              'products': cartProducts
                  .map((e) => {
                        'id': e.id,
                        'price': e.price,
                        'quantity': e.quantity,
                        'title': e.title,
                      })
                  .toList()
            }))
        .then((response) {
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    });
  }
}
