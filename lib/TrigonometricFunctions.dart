// ---------------------- Trigonometric Functions -----------------------
// range reduce angle in degrees.
import 'dart:math';

double fixangle(double a) {
  a = a - (360 * ((a / 360.0).floor()));

  a = a < 0 ? (a + 360) : a;

  return a;
}

// range reduce hours to 0..23
double fixhour(double a) {
  a = a - 24.0 * (a / 24.0).floor();
  a = a < 0 ? (a + 24) : a;
  return a;
}

// radian to degree
double radiansToDegrees(double alpha) {
  return ((alpha * 180.0) / pi);
}

// deree to radian
double DegreesToRadians(double alpha) {
  return ((alpha * pi) / 180.0);
}

// degree sin
double dsin(double d) {
  return (sin(DegreesToRadians(d)));
}

// degree cos
double dcos(double d) {
  return (cos(DegreesToRadians(d)));
}

// degree tan
double dtan(double d) {
  return (tan(DegreesToRadians(d)));
}

// degree arcsin
double darcsin(double x) {
  double val = asin(x);
  return radiansToDegrees(val);
}

// degree arccos
double darccos(double x) {
  double val = acos(x);
  return radiansToDegrees(val);
}

// degree arctan
double darctan(double x) {
  double val = atan(x);
  return radiansToDegrees(val);
}

// degree arctan2
double darctan2(double y, double x) {
  double val = atan2(y, x);
  return radiansToDegrees(val);
}

// degree arccot
double darccot(double x) {
  double val = atan2(1.0, x);
  return radiansToDegrees(val);
}
