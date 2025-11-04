import 'dart:io' show Directory;


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skillhub/student/registration.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skillhub/student/viewfeedback.dart';

class View_projects extends StatefulWidget {
  const View_projects({super.key});

  @override
  State<View_projects> createState() => _View_projectsState();
}

class _View_projectsState extends State<View_projects> {
  List<dynamic> projects = [];

  Future<void> get_project(context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? loginid = prefs.getInt('login_id');

      final response = await dio.get('$baseurl/Project_API/$loginid');
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        setState(() {
          projects = response.data;
        });
        // print(prid);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Project fetched successfully')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('failed')));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> openPdf(String fileUrl, String fileName) async {
    try {
      // Get temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String fullPath = '${tempDir.path}/$fileName';

      // Download file using Dio
      await dio.download(fileUrl, fullPath);

      // Open the file with default PDF viewer
      await OpenFile.open(fullPath);
    } catch (e) {
      print('Error opening PDF: $e');
    }
  }

  Future<void> dlt_project(prid, context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? loginid = prefs.getInt('login_id');

      final response = await dio.delete('$baseurl/Project_API/$prid');
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        get_project(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project tremoved successfully')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('failed')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_project(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(212, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                'View Your Projects',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final pr = projects[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        child: ListTile(
                          leading: IconButton(
                            onPressed: () {
                              String fileUrl =
                                  '$baseurl${pr['File']}'; // full URL to your PDF
                              String fileName = pr['File'].split('/').last;
                              openPdf(fileUrl, fileName);
                            },
                            icon: Icon(Icons.picture_as_pdf_outlined),
                          ),

                          title: Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10,
                            ),
                            child: Text(
                              pr['Project'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 120, child: Text('Date:')),
                                  Expanded(child: Text(pr['Date'])),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text('department:'),
                                  ),
                                  Expanded(child: Text(pr['Dpt'])),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text('description:'),
                                  ),
                                  Expanded(
                                    child: Text(
                                      pr['Description'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 8,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(width: 120, child: Text('Status:')),
                                  Expanded(
                                    child: Text(
                                      pr['Status'],
                                      style: TextStyle(
                                        color: pr['Status'] == 'accept'
                                            ? Colors.green
                                            : pr['Status'] == 'reject'
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Show Feedback button only if project status is 'accept'
                                  if (pr['Status'] == 'accept')
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: TextButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  View_feedback(
                                                    projectId: pr['id'],
                                                  ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.feedback),
                                        label: Text('Feedback'),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          iconColor: Colors.white,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ),

                                  // Remove button
                                  TextButton.icon(
                                    onPressed: () {
                                      dlt_project(pr['id'], context);
                                    },
                                    icon: Icon(Icons.delete_forever),
                                    label: Text('Remove'),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      iconColor: Colors.white,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
