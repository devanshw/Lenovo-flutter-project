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

  Future<void> deleteIncident(String incidentId) async {
    try {
      final apiUrl = 'http://10.0.2.2:3000/api/incidentdel/$incidentId';

      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Refresh incident list after deletion
        fetchIncidents();
      } else {
        print('Failed to delete incident: ${response.statusCode}');
        // Optionally show an error message to the user
      }
    } catch (error) {
      print('Error deleting incident: $error');
    }
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60.0),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Active Incidents',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: incidents.isNotEmpty
                  ? ListView.builder(
                      itemCount: incidents.length,
                      itemBuilder: (context, index) {
                        final incident = incidents[index];
                        return Card(
                          color: Colors.white.withOpacity(0.8),
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: ListTile(
                            title: Text('Caller: ${incident['Caller']}'),
                            subtitle: Text('Category: ${incident['Category']}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Show confirmation dialog before deleting
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Delete'),
                                      content: Text(
                                          'Are you sure you want to delete this incident?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            deleteIncident(incident['_id']);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            onTap: () {
                              _showIncidentDetails(incident);
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: incidents.isEmpty
                          ? Text(
                              'No incidents found',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          : CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
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
              Text('Incident ID: ${incident['_id']}'),
              Text('Created By: ${incident['CreatedBy']}'),
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