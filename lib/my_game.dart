import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:map/load_geojson.dart';
import 'components/zone.dart';

class MyGame extends FlameGame with TapCallbacks {
  static const width = 30.0;
  static const height = 30.0;
  late Map<String, dynamic> geoJson;

  @override
  Future<void> onLoad() async {
    String path = 'assets/geojson/map.geojson';
    geoJson = await loadGeoJson(path);

    List<Zone> zones = generateCountriesWith("region", "Western Europe");
    for (Zone zone in zones) {
      world.add(zone);
    }

    cameraSetup();
  }

  void cameraSetup() {
    camera.viewfinder.visibleGameSize = Vector2(width.toDouble(), height.toDouble());
    camera.viewfinder.position = Vector2(5, -75);
    camera.viewfinder.anchor = Anchor.topCenter;
  }

  // Create Zone for each country with a specific property value.
  List<Zone> generateCountriesWith(String propertyName, String propertyValue) {
    List<Zone> zones = [];
    List? geometries = findCountriesWith(propertyName, propertyValue);

    for (Map<String, dynamic> geometry in geometries!) {
      List? coordinates = geometry['coordinates'];
      assert(coordinates != null);

      // Some territory are composed of multiple polygons like France who has Corsica
      // Some are a simple polygon like Deutchland
      // multiple polygons add one level of complexity in the coordinates array
      if (geometry['type'] == 'MultiPolygon') {
        for (var territories in coordinates!) {
          for (var lands in territories) {
            List<Vector2> landCoord = [];

            for (var land in lands) {
              landCoord.add(Vector2(land[0].toDouble(), -land[1].toDouble()));
            }
            zones.add(Zone(landCoord, 1.0));
          }
        }
      } else if (geometry['type'] == 'Polygon') {
        for (var lands in coordinates!) {
          List<Vector2> landCoord = [];

          for (var land in lands) {
            landCoord.add(Vector2(land[0].toDouble(), -land[1].toDouble()));
          }
          zones.add(Zone(landCoord, 1.0));
        }
      }
    }

    return zones;
  }

  // Parse a geojson to extract all geo data with a specific property value
  // return geometries which are map containing type of the shape (polyygon, multiplePolygon) and coordinates
  List? findCountriesWith(String propertyName, String propertyValue) {
    var geometries = [];

    for (var feature in geoJson['features']) {
      if (feature['properties'][propertyName] == propertyValue &&
          feature['geometry'] != null) {
        geometries.add(feature['geometry']);
      }
    }

    return geometries;
  }
}
