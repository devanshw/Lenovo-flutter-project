// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names, unused_import

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/components/myTextField.dart';
import 'package:login_auth/components/mybutton.dart';
import 'package:login_auth/components/registerButton.dart';
import 'package:login_auth/components/signupbutton.dart';
import 'package:login_auth/pages/loggedin.dart';
import 'package:login_auth/pages/login_page.dart'; 

class SignupPage extends StatelessWidget {
   SignupPage({super.key});
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController AgeController = TextEditingController();
  final TextEditingController JobtitleController= TextEditingController();
  final TextEditingController CompanynameController = TextEditingController();

  final String apiUrl = 'http://10.0.2.2:3000/api/newuser';



Future<void> signUpUser(BuildContext context, String username, String password, String firstname, String lastname,  String Age, String Jobtitle, String companyName) async {
  try {
    print('Username: $username, Password: $password'); // For debugging

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      body: {'username': username, 'password': password, 'firstName': firstname, 'lastName': lastname, "Age": Age, 'JobTitle': Jobtitle, 'companyName': companyName},
    );

    if (response.statusCode == 201) {
      // Handle successful signup
      print("Signed up successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loggedin()), 
      );
    } else {
      print('Error: ${response.statusCode}');
      String errorMessage = 'Sign up failed!';
      if (response.statusCode == 400) {
        errorMessage = 'Invalid username or password format.'; // Example error handling based on status code
      } else {
        errorMessage = 'Error ${response.statusCode}: ${response.body}';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  } catch (error) {
    print('Error: $error');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: $error')));
  }
}

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
                  "Register New User",
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
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                Mytextfield(
                  controller: lastnameController,
                  hintText: "Last Name",
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                Mytextfield(
                  controller: AgeController,
                  hintText: "Age",
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                Mytextfield(
                  controller: JobtitleController,
                  hintText: "Job Title",
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                Mytextfield(
                  controller: CompanynameController,
                  hintText: "Company Name",
                  obscureText: true,
                ),
                const SizedBox(height: 15),








                Signupbutton(onTap: (){
                  signUpUser(
                  context,
                      usernameController.text.trim(),
                      passwordController.text.trim(),
                      firstnameController.text.trim(),
                      lastnameController.text.trim(),
                      AgeController.text.trim(),
                      JobtitleController.text.trim(),
                      CompanynameController.text.trim() ,

                  );
                }),
                const SizedBox(height: 15),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//firstname, lastname, Jobtitle, age, companyName