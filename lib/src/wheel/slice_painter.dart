part of 'wheel.dart';

/// Draws a slice of a circle. The slice's arc starts at the right (3 o'clock)
/// and moves clockwise as far as specified by angle.
class _CircleSlicePainter extends CustomPainter {
  final Color fillColor;
  final Color? strokeColor;
  final double strokeWidth;
  final double angle;
  final BoxBorder? border;

  const _CircleSlicePainter({
    required this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1,
    this.angle = _math.pi / 2,
    this.border,
  }) : assert(angle > 0 && angle < 2 * _math.pi);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = _math.min(size.width, size.height);
    final path = _CircleSlice.buildSlicePath(radius, angle);

    // fill slice area
    canvas.drawPath(
      path,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );

    if (border != null) {
      final topBorder = border?.top;
      if (topBorder != null && topBorder.width > 0) {
        final slicePath = _CircleSlice.buildSlicePathOnly(
          radius,
          offset: topBorder.width / 2,
        );
        canvas.drawPath(
          slicePath,
          Paint()
            ..color = topBorder.color
            ..strokeWidth = topBorder.width
            ..style = PaintingStyle.stroke,
        );
      }

      final arcPath = _CircleSlice.buildArcPath(radius, angle);
      if (border is Border) {
        final rightSide = (border as Border).right;
        final arcBorderColor = rightSide.color;
        final arcBorderWidth = rightSide.width;
        canvas.drawPath(
          arcPath,
          Paint()
            ..color = arcBorderColor
            ..strokeWidth = arcBorderWidth
            ..style = PaintingStyle.stroke,
        );
      }
    }

    // draw slice border
    // if (strokeWidth > 0) {
    // canvas.drawPath(
    //   path,
    //   Paint()
    //     ..color = strokeColor!
    //     ..strokeWidth = strokeWidth
    //     ..style = PaintingStyle.stroke,
    // );

    //   canvas.drawPath(
    //     Path()
    //       ..arcTo(
    //           Rect.fromCircle(
    //             center: Offset(0, 0),
    //             radius: radius,
    //           ),
    //           0,
    //           angle,
    //           false),
    //     Paint()
    //       ..color = strokeColor!
    //       ..strokeWidth = strokeWidth * 2
    //       ..style = PaintingStyle.stroke,
    //   );
    // }
  }

  @override
  bool shouldRepaint(_CircleSlicePainter oldDelegate) {
    return angle != oldDelegate.angle ||
        fillColor != oldDelegate.fillColor ||
        strokeColor != oldDelegate.strokeColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
