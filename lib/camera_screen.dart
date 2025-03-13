import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isScanning = false;
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;
  bool _isFlashOn = false;
  bool _isDetecting = false;
  String _detectedObject = '';
  double _confidence = 0.0;
  Rect? _detectionRect;

  // Thêm các animation controllers mới
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;
  late AnimationController _borderAnimationController;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    // Animation cho đường quét
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _scanAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Animation cho hiệu ứng pulse của khung
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Animation cho đường viền
    _borderAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _borderAnimationController,
        curve: Curves.linear,
      ),
    );
  }

  void _initializeCamera() {
    try {
      _controller = CameraController(
        widget.cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      _initializeControllerFuture = _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});

        // Mô phỏng phát hiện đối tượng
        _startObjectDetectionSimulation();
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _startObjectDetectionSimulation() {
    // Mô phỏng phát hiện đối tượng mỗi 3 giây
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      // Danh sách các loại thực phẩm mô phỏng
      final foods = [
        'Pizza',
        'Hamburger',
        'Salad',
        'Pasta',
        'Sushi',
        'Steak',
        'Ice Cream',
        'Cake',
        'Fruit',
        'Sandwich'
      ];

      // Chọn ngẫu nhiên một loại thực phẩm
      final randomIndex = DateTime.now().millisecondsSinceEpoch % foods.length;
      final food = foods[randomIndex];

      // Tạo độ tin cậy ngẫu nhiên từ 70% đến 95%
      final confidence =
          0.7 + (DateTime.now().millisecondsSinceEpoch % 25) / 100;

      // Tạo vị trí ngẫu nhiên cho khung nhận diện
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      // Tạo khung nhận diện ở khu vực trung tâm màn hình
      final centerX = screenWidth * 0.5;
      final centerY = screenHeight * 0.5;
      final width = screenWidth * 0.6;
      final height = width * 0.75;

      final rect = Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: width,
        height: height,
      );

      setState(() {
        _detectedObject = food;
        _confidence = confidence;
        _detectionRect = rect;
      });

      // Xóa kết quả sau 2 giây
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _detectedObject = '';
            _detectionRect = null;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scanAnimationController.dispose();
    _pulseAnimationController.dispose();
    _borderAnimationController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _controller.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
  }

  Future<void> _takePicture() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
    });

    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      if (!mounted) return;

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isScanning = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(imagePath: image.path),
        ),
      );
    } catch (e) {
      print('Error taking picture: $e');
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview với tỉ lệ chính xác và full màn hình
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _buildCameraPreview();
              } else {
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1A73E8),
                    ),
                  ),
                );
              }
            },
          ),

          // Object detection overlay
          if (_detectionRect != null)
            CustomPaint(
              painter: ObjectDetectionPainter(
                _detectedObject,
                _confidence,
                _detectionRect!,
              ),
              size: MediaQuery.of(context).size,
            ),

          // Scanning overlay
          if (_isScanning)
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return Positioned(
                  top: MediaQuery.of(context).size.height *
                          _scanAnimation.value -
                      50,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color(0xFF1A73E8),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A73E8).withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          // Scanning frame
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_pulseAnimation, _borderAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF1A73E8).withOpacity(0.5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomPaint(
                      painter: ScannerBorderPainter(
                        progress: _borderAnimation.value,
                        color: const Color(0xFF1A73E8),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Top bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // Instructions text
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Position food in frame',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Flash toggle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFlash,
                  ),
                ),
              ],
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: Icons.photo_library,
                    onPressed: _pickImage,
                  ),
                  _buildCameraButton(),
                  _buildControlButton(
                    icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    onPressed: _toggleFlash,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_controller.value.isInitialized) {
      return Container();
    }

    // Lấy kích thước màn hình
    final size = MediaQuery.of(context).size;

    // Lấy tỷ lệ khung hình của camera
    final previewSize = _controller.value.previewSize!;
    final previewRatio = previewSize.height / previewSize.width;

    // Tính toán tỷ lệ màn hình
    final screenRatio = size.height / size.width;

    // Tính toán scale để hiển thị đúng tỷ lệ
    var scale = 1.0;

    if (screenRatio > previewRatio) {
      // Màn hình cao hơn camera, scale theo chiều cao
      scale = size.height / (previewSize.width * previewRatio);
    } else {
      // Màn hình rộng hơn camera, scale theo chiều rộng
      scale = size.width * previewRatio / previewSize.height;
    }

    return Transform.scale(
      scale: scale,
      alignment: Alignment.center,
      child: CameraPreview(_controller),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: _isScanning ? null : _takePicture,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFF1A73E8),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A73E8).withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isScanning ? Colors.grey : const Color(0xFF1A73E8),
            ),
            child: Icon(
              _isScanning ? Icons.hourglass_top : Icons.camera_alt,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

class ObjectDetectionPainter extends CustomPainter {
  final String label;
  final double confidence;
  final Rect rect;

  ObjectDetectionPainter(this.label, this.confidence, this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A73E8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw bounding box with rounded corners
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
    canvas.drawRRect(rrect, paint);

    // Draw background for label
    final textPaint = Paint()
      ..color = const Color(0xFF1A73E8).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        rect.left,
        rect.top - 40,
        rect.width,
        40,
      ),
      const Radius.circular(10),
    );
    canvas.drawRRect(labelRect, textPaint);

    // Draw label text
    final textSpan = TextSpan(
      text: '$label (${(confidence * 100).toInt()}%)',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(minWidth: rect.width);
    textPainter.paint(
      canvas,
      Offset(rect.left + (rect.width - textPainter.width) / 2, rect.top - 30),
    );
  }

  @override
  bool shouldRepaint(ObjectDetectionPainter oldDelegate) {
    return oldDelegate.label != label ||
        oldDelegate.confidence != confidence ||
        oldDelegate.rect != rect;
  }
}

class ScannerBorderPainter extends CustomPainter {
  final double progress;
  final Color color;

  ScannerBorderPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();
    final cornerLength = size.width * 0.1;

    // Top left corner
    path.moveTo(0, cornerLength);
    path.lineTo(0, 0);
    path.lineTo(cornerLength, 0);

    // Top right corner
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cornerLength);

    // Bottom right corner
    path.moveTo(size.width, size.height - cornerLength);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - cornerLength, size.height);

    // Bottom left corner
    path.moveTo(cornerLength, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - cornerLength);

    // Draw the animated border
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final length = metric.length;
      final start = 0.0;
      final end = length * progress;

      canvas.drawPath(
        metric.extractPath(start, end),
        paint..color = color.withOpacity(1.0),
      );
    }
  }

  @override
  bool shouldRepaint(ScannerBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
