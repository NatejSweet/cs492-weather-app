import 'package:flutter/material.dart';
import 'package:weatherapp/models/location.dart' as location;
import 'package:weatherapp/providers/forecast_provider.dart';
import 'package:weatherapp/utils/firebase_storage.dart' as fs;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weatherapp/utils/get_image.dart';

class LocationProvider extends ChangeNotifier {
  final ForecastProvider forecastProvider;

  location.Location? activeLocation;
  String? activeLocationImg;

  LocationProvider(this.forecastProvider) {
    setInitialLocation();
  }

  Future<void> setInitialLocation() async {
    if (await fs.documentCount("locations") == null ||
        await fs.documentCount("locations") == 0) {
      setLocation(await location.getLocationFromGps());
      if (activeLocation != null) {
        await addLocation(activeLocation!);
      }
    } else {
      setLocation(location.Location.fromJson(
          await fs.getEntryByIndex("locations", 0) ?? {}));
    }
    notifyListeners();
  }

  void setLocation(location.Location loc) async {
    activeLocation = loc;

    notifyListeners();
    if (activeLocation != null) {
      forecastProvider.initForecasts(activeLocation!);
    }
  }

  Future<void> setLocationFromAddress(
      String city, String state, String zip) async {
    activeLocation = null;
    notifyListeners();

    final newLocation = await location.getLocationFromAddress(city, state, zip);

    if (newLocation != null) {
      activeLocation = newLocation;
      await addLocation(newLocation);
      notifyListeners();
    }
  }

  void setLocationFromGps() async {
    activeLocation = null;
    notifyListeners();

    final newLocation = await location.getLocationFromGps();
    activeLocation = newLocation;
    await addLocation(newLocation);
    notifyListeners();
  }

  Future<void> addLocation(location.Location newLocation) async {
    newLocation.url = await getImageByQuery(
        "${activeLocation!.city} ${activeLocation!.state}");
    if (!await fs.checkIfEntryExists("locations", "zip", newLocation.zip)) {
      FirebaseFirestore.instance
          .collection("locations")
          .add(newLocation.toJson());
    }
  }

  Future<void> deleteLocation(location.Location locToDelete) async {
    fs.deleteEntryWhere("locations", "zip", locToDelete.zip);
  }
}
