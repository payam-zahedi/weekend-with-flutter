import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/widgets.dart';

class Spinner extends StatefulWidget {
  const Spinner({
    Key? key,
    required this.color,
    this.lineWidth = 7.0,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 4000),
    this.controller,
  }) : super(key: key);

  final Color color;
  final double lineWidth;
  final double size;
  final Duration duration;
  final AnimationController? controller;

  @override
  _SpinnerState createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            child: SizedBox.fromSize(size: Size.square(300)),
            painter: _DualRingPainter(
              _animation.value,
              ringWidth: 5,
              color: widget.color,
            ),
          );
        },
        animation: _animation,
      ),
    );
  }
}

class _DualRingPainter extends CustomPainter {
  _DualRingPainter(
    this.rotateValue, {
    required Color color,
    this.ringWidth = 5,
  }) : ringPaint = Paint()
          ..color = color
          ..strokeWidth = 1
          ..style = PaintingStyle.fill;

  final Paint ringPaint;
  final double rotateValue;
  final double ringWidth;

  @override
  void paint(Canvas canvas, Size size) {
    _drawSpin(canvas, size, ringPaint, 1);
    _drawSpin(canvas, size, ringPaint, 2);
    _drawSpin(canvas, size, ringPaint, 3);
    _drawSpin(canvas, size, ringPaint, 4);
    _drawSpin(canvas, size, ringPaint, 5);
    _drawSpin(canvas, size, ringPaint, 6);
    _drawSpin(canvas, size, ringPaint, 7);
  }

  void _drawSpin(Canvas canvas, Size size, Paint paint, int scale) {
    final scaledSize = size * (scale / 7);
    final spinnerSize = Size.square(scaledSize.longestSide);

    final startX = spinnerSize.width / 2;
    final startY = spinnerSize.topCenter(Offset.zero).dy;

    final radius = spinnerSize.width / 4;

    final endX = startX;
    final endY = spinnerSize.bottomCenter(Offset.zero).dy;

    final borderWith = ringWidth;

    final scaleFactor = -(scale - 8);

    final path = Path();
    path.moveTo(startX, startY);
    path.arcToPoint(
      Offset(endX, endY),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.arcToPoint(
      Offset(startX, startY + borderWith),
      radius: Radius.circular(radius),
    );
    path.lineTo(startX, startY);

    canvas.save();
    _translateCanvas(canvas, size, spinnerSize);
    _rotateCanvas(
      canvas,
      spinnerSize,
      getRadian(rotateValue * 360 * scaleFactor),
    );
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _translateCanvas(Canvas canvas, Size size, Size spinnerSize) {
    final offset = ((size - spinnerSize) as Offset) / 2;
    canvas.translate(offset.dx, offset.dy);
  }

  void _rotateCanvas(Canvas canvas, Size size, double angle) {
    final double r =
        sqrt(size.width * size.width + size.height * size.height) / 2;
    final alpha = atan(size.height / size.width);
    final beta = alpha + angle;
    final shiftY = r * sin(beta);
    final shiftX = r * cos(beta);
    final translateX = size.width / 2 - shiftX;
    final translateY = size.height / 2 - shiftY;
    canvas.translate(translateX, translateY);
    canvas.rotate(angle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double getRadian(double angle) => math.pi / 180 * angle;
}
