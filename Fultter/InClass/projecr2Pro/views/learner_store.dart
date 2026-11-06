import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LearnerProfile {
  const LearnerProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.joinedAt,
    this.phone = '',
    this.level = 'A1',
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String level;
  final String joinedAt;

  LearnerProfile copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? level,
  }) {
    return LearnerProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      level: level ?? this.level,
      joinedAt: joinedAt,
    );
  }

  Map<String, Object> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'level': level,
    'joinedAt': joinedAt,
  };

  factory LearnerProfile.fromJson(Map<String, dynamic> json) {
    return LearnerProfile(
      id: json['id'] as String,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      level: json['level'] as String? ?? 'A1',
      joinedAt: json['joinedAt'] as String? ?? '',
    );
  }
}

class LearnerStore {
  LearnerStore._();

  static final LearnerStore instance = LearnerStore._();
  static const _storageKey = 'busuu_learner_profiles';

  Future<List<LearnerProfile>> getAll() async {
    final preferences = await SharedPreferences.getInstance();
    final json = preferences.getString(_storageKey);
    if (json == null || json.isEmpty) return [];

    final profiles = jsonDecode(json) as List<dynamic>;
    return profiles
        .map(
          (profile) => LearnerProfile.fromJson(profile as Map<String, dynamic>),
        )
        .toList();
  }

  Future<LearnerProfile?> findByEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    for (final profile in await getAll()) {
      if (profile.email.toLowerCase() == normalizedEmail) return profile;
    }
    return null;
  }

  Future<bool> register({
    required String fullName,
    required String email,
  }) async {
    if (await findByEmail(email) != null) return false;

    final now = DateTime.now();
    final profile = LearnerProfile(
      id: '${now.microsecondsSinceEpoch}',
      fullName: fullName,
      email: email.trim(),
      joinedAt: now.toIso8601String(),
    );
    final profiles = await getAll()
      ..add(profile);
    await _write(profiles);
    return true;
  }

  Future<void> update(LearnerProfile updatedProfile) async {
    final profiles = await getAll();
    final index = profiles.indexWhere(
      (profile) => profile.id == updatedProfile.id,
    );
    if (index == -1) return;
    profiles[index] = updatedProfile;
    await _write(profiles);
  }

  Future<void> _write(List<LearnerProfile> profiles) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _storageKey,
      jsonEncode(profiles.map((profile) => profile.toJson()).toList()),
    );
  }
}
