import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _currentTime;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();

    _currentTime = DateTime.now();

    // Update the clock every second.
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Live analog clock
        SizedBox(
          width: 220,
          height: 220,
          child: CustomPaint(
            painter: _AnalogClockPainter(
              time: _currentTime,
            ),
          ),
        ),

        const SizedBox(height: 28),

        const Text(
          'Welcome Home',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1C1C1E),
          ),
        ),

        const SizedBox(height: 10),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            'Manage your money, access your vault,\nand more from here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.45,
              color: Color(0xFF6E6870),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnalogClockPainter extends CustomPainter {
  final DateTime time;

  const _AnalogClockPainter({
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = math.min(size.width, size.height) / 2;

    // ------------------------------------------------------------
    // Clock background
    // ------------------------------------------------------------

    final facePaint = Paint()
      ..color = const Color(0xFFFFF9F8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius - 4,
      facePaint,
    );

    // ------------------------------------------------------------
    // Outer border
    // ------------------------------------------------------------

    final borderPaint = Paint()
      ..color = const Color(0xFFE8D9D7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(
      center,
      radius - 4,
      borderPaint,
    );

    // ------------------------------------------------------------
    // Hour markers
    // ------------------------------------------------------------

    final markerPaint = Paint()
      ..color = const Color(0xFF4A4144)
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi / 6) - math.pi / 2;

      final isMainHour = i % 3 == 0;

      final outerRadius = radius - 15;
      final innerRadius = isMainHour ? radius - 31 : radius - 25;

      final start = Offset(
        center.dx + math.cos(angle) * innerRadius,
        center.dy + math.sin(angle) * innerRadius,
      );

      final end = Offset(
        center.dx + math.cos(angle) * outerRadius,
        center.dy + math.sin(angle) * outerRadius,
      );

      markerPaint.strokeWidth = isMainHour ? 3 : 1.5;

      canvas.drawLine(
        start,
        end,
        markerPaint,
      );
    }

    // ------------------------------------------------------------
    // Current time
    // ------------------------------------------------------------

    final hour = time.hour % 12;
    final minute = time.minute;
    final second = time.second;

    // Hour hand includes minutes and seconds for smooth movement.
    final hourValue =
        hour + (minute / 60) + (second / 3600);

    final hourAngle =
        (hourValue * math.pi / 6) - math.pi / 2;

    // Minute hand includes seconds.
    final minuteValue =
        minute + (second / 60);

    final minuteAngle =
        (minuteValue * math.pi / 30) - math.pi / 2;

    final secondAngle =
        (second * math.pi / 30) - math.pi / 2;

    // ------------------------------------------------------------
    // Hour hand
    // ------------------------------------------------------------

    final hourHandPaint = Paint()
      ..color = const Color(0xFF2E2729)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final hourEnd = Offset(
      center.dx + math.cos(hourAngle) * (radius * 0.48),
      center.dy + math.sin(hourAngle) * (radius * 0.48),
    );

    canvas.drawLine(
      center,
      hourEnd,
      hourHandPaint,
    );

    // ------------------------------------------------------------
    // Minute hand
    // ------------------------------------------------------------

    final minuteHandPaint = Paint()
      ..color = const Color(0xFF3F3538)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    final minuteEnd = Offset(
      center.dx + math.cos(minuteAngle) * (radius * 0.68),
      center.dy + math.sin(minuteAngle) * (radius * 0.68),
    );

    canvas.drawLine(
      center,
      minuteEnd,
      minuteHandPaint,
    );

    // ------------------------------------------------------------
    // Second hand
    // ------------------------------------------------------------

    final secondHandPaint = Paint()
      ..color = const Color(0xFFC44747)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final secondEnd = Offset(
      center.dx + math.cos(secondAngle) * (radius * 0.76),
      center.dy + math.sin(secondAngle) * (radius * 0.76),
    );

    final secondBack = Offset(
      center.dx - math.cos(secondAngle) * (radius * 0.16),
      center.dy - math.sin(secondAngle) * (radius * 0.16),
    );

    canvas.drawLine(
      secondBack,
      secondEnd,
      secondHandPaint,
    );

    // ------------------------------------------------------------
    // Center point
    // ------------------------------------------------------------

    final centerOuterPaint = Paint()
      ..color = const Color(0xFFC44747);

    canvas.drawCircle(
      center,
      6,
      centerOuterPaint,
    );

    final centerInnerPaint = Paint()
      ..color = Colors.white;

    canvas.drawCircle(
      center,
      2.5,
      centerInnerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AnalogClockPainter oldDelegate) {
    return oldDelegate.time != time;
  }
}