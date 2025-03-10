import 'package:flutter/material.dart';
import 'dart:math' as math;

class ScaleSlider extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialValue;
  final String unit;
  final ValueChanged<double> onChanged;
  final String label;
  final int divisions;
  final double step;

  const ScaleSlider({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.unit,
    required this.onChanged,
    required this.label,
    this.divisions = 100,
    this.step = 0.1,
  }) : super(key: key);

  @override
  _ScaleSliderState createState() => _ScaleSliderState();
}

class _ScaleSliderState extends State<ScaleSlider>
    with SingleTickerProviderStateMixin {
  late double _currentValue;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create a bounce animation for the needle
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 60.0,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateValue(double value) {
    // Round to the nearest step
    final roundedValue = (value / widget.step).round() * widget.step;

    if (roundedValue != _currentValue) {
      setState(() {
        _currentValue = roundedValue;
      });
      widget.onChanged(_currentValue);

      // Play the animation
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A73E8),
            ),
          ),
        ),
        Container(
          height: 120,
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
          child: Column(
            children: [
              // Value display
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentValue.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.unit,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Scale visualization
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Scale markings
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomPaint(
                        size: const Size(double.infinity, 40),
                        painter: ScalePainter(
                          min: widget.minValue,
                          max: widget.maxValue,
                          divisions: widget.divisions,
                        ),
                      ),
                    ),

                    // Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 1,
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                          thumbColor: const Color(0xFF1A73E8),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                            elevation: 4,
                          ),
                          overlayColor:
                              const Color(0xFF1A73E8).withOpacity(0.2),
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 16),
                        ),
                        child: Slider(
                          value: _currentValue,
                          min: widget.minValue,
                          max: widget.maxValue,
                          divisions: widget.divisions,
                          onChanged: _updateValue,
                        ),
                      ),
                    ),

                    // Needle indicator - Position it based on the current value
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        // Calculate the position of the needle based on the current value
                        final double position =
                            ((_currentValue - widget.minValue) /
                                        (widget.maxValue - widget.minValue)) *
                                    MediaQuery.of(context).size.width -
                                40;

                        return Positioned(
                          left: position,
                          child: Transform.translate(
                            offset: Offset(0, _animation.value * 10),
                            child: Container(
                              width: 2,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A73E8),
                                borderRadius: BorderRadius.circular(1),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1A73E8)
                                        .withOpacity(0.3),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ScalePainter extends CustomPainter {
  final double min;
  final double max;
  final int divisions;

  ScalePainter({
    required this.min,
    required this.max,
    required this.divisions,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final textPaint = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final range = max - min;
    final step = size.width / divisions;

    for (int i = 0; i <= divisions; i++) {
      final x = i * step;
      final value = min + (i / divisions) * range;

      // Draw tick marks
      if (i % 10 == 0) {
        // Major tick
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, 15),
          paint..strokeWidth = 1.5,
        );

        // Draw value text for major ticks
        textPaint.text = TextSpan(
          text: value.toStringAsFixed(0),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        );
        textPaint.layout();
        textPaint.paint(
          canvas,
          Offset(x - textPaint.width / 2, 20),
        );
      } else if (i % 5 == 0) {
        // Medium tick
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, 10),
          paint..strokeWidth = 1,
        );
      } else {
        // Minor tick
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, 5),
          paint..strokeWidth = 0.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
