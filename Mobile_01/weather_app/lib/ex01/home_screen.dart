import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    Text(
      "Currently",
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    ),
    Text(
      "Today",
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    ),
    Text(
      "Weekly",
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    ),
  ];

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
              onPressed: () {},
              icon: const Icon(
                Icons.near_me,
                color: Colors.white,
              ),
            ),
          ],
          title: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.white),
              hintText: 'Search for wether here ... ',
              border: InputBorder.none,
              prefixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  searchController.clear();
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
            ),
            autofocus: true,
            style: const TextStyle(
                fontSize: 17, letterSpacing: 0.5, color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pages.elementAt(_selectedIndex),
              Text(
                searchController.text,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color.fromARGB(198, 110, 111, 183),
          backgroundColor: const Color.fromARGB(179, 240, 237, 237),
          iconSize: 35,
          elevation: 0,
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
