import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_meteo/open_meteo.dart';
import 'package:weather_icons/weather_icons.dart';

class CurrentlyScreen extends StatelessWidget {
  CurrentlyScreen({
    super.key,
    required this.weatherData,
    required this.location,
    this.error,
  });

  final Map<String, dynamic> location;
  final Map weatherData;
  final String? error;

  String getLocationString() {
    String locStr = "";
    locStr += (location["name"] ?? "Getting location...");
    if (location["admin1"] != null) {
      locStr += "\n${location["admin1"]}";
    }
    if (location["country"] != null) {
      locStr += "\n${location["country"]}";
    }
    return locStr;
  }

  String getCurrentWindSpeed() {
    final value = weatherData[WeatherCurrent.wind_speed_10m]?.value ?? {};
    return "${(value as num?)?.toStringAsFixed(1) ?? "N/A"} km/h";
  }

  String getCurrentTemp() {
    final value = weatherData[WeatherCurrent.temperature_2m]?.value;
    return "${(value as num?)?.toStringAsFixed(1) ?? "N/A"} ºC";
  }

  IconData getWeatherIcon() {
    final r = weatherData[WeatherCurrent.rain]?.value;
    final s = weatherData[WeatherCurrent.snowfall]?.value;
    final sh = weatherData[WeatherCurrent.showers]?.value;
    final c = weatherData[WeatherCurrent.cloud_cover]?.value;
    final w = weatherData[WeatherCurrent.wind_speed_10m]?.value;

    if (s > 0) {
      return WeatherIcons.snow;
    } else if (r > 0 || sh > 0) {
      return WeatherIcons.rain;
    } else if (c > 0) {
      return WeatherIcons.cloudy;
    } else if (w > 38) {
      return WeatherIcons.strong_wind;
    } else {
      return WeatherIcons.day_sunny;
    }
  }

  String getCurrentDescription() {
    final r = weatherData[WeatherCurrent.rain]?.value;
    final s = weatherData[WeatherCurrent.snowfall]?.value;
    final sh = weatherData[WeatherCurrent.showers]?.value;
    final c = weatherData[WeatherCurrent.cloud_cover]?.value;
    final w = weatherData[WeatherCurrent.wind_speed_10m]?.value;

    if (s != null && s > 0) {
      return "Snowy";
    } else if (r != null && r > 0 || sh != null && sh > 0) {
      return "Rainy";
    } else if (c != null && c > 0) {
      return "Cloudy";
    } else if (w != null && w > 38) {
      return "Windy";
    } else {
      return "Clear";
    }
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: Colors.white),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  final TextStyle dataTextStyle = const TextStyle(
    color: Colors.white, // Change to your desired color
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 42),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getWeatherGradient(),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: error != null
                ? Text(
                    error ?? "Error",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.error,
                        ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getLocationString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            fontSize: 25.0,
                          ),
                        ),
                        if (location.isNotEmpty) const SizedBox(height: 25.0),
                        if (location.isNotEmpty)
                          weatherData.isEmpty
                              ? const SpinKitCircle(
                                  color: Colors.white,
                                  size: 48.0,
                                )
                              : Column(
                                  children: [
                                    Icon(
                                      getWeatherIcon(),
                                      size: 64,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      getCurrentDescription(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildWeatherDetail(
                                          WeatherIcons.thermometer,
                                          getCurrentTemp(),
                                          'Temperature',
                                        ),
                                        _buildWeatherDetail(
                                          WeatherIcons.strong_wind,
                                          getCurrentWindSpeed(),
                                          'Wind Speed',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  List<Color> _getWeatherGradient() {
    switch (getCurrentDescription()) {
      case "Snowy":
        return [Colors.lightBlue[100]!, Colors.lightBlue[300]!];
      case "Rainy":
        return [Colors.blueGrey[400]!, Colors.blueGrey[600]!];
      case "Cloudy":
        return [Colors.grey[300]!, Colors.grey[500]!];
      case "Windy":
        return [Colors.teal[200]!, Colors.teal[400]!];
      case "Clear":
        return [Colors.blue[500]!, Colors.blue[200]!];
      default:
        return [Colors.blue[300]!, Colors.blue[500]!];
    }
  }
}
