import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillhub/student/registration.dart';

class View_companies extends StatefulWidget {
  const View_companies({super.key});

  @override
  State<View_companies> createState() => _View_companiesState();
}

class _View_companiesState extends State<View_companies> {
  List<dynamic> companies = [];

  Future<void> get_companies(context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? loginid = prefs.getInt('login_id');

      final response = await dio.get('$baseurl/Company_API');
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        setState(() {
          companies = response.data;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('companiesF fetched successfully')),
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
    get_companies(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 255, 255, 255),
      body: Column(
        children: [
          SizedBox(height: 60),
          Text(
            'View Companies',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final cmp = companies[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 8,
                    shadowColor: Color.fromARGB(255, 36, 120, 159),
                    child: ListTile(
                      title: Text(
                        cmp['ComapanyName'],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Column(
                        children: [
                          SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Icon(Icons.email, size: 15),
                                Text(cmp['Email']),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 15),
                              Text(cmp['Phone'].toString()),
                            ],
                          ),
                          SizedBox(height: 8),
                          RatingBarIndicator(
                            rating: 3.5, // your rating value
                            itemBuilder: (context, index) =>
                                Icon(Icons.star, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 19,
                            itemPadding: EdgeInsets.all(4),
                            direction: Axis.horizontal,
                          ),

                          SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [Text(cmp['Address'])]),
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
    );
  }
}
