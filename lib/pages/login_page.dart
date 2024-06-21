// ignore_for_file: use_build_context_synchronously, unused_local_variable

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
        //final userId = data['_id'];
       // await saveUserId(userId);
       
        

        // Check for "login successful" message
        if (data['message'] == 'Login successful') {
          // Perform additional validation based on your requirements
          // (e.g., check presence of specific user data in response)
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

/*

  Future<void> saveUserId(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
}

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}
*/
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
                  "Welcome back you've been missed!",
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
                const SizedBox(height: 50),
                Mybutton(
                  onTap: () {
                    signUserIn(
                      context,
                      usernameController.text.trim(),
                      passwordController.text.trim(),
                    );
                  },
                ),
                const SizedBox(height: 15),
                
                RegisterButton(onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
