import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizon_pointer/offset_extension.dart';
import 'package:sensors_plus/sensors_plus.dart';

class OverlayScreen extends StatefulWidget {
  const OverlayScreen({
    Key? key,
    required this.child,
    this.sensitivity = 1,
  }) : super(key: key);

  final double sensitivity;

  final Widget child;

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  Offset point = const Offset(50, 50);
  bool isTracking = false;

  late final StreamSubscription _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();

    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      if (isTracking) {
        double dx = event.z * widget.sensitivity;
        double dy = event.x * widget.sensitivity;
        setState(() {
          point = (point - Offset(dx, dy)).clamp(0, 100, 0, 100);
        });
      }
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: () {
          var screenWidth = MediaQuery.of(context).size.width;
          var screenHeight = MediaQuery.of(context).size.height;
          final position = Offset(screenWidth / 100 * point.dx, screenHeight / 100 * point.dy);
          final downEvent = PointerDownEvent(pointer: 1, position: position);
          final upEvent = PointerUpEvent(pointer: 1, position: position);
          WidgetsBinding.instance.handlePointerEvent(downEvent);
          // await Future.delayed(const Duration(milliseconds: 100));
          WidgetsBinding.instance.handlePointerEvent(upEvent);
        },
        onLongPress: () {
          isTracking = true;
          HapticFeedback.lightImpact();
        },
        onLongPressUp: () {
          isTracking = false;
        },
        child: Stack(
          children: [
            widget.child,
            IgnorePointer(
              ignoring: true,
              ignoringSemantics: true,
              key: GlobalKey(),
              child: Column(
                children: [
                  Expanded(
                    child: CustomPaint(
                      painter: ScreenTestPainter(
                        point,
                      ),
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenTestPainter extends CustomPainter {
  ScreenTestPainter(Offset point) : _point = point;

  final Offset _point;

  @override
  void paint(Canvas canvas, Size size) {
    var point = Offset(_point.dx * (size.width / 100), _point.dy * (size.height / 100));
    final paint = Paint()..color = Colors.white.withOpacity(0.9);
    canvas.drawCircle(point, 8, paint);
    paint
      ..color = Colors.black54
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(point, 8.5, paint);
  }

  @override
  bool shouldRepaint(ScreenTestPainter oldDelegate) {
    return oldDelegate._point != _point;
  }

  @override
  bool shouldRebuildSemantics(ScreenTestPainter oldDelegate) {
    return false;
  }
}
