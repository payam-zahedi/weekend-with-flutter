import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekend_with_flutter/src/widget/util/util.dart';

class HypnoCycle extends StatefulWidget {
  const HypnoCycle({
    Key? key,
    this.duration = const Duration(milliseconds: 4000),
    this.controller,
  }) : super(key: key);

  final Duration duration;
  final AnimationController? controller;

  @override
  _HypnoCycleState createState() => _HypnoCycleState();
}

class _HypnoCycleState extends State<HypnoCycle>
    with SingleTickerProviderStateMixin {
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
            child: SizedBox.fromSize(
              size: Size.square(200),
              child: Container(
                color: Colors.white24,
              ),
            ),
            painter: _HypnoPainter(_animation.value),
          );
        },
        animation: _animation,
      ),
    );
  }
}

class _HypnoPainter extends CustomPainter {
  _HypnoPainter(this.rotate)
      : hypnoPaint = Paint()
          ..color = Colors.blueGrey
          ..strokeWidth = 1
          ..style = PaintingStyle.fill;

  final double rotate;

  final Paint hypnoPaint;

  @override
  void paint(Canvas canvas, Size size) {
    _drawCircle(canvas, size / 2);
    _drawCircle(canvas, size / 6);
  }

  _drawCircle(Canvas canvas, Size size) {
    canvas.save();
    canvas.rotate(getRadian(-rotate * 360));
    canvas.drawCircle(
      size.center(Offset.zero),
      size.shortestSide,
      hypnoPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HypnoPainter oldDelegate) => true;
}
