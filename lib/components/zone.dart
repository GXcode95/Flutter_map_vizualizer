import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'country.dart';

class Zone extends PolygonComponent with TapCallbacks  {
  static const Color selectedColor = Color.fromARGB(255, 16, 123, 36);
  static const Color defaultColor = Color.fromARGB(255, 171, 32, 32);
  static final Map palette = {
      'selected': {
        'color': selectedColor,
        'style': PaintingStyle.fill,
      },
      'default': {
        'color': defaultColor,
        'style': PaintingStyle.stroke,
      },
    };
    
  final String? iso3;
  final String name;
  final String? continent;
  final String? region;
  final String? status;
  late Country country;

  Zone({
    required List<Vector2> points,
    required double scale,
    required this.iso3,
    required this.name,
    required this.continent,
    required this.region,
    required this.status
  }) : super(
        points.map((point) => point * scale).toList(),
        paint: Paint()
                ..color = defaultColor
                ..style = PaintingStyle.stroke
                ..strokeWidth = 0.1,
      ){
        priority = 1;
        country = Country.byName(name);
      }

  @override
  bool get debugMode => false;

  @override
  void onTapUp(TapUpEvent event) {
    country.setSelected(true);
  }

  void setStyle(String name){
    paint.color = palette[name]!['color'] as Color;
    paint.color = palette[name]!['color'] as Color;
    paint.style = palette[name]!['style'] as PaintingStyle;
  }
}
