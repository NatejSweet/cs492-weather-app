import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:weatherapp/scripts/time.dart';

class Forecast{
  final String? name;
  final bool isDaytime;
  final int temperature;
  final String temperatureUnit;
  final String windSpeed;
  final String windDirection;
  final String shortForecast;
  final String? detailedForecast;
  final int? precipitationProbability;
  final int? humidity;
  final num? dewpoint;
  final DateTime startTime;
  final DateTime endTime;
  final String? tempHighLow;

  Forecast({
    required this.name,
    required this.isDaytime,
    required this.temperature,
    required this.temperatureUnit,
    required this.windSpeed,
    required this.windDirection,
    required this.shortForecast,
    required this.detailedForecast,
    required this.precipitationProbability,
    required this.humidity,
    required this.dewpoint,
    required this.startTime,
    required this.endTime,
    required this.tempHighLow,
  });

  factory Forecast.fromJson(Map<String, dynamic> json){
    return Forecast(
      name: json["name"].isNotEmpty ? json["name"] : null,
      isDaytime: json["isDaytime"],
      temperature: json["temperature"],
      temperatureUnit: json["temperatureUnit"],
      windSpeed: json["windSpeed"],
      windDirection: json["windDirection"],
      shortForecast: json["shortForecast"],
      detailedForecast: json["detailedForecast"].isNotEmpty ? json["detailedForecast"]: null ,
      precipitationProbability: json["probabilityOfPrecipitation"]["value"],
      humidity: json["relativeHumidity"] != null ? json["relativeHumidity"]["value"] : null,
      dewpoint: json["dewpoint"]?["value"],
      startTime: DateTime.parse(json["startTime"]).toLocal(),
      endTime: DateTime.parse(json["endTime"]).toLocal(),
      tempHighLow: null
    );
  }

  @override
  String toString(){
    return "name: ${name ?? "None"}\n"
          "isDaytime: ${isDaytime ? "Yes" : "No"}\n"
          "temperature: $temperature\n"
          "temperatureUnit: $temperatureUnit\n"
          "windSpeed: $windSpeed\n"
          "windDirection: $windDirection\n"
          "shortForecast: $shortForecast\n"
          "detailedForecast: $detailedForecast\n"
          "precipitationProbability: ${precipitationProbability ?? "None"}\n"
          "humidity: ${humidity ?? "None"}\n"
          "dewpoint: ${dewpoint ?? "None"}\n"
          "startTime: ${startTime.toLocal()}\n"
          "endTime: ${endTime.toLocal()}\n"
          "tempHighLow: ${tempHighLow ?? "None"}";
  }

  String getIconPath() {
    final Map<String, String> iconMap = {
      "sunny": "assets/weather_icons/sunny.svg",
      "clear_day": "assets/weather_icons/sunny.svg",
      "clear_night": "assets/weather_icons/clear.svg",
      "mostly_cloudy_day": "assets/weather_icons/mostly_cloudy.svg",
      "mostly_cloudy_night": "assets/weather_icons/mostly_cloudy_night.svg",
      "partly_cloudy_day": "assets/weather_icons/partly_cloudy.svg",
      "partly_cloudy_night": "assets/weather_icons/partly_clear.svg",
      "cloudy": "assets/weather_icons/cloudy.svg",
      "thunderstorms": "assets/weather_icons/strong_tstorms.svg",
      "drizzle": "assets/weather_icons/drizzle.svg",
      "rain_showers": "assets/weather_icons/scattered_showers.svg",
      "rain": "assets/weather_icons/droplet_heavy.svg",
      "snow_showers": "assets/weather_icons/scattered_snow.svg",
      "blowing_snow": "assets/weather_icons/blowing_snow.svg",
      "heavy_snow": "assets/weather_icons/heavy_snow.svg",
      "light_snow": "assets/weather_icons/flurries.svg",
      "snow": "assets/weather_icons/snow_showers.svg",
      "frost": "assets/weather_icons/icy.svg",
      "fog": "assets/weather_icons/fog.svg",
      "sleet_hail": "assets/weather_icons/sleet_hail.svg",
      "default": "assets/weather_icons/question.svg"
    };

    String key = "default";
    if (shortForecast.toLowerCase().contains("sunny")) {
      key = "sunny";
    } else if (shortForecast.toLowerCase().contains("clear")) {
      key = isDaytime ? "clear_day" : "clear_night";
    } else if (shortForecast.toLowerCase().contains("mostly cloudy")) {
      key = isDaytime ? "mostly_cloudy_day" : "mostly_cloudy_night";
    } else if (shortForecast.toLowerCase().contains("partly cloudy")) {
      key = isDaytime ? "partly_cloudy_day" : "partly_cloudy_night";
    } else if (shortForecast.toLowerCase().contains("cloudy")) {
      key = "cloudy";
    } else if (shortForecast.toLowerCase().contains("thunderstorms")) {
      key = "thunderstorms";
    } else if (shortForecast.toLowerCase().contains("drizzle")) {
      key = "drizzle";
    } else if (shortForecast.toLowerCase().contains("rain showers")) {
      key = "rain_showers";
    } else if (shortForecast.toLowerCase().contains("rain")) {
      key = "rain";
    } else if (shortForecast.toLowerCase().contains("snow showers")) {
      key = "snow_showers";
    } else if (shortForecast.toLowerCase().contains("blowing snow")) {
      key = "blowing_snow";
    } else if (shortForecast.toLowerCase().contains("heavy snow")) {
      key = "heavy_snow";
    } else if (shortForecast.toLowerCase().contains("light snow")) {
      key = "light_snow";
    } else if (shortForecast.toLowerCase().contains("snow")) {
      key = "snow";
    } else if (shortForecast.toLowerCase().contains("frost")) {
      key = "frost";
    } else if (shortForecast.toLowerCase().contains("fog")) {
      key = "fog";
    } else if (shortForecast.toLowerCase().contains("sleet") || shortForecast.contains("hail")) {
      key = "sleet_hail";
    }

    return iconMap[key] ?? iconMap["default"]!;
  }
}

