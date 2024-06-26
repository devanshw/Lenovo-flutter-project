import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/pages/Updatedetails_page.dart';
import 'package:login_auth/pages/login_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});
  final String apiUrl = 'http://10.0.2.2:3000/api/getuserdetails'; // Replace with your actual API URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            if (user == null) {
              // Handle case where user is not found
              return const Center(child: Text('User not found'));
            }
            return _buildUserDetails(context, user); // Pass context to _buildUserDetails
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Display a loading indicator while fetching user details
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context, Map<String, dynamic> user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDetailText('Hey ${user['username']}', Colors.blue, 24.0), // Username
          const SizedBox(height: 10.0), // Spacing between lines
          _buildDetailText('First Name: ${user['firstName']}', Colors.teal, 16.0),
          const SizedBox(height: 5.0),
          _buildDetailText('Last Name: ${user['lastName']}', Colors.teal, 16.0),
          const SizedBox(height: 5.0),
          _buildDetailText('Age: ${user['Age']}', Colors.teal, 16.0),
          const SizedBox(height: 5.0),
          _buildDetailText('Job Title: ${user['JobTitle']}', Colors.teal, 16.0),
          const SizedBox(height: 5.0),
          _buildDetailText('Company Name: ${user['companyName']}', Colors.teal, 16.0),
          ElevatedButton(
            onPressed: () async {
              await _logout(context); // Pass context to _logout
            },
            child: const Text('Logout'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _update(context); // Pass context to _logout
            },
            child: const Text('Upadate User Details'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username'); // Remove username from local storage
   Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), 
      ); // Redirect to home page
  }
   Future<void> _update(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
   Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Updatedetails() ), 
      );
  }

  Future<String> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    return savedUsername ?? '';
  }

  Future<Map<String, dynamic>?> _getUserDetails() async {
    final username = await _getUsername();
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'username': username},
      );
      print("for api call");
      print(username);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        print('Error fetching user details: ${response.statusCode}');
        return null; // Indicate error
      }
    } catch (error) {
      print('Error fetching user details: $error');
      return null; // Indicate error
    }
  }

  Widget _buildDetailText(String text, Color color, double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2), // Semi-transparent background
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
        ),
      ),
    );
  }
}
