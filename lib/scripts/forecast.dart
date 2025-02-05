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
    bool isNightTime = DateTime.now().hour < 8 || DateTime.now().hour >= 20;
  
    if (shortForecast.toLowerCase().contains("showers and thunderstorms likely")) {
      return "assets/weather_icons/isolated_tstorms.svg";
    } else if (shortForecast.toLowerCase().contains("showers and thunderstorms")) {
      return "assets/weather_icons/strong_tstorms.svg";
    } else if (shortForecast.toLowerCase().contains("chance showers and thunderstorms")) {
      return "assets/weather_icons/isolated_tstorms.svg";
    } else if (shortForecast.toLowerCase().contains("slight chance showers and thunderstorms")) {
      return "assets/weather_icons/isolated_tstorms.svg";
    } else if (shortForecast.toLowerCase().contains("chance rain and snow showers")) {
      return "assets/weather_icons/wintry_mix.svg";
    } else if (shortForecast.toLowerCase().contains("heavy snow and patchy blowing snow")) {
      return "assets/weather_icons/heavy_snow.svg";
    } else if (shortForecast.toLowerCase().contains("snow and patchy blowing snow")) {
      return "assets/weather_icons/snow_showers.svg";
    } else if (shortForecast.toLowerCase().contains("slight chance rain and snow")) {
      return "assets/weather_icons/wintry_mix.svg";
    } else if (shortForecast.toLowerCase().contains("chance rain and snow")) {
      return "assets/weather_icons/wintry_mix.svg";
    } else if (shortForecast.toLowerCase().contains("rain and snow likely")) {
      return "assets/weather_icons/wintry_mix.svg";
    } else if (shortForecast.toLowerCase().contains("slight chance freezing drizzle")) {
      return "assets/weather_icons/drizzle.svg";
    } else if (shortForecast.toLowerCase().contains("freezing drizzle likely")) {
      return "assets/weather_icons/drizzle.svg";
    } else if (shortForecast.toLowerCase().contains("chance freezing drizzle")) {
      return "assets/weather_icons/drizzle.svg";
    } else if (shortForecast.toLowerCase().contains("slight chance light snow")) {
      return "assets/weather_icons/scattered_snow.svg";
    } else if (shortForecast.toLowerCase().contains("chance light snow")) {
      return "assets/weather_icons/scattered_snow.svg";
    } else if (shortForecast.toLowerCase().contains("light snow likely")) {
      return "assets/weather_icons/scattered_snow.svg";
    } else if (shortForecast.toLowerCase().contains("snow likely")) {
      return "assets/weather_icons/snow_showers.svg";
    } else if (shortForecast.toLowerCase().contains("heavy snow likely")) {
      return "assets/weather_icons/heavy_snow.svg";
    } else if (shortForecast.toLowerCase().contains("heavy snow")) {
      return "assets/weather_icons/heavy_snow.svg";
    } else if (shortForecast.toLowerCase().contains("slight chance rain showers")) {
      return "assets/weather_icons/scattered_showers.svg";
    } else if (shortForecast.toLowerCase().contains("chance rain showers")) {
      return "assets/weather_icons/scattered_showers.svg";
    } else if (shortForecast.toLowerCase().contains("rain showers likely")) {
      return "assets/weather_icons/scattered_showers.svg";
    } else if (shortForecast.toLowerCase().contains("rain showers")) {
      return "assets/weather_icons/scattered_showers.svg";
    } else if (shortForecast.toLowerCase().contains("light rain likely")) {
      return "assets/weather_icons/scattered_showers.svg";
    } else if (shortForecast.toLowerCase().contains("rain and snow")) {
      return "assets/weather_icons/wintry_mix.svg";
    } else if (shortForecast.toLowerCase().contains("slight chance drizzle")) {
      return "assets/weather_icons/drizzle.svg";
    } else if (shortForecast.toLowerCase().contains("chance freezing rain")) {
      return "assets/weather_icons/showers.svg";
    } else if (shortForecast.toLowerCase().contains("freezing rain likely")) {
      return "assets/weather_icons/showers.svg";
    } else if (shortForecast.toLowerCase().contains("patchy blowing snow")) {
      return "assets/weather_icons/blowing_snow.svg";
    } else if (shortForecast.toLowerCase().contains("slight chance snow showers")) {
      return "assets/weather_icons/scattered_snow.svg";
    } else if (shortForecast.toLowerCase().contains("patchy blowing dust")) {
      return "assets/weather_icons/dust.svg";
    } else if (shortForecast.toLowerCase().contains("areas of fog")) {
      return "assets/weather_icons/fog.svg";
    } else if (shortForecast.toLowerCase().contains("patchy fog")) {
      return "assets/weather_icons/fog.svg";
    } else if (shortForecast.toLowerCase().contains("mostly cloudy")) {
      return "assets/weather_icons/cloudy.svg";
    } else if (shortForecast.toLowerCase().contains("partly cloudy")) {
      return isNightTime ? "assets/weather_icons/partly_cloudy_night.svg" : "assets/weather_icons/cloudy.svg";
    } else if (shortForecast.toLowerCase().contains("mostly sunny")) {
      return isNightTime ? "assets/weather_icons/mostly_clear_night.svg" : "assets/weather_icons/mostly_sunny.svg";
    } else if (shortForecast.toLowerCase().contains("mostly clear")) {
      return isNightTime ? "assets/weather_icons/mostly_clear_night.svg" : "assets/weather_icons/clear.svg";
    } else if (shortForecast.toLowerCase().contains("partly sunny")) {
      return isNightTime ? "assets/weather_icons/partly_cloudy_night.svg" : "assets/weather_icons/sunny.svg";
    } else if (shortForecast.toLowerCase().contains("blowing")) {
      return "assets/weather_icons/wind.svg";
    } else if (shortForecast.toLowerCase().contains("volcanic")) {
      return "assets/weather_icons/fog.svg";
    } else if (shortForecast.toLowerCase().contains("squalls")) {
      return "assets/weather_icons/fog.svg";
    } else if (shortForecast.toLowerCase().contains("ash")) {
      return "assets/weather_icons/smoke.svg";
    } else if (shortForecast.toLowerCase().contains("sand")) {
      return "assets/weather_icons/fog.svg";
    } else if (shortForecast.toLowerCase().contains("dust")) {
      return "assets/weather_icons/dust.svg";
    } else if (shortForecast.toLowerCase().contains("smoke")) {
      return "assets/weather_icons/smoke.svg";
    } else if (shortForecast.toLowerCase().contains("haze")) {
      return "assets/weather_icons/fog.svg";
    } else if (shortForecast.toLowerCase().contains("mist")) {
      return "assets/weather_icons/mist.svg";
    } else if (shortForecast.toLowerCase().contains("fog")) {
      return "assets/weather_icons/fog.svg";
    } else if (shortForecast.toLowerCase().contains("drizzle")) {
      return "assets/weather_icons/drizzle.svg";
    } else if (shortForecast.toLowerCase().contains("thunderstorm")) {
      return "assets/weather_icons/thunderstorm.svg";
    } else if (shortForecast.toLowerCase().contains("snow")) {
      return "assets/weather_icons/snow.svg";
    } else if (shortForecast.toLowerCase().contains("rain")) {
      return "assets/weather_icons/showers.svg";
    } else if (shortForecast.toLowerCase().contains("cloudy")) {
      return "assets/weather_icons/cloudy.svg";
    } else if (shortForecast.toLowerCase().contains("clear")) {
      return isNightTime ? "assets/weather_icons/clear_night.svg" : "assets/weather_icons/clear.svg";
    } else if (shortForecast.toLowerCase().contains("sunny")) {
      return isNightTime ? "assets/weather_icons/clear_night.svg" : "assets/weather_icons/sunny.svg";
    } else if (shortForecast.toLowerCase().contains("sleet")) {
      return "assets/weather_icons/snow.svg";
    } else if (shortForecast.toLowerCase().contains("hail")) {
      return "assets/weather_icons/snow.svg";
    } else if (shortForecast.toLowerCase().contains("flurries")) {
      return "assets/weather_icons/flurries.svg";
    } else if (shortForecast.toLowerCase().contains("blizzard")) {
      return "assets/weather_icons/blizzard.svg";
    } else if (shortForecast.toLowerCase().contains("ice")) {
      return "assets/weather_icons/fog.svg";
    } else if (shortForecast.toLowerCase().contains("freezing")) {
      return "assets/weather_icons/very_cold.svg";
    } else {
      return "assets/weather_icons/question_mark.svg";
    }
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
