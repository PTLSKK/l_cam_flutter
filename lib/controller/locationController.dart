import 'package:location/location.dart';

class LocationController {
  bool _permission = false;
  LocationData _currentLocation;
  Location _location = Location();

  Future<LocationData> getLocation() async {
    await _location.changeSettings(accuracy: LocationAccuracy.NAVIGATION);

    try {
      bool serviceStatus = await _location.serviceEnabled();

      print("Service status: $serviceStatus");

      if (serviceStatus) {
        _permission = await _location.requestPermission();

        print("Permission: $_permission");
        if (_permission) {
          _currentLocation = await _location.getLocation();

          return _currentLocation;
        } else {
          var serviceStatusResult = await _location.requestService();
          print("Service status activated after request: $serviceStatusResult");

          if (serviceStatusResult) {
            _currentLocation = await _location.getLocation();
            return _currentLocation;
          }
        }
      }
    } catch (e) {
      print('[getLocation] an error has occurred ${e.message}');
      return null;
    }
  }
}
