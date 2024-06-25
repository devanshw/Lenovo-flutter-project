// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:login_auth/components/myTextField.dart';
import 'package:login_auth/components/signupbutton.dart';

class Updatedetails extends StatelessWidget {
   Updatedetails({super.key});
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController AgeController = TextEditingController();
  final TextEditingController JobtitleController= TextEditingController();
  final TextEditingController CompanynameController = TextEditingController();

  final String apiUrl = 'http://10.0.2.2:3000/api/newuser';

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
  
  void signUpUser(BuildContext context, String trim, String trim2, String trim3, String trim4, String trim5, String trim6, String trim7) {}
}