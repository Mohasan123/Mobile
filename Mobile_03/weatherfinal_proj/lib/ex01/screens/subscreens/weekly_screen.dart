import 'package:flutter/material.dart';
import 'package:open_meteo/open_meteo.dart';
import 'package:weather_icons/weather_icons.dart';

class WeeklyScreen extends StatelessWidget {
  const WeeklyScreen({
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

  String getWeatherDescription(
      num rain, num snowfall, num showers, num windSpd) {
    if (snowfall > 0) {
      return "Snowy";
    } else if (rain > 0 || showers > 0) {
      return "Rainy";
    } else if (windSpd > 38) {
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
      case "Windy":
        return WeatherIcons.strong_wind;
      case "Clear":
      default:
        return WeatherIcons.day_sunny;
    }
  }

  List<Map<String, dynamic>> getWeeklyWeather() {
    final tempMinValues = weatherData[WeatherDaily.temperature_2m_min]?.values
            as Map<DateTime, num>? ??
        {};
    final tempMaxValues = weatherData[WeatherDaily.temperature_2m_max]?.values
            as Map<DateTime, num>? ??
        {};
    final rainValue =
        weatherData[WeatherDaily.rain_sum]?.values as Map<DateTime, num>? ?? {};
    final snowValue =
        weatherData[WeatherDaily.snowfall_sum]?.values as Map<DateTime, num>? ??
            {};
    final showersValue =
        weatherData[WeatherDaily.showers_sum]?.values as Map<DateTime, num>? ??
            {};
    final windSpdValue = weatherData[WeatherDaily.wind_speed_10m_max]?.values
            as Map<DateTime, num>? ??
        {};

    final todayMinTemp = tempMinValues.entries.take(7).toList();
    final todayMaxTemp = tempMaxValues.entries.take(7).toList();
    final todayRain = rainValue.entries.take(7).toList();
    final todaySnow = snowValue.entries.take(7).toList();
    final todayShowers = showersValue.entries.take(7).toList();
    final todayWindSpd = windSpdValue.entries.take(7).toList();

    List<Map<String, dynamic>> weeklyWeatherList = [];
    for (int i = 0; i < todayMinTemp.length; i++) {
      if (i < todayMaxTemp.length &&
          i < todayRain.length &&
          i < todaySnow.length &&
          i < todayShowers.length &&
          i < todayWindSpd.length) {
        final date = todayMinTemp[i].key.toString().split(" ").first;
        final minTemp =
            "${(todayMinTemp[i].value as num?)?.toStringAsFixed(1)} ºC";
        final maxTemp =
            "${(todayMaxTemp[i].value as num?)?.toStringAsFixed(1)} ºC";
        final desc = getWeatherDescription(
          todayRain[i].value,
          todaySnow[i].value,
          todayShowers[i].value,
          todayWindSpd[i].value,
        );

        weeklyWeatherList.add({
          'date': date,
          'minTemp': minTemp,
          'maxTemp': maxTemp,
          'description': desc,
          'windSpeed': todayWindSpd[i].value,
        });
      }
    }
    return weeklyWeatherList;
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
                      itemCount: getWeeklyWeather().length,
                      itemBuilder: (BuildContext context, int index) {
                        final weather = getWeeklyWeather()[index];
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
                              weather['date'],
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
                                  '${weather['minTemp']} / ${weather['maxTemp']} ºC',
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
                ],
              ),
      ),
    );
  }
}
