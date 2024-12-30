import 'dart:convert';
import 'package:http/http.dart' as http;

class CityService {
  late List<Map<String, dynamic>> results;
  Future<Map<String, dynamic>> getWeather(
      String latitude, String longitude) async {
    final encodedLongitude = Uri.encodeQueryComponent(longitude);
    final encodedLatitude = Uri.encodeQueryComponent(latitude);

    final apiUrl =
        'https://api.open-meteo.com/v1/forecast?latitude=$encodedLatitude&longitude=$encodedLongitude&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=GMT&current_weather=true';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['current_weather'].isEmpty) {
        throw Exception('Location not found');
      }
      return data;
    } else {
      throw Exception('Failed to fetch  data');
    }
  }

  Future<Map<String, dynamic>> getHourlyWeather(
      String latitude, String longitude) async {
    final encodedLongitude = Uri.encodeQueryComponent(longitude);
    final encodedLatitude = Uri.encodeQueryComponent(latitude);
    final apiUrl =
        'https://api.open-meteo.com/v1/forecast?latitude=$encodedLatitude&longitude=$encodedLongitude&hourly=temperature_2m,weathercode,windspeed_10m&timezone=GMT';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['hourly'].isEmpty) {
          throw Exception('Location not found');
        }
        final hourly = data['hourly'];

        //24 hours maximum
        List<String> time = List<String>.from(hourly['time'].take(24));
        List<double> temperature =
            List<double>.from(hourly['temperature_2m'].take(24));
        List<double> windespeed =
            List<double>.from(hourly['windspeed_10m'].take(24));
        List<int> weatherCode = List<int>.from(hourly['weathercode'].take(24));

        Map<String, dynamic> first24Entries = {
          'time': time,
          'temperature': temperature,
          'weathercode': weatherCode,
          'windspeed': windespeed,
        };
        return first24Entries;
      } else {
        throw Exception('Failed to fetch  data');
      }
    } catch (e) {
      throw Exception('Failed to fetch  data');
    }
  }

  Future<List<dynamic>> get_cityResults(String cityName) async {
    try {
      final encodedCityName = Uri.encodeComponent(cityName);
      final apiUrl =
          'https://geocoding-api.open-meteo.com/v1/search?name=$encodedCityName&count=5&language=en&format=json';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('results') == false) {
          data['results'] = [];
        }
        return data['results'];
  
      }
      throw Exception('failed to fetch data');
    } catch (e) {
      throw Exception('failed to fetch data');
    }
  }

  Future<List<String>> getCities(String cityName) async {
    if (cityName.isEmpty || cityName.length < 3 || cityName.length > 12) {
      return [];
    }
    try {
      final tempResults = await get_cityResults(cityName);
      if (tempResults.isEmpty) {
        throw Exception('Location not found');
      }
      results = tempResults.map((rslt) {
        return {
          'name': rslt['name'],
          'region': rslt['region'],
          'country': rslt['country'],
          'latitude': rslt['latitude'],
          'longitude': rslt['longitude'],
        };
      }).toList();

      List<String> cities = results.map((rslt) {
        return '${rslt['name']} - ${rslt['region']} - ${rslt['country']}';
      }).toList();

      cities = cities.map((city) {
        return city.replaceAll('null', 'Unknown');
      }).toList();
      return cities;
    } catch (e) {
      throw Exception('Failed to fetch Data');
    }
  }
}
