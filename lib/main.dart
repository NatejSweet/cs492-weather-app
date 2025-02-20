import 'package:flutter/material.dart';

import 'package:weatherapp/scripts/location/location.dart' as location;
import 'package:weatherapp/scripts/forecast/forecast.dart' as forecast;
import 'package:weatherapp/scripts/time.dart' as time;
import 'package:weatherapp/widgets/forecast/forecast_tab_widget.dart';
import 'package:weatherapp/widgets/location/location_tab_widget.dart';

// TODO: With a partner, refactor the entire codebase (not just main.dart, every file)
// You should be looking for opportunities to make the code better
// Examples include (but are not limited to): Abstraction, Code Structure, Naming Conventions, Code Optimization, Redundant Code Removal, File names/directories
// You should be working with a partner. One person should be making changes to the code and the other should be documenting those changes in documentation/refactor.txt

void main() {
  runApp(const MyApp());
}

// Title and color scheme
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

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  location.Location? _location;

  @override
  void initState() {
    super.initState();
    if (_location == null) {
      setInitialLocation();
    }
  }

  // sets _location to the gps location
  void setInitialLocation() async {
    setLocation(await location.getLocationFromGps());
  }

  void setLocation(location.Location? currentLocation) async {
    setState(() {
      _location = currentLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.sunny_snowing)),
            Tab(icon: Icon(Icons.edit_location_alt))
          ]),
        ),
        body: TabBarView(
          children: [
            ForecastTabWidget(location: _location),
            LocationTabWidget(setLocation: setLocation, activeLocation: _location)
          ],
        ),
      ),
    );
  }
}
