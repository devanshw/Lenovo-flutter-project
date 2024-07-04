import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class IncidentList extends StatefulWidget {
  const IncidentList({Key? key}) : super(key: key);

  @override
  _IncidentListState createState() => _IncidentListState();
}

class _IncidentListState extends State<IncidentList> {
  late List<dynamic> incidents = []; // Initialize incidents as an empty list

  @override
  void initState() {
    super.initState();
    fetchIncidents();
  }

  Future<void> fetchIncidents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? '';

      final apiUrl = 'http://10.0.2.2:3000/api/incidents/$username';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          incidents = jsonData;
        });
      } else {
        print('Failed to load incidents: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching incidents: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incident List'),
      ),
      body: incidents.isNotEmpty
          ? ListView.builder(
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final incident = incidents[index];
                return ListTile(
                  title: Text('Caller: ${incident['Caller']}'),
                  subtitle: Text('Category: ${incident['Category']}'),
                  onTap: () {
                    _showIncidentDetails(incident);
                  },
                );
              },
            )
          : Center(
              child: incidents.isEmpty
                  ? Text('No incidents found')
                  : CircularProgressIndicator(),
            ),
    );
  }

  void _showIncidentDetails(Map<String, dynamic> incident) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incident Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Caller: ${incident['Caller']}'),
              Text('Category: ${incident['Category']}'),
              Text('SubCategory: ${incident['SubCategory']}'),
              Text('Service: ${incident['Service']}'),
              Text('Description: ${incident['Description']}'),
              Text('WorkNotes: ${incident['WorkNotes']}'),
              // Add more fields as needed
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: IncidentList(),
  ));
}
