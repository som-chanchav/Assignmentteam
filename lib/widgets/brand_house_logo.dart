import 'package:flutter/material.dart';

/// Architectural house logo widget matching the Figma onboarding design
class BrandHouseLogo extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color backgroundColor;
  final Color borderColor;

  const BrandHouseLogo({
    super.key,
    this.size = 48.0,
    this.primaryColor = const Color(0xFFC08A5E),
    this.backgroundColor = const Color(0xFFFBF8F5),
    this.borderColor = const Color(0xFFEADCCB),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.22),
      child: CustomPaint(
        painter: _HouseLogoPainter(color: primaryColor),
      ),
    );
  }
}

class _HouseLogoPainter extends CustomPainter {
  final Color color;

  _HouseLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Roof peak
    final roofPath = Path()
      ..moveTo(0, h * 0.45)
      ..lineTo(w * 0.5, h * 0.08)
      ..lineTo(w, h * 0.45);
    canvas.drawPath(roofPath, paint);

    // Chimney / small accent top right
    final chimneyPath = Path()
      ..moveTo(w * 0.72, h * 0.25)
      ..lineTo(w * 0.72, h * 0.12)
      ..lineTo(w * 0.85, h * 0.12)
      ..lineTo(w * 0.85, h * 0.35);
    canvas.drawPath(chimneyPath, paint);

    // House body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.45, w * 0.76, h * 0.52),
      const Radius.circular(2),
    );
    canvas.drawRRect(bodyRect, paint);

    // Door
    final doorRect = Rect.fromLTWH(w * 0.38, h * 0.65, w * 0.24, h * 0.32);
    canvas.drawRect(doorRect, paint);

    // Small window accent
    final windowRect = Rect.fromLTWH(w * 0.38, h * 0.32, w * 0.24, h * 0.16);
    canvas.drawRect(windowRect, fillPaint);
    canvas.drawRect(windowRect, paint);
  }

  @override
  bool shouldRepaint(covariant _HouseLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}
