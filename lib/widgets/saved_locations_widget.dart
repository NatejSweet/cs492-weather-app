import 'package:flutter/material.dart';
import 'package:weatherapp/scripts/location.dart' as location;

class SavedLocationsWidget extends StatelessWidget {
  const SavedLocationsWidget({
    super.key,
    required List<location.Location> savedLocations,
    required Function setLocation
  }) : _savedLocations = savedLocations, _setLocation = setLocation;

  final List<location.Location> _savedLocations;
  final Function _setLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Saved Locations"),
        for (var location in _savedLocations) SavedLocationWidget(location: location, setLocation: _setLocation)
      ],
    );
  }
}

class SavedLocationWidget extends StatelessWidget {
  const SavedLocationWidget({
    super.key,
    required location.Location location,
    required Function setLocation
  }) : _location = location, _setLocation = setLocation;

  final location.Location _location;
  final Function _setLocation;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('${_location.city}, ${_location.state} ${_location.zip}'),
        ElevatedButton(onPressed: ()=>{_setLocation(_location)}, child: const Text("Set"))
      ],
    );
  }
}