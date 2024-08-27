import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

Future<String> getUserLocality() async {
  try {
    // Request location permission
    await Geolocator.requestPermission();

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Get the list of placemarks from the position
    List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Get the locality from the first placemark
    if (placemarks.isNotEmpty) {
      return placemarks[0].locality ?? 'Unknown locality';
    }
  } catch (e) {
    print('Error getting location: $e');
  }
  return 'Unknown locality';
}
