import 'package:flutter/material.dart';
import 'package:weather_app_proj/services/city_service.dart';

class Autocomplet extends StatefulWidget {
  const Autocomplet({super.key});

  static List<String> _kOptions = <String>[
    'Paris',
    'London',
    'New York',
  ];

  @override
  State<Autocomplet> createState() => _AutocompletState();
}

class _AutocompletState extends State<Autocomplet> {
  final CityService cityService = CityService();

  Future<void> _findCities(String searchText) async {
    if (searchText.length > 4) {
      final newOptions = await cityService.getCities(searchText);
      debugPrint('New Options: $newOptions');
      setState(() {
        Autocomplet._kOptions = newOptions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return Autocomplet._kOptions.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textController,
          FocusNode focusNode,
          VoidCallback onfieldSubmitted) {
        return TextField(
          controller: textController,
          onChanged: (value) {
            debugPrint('Status changed $value');
            _findCities(value);
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
