import 'package:weather_app_proj/utils/forcast.dart';

String formatCurrentView(Map<String, dynamic> currnetWeather) {
  return '${currnetWeather['temperature']}°C\n${translateSingleForeCast(currnetWeather['weathercode'])}\n${currnetWeather['windspeed']} Km/h';
}

List<List<String>> formatHourlyView(Map<String, dynamic> hourlyWeather) {
  List<String> time = List<String>.from(hourlyWeather['time']);
  List<double> temperature = List<double>.from(hourlyWeather['temperature']);
  List<int> hourlyWeatherCode = List<int>.from(hourlyWeather['weathercode']);
  List<String> hourlyWeatherForecast = translateForecast(hourlyWeatherCode);

  List<double> windspeed = List<double>.from(hourlyWeather['windspeed']);
  List<List<String>> formattedHourlyView = [];

  for (int i = 0; i < time.length; i++) {
    String hour = time[i].split('T')[1];
    String temp = '${temperature[i].toString()} °C';
    String windSpeed = '${windspeed[i].toString()} Km/h';
    String forecast = hourlyWeatherForecast[i];
    formattedHourlyView.add([hour, temp, forecast, windSpeed]);
  }
  return formattedHourlyView;
}

List<List<String>> formattedDailyView(Map<String, dynamic> dailyWeather) {
  List<String> dailyTime = List<String>.from(dailyWeather['time']);
  List<double> dailyMaxTemp =
      List<double>.from(dailyWeather['temperature_2m_max']);
  List<double> dailyMinTemp =
      List<double>.from(dailyWeather['temperature_2m_min']);
  List<int> dailyWeatherCode = List<int>.from(dailyWeather['weathercode']);
  List<String> dailyWeatherForecast = translateForecast(dailyWeatherCode);

  List<List<String>> formattedDailyView = [];
  for (int i = 0; i < dailyTime.length; i++) {
    String timeZone = dailyTime[i];
    String minTemp = '${dailyMinTemp[i].toString()} °C';
    String maxTemp = '${dailyMaxTemp[i].toString()} °C';
    String forecast = dailyWeatherForecast[i];
    formattedDailyView.add([timeZone, minTemp, maxTemp, forecast]);
  }
  return formattedDailyView;
}
