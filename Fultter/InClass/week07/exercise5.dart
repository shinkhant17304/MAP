import 'package:flutter/material.dart';

void main() {
  runApp(const CookingRecipesApp());
}

class CookingRecipesApp extends StatelessWidget {
  const CookingRecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cooking Recipes',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF6750A4),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Papaya Salad',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.deepPurple.shade200,
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Lorem ipsum dolor sit amet consectetur adipisicing elit. Soluta ducimus in modi illo ad ipsa non officiis. Ea placeat necessitatibus in aliquid ullam quasi porro vel dolores, dignissimos quisquam aspernatur.',
                        style: TextStyle(fontSize: 13, height: 1.3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500',
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 130,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.restaurant,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            Icon(Icons.star, color: Colors.black87, size: 20),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '3128 reviews',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInfoColumn(Icons.av_timer, 'PREP:', '5 mins'),
                            _buildInfoColumn(Icons.timer_outlined, 'COOK:', '10 mins'),
                            _buildInfoColumn(Icons.restaurant, 'FEEDS:', '1-3'),
                          ],
                        ),
                      ],
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

  static Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 22, color: Colors.black87),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}