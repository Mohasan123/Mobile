import 'dart:async';

import 'package:flutter/material.dart';

import 'package:weatherfinal_proj/services/location_service.dart';
import 'package:weatherfinal_proj/services/open_meteo_service.dart';
import 'package:weatherfinal_proj/widgets/search_field.dart';

import 'subscreens/currently_screen.dart';
import 'subscreens/today_screen.dart';
import 'subscreens/weekly_screen.dart';

class WeatherScreenEx01 extends StatefulWidget {
  const WeatherScreenEx01({super.key});

  @override
  State<WeatherScreenEx01> createState() => _WeatherScreenEx01State();
}

class _WeatherScreenEx01State extends State<WeatherScreenEx01>
    with TickerProviderStateMixin {
  int screenIndex = 0;
  TabController? controller;
  TextEditingController textController = TextEditingController();
  final locationService = LocationService.instance;
  final meteoService = OpenMeteoService.instance;

  Map hourlyWeatherData = {};
  Map currentWeatherData = {};
  Map dailyWeatherData = {};
  Map<String, dynamic> location = {};
  String? error;

  void onLocationIconPressed() async {
    setState(() {
      textController.clear();
    });
    await initLocationService();
  }

  void onDestinationChanged(index) {
    setState(() {
      screenIndex = index;
    });
    controller?.animateTo(index);
  }

  Future<void> initLocationService() async {
    setState(() {
      error = null;
      hourlyWeatherData = {};
      currentWeatherData = {};
      dailyWeatherData = {};
      location = {};
    });
    try {
      final locationData = await locationService.getLocation();
      if (locationData != null) {
        error = null;
        final lc = {
          "name": "My Location",
          "latitude": locationData.latitude ?? 0,
          "longitude": locationData.longitude ?? 0,
        };
        onGetWeatherForLocation(lc);
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        hourlyWeatherData = {};
        currentWeatherData = {};
        dailyWeatherData = {};
        location = {};
      });
    }
  }

  Future<void> onGetWeatherForLocation(Map<String, dynamic> location) async {
    if (location["latitude"] == null || location["longitude"] == null) return;

    setState(() {
      error = null;
      this.location = location;
    });

    final weather = await meteoService.getWeather(
      location["latitude"],
      location["longitude"],
    );

    if (weather == null) {
      setState(() {
        error = "Failed to get weather\nCheck your internet and try again!";
      });
    } else {
      setState(() {
        hourlyWeatherData = weather.hourlyData;
        currentWeatherData = weather.currentData;
        dailyWeatherData = weather.dailyData;
      });
    }
  }

  @override
  void initState() {
    initLocationService();
    controller = TabController(length: 3, vsync: this);
    controller?.addListener(() {
      setState(() {
        screenIndex = controller!.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(27, 34, 68, 1),
            foregroundColor: const Color.fromRGBO(15, 18, 41, 1),
            titleSpacing: 0,
            title: SearchField(
              optionsBuilder: onBuildOptions,
              onSetTextController: (controller) {
                textController = controller;
              },
              onTextChanged: (v) {},
              onTextSubmitted: (v) {},
              onSelected: (selected) {
                FocusScope.of(context).unfocus();
                onGetWeatherForLocation(selected);
                print(selected);
              },
            ),
            actions: [
              IconButton(
                onPressed: onLocationIconPressed,
                icon: const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Image.asset(
                "assets/weather.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: TabBarView(
                  controller: controller,
                  children: [
                    CurrentlyScreen(
                      weatherData: currentWeatherData,
                      location: location,
                      error: error,
                    ),
                    TodayScreen(
                      weatherData: hourlyWeatherData,
                      location: location,
                      error: error,
                    ),
                    WeeklyScreen(
                      weatherData: dailyWeatherData,
                      location: location,
                      error: error,
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            backgroundColor: const Color.fromRGBO(15, 18, 41, 1),
            selectedIndex: screenIndex,
            indicatorColor: Colors.white30,
            onDestinationSelected: onDestinationChanged,
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.sunny,
                  color: Colors.white70,
                ),
                label: "Currently",
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.white70,
                ),
                label: "Today",
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white70,
                ),
                label: "Weekly",
              ),
            ],
          )),
    );
  }

  FutureOr<Iterable<Map<String, dynamic>>> onBuildOptions(
      TextEditingValue value) async {
    final trimmed = value.text.trim();
    if (trimmed.isEmpty) return [];
    final suggestions = await meteoService.getGeo(trimmed);
    if (suggestions == null) {
      setState(() {
        error =
            "Failed to get geolocations\nCheck your internet and try again!";
      });
    } else if (suggestions.isEmpty) {
      setState(() {
        error =
            "The city you entered couldn't be found, please enter valid city name!";
      });
    }
    return suggestions ?? [];
  }
}
