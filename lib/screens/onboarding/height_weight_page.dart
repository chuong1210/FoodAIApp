import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'dart:math' as math;

class HeightWeightPage extends StatefulWidget {
  final UserModel userData;
  final Function(double) onHeightChanged;
  final Function(double) onWeightChanged;

  const HeightWeightPage({
    Key? key,
    required this.userData,
    required this.onHeightChanged,
    required this.onWeightChanged,
  }) : super(key: key);

  @override
  _HeightWeightPageState createState() => _HeightWeightPageState();
}

class _HeightWeightPageState extends State<HeightWeightPage> {
  late double _heightValue;
  late double _weightValue;

  @override
  void initState() {
    super.initState();
    _heightValue = widget.userData.height ?? 170;
    _weightValue = widget.userData.weight ?? 65;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chiều cao & Cân nặng',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Hãy cho chúng tôi biết chiều cao và cân nặng hiện tại của bạn',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            _buildHeightSlider(),
            const SizedBox(height: 20),
            _buildWeightSlider(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightSlider() {
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
                'Chiều cao',
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
                  '${_heightValue.toInt()} cm',
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
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                // Scale markings - keeping the original
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(11, (index) {
                    final height = 140 + (index * 5);
                    return Container(
                      width: 2,
                      height: index % 2 == 0 ? 20 : 10,
                      color: Colors.grey[400],
                      margin: EdgeInsets.only(
                        left: index == 0 ? 10 : 0,
                        right: index == 10 ? 10 : 0,
                        top: 10,
                      ),
                    );
                  }),
                ),
                // Custom Slider with thumb that shows value
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    activeTrackColor: const Color(0xFF1A73E8),
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: Colors.white,
                    thumbShape: _CustomSliderThumbCircle(
                      thumbRadius: 15,
                      min: 140,
                      max: 190,
                    ),
                    overlayColor: const Color(0xFF1A73E8).withOpacity(0.2),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 25),
                  ),
                  child: Slider(
                    value: _heightValue,
                    min: 140,
                    max: 190,
                    onChanged: (value) {
                      setState(() {
                        _heightValue = value;
                        widget.onHeightChanged(value);
                      });
                    },
                  ),
                ),
                // Height indicator - now aligned with the thumb position
                Positioned(
                  left: ((_heightValue - 140) / 50) *
                          (MediaQuery.of(context).size.width - 80 - 40) +
                      20,
                  bottom: 0,
                  child: Container(
                    width: 2,
                    height: 40,
                    color: const Color(0xFF1A73E8),
                  ),
                ),
              ],
            ),
          ),
          // Height labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('140 cm', style: TextStyle(color: Colors.grey)),
                const Text('165 cm', style: TextStyle(color: Colors.grey)),
                const Text('190 cm', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightSlider() {
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
                'Cân nặng',
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
                  '${_weightValue.toInt()} kg',
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
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                // Scale markings
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(11, (index) {
                    return Container(
                      width: 2,
                      height: index % 2 == 0 ? 20 : 10,
                      color: Colors.grey[400],
                      margin: EdgeInsets.only(
                        left: index == 0 ? 10 : 0,
                        right: index == 10 ? 10 : 0,
                        top: 10,
                      ),
                    );
                  }),
                ),
                // Custom Slider
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    activeTrackColor: const Color(0xFF1A73E8),
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: Colors.white,
                    thumbShape: _CustomSliderThumbCircle(
                      thumbRadius: 15,
                      min: 40,
                      max: 120,
                    ),
                    overlayColor: const Color(0xFF1A73E8).withOpacity(0.2),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 25),
                  ),
                  child: Slider(
                    value: _weightValue,
                    min: 40,
                    max: 120,
                    onChanged: (value) {
                      setState(() {
                        _weightValue = value;
                        widget.onWeightChanged(value);
                      });
                    },
                  ),
                ),
                // Weight indicator - fixed calculation for better alignment
                Positioned(
                  left: ((_weightValue - 40) / 80) *
                          (MediaQuery.of(context).size.width - 80 - 40) +
                      20,
                  bottom: 0,
                  child: Container(
                    width: 2,
                    height: 40,
                    color: const Color(0xFF1A73E8),
                  ),
                ),
              ],
            ),
          ),
          // Weight labels
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

    // Draw white circle
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw border
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
    final actualValue = min + (max - min) * value;
    final textSpan = TextSpan(
      text: '${actualValue.round()}',
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
