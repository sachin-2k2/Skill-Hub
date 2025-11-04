// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillhub/student/add%20&%20manage%20project.dart';
import 'package:skillhub/student/chat%20ai.dart';
import 'package:skillhub/student/edit%20profile.dart';
import 'package:skillhub/student/login.dart';
import 'package:skillhub/student/send%20complaint.dart';
import 'package:skillhub/student/view%20companies.dart';
import 'package:skillhub/student/view%20projects.dart';
import 'package:skillhub/student/view%20request.dart';
import 'package:skillhub/student/viewfeedback.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  void logout(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure want to Logout?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
            ),
          ),
          TextButton(
            onPressed: () {
              log_out_splash(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> log_out_splash(context) async {
    SharedPreferences logout = await SharedPreferences.getInstance();
    await logout.setBool('logged', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => stdnt_login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/icon.png', width: 90, height: 90),
                  SizedBox(width: 5),
                  Column(
                    children: [
                      Text(
                        'SKILL HUB',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        'ShowCase.Conect.Innovate',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(188, 6, 6, 6),
                        offset: Offset(4, 4),
                        blurRadius: 10,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 241, 164, 98),
                        const Color.fromARGB(255, 209, 70, 105),
                        const Color.fromARGB(255, 149, 65, 218),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          top: 20,
                          bottom: 5,
                        ),
                        child: Text(
                          'Welcome back!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          'Hi alex,Redy to Innovate ? ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.bar_chart,
                              size: 30,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  SizedBox(width: 23),
                  Text(
                    'Your Projects',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  SizedBox(width: 90),
                  Text(
                    'Insight',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => addmanageproject(),
                        ),
                      );
                    },
                    child: Container(
                      height: 130,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.lightBlue, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(173, 0, 0, 0),
                            blurRadius: 8,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/icon.png',
                              width:
                                  60, // 👈 adjust this value to control image size
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Add & Manage \n      Projects',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 130,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(173, 0, 0, 0),
                          blurRadius: 8,
                          blurStyle: BlurStyle.outer,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.lightBlue, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => View_projects(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                          ),
                          child: Text(
                            'View Feedback',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // SizedBox(height: 8,),
                        Divider(color: Colors.lightBlue),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Complaint(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                          ),
                          child: Text(
                            'Send Complaint',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 40),
                child: Row(
                  children: [
                    Text(
                      'Discover',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(width: 250),
                    Icon(Icons.arrow_forward_outlined),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 23,
                    top: 8,
                    bottom: 8,
                    right: 8,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => View_companies(),
                            ),
                          );
                        },
                        child: Container(
                          height: 130,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(173, 0, 0, 0),
                                blurRadius: 8,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.lightBlue,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.business_outlined,
                                    size: 40,
                                    color: Colors.lightBlue,
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    'View Companies',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 25),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => View_requests(),
                            ),
                          );
                        },
                        child: Container(
                          height: 130,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(173, 0, 0, 0),
                                blurRadius: 8,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.lightBlue,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.hourglass_empty_outlined,
                                    size: 40,
                                    color: Colors.lightBlue,
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    'View Requests',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 23),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditP_profile(),
                            ),
                          );
                        },
                        child: Container(
                          height: 130,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(173, 0, 0, 0),
                                blurRadius: 8,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.lightBlue,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.edit_note_sharp,
                                    size: 40,
                                    color: Colors.lightBlue,
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 23),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage()),
                          );
                        },
                        child: Container(
                          height: 130,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(173, 0, 0, 0),
                                blurRadius: 8,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.lightBlue,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/chatboat.jpg',
                                      width: 60,
                                      height: 60,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Chat With AI',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Material(
                shape: const CircleBorder(),
                shadowColor: Colors.black,
                elevation: 8,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {
                      logout(context);
                    },
                    icon: Icon(
                      Icons.logout_rounded,
                      color: Colors.lightBlue,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Text('Logout', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
