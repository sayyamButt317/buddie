import 'package:flutter/material.dart';

class Availability extends StatefulWidget {
  const Availability({super.key});

  @override
  State<Availability> createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {
  final _chooseTime = [
    'Choose Tim',
    '7:30am',
    '7:45am',
    '8:00am',
    '8:15am',
    '8:30am'
  ];
  String? _selectedTime;

  final _locationOptions = [
    'Choose Location'
        'Student Center East',
    'School of Design',
    'Richard Dailey Library out Front',
    'Choose on Map'
  ];
  String? _selectedlocation;
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
                "Pick Your Availability",
                style: TextStyle(
                    fontSize: 28, height: 1.8, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Choose Time',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: _selectedTime,
                items: _chooseTime.map((time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTime = value;
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
                  hintText: 'Choose on Map',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: _selectedlocation,
                items: _locationOptions.map((location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedlocation = value;
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
                    onPressed: () {
                      Navigator.pop(context, {
                        'Time': _chooseTime,
                        'Location': _locationOptions,
                      });
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
