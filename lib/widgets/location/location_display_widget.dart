import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/models/location.dart' as location;
import 'package:weatherapp/providers/location_provider.dart';

class LocationDisplayWidget extends StatelessWidget {
  const LocationDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var locationProvider = Provider.of<LocationProvider>(context);
    location.Location? loc = locationProvider.activeLocation;

    return loc != null
        ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Image.network(
                    loc.url ?? "",
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Failed to load image'));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${loc.city}, ${loc.state} ${loc.zip}"),
                )
              ],
            ),
        )
        : Text("No Location Set");
  }
}
