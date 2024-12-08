import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:map/load_geojson.dart';
import 'components/country.dart';
import 'components/zone.dart';



//class MyGame extends FlameGame with PanDetector, TapCallbacks {
class MyGame extends FlameGame with ScaleDetector, TapCallbacks, ScrollDetector {
  static const width = 60.0;
  static const height = 60.0;

  late Map<String, dynamic> geoJson;
  late List<Zone> zones = [];

  @override
  Future<void> onLoad() async {
    String path = 'assets/geojson/map.geojson';
    geoJson = await loadGeoJson(path);

    buildZones();

    for (Zone zone in zones) {
      world.add(zone);
    }

    cameraSetup();
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color.fromARGB(255, 32, 32, 107);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);

    super.render(canvas);
  }

  ////@override
  //void onPanUpdate(DragUpdateInfo info) {
  //  double deltaX = info.raw.delta.dx; // x position of the pointer in the global coordinate system
  //  double deltaY = info.raw.delta.dy; // x position of the pointer in the global coordinate system
  //  camera.viewfinder.position += Vector2(-deltaX / 10, -deltaY / 10); // Move the camera
  //  
  //  print("Position de la caméra : ${camera.viewfinder.position}");
  //}

  //@override
  //void onDragUpdate(DragUpdateInfo info) {
  //  // work same as panUpdate, pan is more complete, they both rely on flutter drag event (like scale)
  //}

  // Handle movement from a pointer or multiple pointer. can't mix with drag and pan so probably just use this one
  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    super.onScaleUpdate(info);
    // info:
    // globalposition                  
    //  dx                             -> represent the horizontal position of the pointer in the global coordinate system
    //  dy                             -> represent the vertical position of the pointer in the global coordinate system
    //  direction                      -> represent the direction. idk if it's direction for the pointer or between the pointers  
    //  distance                       -> double. not sure but probably the distance since last update (like the paneComponent)
    // pointerCount                    -> Number of pointers involved in the event
    // rotation                        -> double
    // raw                             
    //  focalpoint (offset)            -> offset
    //  focalpointdelta (offset)       -> offset
    //  pointercount                   -> Number of pointers involved in the event
    //  scale                          -> double
    //  verticale                      -> double
    //  horizonscale                   -> double
    print('SCALE');
  }


  static const zoomPerScrollUnit = 1;

  @override
  void onScroll(PointerScrollInfo info) {
    print(info.scrollDelta.global.y.sign); // get scroll direction ( 1 or -1)
    print(info.scrollDelta.global.y.sign * zoomPerScrollUnit); 
    print(camera.viewfinder.zoom);
    camera.viewfinder.zoom += info.scrollDelta.global.y.sign * zoomPerScrollUnit;  // multiply the direction by the zoomPerScrollUnit, can add a factor to increase/decrease the zoom speed
  }
  
  void cameraSetup() {
    camera.viewfinder.visibleGameSize = Vector2(width.toDouble(), height.toDouble());
    camera.viewfinder.position = Vector2(5, -60);
    camera.viewfinder.anchor = Anchor.topCenter;
  }

  void buildZones() {
    for (var feature in geoJson['features']) {
      if (feature['geometry'] != null) {
        List<Vector2> landCoord = [];
        List? coordinates = feature['geometry']['coordinates'];
        String name = feature['properties']['name'];

        //if (feature['geometry']['type'] == null) {
        //  print('*************************');
        //}
        if (feature['geometry']['type'] == 'MultiPolygon') {
          // Create a zone for each territory
          for (var territories in coordinates!) {
            for (var frontierPoints in territories) {
              for (var points in frontierPoints) {
                landCoord.add(Vector2(points[0].toDouble(), -points[1].toDouble()));
              }
            }
            //if (feature['properties']['iso3'] == null || feature['properties']['continent'] == null ||
            //  feature['properties']['region'] == null || feature['properties']['status'] == null) {
            //    print('*************************');
            //}

            Zone newZone = Zone(
              points: landCoord,
              scale: 1.0,
              name: name,
              iso3: feature['properties']['iso3'],
              continent: feature['properties']['continent'],
              region: feature['properties']['region'],
              status: feature['properties']['status'],
            );
            zones.add(newZone);
            Country country = Country.byName(name);
            country.addZone(newZone);
            
            landCoord = [];
          }
        }
        else if (feature['geometry']['type'] == 'Polygon') {
          // Create zone for the only territorry 
          for (var frontierPoints in coordinates!) {
            for (var points in frontierPoints) {
              landCoord.add(Vector2(points[0].toDouble(), -points[1].toDouble()));
            }
          }

          //if (feature['properties']['iso3'] == null || feature['properties']['continent'] == null ||
          //    feature['properties']['region'] == null || feature['properties']['status'] == null) {
          //      print('*************************');
          //}
          Zone newZone = Zone(
            points: landCoord,
            scale: 1.0,
            name: name,
            iso3: feature['properties']['iso3'],
            continent: feature['properties']['continent'],
            region: feature['properties']['region'],
            status: feature['properties']['status'],
          );
          zones.add(newZone);
          Country country = Country.byName(name);
          country.addZone(newZone);
        }
      }
    }
  }
}
