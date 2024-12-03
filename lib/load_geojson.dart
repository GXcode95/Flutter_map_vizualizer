import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> loadGeoJson(String path) async {
  try {
    String data = await rootBundle.loadString(path);
    Map<String, dynamic> geoJson = jsonDecode(data);

    return geoJson;
  } catch (e) {
    print("Error loading GeoJSON : $e");
    return {};
  }
}