# Project Name: CS492 Weather App
### Refactor Date: 2/20/2025
### Refactorers: 
`Daniel Lounsbury`, `Nathan Sweet`, `Tristan Hook`



## File Tree Changes:
In the `lib/scripts`and `lib/widgets`folders: create new subdirectories called `forecast/` and `location/`.


### File Changes 

`lib/main.dart`:

- Add code comments/documentation for functions

- Move forecast-related functions and variables to `lib/widgets/forecast/forecast_tab_widget.dart`

`lib/widgets/location/location_tab_widget.dart`:
- removed unused/commented out functions
- removed mentions/usage of `location_storage.dart`

`forecast.dart`:

  - Change <span style="color:#DCDCAA">getIconPath</span> function to use dictionary of JSON keys

  
`location_tab_widget.dart`

`location.dart`:


### File Tree Changes

- removed `lib/scipts/location/location_storage.dart`






- Covert <span style="color:#4EC9B0">ForecastTabWidget</span> to a <span style="color:#4EC9B0">Stateful</span> widget so it can hold its own forecast-related variable values


![Alt Text](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExd3Jlc3JnODJzYml4aGF0ZGZ0ZmQ1eXhpZjc2M3Z3bGs0dm41bngzbiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/hTC6BDL04MTQtKjGTl/giphy.gif)






