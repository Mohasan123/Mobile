import 'package:flutter/material.dart';
import 'package:open_meteo/open_meteo.dart';
import 'package:weather_icons/weather_icons.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({
    super.key,
    required this.weatherData,
    required this.location,
    this.error,
  });

  final Map<String, dynamic> location;
  final Map weatherData;
  final String? error;

  String getWeatherDescription(
    num rain,
    num snowfall,
    num showers,
    num cloudCover,
    num windSpeed,
  ) {
    if (snowfall > 0) {
      return "Snowy";
    } else if (rain > 0 || showers > 0) {
      return "Rainy";
    } else if (cloudCover > 0) {
      return "Cloudy";
    } else if (windSpeed > 38) {
      return "Windy";
    } else {
      return "Clear";
    }
  }

  IconData getWeatherIcon(String description) {
    switch (description) {
      case "Snowy":
        return WeatherIcons.snow;
      case "Rainy":
        return WeatherIcons.rain;
      case "Cloudy":
        return WeatherIcons.cloudy;
      case "Windy":
        return WeatherIcons.strong_wind;
      case "Clear":
      default:
        return WeatherIcons.day_sunny;
    }
  }

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

  List<Map<String, dynamic>> getTodayTemp() {
    final tempValues = weatherData[WeatherHourly.temperature_2m]?.values
            as Map<DateTime, num>? ??
        {};
    final windSpdValue = weatherData[WeatherHourly.wind_speed_10m]?.values
            as Map<DateTime, num>? ??
        {};
    final rainValue =
        weatherData[WeatherHourly.rain]?.values as Map<DateTime, num>? ?? {};
    final snowValue =
        weatherData[WeatherHourly.snowfall]?.values as Map<DateTime, num>? ??
            {};
    final showersValue =
        weatherData[WeatherHourly.showers]?.values as Map<DateTime, num>? ?? {};
    final cloudsValue =
        weatherData[WeatherHourly.cloud_cover]?.values as Map<DateTime, num>? ??
            {};

    final todayTemp = tempValues.entries.take(24).toList();
    final todayWindSpd = windSpdValue.entries.take(24).toList();
    final todayRain = rainValue.entries.take(24).toList();
    final todaySnow = snowValue.entries.take(24).toList();
    final todayShowers = showersValue.entries.take(24).toList();
    final todayClouds = cloudsValue.entries.take(24).toList();

    List<Map<String, dynamic>> todayWeatherList = [];
    for (int i = 0; i < todayTemp.length; i++) {
      if (i < todayWindSpd.length &&
          i < todayRain.length &&
          i < todaySnow.length &&
          i < todayShowers.length &&
          i < todayClouds.length) {
        final time = todayTemp[i].key;
        final temp = todayTemp[i].value;
        final windSpd = todayWindSpd[i].value;
        final desc = getWeatherDescription(
          todayRain[i].value,
          todaySnow[i].value,
          todayShowers[i].value,
          todayClouds[i].value,
          todayWindSpd[i].value,
        );

        todayWeatherList.add({
          'time': time,
          'temp': temp,
          'windSpeed': windSpd,
          'description': desc,
        });
      }
    }
    return todayWeatherList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: error != null
            ? Text(
                error ?? "Error",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.redAccent,
                      height: 1.5,
                    ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getLocationString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: getTodayTemp().length,
                      itemBuilder: (BuildContext context, int index) {
                        final weather = getTodayTemp()[index];
                        return Card(
                          color: Colors.white.withOpacity(0.1),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ListTile(
                            leading: Icon(
                              getWeatherIcon(weather['description']),
                              color: Colors.white,
                              size: 32,
                            ),
                            title: Text(
                              '${weather['time'].hour.toString().padLeft(2, '0')}:${weather['time'].minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              weather['description'],
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${weather['temp'].toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${weather['windSpeed'].toStringAsFixed(1)} km/h',
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // if (location.isNotEmpty) const SizedBox(height: 16),
                  // if (location.isNotEmpty)
                  //   for (final item in getTodayTemp())
                  //     Text(
                  //       item,
                  //       textAlign: TextAlign.start,
                  //       style: Theme.of(context).textTheme.headlineSmall,
                  //     ),
                ],
              ),
      ),
    );
  }
}
