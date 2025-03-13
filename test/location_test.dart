import 'package:test/test.dart';
import 'package:weatherapp/models/location.dart';

void main() {
  test("Test Location equality", testLocation);
  test("Test Location from JSON", testLocationFromJson);
  test("Test Location to JSON", testLocationToJson);
  test("Test AreLocationsEqual", testAreLocationsEqual);
}

Location mockLocation() {
  return Location(
    city: "Bend",
    state: "OR",
    zip: "97701",
    latitude: 44.0582,
    longitude: -121.3153,
  );
}

Location mockLocation_2() {
  return Location(
    city: "Portland",
    state: "OR",
    zip: "97201",
    latitude: 45.5152,
    longitude: -122.6784,
  );
}

Location mockLocation_3() {
  return Location(
    city: "Seattle",
    state: "WA",
    zip: "98101",
    latitude: 47.6062,
    longitude: -122.3321,
  );
}

void testLocation() {
  Location location1 = mockLocation();
  expect(location1.city, "Bend");
  expect(location1.state, "OR");
  expect(location1.zip, "97701");
  expect(location1.latitude, 44.0582);
  expect(location1.longitude, -121.3153);
}

void testLocationFromJson() {
  Map<String, dynamic> json = {
    "city": "Bend",
    "state": "OR",
    "zip": "97701",
    "latitude": 44.0582,
    "longitude": -121.3153,
  };

  Location location = Location.fromJson(json);

  expect(location.city, "Bend");
  expect(location.state, "OR");
  expect(location.zip, "97701");
  expect(location.latitude, 44.0582);
  expect(location.longitude, -121.3153);
}

void testLocationToJson() {
  Location location = mockLocation();
  Map<String, dynamic> json = location.toJson();

  expect(json["city"], "Bend");
  expect(json["state"], "OR");
  expect(json["zip"], "97701");
  expect(json["latitude"], 44.0582);
  expect(json["longitude"], -121.3153);
}

void testAreLocationsEqual() {
  Location location1 = mockLocation();
  Location location2 = mockLocation();
  Location location3 = mockLocation_2();

  expect(AreLocationsEqual(location1, location2, true), true);
  expect(AreLocationsEqual(location1, location3, false), true);
}

bool AreLocationsEqual(Location location1, Location location2, bool expected) {
  return (location1 == location2) == expected;
}