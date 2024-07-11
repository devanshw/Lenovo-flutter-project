import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/pages/login_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});
  final String apiUrl = 'http://10.0.2.2:3000/api/getuserdetails'; // Replace with your actual API URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(232, 95, 6, 43),
              Color.fromARGB(255, 194, 17, 17),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data!;
              if (user == null) {
                return const Center(child: Text('User not found'));
              }
              return _buildUserDetails(context, user);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context, Map<String, dynamic> user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50.0), // Adjust spacing if needed
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            child: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 70.0), // Adjust spacing if needed
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user['profileImageUrl'] ?? 'https://cdn-icons-png.freepik.com/512/3404/3404932.png'),
          ),
          const SizedBox(height: 10.0),
          Text(
            '${user['firstName']} ${user['lastName']}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            user['JobTitle'],
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20.0),
          _buildDetailText('Username: ${user['username']}', Colors.teal, 16.0),
          _buildDetailText('First Name: ${user['firstName']}', Colors.teal, 16.0),
          _buildDetailText('Last Name: ${user['lastName']}', Colors.teal, 16.0),
          _buildDetailText('Age: ${user['Age']}', Colors.teal, 16.0),
          _buildDetailText('Job Title: ${user['JobTitle']}', Colors.teal, 16.0),
          _buildDetailText('Company Name: ${user['companyName']}', Colors.teal, 16.0),
          const SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: () async {
              await _logout(context);
            },
            child: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.black, // Text color
              minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 50), // Button size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded edges
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
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
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Widget _buildDetailText(String text, Color color, double fontSize) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
      child: Text(
        text,
       style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}
