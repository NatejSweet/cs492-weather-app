import 'package:flutter/material.dart';
import 'package:weatherapp/scripts/forecast.dart' as forecast;

class ForecastSummaryWidget extends StatelessWidget {
  const ForecastSummaryWidget({
    super.key,
    required forecast.Forecast currentForecast,
  }) : _forecast = currentForecast;

  final forecast.Forecast _forecast;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Text(
        "${_forecast.name ?? ""}: ",
        style: TextStyle(
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("${_forecast.shortForecast} and "),
        Text("${_forecast.temperature}${_forecast.temperatureUnit}")
        ],
      ),
      const SizedBox(height: 10),
      ],
    );
  }
}
