import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Zone extends PolygonComponent with TapCallbacks  {
  static const Color selectedColor = Color.fromARGB(255, 34, 197, 34);
  static const Color defaultColor = Color.fromARGB(255, 55, 78, 192);

  Zone({
    required List<Vector2> points,
    required double scale,
    required String iso3,
    required String name,
    required String continent,
    required String region,
    required String status
  }) : super(
        points.map((point) => point * scale).toList(),
        paint: Paint()
                ..color = defaultColor
                ..style = PaintingStyle.stroke
                ..strokeWidth = 0.1,
      ){
        priority = 1;

      }

  @override
  bool get debugMode => false;

  @override
  void onTapUp(TapUpEvent event) {
    // Do something in response to a tap event
    if (paint.color == selectedColor) {
      paint.style = PaintingStyle.stroke;
      paint.color = defaultColor;
    } else {
      paint.style = PaintingStyle.fill;
      paint.color = selectedColor;
    }

    final gameCoordinates = event.localPosition;
    print("Tap detected at game coordinates: $gameCoordinates");
  }
}
