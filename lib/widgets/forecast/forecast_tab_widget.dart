
import 'package:flutter/material.dart';
import 'package:weatherapp/scripts/forecast/forecast.dart' as forecast;
import 'package:weatherapp/scripts/location/location.dart' as location;
import 'package:weatherapp/scripts/time.dart' as time;

import 'package:weatherapp/widgets/location/location_widget.dart';
import 'package:weatherapp/widgets/forecast/forecast_summaries_widget.dart';
import 'package:weatherapp/widgets/forecast/forecast_widget.dart';




class ForecastTabWidget extends StatefulWidget {
  ForecastTabWidget({
    super.key,
    required location.Location? location,
  }) : _location = location;

  final location.Location? _location;

  @override
  State<ForecastTabWidget> createState() => _ForecastTabWidgetState();
}

class _ForecastTabWidgetState extends State<ForecastTabWidget> {
  List<forecast.Forecast> _forecastsHourly = [];
  List<forecast.Forecast> _filteredForecastsHourly = [];
  List<forecast.Forecast> _forecasts = [];
  List<forecast.Forecast> _dailyForecasts = [];
  forecast.Forecast? _activeForecast;

  @override
  void initState() {
    super.initState();
    if (widget._location != null) {
      _initializeForecasts();
    }
  }

  void _initializeForecasts() async {
    if (widget._location != null) {
      _forecastsHourly = await getHourlyForecasts(widget._location!);
      _forecasts = await getForecasts(widget._location!);
      setState(() {
        _activeForecast = _forecasts[0];
      });
      setDailyForecasts();
      setActiveForecast(0);
    }
  }


  // gets the forecast from the location
  Future<List<forecast.Forecast>> getForecasts(
      location.Location currentLocation) async {
    return forecast.getForecastFromPoints(
        currentLocation.latitude, currentLocation.longitude);
  }

  Future<List<forecast.Forecast>> getHourlyForecasts(
      location.Location currentLocation) async {
    return forecast.getForecastHourlyFromPoints(
        currentLocation.latitude, currentLocation.longitude);
  }

  // sets main display forecast
  void setActiveForecast(int i) {
    setState(() {
      _filteredForecastsHourly = getFilteredForecasts(i);
      _activeForecast = _dailyForecasts[i];
    });
  }

  void setActiveHourlyForecast(int i) {
    setState(() {
      _activeForecast = _filteredForecastsHourly[i];
    });
  }

  // sets day by day forecasts
  void setDailyForecasts() {
    List<forecast.Forecast> dailyForecasts = [];
    for (int i = 0; i < _forecasts.length - 1; i += 2) {
      dailyForecasts
          .add(forecast.getForecastDaily(_forecasts[i], _forecasts[i + 1]));
    }
    setState(() {
      _dailyForecasts = dailyForecasts;
    });
  }

  // gets the hourly forecasts for the selected day
  List<forecast.Forecast> getFilteredForecasts(int i) {
    return _forecastsHourly
        .where((f) => time.equalDates(f.startTime, _dailyForecasts[i].startTime))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_forecasts.isEmpty) {
      _initializeForecasts();
    }
    return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
        child: Column(
          children: [
            LocationWidget(location: widget._location),
            _activeForecast != null ? ForecastWidget(forecast: _activeForecast!) : Text(""),
            _dailyForecasts.isNotEmpty ? ForecastSummariesWidget(forecasts: _dailyForecasts, setActiveForecast: setActiveForecast) : Text(""),
            _filteredForecastsHourly.isNotEmpty ? ForecastSummariesWidget(forecasts: _filteredForecastsHourly, setActiveForecast: setActiveHourlyForecast) : Text("")
          ],
        ),
      ),
    );
  }
}