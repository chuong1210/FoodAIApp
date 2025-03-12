import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'dart:math' as math;

class TargetWeightPage extends StatelessWidget {
  final UserModel userData;
  final Function(double) onTargetWeightChanged;

  const TargetWeightPage({
    Key? key,
    required this.userData,
    required this.onTargetWeightChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mục tiêu cân nặng',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Hãy chia sẻ cân nặng lý tưởng bạn muốn đạt được',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            _buildTargetWeightSlider(),
            const SizedBox(height: 20),
            _buildCurrentWeightDisplay(),
            const SizedBox(height: 20),
            _buildWeightDifference(),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetWeightSlider() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cân nặng mục tiêu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A73E8),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A73E8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${userData.targetWeight?.toInt() ?? 60} kg',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A73E8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              activeTrackColor: const Color(0xFF1A73E8),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: Colors.white,
              thumbShape: const _CustomSliderThumbCircle(
                thumbRadius: 15,
                min: 40,
                max: 120,
              ),
              overlayColor: const Color(0xFF1A73E8).withOpacity(0.2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 25),
            ),
            child: Slider(
              value: userData.targetWeight ?? 60,
              min: 40,
              max: 120,
              onChanged: onTargetWeightChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('40 kg', style: TextStyle(color: Colors.grey)),
                const Text('80 kg', style: TextStyle(color: Colors.grey)),
                const Text('120 kg', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeightDisplay() {
    if (userData.weight == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Cân nặng hiện tại của bạn: ${userData.weight?.toInt()} kg',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightDifference() {
    if (userData.weight == null || userData.targetWeight == null) {
      return const SizedBox.shrink();
    }

    final weightDifference =
        (userData.targetWeight! - userData.weight!).abs().toInt();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hành trình của bạn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A73E8),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    '${userData.weight?.toInt()} kg',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Hiện tại',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: 80,
                height: 2,
                color: Colors.grey[300],
              ),
              Column(
                children: [
                  Text(
                    '${userData.targetWeight?.toInt()} kg',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A73E8),
                    ),
                  ),
                  const Text(
                    'Mục tiêu',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Bạn cần ${userData.weight! > userData.targetWeight! ? "giảm" : "tăng"} $weightDifference kg để đạt mục tiêu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: userData.weight! > userData.targetWeight!
                    ? Colors.orange
                    : userData.weight! < userData.targetWeight!
                        ? Colors.green
                        : const Color(0xFF1A73E8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final double min;
  final double max;

  const _CustomSliderThumbCircle({
    required this.thumbRadius,
    required this.min,
    required this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, thumbRadius, paint);
    canvas.drawCircle(center, thumbRadius, borderPaint);

    // Draw the pointer
    final pointerPaint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;

    const pointerLength = 10.0;
    const pointerWidth = 2.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(2 * math.pi * (value - 0.5));
    canvas.drawRect(
      Rect.fromLTWH(
          -pointerWidth / 2, -thumbRadius, pointerWidth, pointerLength),
      pointerPaint,
    );
    canvas.restore();

    // Draw the value text
    final textSpan = TextSpan(
      text: '${(min + (max - min) * value).round()}',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A73E8),
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final textCenter = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );

    textPainter.paint(canvas, textCenter);
  }
}
