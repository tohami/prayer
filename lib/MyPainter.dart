import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as materials;
import 'package:prayertime/TrigonometricFunctions.dart';

class MyPainter extends CustomPainter {
  Color lineColor;
  Color pointsColor;
  List<double> pointsPercent;
  double lineWidth;
  double fastAnimationValue;
  double slowAnimationValue;

  MyPainter(
      {this.lineColor,
      this.pointsColor,
      this.pointsPercent,
      this.lineWidth,
      this.fastAnimationValue = 1.0, this.slowAnimationValue = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    //the arch padding from start and end
    double archPadding = 25.0;

    Paint linesPaint = new Paint()
      ..color = Color.fromARGB((fastAnimationValue * 254).round(),
          lineColor.red, lineColor.green, lineColor.blue)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth * fastAnimationValue;

    Paint dashedPaint = new Paint()
      ..color = Color.fromARGB((fastAnimationValue * 254).round(),
          lineColor.red, lineColor.green, lineColor.blue)
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth / 2 * fastAnimationValue;

    Paint pointPaint = new Paint()
      ..color = pointsColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth * 2 * fastAnimationValue;

    Paint sunPaint = new Paint()
      ..color = materials.Colors.amber
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth * 4 * fastAnimationValue;

    //center of circle
    Offset center = Offset(size.width / 2, size.height);
    double circleRadius =
        (min(size.height, size.width) - archPadding / pi) * fastAnimationValue;
    double Circumference = 2 * pi * circleRadius;

    List<double> dashed = List.generate(50, (i) => i * 2.0);

    dashed.forEach((dash) {
      Offset dashStart = getPointLocation(dash, circleRadius, center);
      Offset dashend = getPointLocation(dash + 0.5, circleRadius, center);
      canvas.drawLine(dashStart, dashend, dashedPaint);
    });

    //draw bottom line
    canvas.drawLine(Offset(0, size.height),
        Offset(size.width * fastAnimationValue, size.height), linesPaint);

    //drow salah times points
    List pointsOnArch = pointsPercent
        .map((percent) => getPointLocation(
            percent * slowAnimationValue, circleRadius, center))
        .toList();

    canvas.drawPoints(PointMode.points, pointsOnArch, pointPaint);


    canvas.drawPoints(
        PointMode.points,
        [getPointLocation(pointsPercent.last * slowAnimationValue, circleRadius, center)],
        sunPaint);
  }

  //to draw point on the arch based on known angle θ and radius r the if the center (0 , 0)
  // point set on x = rsin(θ), y = rcos(θ).
  Offset getPointLocation(
      double percentage, double circleRadius, Offset circleCinter) {
    //the percentage is from 0 to 100 and the angle is from 0 to 360
    //and the visable part of the circle is from angle 90 to 270 in reverse >> from right to left
    // or -90 to -270 in forward from left to right
    double onePercent = (270 - 90) / 100;
    double pointDegree = -90 - (onePercent * percentage);
    double pointX = (circleRadius * dsin(pointDegree)) + circleCinter.dx;
    double pointY = circleRadius * dcos(pointDegree) + circleCinter.dy;
    return Offset(pointX, pointY);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