Future<List<Forecast>> getForecastFromPoints(double lat, double lon) async{
  // make a request to the weather api using the latitude and longitude and decode the json data
  String pointsUrl = "https://api.weather.gov/points/${lat},${lon}";
  Map<String, dynamic> pointsJson = await getRequestJson(pointsUrl);

  // pull the forecast URL from the response json
  String forecastUrl = pointsJson["properties"]["forecast"];

  // make a request to the forecastJson url and decode the json data
  Map<String, dynamic> forecastJson = await getRequestJson(forecastUrl);
  return processForecasts(forecastJson["properties"]["periods"]);
}

Future<List<Forecast>> getForecastHourlyFromPoints(double lat, double lon) async{
  // make a request to the weather api using the latitude and longitude and decode the json data
  String pointsUrl = "https://api.weather.gov/points/${lat},${lon}";
  Map<String, dynamic> pointsJson = await getRequestJson(pointsUrl);

  // pull the forecastHourly URL from the response json
  String forecastHourlyUrl = pointsJson["properties"]["forecastHourly"];

  // make a request to the forecastHourlyJson url and decode the json data
  Map<String, dynamic> forecastHourlyJson = await getRequestJson(forecastHourlyUrl);
  return processForecasts(forecastHourlyJson["properties"]["periods"]);
}

List<Forecast> processForecasts(List<dynamic> forecasts){
  List<Forecast> forecastObjs = [];
  for (dynamic forecast in forecasts){
    forecastObjs.add(Forecast.fromJson(forecast));
  }
  return forecastObjs;
}

Future<Map<String, dynamic>> getRequestJson(String url) async{
  http.Response r = await http.get(Uri.parse(url));
  return convert.jsonDecode(r.body);
}


Forecast getForecastDaily(Forecast forecast1, Forecast forecast2){
  String tempHighLow = getTempHighLow(forecast1.temperature, forecast2.temperature, forecast1.temperatureUnit);

  return Forecast(
    name: equalDates(DateTime.now(), forecast1.startTime) ? "Today" : forecast1.name, 
    isDaytime: forecast1.isDaytime, 
    temperature: forecast1.temperature, 
    temperatureUnit: forecast1.temperatureUnit, 
    windSpeed: forecast1.windSpeed, 
    windDirection: forecast1.windDirection, 
    shortForecast: forecast1.shortForecast, 
    detailedForecast: forecast1.detailedForecast, 
    precipitationProbability: forecast1.precipitationProbability, 
    humidity: forecast1.humidity, 
    dewpoint: forecast1.dewpoint, 
    startTime: forecast1.startTime, 
    endTime: forecast2.endTime, 
    tempHighLow: tempHighLow);

}

String getTempHighLow(int temp1, int temp2, String tempUnit){
  if (temp1 < temp2){
    return "$temp1°$tempUnit/$temp2°$tempUnit";
  }
  else {
    return "$temp2°$tempUnit/$temp1°$tempUnit";
  }

}