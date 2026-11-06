import 'package:flutter/material.dart';

void main() {
  runApp(const TouristPlaceApp());
}

class TouristPlaceApp extends StatelessWidget {
  const TouristPlaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tourist Place',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1F5F8B),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header Image using provided URL
              Image.network(
                'https://thumb.wikimedia.org/wikipedia/commons/thumb/7/75/%E0%B8%AB%E0%B8%AD%E0%B8%99%E0%B8%B2%E0%B8%AC%E0%B8%B4%E0%B8%81%E0%B8%B2%E0%B9%80%E0%B8%8A%E0%B8%B5%E0%B8%A2%E0%B8%87%E0%B8%A3%E0%B8%B2%E0%B8%A2_Chiang_Rai_Clock_Tower.jpg/250px-%E0%B8%AB%E0%B8%AD%E0%B8%99%E0%B8%B2%E0%B8%AC%E0%B8%B4%E0%B8%81%E0%B8%B2%E0%B9%80%E0%B8%8A%E0%B8%B5%E0%B8%A2%E0%B8%87%E0%B8%A3%E0%B8%B2%E0%B8%A2_Chiang_Rai_Clock_Tower.jpg?utm_source=en.wikipedia.org&utm_campaign=index&utm_content=thumbnail',
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 240,
                    color: Colors.blueGrey,
                    child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.white),
                    ),
                  );
                },
              ),

              // Title Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Chiang Rai Clock Tower',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Chiang Rai, Thailand',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.red,
                      size: 24,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '559',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              // Action Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButtonColumn(const Color(0xFF29B6F6), Icons.call, 'CALL'),
                  _buildButtonColumn(const Color(0xFF29B6F6), Icons.near_me, 'ROUTE'),
                  _buildButtonColumn(const Color(0xFF29B6F6), Icons.share, 'SHARE'),
                ],
              ),

              // Description Section
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}