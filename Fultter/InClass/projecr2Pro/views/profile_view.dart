import 'package:flutter/material.dart';

import 'learner_store.dart';

class BusuuProfileView extends StatelessWidget {
  const BusuuProfileView({super.key, required this.profile});

  final LearnerProfile profile;

  @override
  Widget build(BuildContext context) {
    final initials = profile.fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // User Header
            CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF0056C6),
              child: Text(
                initials.isEmpty ? '?' : initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              profile.fullName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(profile.email, style: const TextStyle(color: Colors.grey)),
            Text(
              'Learning French ${profile.level}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Main Stat Cards Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.local_fire_department,
                    iconColor: const Color(0xFFFF8D00),
                    title: '7 Days',
                    subtitle: 'Current Streak',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.auto_stories,
                    iconColor: const Color(0xFF0056C6),
                    title: '142 Words',
                    subtitle: 'Mastered',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.speed,
                    iconColor: const Color(0xFF00C853),
                    title: '88%',
                    subtitle: 'Accuracy',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.workspace_premium,
                    iconColor: Colors.purple,
                    title: 'French ${profile.level}',
                    subtitle: 'Current Level',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Achievement Badges Section
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Achievements',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBadge(Icons.bolt, '7-Day Club', Colors.amber),
                    _buildBadge(
                      Icons.military_tech,
                      'Word Master',
                      Colors.blue,
                    ),
                    _buildBadge(Icons.stars, 'Fast Learner', Colors.orange),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
