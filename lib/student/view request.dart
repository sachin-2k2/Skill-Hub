import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillhub/student/registration.dart';

class View_requests extends StatefulWidget {
  const View_requests({super.key});

  @override
  State<View_requests> createState() => _View_requestsState();
}

class _View_requestsState extends State<View_requests> {
  List<dynamic> projectss = [];

  // ✅ Fetch data
  Future<void> get_conference(context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? loginid = prefs.getInt('login_id');

      final response = await dio.get('$baseurl/Conference_API/$loginid');
      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          projectss = response.data;
        });
        print('Details fetched successfully');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to fetch data')));
      }
    } catch (e) {
      print(e);
    }
  }

  // ✅ Accept request
  Future<void> status_accept(BuildContext context, String reqid) async {
    try {
      final response = await dio.get('$baseurl/Acceptreq_Api/$reqid');
      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Accepted successfully');

        // Update local list
        setState(() {
          final index = projectss.indexWhere((e) => e['id'].toString() == reqid);
          if (index != -1) projectss[index]['status'] = 'Accepted';
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to accept')));
      }
    } catch (e) {
      print(e);
    }
  }

  // ✅ Reject request
  Future<void> status_reject(BuildContext context, String reqid) async {
    try {
      final response = await dio.get('$baseurl/Rejectreq_Api/$reqid');
      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Rejected successfully');

        // Update local list
        setState(() {
          final index = projectss.indexWhere((e) => e['id'].toString() == reqid);
          if (index != -1) projectss[index]['status'] = 'Rejected';
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to reject')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    get_conference(context);
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
              const SizedBox(height: 40),
              const Text(
                'View Requests',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: projectss.length,
                  itemBuilder: (context, index) {
                    final prr = projectss[index];
                    final status = prr['status']?.toString() ?? '';

                    // ✅ Determine color based on status
                    Color statusColor;
                    if (status.toLowerCase() == 'accepted') {
                      statusColor = Colors.green;
                    } else if (status.toLowerCase() == 'rejected') {
                      statusColor = Colors.red;
                    } else {
                      statusColor = Colors.orange; // Pending
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.business,
                                  color: Colors.lightBlue,
                                ),
                                title: Text(
                                  prr['Title'] ?? 'null',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(prr['companyname'] ?? 'null'),
                                    const SizedBox(height: 8),
                                    Text(prr['Location'] ?? 'null'),
                                    const SizedBox(height: 8),
                                    Text(prr['Date'] ?? 'null'),
                                    const SizedBox(height: 8),

                                    // ✅ Status text
                                    Text(
                                      status.isEmpty ? 'Pending' : status,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    RatingBarIndicator(
                                      rating: 2.5,
                                      itemBuilder: (context, index) =>
                                          const Icon(Icons.star,
                                              color: Colors.amber),
                                      itemCount: 5,
                                      itemSize: 19,
                                      itemPadding:
                                          const EdgeInsets.only(right: 4),
                                      direction: Axis.horizontal,
                                    ),
                                    const SizedBox(height: 8),

                                    // ✅ Show buttons only if status is Pending or Empty
                                    if (status.isEmpty ||
                                        status.toLowerCase() == 'pending')
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              status_accept(context,
                                                  prr['id'].toString());
                                            },
                                            child: const Text(
                                              'Accept',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              status_reject(context,
                                                  prr['id'].toString());
                                            },
                                            child: const Text(
                                              'Reject',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
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
