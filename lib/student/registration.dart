import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skillhub/student/login.dart';

// 🌍 Base URL for your backend
final baseurl = 'http://192.168.1.48:8000';
Dio dio = Dio();

// 🌍 Global dynamic department list
List<String> departments = [];

class stdnt_reg extends StatefulWidget {
  const stdnt_reg({super.key});

  @override
  State<stdnt_reg> createState() => _stdnt_regState();
}

class _stdnt_regState extends State<stdnt_reg> {
  bool obsecuretext = true;
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phon = TextEditingController();
  TextEditingController Age = TextEditingController();
  TextEditingController dept = TextEditingController();
  TextEditingController address = TextEditingController();
  String? gender = '';
  final formkey = GlobalKey<FormState>();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  int? depid;

  // 📸 Pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 🌐 Fetch departments dynamically from API
  Future<void> fetchDepartments() async {
    try {
      final response = await dio.get('$baseurl/Department_API');
      if (response.statusCode == 200) {
        final List data = response.data;
        depid = response.data[0]['id'];
        print(response.data);

        setState(() {
          // Extract only department names
          departments = data
              .map((item) => item['Department'].toString())
              .toList();
        });
        print(depid);

        print("✅ Departments fetched: $departments");
      } else {
        print('⚠️ Failed to fetch departments: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching departments: $e');
    }
  }

  // 🧾 Post registration
  Future<void> post_reg(context) async {
    try {
      final formData = FormData.fromMap({
        'DEPARTMENTID': depid,
        'Name': name.text,
        'Username': email.text,
        'Email': email.text,
        'phone': phon.text,
        'Age': Age.text,
        'Address': address.text,
        'Gender': gender,
        'Password': pass.text,
        'Department': dept.text,
        'Img': await MultipartFile.fromFile(
          _image!.path,
          filename: _image!.path.split('/').last,
        ),
      });

      final response = await dio.post(
        '$baseurl/Student_API',
        data: formData, // ✅ use FormData, not a normal map
      );

      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => stdnt_login()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Registration failed')));
      }
    } catch (e) {
      print("❌ Registration error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDepartments(); // 🔄 Fetch departments on page load
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
              const SizedBox(height: 80),
              Center(
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 150,
                  height: 150,
                ),
              ),
              const Text(
                'SKILL HUB',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const Text(
                'ShowCase.Connect.Innovate',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 20),
              const Text(
                'CREATE YOUR ACCOUNT',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),

              // 🧍 Name Field
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your name';
                    }
                    return null;
                  },
                  decoration: _inputDecoration('Name'),
                ),
              ),

              // ✉️ Email Field
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your email';
                    } else if (!value.contains('@') ||
                        !value.endsWith('@gmail.com')) {
                      return 'Enter a valid Gmail address';
                    }
                    return null;
                  },
                  decoration: _inputDecoration('Email'),
                ),
              ),

              // 📞 Phone
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: phon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your phone number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Phone No'),
                ),
              ),

              // 🏠 Address
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: address,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your address';
                    }
                    return null;
                  },
                  decoration: _inputDecoration('Address'),
                ),
              ),

              // 🎂 Age
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: Age,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your age';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Age'),
                ),
              ),

              // 🏫 Department Dropdown (Dynamic)
              // 🏫 Department Dropdown (Dynamic)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: DropdownButtonFormField<String>(
                  value: dept.text.isNotEmpty ? dept.text : null,
                  decoration: _inputDecoration('Department'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your department';
                    }
                    return null;
                  },
                  // Show dropdown even if empty — avoids showing CircularProgressIndicator
                  items: departments.isEmpty
                      ? []
                      : departments
                            .map(
                              (dept) => DropdownMenuItem<String>(
                                value: dept,
                                child: Text(dept),
                              ),
                            )
                            .toList(),
                  onChanged: (value) {
                    setState(() {
                      dept.text = value ?? '';
                    });
                  },
                ),
              ),

              // 🚻 Gender Selection
              Row(
                children: [
                  Checkbox(
                    value: gender == 'Male',
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        gender = value! ? 'Male' : '';
                      });
                    },
                  ),
                  const Text('Male'),
                  Checkbox(
                    value: gender == 'Female',
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        gender = value! ? 'Female' : '';
                      });
                    },
                  ),
                  const Text('Female'),
                  Checkbox(
                    value: gender == 'Others',
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        gender = value! ? 'Others' : '';
                      });
                    },
                  ),
                  const Text('Others'),
                ],
              ),

              // 🔒 Password
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
                  decoration: _inputDecoration('Password').copyWith(
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
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // 🔘 Register Button + Image Upload
              Row(
                children: [
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      if (formkey.currentState!.validate()) {
                        if (gender == null || gender!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select your gender'),
                            ),
                          );
                        } else {
                          post_reg(context);
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      width: 200,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [
                            Color.fromARGB(255, 97, 191, 235),
                            Colors.white,
                            Color.fromARGB(255, 97, 191, 235),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          'REGISTER',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 70),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      children: [
                        const Text('Upload photo'),
                        InkWell(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey.shade400,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : null,
                            child: _image == null
                                ? const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 30,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ✨ Helper function for consistent input decoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      label: Text(
        label,
        style: const TextStyle(color: Color.fromARGB(117, 0, 0, 0)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.lightBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.lightBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.lightBlue),
      ),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
