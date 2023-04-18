import 'dart:ui';

extension OffsetClamping on Offset {
  Offset clamp(double minDx, double maxDx, double minDy, double maxDy) {
    var newDx = clampDouble(dx, minDx, maxDx);
    var newDy =  clampDouble(dy, minDy, maxDy);
    return Offset(newDx, newDy);
  }
}
