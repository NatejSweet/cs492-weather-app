import 'dart:math';

import 'package:geocoding/geocoding.dart' as geocoding;

class Location {
  String? city;
  String? state;
  String? zip;
  double latitude;
  double longitude;

  Location(
      {this.city,
      this.state,
      this.zip,
      required this.latitude,
      required this.longitude});
}
// This class should store the values of our location:
// city, state, zip, latitude, longitude
// use appropriate data types as well as appropriate null safing for city state zip
// you do not need to create a factory, but you do need the basic contstructor
// use the forecast class as a template to help you

// create a Location object from the lat, lon, city, state, and zip
// return the Location if it's found, null if it's not found

Future<Location?> getLocationFromAddress(
    String rawCity, String rawState, String rawZip) async {
  String address = '$rawCity $rawState $rawZip';
  try {
    List<geocoding.Location> locations =
        await geocoding.locationFromAddress(address);
    double lat = locations[0].latitude;
    double lon = locations[0].longitude;
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(lat, lon);
    String? state = placemarks[0].administrativeArea;
    String? city = placemarks[0].locality;
    String? zip = placemarks[0].postalCode;
    return Location(
        city: city, state: state, zip: zip, latitude: lat, longitude: lon);
  } on geocoding.NoResultFoundException {
    return Location(
        city: rawCity,
        state: rawState,
        zip: rawZip,
        latitude: 0.0,
        longitude: 0.0);
  }
}
