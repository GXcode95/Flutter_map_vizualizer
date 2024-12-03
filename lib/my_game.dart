import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:map/load_geojson.dart';
import 'components/zone.dart';

class MyGame extends FlameGame with TapCallbacks {
  static const width = 30.0;
  static const height = 30.0;
  late Map<String, dynamic> geoJson;
  late List<Zone> zones = [];

  @override
  Future<void> onLoad() async {
    String path = 'assets/geojson/map.geojson';
    geoJson = await loadGeoJson(path);

    //List<Zone> zones = generateCountriesWith("region", "Western Europe");
    //for (Zone zone in zones) {
    //  world.add(zone);
    //}

    buildZones();
    print('ok');
    for (Zone zone in zones) {
      world.add(zone);
    }

    cameraSetup();
  }

  void cameraSetup() {
    camera.viewfinder.visibleGameSize = Vector2(width.toDouble() / 2, height.toDouble() /2);
    camera.viewfinder.position = Vector2(5, -75);
    camera.viewfinder.anchor = Anchor.topCenter;
  }

  void buildZones() {
    for (var feature in geoJson['features']) {
      if (feature['geometry'] != null) {
        List<Vector2> landCoord = [];
        List? coordinates = feature['geometry']['coordinates'];
        String name = feature['properties']['name'];

        if (feature['geometry']['type'] == 'MultiPolygon') {
          // Create a zone for each territory
          for (var territories in coordinates!) {

            for (var frontierPoints in territories) {
              for (var points in frontierPoints) {
                landCoord.add(Vector2(points[0].toDouble(), -points[1].toDouble()));
              }
            }
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
        }

       

        print('ok');
      }
    }
  }
}
