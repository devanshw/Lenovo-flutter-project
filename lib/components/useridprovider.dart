import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserID with ChangeNotifier {
  String _id = '';

  String get id => _id;

  void setUserID(String newID) {
    _id = newID;
    notifyListeners(); // Notify listeners of the change
  }
}

final userIDProvider = ChangeNotifierProvider<UserID>(
  create: (context) => UserID(), // Function to create an instance of UserID
);

