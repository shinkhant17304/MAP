import 'package:flutter/material.dart';

import '../models/entities.dart';

class Palette {
  static const blue = Color(0xFF4358E8);
  static const blueDark = Color(0xFF3046CD);
  static const ink = Color(0xFF202638);
  static const muted = Color(0xFF8990A1);
  static const canvas = Color(0xFFF7F8FC);
  static const line = Color(0xFFE7EAF2);
  static const yellow = Color(0xFFFFD35A);
  static const green = Color(0xFF4EAA83);
  static const red = Color(0xFFD66C70);
}

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Palette.blue,
    surface: Palette.canvas,
  ),
  scaffoldBackgroundColor: Palette.canvas,
  appBarTheme: const AppBarTheme(
    backgroundColor: Palette.canvas,
    foregroundColor: Palette.ink,
    surfaceTintColor: Colors.transparent,
  ),
  snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
);

InputDecoration inputStyle(String hint, {Widget? prefix, Widget? suffix}) =>
    InputDecoration(
      hintText: hint,
      prefixIcon: prefix,
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFFAFBFE),
      hintStyle: const TextStyle(color: Color(0xFFA8AEBA), fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Palette.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Palette.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Palette.blue, width: 1.5),
      ),
    );

ButtonStyle primaryButton() => FilledButton.styleFrom(
  backgroundColor: Palette.blue,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
);

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color = Colors.white,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: Palette.line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: child,
  );
}

class Brand extends StatelessWidget {
  const Brand({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: compact ? 29 : 38,
        height: compact ? 29 : 38,
        decoration: BoxDecoration(
          color: Palette.blue,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          Icons.menu_book_rounded,
          color: Colors.white,
          size: compact ? 17 : 23,
        ),
      ),
      const SizedBox(width: 8),
      Text(
        'linguago',
        style: TextStyle(
          color: Palette.ink,
          fontSize: compact ? 16 : 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

class CourseArt extends StatelessWidget {
  const CourseArt({
    super.key,
    required this.course,
    this.height = 110,
    this.compact = false,
  });

  final Course course;
  final double height;
  final bool compact;

  static const _colors = [
    Color(0xFF465CE7),
    Color(0xFFE4B943),
    Color(0xFF5C9B89),
    Color(0xFF7766D7),
  ];
  static const _letters = ['ก', 'ไป', 'ม้า', 'สวัสดี'];

  @override
  Widget build(BuildContext context) {
    final index = (course.id - 1) % _colors.length;
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _colors[index],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            top: -34,
            child: Container(
              width: height * 1.15,
              height: height * 1.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 0,
            child: Text(
              _letters[index],
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 36 : 50,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 10,
            child: Text(
              'THAI  /  BEGINNER',
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 8 : 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            color: Palette.ink,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
      if (action != null)
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: Palette.blue,
            padding: EdgeInsets.zero,
          ),
          child: Text(
            action!,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ),
    ],
  );
}

class Rating extends StatelessWidget {
  const Rating(this.value, {super.key, this.size = 14});

  final double value;
  final double size;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.star_rounded, color: Palette.yellow, size: size),
      const SizedBox(width: 3),
      Text(
        value == 0 ? 'New' : value.toStringAsFixed(1),
        style: TextStyle(
          color: Palette.muted,
          fontSize: size - 2,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class Metric extends StatelessWidget {
  const Metric({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.tint,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color tint;

  @override
  Widget build(BuildContext context) => Panel(
    padding: const EdgeInsets.all(11),
    child: Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: tint.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: tint),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Palette.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Palette.muted, fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.name, this.radius = 22});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: radius,
    backgroundColor: Palette.yellow,
    child: Text(
      name.isEmpty ? 'L' : name.substring(0, 1).toUpperCase(),
      style: TextStyle(
        color: Palette.ink,
        fontWeight: FontWeight.w800,
        fontSize: radius * 0.55,
      ),
    ),
  );
}
