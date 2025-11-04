import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillhub/student/home.dart';

import 'package:dio/dio.dart';
import 'package:skillhub/student/registration.dart';

class stdnt_login extends StatefulWidget {
  const stdnt_login({super.key});

  @override
  State<stdnt_login> createState() => _stdnt_loginState();
}

int? loginid;

class _stdnt_loginState extends State<stdnt_login> {
  bool obsecuretext = true;
  TextEditingController usr = TextEditingController();
  TextEditingController pass = TextEditingController();
  final formkey = GlobalKey<FormState>();

  Future<void> login_splash(context) async {
    SharedPreferences log_in = await SharedPreferences.getInstance();
    await log_in.setBool('logged', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homepage()),
    );
  }

  Dio dio = Dio();

  Future<void> post_login(context) async {
    try {
      final response = await dio.post(
        '$baseurl/LoginAPI',
        data: {'Username': usr.text, 'Password': pass.text},
      );
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        loginid = response.data['login_id'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('login_id', loginid!);
        print(loginid);
        login_splash(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('login succesfull')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('registration failed')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(210, 255, 255, 255),
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80),
              Center(
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 150,
                  height: 150,
                ),
              ),
              Text(
                'SKILL HUB',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text('ShowCase.Conect.Innovate', style: TextStyle(fontSize: 13)),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: usr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your email';
                    } else if (!value.contains('@') ||
                        !value.endsWith('@gmail.com')) {
                      return 'Enter a valid Gmail address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: Text(
                      'Username',
                      style: TextStyle(
                        color: const Color.fromARGB(117, 0, 0, 0),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlue),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: pass,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  obscureText: obsecuretext,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecuretext = !obsecuretext;
                        });
                      },
                      icon: Icon(
                        obsecuretext
                            ? Icons.visibility_off_rounded
                            : Icons.visibility,
                      ),
                    ),
                    label: Text(
                      'Password',
                      style: TextStyle(
                        color: const Color.fromARGB(117, 0, 0, 0),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlue),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
              InkWell(
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    post_login(context);
                  }
                },
                child: Container(
                  height: 60,
                  width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [
                        const Color.fromARGB(255, 97, 191, 235),
                        Colors.white,
                        const Color.fromARGB(255, 97, 191, 235),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dont Have You Account?",
                    style: TextStyle(color: const Color.fromARGB(255, 8, 8, 8)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => stdnt_reg()),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 56, 185, 221),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
