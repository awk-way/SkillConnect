import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> serviceCategories = [
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Cleaning',
    'Painting',
    'Gardening',
    'AC Repair',
    'Moving',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SkillConnect'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.blue[700],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Your Location',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Mumbai, Maharashtra',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for services...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),

            // Service Categories
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Service Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),

            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemCount: serviceCategories.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Card(
                      elevation: 3,
                      child: InkWell(
                        onTap: () {
                          // Navigate to workers in this category
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.build,
                              size: 40,
                              color: Colors.blue[700],
                            ),
                            SizedBox(height: 8),
                            Text(
                              serviceCategories[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30),

            // Quick Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Quick Actions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 3,
                      child: InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, '/job-posting'),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.add_circle,
                                size: 50,
                                color: Colors.green,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Post a Job',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      elevation: 3,
                      child: InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, '/job-tracking'),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.track_changes,
                                size: 50,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Track Jobs',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
