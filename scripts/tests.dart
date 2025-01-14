import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

void main() async {
  String pointsUrl = "https://api.weather.gov/points/44.058,-121.31";
  Map<String, dynamic> pointsJsonData = await getJsonFromUrl(pointsUrl);

  String forecastUrl = pointsJsonData["properties"]["forecast"];
  String forecastHourlyUrl = pointsJsonData["properties"]["forecastHourly"];

  Map<String, dynamic> forecastJsonData = await getJsonFromUrl(forecastUrl);
  Map<String, dynamic> forecastHourlyJsonData =
      await getJsonFromUrl(forecastHourlyUrl);

  List<Map<String, dynamic>> bidailyForecasts =
      processForecasts(forecastJsonData);
  List<Map<String, dynamic>> hourlyForecasts =
      processForecasts(forecastHourlyJsonData);

  prettyPrint(bidailyForecasts);
  prettyPrint(hourlyForecasts);
  return;
}

Future<Map<String, dynamic>> getJsonFromUrl(String url) async {
  http.Response r = await http.get(Uri.parse(url));
  return convert.jsonDecode(r.body);
}

List<Map<String, dynamic>> processForecasts(Map<String, dynamic> forecasts) {
  List<dynamic> forecastPeriods = forecasts["properties"]["periods"];
  List<Map<String, dynamic>> processedForecasts = [];
  for (var forecast in forecastPeriods) {
    // processForecast(forecast);
    processedForecasts.add(processForecast(forecast));
  }
  return processedForecasts;
}

Map<String, dynamic> processForecast(Map<String, dynamic> forecast) {
  // TODO: Pass a forecast entry (either hourly or bidaily), and extract
  // The proper values that will be useful. i.e. temperature, shortForecast, longForecast
  // for now, don't return anything, just assign values for each
  // i.e. String shortForcast = "";

  String shortForecast = forecast["shortForecast"] ?? "";
  String detailedForecast = forecast["detailedForecast"] ?? "";
  String temperature = forecast["temperature"]?.toString() ?? "";
  String tempUnit = forecast["temperatureUnit"]?.toString() ?? "";
  String windSpeed = forecast["windSpeed"]?.toString() ?? "";
  String windDirection = forecast["windDirection"] ?? "";
  String startTime = forecast["startTime"] ?? "";
  String endTime = forecast["endTime"] ?? "";
  String humidity = forecast["relativeHumidity"]?['value']?.toString() ?? "";

  Map<String, dynamic> forecastEntry = {
    "shortForecast": shortForecast,
    "detailedForecast": detailedForecast,
    "temperature": temperature,
    "tempUnit": tempUnit,
    "windSpeed": windSpeed,
    "windDirection": windDirection,
    "startTime": startTime,
    "endTime": endTime,
    "humidity": humidity
  };
  return forecastEntry;
}

void prettyPrint(List<Map<String, dynamic>> data) {
  for (var entry in data) {
    print("===================================================");
    print("${entry['startTime']} - ${entry['endTime']}");
    print("Short Forecast: ${entry['shortForecast']}");
    print("Detailed Forecast: ${entry['detailedForecast']}");
    print("Temperature: ${entry['temperature']} ${entry['tempUnit']}");
    print("Wind Speed: ${entry['windSpeed']} ${entry['windDirection']}");
    print("Humidity: ${entry['humidity']}%");
  }
}
