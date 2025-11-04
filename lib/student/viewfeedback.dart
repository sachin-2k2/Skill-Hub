import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillhub/student/registration.dart';
import 'package:skillhub/student/view%20projects.dart';

class View_feedback extends StatefulWidget {
  final int projectId;
  const View_feedback({super.key, required this.projectId});

  @override
  State<View_feedback> createState() => _View_feedbackState();
}

class _View_feedbackState extends State<View_feedback> {
  List<dynamic> projectsss = [];

  Future<void> get_feed(context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? loginid = prefs.getInt('login_id');

      final response = await dio.get(
        '$baseurl/Projectfeed_API/${widget.projectId}',
      );
      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          projectsss = response.data;
        });
        print('Details fetched successfully');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to fetch data')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_feed(context);
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
                'View Your Projects Feedback',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: projectsss.length,
                  itemBuilder: (context, index) {
                    final pr = projectsss[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        child: ListTile(
                          leading: Icon(
                            Icons.picture_as_pdf_outlined,
                            color: Colors.lightBlue,
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10,
                            ),
                            child: Text(
                              pr['project_name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text('Description:'),
                                  ),
                                  Expanded(child: Text(pr['description'])),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(width: 120, child: Text('Date:')),
                                  Expanded(
                                    child: Text(
                                      pr['Date'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 8,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text('Feedback:'),
                                  ),
                                  Expanded(
                                    child: Text(
                                      pr['Feedback'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 8,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(width: 120, child: Text('Mark:')),
                                  Expanded(
                                    child: Text(pr['mark']['Mark'].toString()),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(width: 120, child: Text('Rating:')),
                                  Expanded(
                                    child: RatingBarIndicator(
                                      rating:
                                          pr['rat']['Rating'], // your rating value
                                      itemBuilder: (context, index) =>
                                          Icon(Icons.star, color: Colors.amber),
                                      itemCount: 5,
                                      itemSize: 19,
                                      itemPadding: EdgeInsets.all(4),
                                      direction: Axis.horizontal,
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
