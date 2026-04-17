import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  const LocationService._();

  /// Requests location permission from the platform.
  /// Typically called during app startup.
  static Future<void> requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return;
    }
  }

  /// Fetches the current city and country names.
  /// Returns a string in "City, Country" format or null on failure.
  static Future<String?> getCurrentCityCountry() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final String city = place.locality ?? 
                           place.subLocality ?? 
                           place.administrativeArea ?? 
                           '';
        final String country = place.country ?? '';
        
        if (city.isNotEmpty && country.isNotEmpty) {
          return '$city, $country';
        } else if (country.isNotEmpty) {
          return country;
        } else if (city.isNotEmpty) {
          return city;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
