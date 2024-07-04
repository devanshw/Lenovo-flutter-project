// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/components/myTextField.dart';
import 'package:login_auth/components/updatebutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Updatedetails extends StatelessWidget {
  Updatedetails({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();

  final String apiUrl = 'http://10.0.2.2:3000/api'; // Base API URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(Icons.lock, size: 100),
                const SizedBox(height: 50),
                Text(
                  "Update User Details",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 94, 92, 92),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                Mytextfield(
                  controller: usernameController,
                  hintText: "Username",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: firstnameController,
                  hintText: "First Name",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: lastnameController,
                  hintText: "Last Name",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: ageController,
                  hintText: "Age",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: jobTitleController,
                  hintText: "Job Title",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: companyNameController,
                  hintText: "Company Name",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Updatebutton(
                  onTap: () async {
                    String username = usernameController.text.trim();
                    String password = passwordController.text.trim();
                    String firstName = firstnameController.text.trim();
                    String lastName = lastnameController.text.trim();
                    String age = ageController.text.trim();
                    String jobTitle = jobTitleController.text.trim();
                    String companyName = companyNameController.text.trim();

                    String userId = await _fetchUserId(username);
                    if (userId.isNotEmpty) {
                      await _updateUserDetails(
                        userId,
                        username,
                        password,
                        firstName,
                        lastName,
                        age,
                        jobTitle,
                        companyName,
                      );
                    } else {
                      // Handle case where username is not found
                      print('Username not found or error occurred.');
                    }
                  },
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _fetchUserId(String savedUsername) async {
    try {
      

      String getUrl = 'http://10.0.2.2:3000/api/getUserIdByUsername';
      var response = await http.post(
        Uri.parse(getUrl),
        body: {'username': savedUsername},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String userId = data['id']; 
        return userId;
      } else {
        throw Exception('Failed to load user ID');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<void> _updateUserDetails(
    String userId,
    String username,
    String password,
    String firstName,
    String lastName,
    String age,
    String jobTitle,
    String companyName,
  ) async {
    try {
      String putUrl = 'http://10.0.2.2:3000/api/updateuser/$userId';
      var response = await http.put(
        Uri.parse(putUrl),
        body: {
          'username': username,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'age': age,
          'jobTitle': jobTitle,
          'companyName': companyName,
        },
      );

      if (response.statusCode == 200) {
        print('User details updated successfully');
      } else {
        throw Exception('Failed to update user details');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
   Future<String> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    return savedUsername ?? '';
  }

}
