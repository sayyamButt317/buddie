import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  String? _selectedLanguage;
  String? _selectedEthnicity;
  String? _selectedMajor;
  String? _selectedAge;

  final List<Map<String, dynamic>> items = [
    {
      'name': 'John',
      'age': 25,
      'language': 'English',
      'ethnicity': 'Caucasian',
      'major': 'Computer Science'
    },
    {
      'name': 'Jane',
      'age': 30,
      'language': 'Spanish',
      'ethnicity': 'Hispanic & Latino',
      'major': 'Graphic Design'
    },
    {
      'name': 'Bob',
      'age': 40,
      'language': 'Urdu',
      'ethnicity': 'Asian',
      'major': 'Architecture'
    },
    {
      'name': 'Mary',
      'age': 20,
      'language': 'French',
      'ethnicity': 'African American',
      'major': 'Psychology'
    },
  ];

  final List<String> _languageOptions = [
    'English',
    'Spanish',
    'Urdu',
    'French'
  ];
  final List<String> _ethnicityOptions = [
    'Caucasian',
    'Hispanic & Latino',
    'Asian',
    'African American'
  ];
  final List<String> _majorOptions = [
    'Computer Science',
    'Graphic Design',
    'Architecture',
    'Psychology'
  ];
  final List<String> _ageOptions = ['18-24', '25-34', '35-44', 'Above 35'];

  List<Map<String, dynamic>> applyFilter() {
    List<Map<String, dynamic>> filteredItems = List.from(items);

    if (_selectedLanguage != null) {
      filteredItems = filteredItems
          .where((item) => item['language'] == _selectedLanguage)
          .toList();
    }

    if (_selectedEthnicity != null) {
      filteredItems = filteredItems
          .where((item) => item['ethnicity'] == _selectedEthnicity)
          .toList();
    }

    if (_selectedMajor != null) {
      filteredItems = filteredItems
          .where((item) => item['major'] == _selectedMajor)
          .toList();
    }

    if (_selectedAge != null) {
      switch (_selectedAge) {
        case '18-24':
          filteredItems = filteredItems
              .where((item) => item['age'] >= 18 && item['age'] <= 24)
              .toList();
          break;
        case '25-34':
          filteredItems = filteredItems
              .where((item) => item['age'] >= 25 && item['age'] <= 34)
              .toList();
          break;
        case '35-44':
          filteredItems = filteredItems
              .where((item) => item['age'] >= 35 && item['age'] <= 44)
              .toList();
          break;
        case 'Above 35':
          filteredItems =
              filteredItems.where((item) => item['age'] > 35).toList();
          break;
      }
    }

    return filteredItems;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image(
          image: const AssetImage(
            "images/Buddie.png",
          ),
          height: height * 0.05,
        ),
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Filters",
                style: TextStyle(
                    fontSize: 28, height: 1.8, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Select Language',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: _selectedLanguage,
                items: _languageOptions.map((language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
              ),
            ),
            Container(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Ethnicity',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: _selectedEthnicity,
                items: _ethnicityOptions.map((ethnicity) {
                  return DropdownMenuItem<String>(
                    value: ethnicity,
                    child: Text(ethnicity),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEthnicity = value;
                  });
                },
              ),
            ),
            Container(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Age',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: _selectedAge,
                items: _ageOptions.map((age) {
                  return DropdownMenuItem<String>(
                    value: age,
                    child: Text(age),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAge = value;
                  });
                },
              ),
            ),
            Container(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Major',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: _selectedMajor,
                items: _majorOptions.map((major) {
                  return DropdownMenuItem<String>(
                    value: major,
                    child: Text(major),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMajor = value;
                  });
                },
              ),
            ),
            Container(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, {
                          'ethnicity': _selectedEthnicity,
                          'major': _selectedMajor,
                          'age': _selectedAge,
                          'language': _languageOptions
                        });
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
