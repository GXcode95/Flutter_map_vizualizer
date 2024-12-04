import 'package:flame/components.dart';

import 'zone.dart';

class Country extends Component {
  factory Country.byName(String name) {
    return _singletons.putIfAbsent(name, () => Country._(name));
  }

  Country._(this.name);
  
  static final Map<String, Country> _singletons = {};
  static Country? selectedCountry;

  static List<Country> all(){
    return _singletons.values.toList();
  }

  static void setSelectedCountry(Country country){
    selectedCountry?.setSelected(false);
    selectedCountry = country;
  }

  final String name;
  final List<Zone> zones = [];
  bool selected = true;

  void addZone(Zone zone) {
    zones.add(zone);
  }

  void setSelected(bool value) {
    if (value == true) {
      selectedCountry?.setSelected(false);
      selectedCountry = this;
      for (var zone in zones) {
        zone.setStyle('selected');
      }
    }
    else {
      selectedCountry = null;
      for (var zone in zones) {
        zone.setStyle('default');
      }
    }

    selected = value;
  }

  void toggleSelected() {
    setSelected(!selected);
  }
}
