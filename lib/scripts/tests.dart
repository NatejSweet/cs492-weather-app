import 'forecast.dart' as forecast;
import 'location.dart' as location;

// void main() async {
//   testForecast();
// }

void testLocation() async {
  // TODO: Create a list of Map<String, String>
  List<Map<String, String>> locations = [
    {"city": "Bend", "state": "OR", "zip": "97701"},
    {"city": "New York", "state": "NY", "zip": "10001"},
    {"city": "Chicago", "state": "IL", "zip": "60601"},
    {"city": "Miami", "state": "FL", "zip": "33101"},
    {"city": "Albuquerque", "state": "NM", "zip": "87101"}
  ];
  for (Map<String, String> loc in locations) {
    location.Location? locationResult = await location.getLocationFromAddress(
        loc["city"]!, loc["state"]!, loc["zip"]!);
    print(locationResult);
  }
  location.Location? locationResult = await location.getLocationFromAddress(
      "oijeqofwkjfla", "asdfsd", "98839829382");
  print(locationResult);
}

void testForecast() async {
// testing with Bend, OR coordinates
  // double lat = 44.05;
  // double lon = -121.31;
  List<List<double>> coords = [
    [44.05, -121.31],
    [40.71, -74.006],
    [41.878, -87.629],
    [25.7617, -80.1918],
    [35.0844, -106.65]
  ];

  for (List<double> coord in coords) {
    List<forecast.Forecast> forecasts =
        await forecast.getForecastFromPoints(coord[0], coord[1]);
    List<forecast.Forecast> forecastsHourly =
        await forecast.getForecastHourlyFromPoints(coord[0], coord[1]);
  }
}
