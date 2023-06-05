import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token = null;
  // this token expires at some point of time usually 1 hr in firebase
  late DateTime expiryDate;
  late String userId;

// isauth is a function to check that if the user has logged in recently and doesn't neeeded to be lgged in again
  bool get isAuth {
    // print("test");
    // if we have a token and the token didn't expired then the user can be authenticated
    print(_token);
    return token != null;
  }

  String? get token {
    print("test");
    if (_token != null && expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userid {
    return userId;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAv-uixmCUD2Y4LGZKKa2BduaYJa3881Tc");

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        // print(responseData["error"]["message"]);
        // print("test");
        throw HttpException(message: responseData["error"]["message"]);
      }
      _token = responseData['idToken'];
      userId = responseData['localId'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    var url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAv-uixmCUD2Y4LGZKKa2BduaYJa3881Tc");
    // print(url);
//         email	string	The email for the user to create.
// password	string	The password for the user to create.
// returnSecureToken	boolean	Whether or not to return an ID and refresh token. Should always be true.
    await authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    var url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAv-uixmCUD2Y4LGZKKa2BduaYJa3881Tc");
    await authenticate(email, password, "signInWithPassword");
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
