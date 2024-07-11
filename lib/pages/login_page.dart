// ignore_for_file: use_build_context_synchronously, unused_local_variable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/components/myTextField.dart';
import 'package:login_auth/components/mybutton.dart';
import 'package:login_auth/components/registerButton.dart';
import 'package:login_auth/pages/loggedin.dart';
import 'package:login_auth/pages/signup_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String apiUrl = 'http://10.0.2.2:3000/api/login';

  Future<void> signUserIn(
      BuildContext context, String username, String password) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(response.body);

        // Check for "login successful" message
        if (data['message'] == 'Login successful') {
          print('Login successful! User: ${data['user']['username'] ?? ''}');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Loggedin()),
          );
        } else {
          // Handle other login messages (e.g., "Invalid credentials")
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Login failed')),
          );
        }
      } else {
        // Handle other status codes (e.g., network errors)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'An error occurred (status code: ${response.statusCode})')),
        );
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/0/03/Lenovo_Global_Corporate_Logo.png', // Replace with your image URL
                    height: 100,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Incident Management System",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
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
                  const SizedBox(height: 50),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal:
                                  0.0), // Adjusted horizontal padding to 0.0
                          child: Mybutton(
                            onTap: () {
                              signUserIn(
                                context,
                                usernameController.text.trim(),
                                passwordController.text.trim(),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal:
                                  0.0), // Adjusted horizontal padding to 0.0
                          child: RegisterButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
