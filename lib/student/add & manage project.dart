import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillhub/student/registration.dart';
import 'dart:ui' as ui;

import 'package:skillhub/student/view%20projects.dart';

class addmanageproject extends StatefulWidget {
  const addmanageproject({super.key});

  @override
  State<addmanageproject> createState() => _addmanageprojectState();
}

File? selectedPdf;
String? pdfName;


class _addmanageprojectState extends State<addmanageproject> {
  final formkey = GlobalKey<FormState>();
  TextEditingController pname = TextEditingController();
  TextEditingController pdesc = TextEditingController();

  void clearAllFields() {
    setState(() {
      pname.clear();
      pdesc.clear();
      selectedPdf = null;
      pdfName = null;
    });
  }

  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedPdf = File(result.files.single.path!);
        pdfName = result.files.single.name;
      });
    }
  }

  Future<void> post_project(context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? loginid = prefs.getInt('login_id');

      final formData = FormData.fromMap({
        'Project': pname.text,
        'Description': pdesc.text,
        'File': await MultipartFile.fromFile(
          selectedPdf!.path,
          filename: selectedPdf!.path.split('/').last,
        ),
      });

      final response = await dio.post(
        '$baseurl/Project_API/$loginid',
        data: formData,
      );
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
       
       
        clearAllFields();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Project Added successfully')));
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(212, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Add & Manage Projects',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'Add New Project',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 👇 Custom dashed border container
                    Center(
                      child: GestureDetector(
                        onTap: pickPdf, // ✅ call the separate function here
                        child: CustomPaint(
                          painter: DashedRectPainter(
                            color: Colors.lightBlue,
                            strokeWidth: 2,
                            gap: 5,
                            dashWidth: 8,
                            radius: 10,
                          ),
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(189, 255, 255, 255),
                            ),
                            alignment: Alignment.center,
                            child: pdfName == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.add,
                                        color: Colors.lightBlue,
                                        size: 30,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Add Project',
                                        style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.redAccent,
                                        size: 30,
                                      ),
                                      Text(
                                        pdfName!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: pname,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your project name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'Project Name',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: pdesc,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your project description';
                          }
                          return null;
                        },
                        maxLines: 3,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'Project Description',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            post_project(context);
                          }
                        },
                        child: Container(
                          height: 50,
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
                          child: Center(
                            child: Text(
                              'Upload Project',
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
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => View_projects(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
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
                          child: Center(
                            child: Text(
                              'View Projects',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 🎨 Custom painter for dashed rectangle
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double gap;
  final double radius;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 2,
    this.dashWidth = 5,
    this.gap = 3,
    this.radius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final dashPath = _createDashedPath(path);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source) {
    final Path dest = Path();
    for (final ui.PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dest.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + gap;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
