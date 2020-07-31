import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exeption.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryTokenDate;
  String _userId;

  Future<void> _authenticate(String email, String password, String segment) {
    const apiKey = String.fromEnvironment('WEB_API_KEY');
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=$apiKey';
    return http
        .post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    )
        .then((value) {
      final responseData = json.decode(value.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    }).catchError((err) => throw err);
  }

  Future<void> signUp(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
