import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  late Future<String?> _userId; // Declare a Future for the user ID

  @override
  void initState() {
    super.initState();
    _userId = getUserId(); // Fetch user ID on widget initialization
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<String?>(
        future: _userId,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userId = snapshot.data!;
            return Text('Profile Page for User ID: $userId'); // Use the user ID
          } else if (snapshot.hasError) {
            print(snapshot.error); // Handle errors
            return Text('Error retrieving user ID');
          }
          return CircularProgressIndicator(); // Show loading indicator
        },
      ),
    );
  }
}
