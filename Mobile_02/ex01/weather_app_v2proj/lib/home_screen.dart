import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weather_app_proj/services/city_service.dart';
import 'package:weather_app_proj/services/geolocator.dart';
import 'package:weather_app_proj/utils/views.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ServiceGeolocator serviceGeolocator = ServiceGeolocator();
  final CityService cityService = CityService();
  late final TabController _tabController;
  late final TextEditingController _inputController;
  late String cityNameText;
  late String regionText;
  late String countryText;
  late String searchedTextValue;
  late String currentViewText;

  late List<List<String>> hourlyViewText;
  late List<List<String>> dailyViewText;
  late List<String> displayedCities;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _inputController = TextEditingController();
    searchedTextValue = '';
    currentViewText = '';
    cityNameText = '';
    regionText = '';
    countryText = '';
    hourlyViewText = [
      ['', '', '', '']
    ];
    dailyViewText = [
      ['', '', '', '']
    ];
    displayedCities = [
      'London',
      'Paris',
      'New York',
      'Tokyo',
      'Morocco',
    ];
    _findLocation();
  }

  Future<void> _findLocation() async {
    if (await serviceGeolocator.isLocationEnabled()) {
      final position = await serviceGeolocator.getCurrentPosition();
      final latitude = position.latitude.toString();
      final longitude = position.longitude.toString();

      if (latitude == '' || longitude == '') {
        throw Exception('Error: Location not found !!');
      }
      final weather = await cityService.getWeather(latitude, longitude);
      final hourlyWeather =
          await cityService.getHourlyWeather(latitude, longitude);
      setState(() {
        cityNameText = 'Sao Paulo';
        regionText = 'Sao Paulo';
        countryText = 'Brazil';
        currentViewText = formatCurrentView(weather['current_weather']);
        hourlyViewText = formatHourlyView(hourlyWeather);
        dailyViewText = formattedDailyView(weather['daily']);
      });
      return;
    }
    setState(() {
      cityNameText =
          'Geoloaction is not available, please enable it in your App settings';
    });
  }

  Future<void> _updateCurrentCity(String suggestion) async {
    final elements = suggestion.split(' - ');
    final cityname = elements[0];
    String latitude = '';
    String longitude = '';
    String region = elements[1];
    String country = elements[2];

    for (var city in cityService.results) {
      if (city['name'] == cityname && city['region'] == region) {
        latitude = city['latitude'].toString();
        longitude = city['longitude'].toString();
        continue;
      }
    }
    if (latitude == '' || longitude == '') {
      throw Exception('Error: Location not found');
    }
    final weather = await cityService.getWeather(latitude, longitude);
    final hourlyWeather =
        await cityService.getHourlyWeather(latitude, longitude);
    setState(() {
      cityNameText = cityname;
      regionText = region;
      countryText = country;
      currentViewText = formatCurrentView(weather['current_weather']);
      hourlyViewText = formatHourlyView(hourlyWeather);
      dailyViewText = formattedDailyView(weather['daily']);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                '|',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: () {
                _findLocation();
              },
              icon: const Icon(
                Icons.near_me,
                color: Colors.white,
              ),
            ),
          ],
          title: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _inputController,
              autofocus: true,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: 'Search Location',
              ),
            ),
            suggestionsCallback: (pattern) async {
              return await cityService.getCities(pattern);
            },
            itemBuilder: (context, value) {
              return ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(value),
              );
            },
            onSuggestionSelected: (value) {
              _updateCurrentCity(value);
              setState(() {
                _inputController.text = value;
              });
            },
          ),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(cityNameText),
                      Text(regionText),
                      Text(countryText),
                      Text(currentViewText),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(cityNameText),
                        Text(regionText),
                        Text(countryText),
                        Column(
                          children: List.generate(
                            hourlyViewText.length,
                            (index) {
                              return Row(
                                children: [
                                  Expanded(
                                      child: Text(hourlyViewText[index][0])),
                                  Expanded(
                                      child: Text(hourlyViewText[index][1])),
                                  Expanded(
                                      child: Text(hourlyViewText[index][2])),
                                  Expanded(
                                      child: Text(hourlyViewText[index][3])),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(cityNameText),
                        Text(regionText),
                        Text(countryText),
                        Text(currentViewText),
                        Column(
                          children:
                              List.generate(dailyViewText.length, (index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(child: Text(dailyViewText[index][0])),
                                Expanded(child: Text(dailyViewText[index][1])),
                                Expanded(child: Text(dailyViewText[index][2])),
                                Expanded(child: Text(dailyViewText[index][3])),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: const Color.fromARGB(198, 110, 111, 183),
          iconSize: 35,
          elevation: 2,
          showSelectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.timelapse), label: 'Currently'),
            BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
            BottomNavigationBarItem(
                icon: Icon(Icons.date_range), label: 'Weekly'),
          ],
          currentIndex: _selectedIndex,
          onTap: onTapedTpped,
        ),
      ),
    );
  }

  void onTapedTpped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
