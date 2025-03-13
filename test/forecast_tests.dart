import 'package:test/test.dart';
import 'package:weatherapp/models/forecast.dart';

void main(){
  test("Testing getIconPath()", testIconPath);
  test("Test toString()", testToString);
  test("Test coords", testGetForecasts);
}

void testIconPath() {
  Forecast forecast = getMockForecast();
  expect(forecast.getIconPath(), "assets/weather_icons/clear.svg");
}

void testToString() {
  Forecast forecast = getMockForecast();
  String forecastString = forecast.toString();
  expect(forecastString.contains("temperature: 120"), true);
}

void testGetForecasts() async {
  List<Forecast> forecasts = await getForecastHourlyFromPoints(42, -122);
  expect(forecasts.length, 156, reason: "Checking to see if return is 2 x 7");
  expect(forecasts[0].detailedForecast, null);
  
}


Forecast getMockForecast(){
  return Forecast(name: "This Forecast", 
    isDaytime: false, 
    temperature: 120, 
    temperatureUnit: "F", 
    windSpeed: "200MPH", 
    windDirection: "SSE", 
    shortForecast: "It's clear.", 
    detailedForecast: "More details about how sunny it is", 
    precipitationProbability: 4, 
    humidity: 2, 
    dewpoint: 5, 
    startTime: DateTime.now(), 
    endTime: DateTime.now(), 
    tempHighLow: null);
}