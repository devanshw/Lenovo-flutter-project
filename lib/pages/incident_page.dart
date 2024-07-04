import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/components/createIncidentButton.dart';
import 'package:login_auth/components/myTextField.dart';
import 'package:login_auth/pages/loggedin.dart';

class IncidentPage extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final TextEditingController callerController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController incidentCreationChannelController =
      TextEditingController();
  final TextEditingController impactController = TextEditingController();
  final TextEditingController urgencyController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController workNotesController = TextEditingController();

  final String apiUrl = 'http://10.0.2.2:3000/api/newincident';

  Future<void> createIncident(
    BuildContext context,
    String caller,
    String category,
    String subCategory,
    String service,
    String incidentCreationChannel,
    String impact,
    String urgency,
    String description,
    String workNotes,
  ) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'Caller': caller,
          'Category': category,
          'SubCategory': subCategory,
          'Service': service,
          'IncidentCreationChannel': incidentCreationChannel,
          'Impact': impact,
          'Urgency': urgency,
          'Description': description,
          'WorkNotes': workNotes,
        },
      );

      if (response.statusCode == 201) {
        // Handle successful incident creation
        print("Incident created successfully");

        // Clear text fields
        callerController.clear();
        categoryController.clear();
        subCategoryController.clear();
        serviceController.clear();
        incidentCreationChannelController.clear();
        impactController.clear();
        urgencyController.clear();
        descriptionController.clear();
        workNotesController.clear();

        // Navigate to Loggedin screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loggedin()),
        );

      } else {
        print('Error: ${response.statusCode}');
        String errorMessage = 'Incident creation failed!';
        if (response.statusCode == 400) {
          errorMessage = 'Invalid entries'; // Example error handling based on status code
        } else {
          errorMessage = 'Error ${response.statusCode}: ${response.body}';
        }
        scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(Icons.work, size: 100),
                const SizedBox(height: 50),
                Text(
                  "Create New Incident",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 94, 92, 92),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                Mytextfield(
                  controller: callerController,
                  hintText: "Caller (Enter your Username)",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: categoryController,
                  hintText: "Category",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: subCategoryController,
                  hintText: "Sub Category",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: serviceController,
                  hintText: "Service",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: incidentCreationChannelController,
                  hintText: "Incident Creation Channel",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: impactController,
                  hintText: "Impact",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: urgencyController,
                  hintText: "Urgency",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: descriptionController,
                  hintText: "Description",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Mytextfield(
                  controller: workNotesController,
                  hintText: "Work Notes",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                Createincidentbutton(
                  onTap: () {
                    createIncident(
                      context,
                      callerController.text.trim(),
                      categoryController.text.trim(),
                      subCategoryController.text.trim(),
                      serviceController.text.trim(),
                      incidentCreationChannelController.text.trim(),
                      impactController.text.trim(),
                      urgencyController.text.trim(),
                      descriptionController.text.trim(),
                      workNotesController.text.trim(),
                    );
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
}
