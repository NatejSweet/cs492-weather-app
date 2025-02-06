import 'package:flutter/material.dart';

import 'package:weatherapp/scripts/location.dart' as location;
import 'package:weatherapp/scripts/forecast.dart' as forecast;
import 'package:weatherapp/scripts/time.dart' as time;

import 'package:weatherapp/widgets/forecast_summaries_widget.dart';
import 'package:weatherapp/widgets/forecast_widget.dart';
import 'package:weatherapp/widgets/location_widget.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String title = 'CS492 Weather App';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();


  List<forecast.Forecast> _forecastsHourly = [];
  List<forecast.Forecast> _filteredForecastsHourly= [];
  List<forecast.Forecast> _forecasts = [];
  List<forecast.Forecast> _dailyForecasts = [];
  forecast.Forecast? _activeForecast;
  location.Location? _location;

  @override
  void initState() {
    super.initState();
    setLocation();

  }

  Future<List<forecast.Forecast>> getForecasts(location.Location currentLocation) async {
    return forecast.getForecastFromPoints(currentLocation.latitude, currentLocation.longitude);
  }


  Future<List<forecast.Forecast>> getHourlyForecasts(location.Location currentLocation) async {
    return forecast.getForecastHourlyFromPoints(currentLocation.latitude, currentLocation.longitude);
  }

  void setActiveForecast(int i){
    setState(() {
      _filteredForecastsHourly = getFilteredForecasts(i);
      _activeForecast = _dailyForecasts[i];
    });
  }

  void setActiveHourlyForecast(int i){
    setState(() {
      _activeForecast = _filteredForecastsHourly[i];
    });
  }

  void setDailyForecasts(){
    List<forecast.Forecast> dailyForecasts = [];
    for (int i = 0; i < _forecasts.length-1; i+=2){
      dailyForecasts.add(forecast.getForecastDaily(_forecasts[i], _forecasts[i+1]));
      
    }
    setState(() {
      _dailyForecasts = dailyForecasts;
    });
  }

  List<forecast.Forecast> getFilteredForecasts(int i){
    return _forecastsHourly.where((f)=>time.equalDates(f.startTime, _dailyForecasts[i].startTime)).toList();
  }

  void setLocation([String? city, String? state, String? zip]) async {
    location.Location? currentLocation;
    if (city == null || state == null || zip == null){
      currentLocation = await location.getLocationFromGps();
    }else{
      currentLocation = (await location.getLocationFromAddress(city,state, zip))!;
    }

    List<forecast.Forecast> currentHourlyForecasts = await getHourlyForecasts(currentLocation);
    List<forecast.Forecast> currentForecasts = await getForecasts(currentLocation);

    setState(() {
      _location = currentLocation;
      _forecastsHourly = currentHourlyForecasts;
      _forecasts = currentForecasts;
      setDailyForecasts();
      _filteredForecastsHourly = getFilteredForecasts(0);
      _activeForecast = _forecastsHourly[0];
      });
    }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.sunny_snowing)),
              Tab(icon: Icon(Icons.edit_location_alt))
            ]
          )
        ),
        body:TabBarView(
          children: [ForecastTabWidget(
            location: _location, 
            activeForecast: _activeForecast,
            dailyForecasts: _dailyForecasts,
            filteredForecastsHourly: _filteredForecastsHourly,
            setActiveForecast: setActiveForecast,
            setActiveHourlyForecast: setActiveHourlyForecast),
          LocationTabWidget(
        cityController: cityController,
        stateController: stateController,
        zipController: zipController,
        onSubmit: () => setLocation(cityController.text, stateController.text, zipController.text)
      )]
        ),
      ),
    );
  }
}

class LocationTabWidget extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;
  final VoidCallback onSubmit;

  const LocationTabWidget({
    super.key,
    required this.cityController,
    required this.stateController,
    required this.zipController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const Text("Location Tab"),
            ElevatedButton(
              onPressed: () {
                // Set location to GPS
              },
              child: const Text("Set Location to GPS"),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'City',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: stateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'State',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: zipController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Zip',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onSubmit,
              child: const Text("Set Location"),
            ),
          ],
        ),
      ),
    );
  }
}

class ForecastTabWidget extends StatelessWidget {
  const ForecastTabWidget({
    super.key,
    required location.Location? location,
    required forecast.Forecast? activeForecast,
    required List<forecast.Forecast> dailyForecasts,
    required List<forecast.Forecast> filteredForecastsHourly,
    required Function setActiveForecast,
    required Function setActiveHourlyForecast

  }) : _location = location, 
      _activeForecast = activeForecast,
      _dailyForecasts = dailyForecasts,
      _filteredForecastsHourly = filteredForecastsHourly,
      _setActiveForecast = setActiveForecast,
      _setActiveHourlyForecast = setActiveHourlyForecast;

  final location.Location? _location;
  final forecast.Forecast? _activeForecast;
  final List<forecast.Forecast> _dailyForecasts;
  final List<forecast.Forecast> _filteredForecastsHourly;
  final Function _setActiveForecast;
  final Function _setActiveHourlyForecast;

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
        child: Column(
          children: [
            LocationWidget(location: _location),
            _activeForecast != null ? ForecastWidget(forecast: _activeForecast!) : Text(""),
            _dailyForecasts.isNotEmpty ? ForecastSummariesWidget(forecasts: _dailyForecasts, setActiveForecast: _setActiveForecast) : Text(""),
            _filteredForecastsHourly.isNotEmpty ? ForecastSummariesWidget(forecasts: _filteredForecastsHourly, setActiveForecast: _setActiveHourlyForecast) : Text("")
          ],
        ),
      ),
    );
  }
}