// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
            return Stack( // Use Stack widget for positioning
              children: [
                // Username at the top (replace with your desired position)
                Positioned(
                  top: 20.0, // Adjust top padding as needed
                  left: 20.0, // Adjust left padding as needed
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_circle, // Replace with your desired icon
                        size: 60.0, // Adjust icon size as needed
                        color: Color.fromARGB(255, 0, 0, 0), // Adjust icon color as needed
                      ),
                      const SizedBox(width: 10.0), // Spacing between icon and text
                      _buildDetailText(
                        'Hey ${user['username']}',
                        Colors.black, // Adjust text color as needed
                      60.0, // Increased font size for username
                      ),
                    ],
                  ),
                ),
                // Rest of the user details centered
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50.0), // Spacing after username
                      _buildDetailText('First Name: ${user['firstName']}', Colors.teal, 16.0),
                      const SizedBox(height: 5.0),
                      _buildDetailText('Last Name: ${user['lastName']}', Colors.teal, 16.0),
                      const SizedBox(height: 5.0),
                      _buildDetailText('Age: ${user['Age']}', Colors.teal, 16.0),
                      const SizedBox(height: 5.0),
                      _buildDetailText('Job Title: ${user['JobTitle']}', Colors.teal, 16.0),
                      const SizedBox(height: 5.0),
                      _buildDetailText('Company Name: ${user['companyName']}', Colors.teal, 16.0),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Display a loading indicator while fetching user details
          return const Center(child: CircularProgressIndicator());
        },
      ),
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
      print (username  );
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



  
  Widget _buildUserDetails(Map<String, dynamic> user) {
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
      ],
    ),
  );
}

// Reusable function to create styled text with rounded borders
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
