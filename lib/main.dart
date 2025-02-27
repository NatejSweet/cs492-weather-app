import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/settings_provider.dart';
import 'package:weatherapp/widgets/forecast/forecast_tab_widget.dart';
import 'package:weatherapp/widgets/location/location_tab_widget.dart';
import 'package:weatherapp/providers/location_provider.dart';
import 'package:weatherapp/providers/forecast_provider.dart';
import 'package:weatherapp/themes/themes.dart' as themes;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// TODOS: The TODOs are located in Assignment8-1 in canvas assignments
void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ForecastProvider()),
    ChangeNotifierProvider(
        create: (context) => LocationProvider(
            Provider.of<ForecastProvider>(context, listen: false))),
    ChangeNotifierProvider(create: (context) => SettingsProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String title = 'CS492 Weather App';

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: settingsProvider.lightThemeSeedColor),
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: settingsProvider.darkThemeSeedColor, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: settingsProvider.darkMode ? ThemeMode.dark : ThemeMode.light,
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
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        endDrawer: SettingsDrawer(settingsProvider: settingsProvider),
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              SettingsButton()
            ],
            title: Text(widget.title),
            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.sunny_snowing)),
              Tab(icon: Icon(Icons.edit_location_alt))
            ])),
        body: TabBarView(children: [ForecastTabWidget(), LocationTabWidget()]),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {Scaffold.of(context).openEndDrawer();});
  }
}

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({
    super.key,
    required this.settingsProvider,
  });

  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Switch(
                value: settingsProvider.darkMode,
                onChanged: (bool value) {
                  settingsProvider.toggleMode();
                },
              ),
            ],
          ),
            ColorPicker(pickerColor: settingsProvider.darkMode ? settingsProvider.darkThemeSeedColor : settingsProvider.lightThemeSeedColor, onColorChanged: (color) => settingsProvider.setSeedColor(color)),
          ],)
    );
  }
}