import 'package:flutter/material.dart';
import 'package:weatherapp/scripts/forecast.dart' as forecast;
import 'package:weatherapp/widgets/forecast_summary_widget.dart';

class ForecastSummariesWidget extends StatelessWidget {
  const ForecastSummariesWidget({
    super.key,
    required List<forecast.Forecast> currentForecasts,
  }) : _forecasts = currentForecasts;

  final List<forecast.Forecast> _forecasts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var forecast in _forecasts)
          ForecastSummaryWidget(currentForecast: forecast),
      ],
    );
  }
}
