import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillhub/student/registration.dart';

class Complaint extends StatefulWidget {
  const Complaint({super.key});

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  TextEditingController comp = TextEditingController();
  final formkey = GlobalKey<FormState>();

  List<dynamic> replayList = []; // ✅ Always treat as list

  Future<void> post_com(context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? loginid = prefs.getInt('login_id');

      final response = await dio.post(
        '$baseurl/Complaint_Api/$loginid',
        data: {'Complaint': comp.text},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complaint submitted successfully')),
        );
        comp.clear();
        // Refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit complaint')),
        );
      }
    } catch (e) {
      print("Error in post_com: $e");
    }
  }

  Future<void> get_replay(context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? loginid = prefs.getInt('login_id');

      final response = await dio.get('$baseurl/Complaint_Api/$loginid');
      print("Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          // ✅ Handle both list or single object
          if (response.data is List) {
            replayList = response.data;
          } else if (response.data is Map) {
            replayList = [response.data];
          } else {
            replayList = [];
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch complaint')),
        );
      }
    } catch (e) {
      print("Error fetching replay: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    get_replay(context);       
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(203, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    'Send Complaint',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Complaint input
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: comp,
                      maxLines: 8,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        label: const Text(
                          'Please describe your complaint or issue here...',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Send button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          post_com(context);
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(188, 6, 6, 6),
                              offset: Offset(4, 4),
                              blurRadius: 10,
                            ),
                          ],
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 241, 164, 98),
                              Color.fromARGB(255, 209, 70, 105),
                              Color.fromARGB(255, 149, 65, 218),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Send Complaint',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(right: 280.0, top: 30),
                    child: Text(
                      'Reply:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  // Display complaints list
                  replayList.isEmpty
                      ? const Center(child: Text("No complaints yet"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: replayList.length,
                          itemBuilder: (context, index) {
                            final item = replayList[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Complaint: ${item['Complaint'] ?? 'N/A'}",
                                    ),
                                    const SizedBox(height: 6),
                                    Text("Date: ${item['Date'] ?? 'Unknown'}"),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Reply: ${item['Reply'] ?? 'No reply yet'}",
                                      style: TextStyle(
                                        color: item['Reply'] == null
                                            ? Colors.grey
                                            : Colors.green[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
