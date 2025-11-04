import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:skillhub/student/registration.dart'; // Your baseurl

class EditP_profile extends StatefulWidget {
  const EditP_profile({super.key});

  @override
  State<EditP_profile> createState() => _EditP_profileState();
}

class _EditP_profileState extends State<EditP_profile> {
  bool readonly = true;

  // Controllers
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController ph_no = TextEditingController();
  TextEditingController dept = TextEditingController();

  File? _image; // Locally picked image
  ImageProvider? profileImage; // Either network or local
  final ImagePicker _picker = ImagePicker();

  List<dynamic> profile = [];

  final Dio dio = Dio(); // Dio instance

  // Pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        profileImage = FileImage(_image!);
      });
    }
  }

  // Fetch profile data
  Future<void> get_profile(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? loginid = prefs.getInt('login_id');

      final response = await dio.get('$baseurl/Profiles_Api/$loginid');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        setState(() {
          profile = response.data;
          name.text = profile[0]['Name'];
          email.text = profile[0]['Email'];
          ph_no.text = profile[0]['phone'].toString();
          age.text = profile[0]['Age'].toString();
          dept.text = profile[0]['dpt'] ?? '';

          String imgPath = profile[0]['Img'] ?? '';
          if (imgPath.isNotEmpty) {
            profileImage = NetworkImage('$baseurl$imgPath');
          }
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to fetch data')));
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  // Post updated profile
  Future<void> post_edit() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? loginid = prefs.getInt('login_id');

      // Build formData
      final Map<String, dynamic> data = {
        'Name': name.text,
        'Username': email.text,
        'Email': email.text,
        'phone': ph_no.text,
        'Age': age.text,
        'Department': dept.text,
      };

      // Only add image if user picked a new one
      if (_image != null) {
        data['Img'] = await MultipartFile.fromFile(
          _image!.path,
          filename: _image!.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(data);

      final response = await dio.put(
        '$baseurl/Profiles_Api/$loginid', // Include login id in endpoint if needed
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        setState(() {
          readonly = true; // switch back to read-only mode
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      print("❌ Profile update error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error updating profile')));
    }
  }

  @override
  void initState() {
    super.initState();
    get_profile(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Edit Profile',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 30),

                // CircleAvatar
                InkWell(
                  onTap: readonly ? null : _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: const Color.fromARGB(105, 158, 158, 158),
                      backgroundImage: profileImage,
                      child: profileImage == null
                          ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Color.fromARGB(255, 95, 95, 95),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                _buildTextField(controller: name, readOnly: readonly),
                _buildTextField(controller: email, readOnly: true),
                _buildTextField(controller: ph_no, readOnly: readonly),
                _buildTextField(controller: age, readOnly: readonly),
                _buildTextField(controller: dept, readOnly:true),

                const SizedBox(height: 20),
                // Edit / Save button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: InkWell(
                    onTap: () {
                      if (readonly) {
                        setState(() {
                          readonly = false;
                        });
                      } else {
                        post_edit(); // Save changes
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
                      child: Center(
                        child: Text(
                          readonly ? 'Edit Profile' : 'Save Changes',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required bool readOnly,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
