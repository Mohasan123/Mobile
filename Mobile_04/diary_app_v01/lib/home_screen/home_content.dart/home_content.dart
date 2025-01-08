import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Map<String, String>> diaryEntries = [
    {
      'title': 'First Diary Entry',
      'content': 'Today was a great day...',
      'date': '2024-10-12',
      'emoji': '🤔'
    }
  ];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController();

  // List of predefined emojis for easy selection
  final List<String> emojiList = [
    '😊',
    '😍',
    '🥰',
    '😎',
    '🤔',
    '😢',
    '😡',
    '😴',
    '🤩',
    '😱'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 25.0),
          Center(
            child: Text(
              'Your last Diary entries',
              style: GoogleFonts.caveat(
                textStyle: const TextStyle(
                  fontSize: 45,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              itemCount: diaryEntries.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  width: 500,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(76, 177, 81, 1),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              diaryEntries[index]['emoji'] ?? '🤔',
                              style: const TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(diaryEntries[index]['title'] ?? 'Untitled',
                                style: GoogleFonts.caveat(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            const SizedBox(height: 5.0),
                            Text(
                              'Date: ${diaryEntries[index]['date'] ?? ''}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 35.0),
                        const VerticalDivider(
                          thickness: 3.0,
                          color: Colors.white60,
                        ),
                        const SizedBox(width: 35.0),
                        Flexible(
                          child: Text(
                            diaryEntries[index]['content'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddDiaryDialog();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(76, 177, 81, 1),
                  minimumSize: const Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )),
              child: const Text(
                'New Diary Entry',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDiaryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: const Color.fromRGBO(76, 177, 81, 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              insetPadding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Add an Entry',
                        style: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                        )),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        style: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        )),
                        strutStyle: StrutStyle.fromTextStyle(
                          GoogleFonts.dosis(
                              textStyle: const TextStyle(
                            fontSize: 25,
                            color: Colors.black54,
                          )),
                        ),
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: "Title",
                          hintStyle: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              color: Colors.black54,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Select Mood Emoji',
                        style: GoogleFonts.dosis(
                          textStyle: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: emojiList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _emojiController.text = emojiList[index];
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  emojiList[index],
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        style: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        )),
                        maxLines: 4,
                        strutStyle: StrutStyle.fromTextStyle(
                          GoogleFonts.dosis(
                              textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                          )),
                        ),
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: "Text",
                          hintStyle: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              color: Colors.black54,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(100, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                )),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.dosis(
                                textStyle: const TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(76, 177, 81, 1),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(100, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                )),
                            onPressed: () {
                              if (_titleController.text.isNotEmpty &&
                                  _descriptionController.text.isNotEmpty) {
                                setState(() {
                                  diaryEntries.add({
                                    'title': _titleController.text,
                                    'content': _descriptionController.text,
                                    'date':
                                        DateTime.now().toString().split(' ')[0],
                                    'emoji': _emojiController.text.isNotEmpty
                                        ? _emojiController.text
                                        : '😊'
                                  });
                                  _titleController.clear();
                                  _descriptionController.clear();
                                  _emojiController.clear();
                                });
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              "Add",
                              style: GoogleFonts.dosis(
                                textStyle: const TextStyle(
                                  fontSize: 30,
                                  color: Color.fromRGBO(76, 177, 81, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}
