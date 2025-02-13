import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/UserState.dart';

class FiltersPage extends StatefulWidget {
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  RangeValues _ageRange = const RangeValues(18, 50);
  String? _selectedGender;
  double _selectedHeight = 160;
  String? _selectedBodyColor;

  final List<String> _genders = ["Male", "Female", "Other"];
  final List<String> _bodyColors = ["Fair", "Medium", "Dark"];

  void _applyFilters() {
    Map<String, dynamic> filters = {
      "ageRange": {
        "min": _ageRange.start.round(),
        "max": _ageRange.end.round(),
      },
      "gender": _selectedGender ?? "Any",
      "height": _selectedHeight.round(),
      "bodyColor": _selectedBodyColor ?? "Any",
    };

    Provider.of<UserState>(context, listen: false).setSelectedFilters(filters);
    Navigator.pop(context);
  }

  Widget _buildSliderWithButtons({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF081B48))),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle, color: Color(0xFF081B48)),
                onPressed: () => setState(() {
                  if (value > min) onChanged(value - 1);
                }),
              ),
              Expanded(
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: (max - min).toInt(),
                  label: value.round().toString(),
                  onChanged: onChanged,
                  activeColor: Color(0xFF081B48),
                  inactiveColor: Colors.grey[300],
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: Color(0xFF081B48)),
                onPressed: () => setState(() {
                  if (value < max) onChanged(value + 1);
                }),
              ),
            ],
          ),
          Center(
            child: Text(value.round().toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        title: const Text("Filters"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF081B48)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Age Range
            _buildSliderWithButtons(
              label: "Age Range",
              value: _ageRange.end,
              min: 18,
              max: 100,
              onChanged: (value) => setState(() {
                _ageRange = RangeValues(_ageRange.start, value);
              }),
            ),

            SizedBox(height: 15),
            // Gender
            Text("Gender", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF081B48))),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _genders.map((gender) {
                return ChoiceChip(
                  label: Text(gender),
                  selected: _selectedGender == gender,
                  onSelected: (selected) {
                    setState(() {
                      _selectedGender = selected ? gender : null;
                    });
                  },
                  selectedColor: Color(0xFF081B48),
                  backgroundColor: Colors.grey[300],
                  labelStyle: TextStyle(color: _selectedGender == gender ? Colors.white : Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 15),
            // Height Selector
            _buildSliderWithButtons(
              label: "Height (cm)",
              value: _selectedHeight,
              min: 140,
              max: 200,
              onChanged: (value) => setState(() => _selectedHeight = value),
            ),

            SizedBox(height: 15),
            // Body Color
            Text("Body Color", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF081B48))),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _bodyColors.map((color) {
                return ChoiceChip(
                  label: Text(color),
                  selected: _selectedBodyColor == color,
                  onSelected: (selected) {
                    setState(() {
                      _selectedBodyColor = selected ? color : null;
                    });
                  },
                  selectedColor: Color(0xFF081B48),
                  backgroundColor: Colors.grey[300],
                  labelStyle: TextStyle(color: _selectedBodyColor == color ? Colors.white : Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20),
            // Apply Filters Button
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // Fully rounded
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 5,
                    backgroundColor: Colors.transparent, // Transparent to use gradient
                    shadowColor: Colors.black26,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF004DAB), Color(0xFF09163D)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xF4EEEED3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text("Apply Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
