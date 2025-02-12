import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/UserState.dart';

class FiltersPage extends StatefulWidget {
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  RangeValues _ageRange = const RangeValues(18, 50); // Default age range
  String? _selectedGender;
  double _selectedHeight = 160; // Default height
  String? _selectedBodyColor;

  // Gender options
  final List<String> _genders = ["Male", "Female", "Other"];

  // Body color options
  final List<String> _bodyColors = ["Fair", "Medium", "Dark"];

  void _applyFilters() {
    Map<String, dynamic> filters = {
      "ageRange": {
        "min": _ageRange.start.round(),
        "max": _ageRange.end.round(),
      },
      "gender": _selectedGender ?? "Any", // Ensures no null values
      "height": _selectedHeight.round(),
      "bodyColor": _selectedBodyColor ?? "Any",
    };

    // Store filters in UserState
    Provider.of<UserState>(context, listen: false).setSelectedFilters(filters);

    // Close the filter page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filters")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Age Range Selector
            const Text("Age Range", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RangeSlider(
              values: _ageRange,
              min: 18,
              max: 100,
              divisions: 82,
              labels: RangeLabels(
                _ageRange.start.round().toString(),
                _ageRange.end.round().toString(),
              ),
              onChanged: (values) => setState(() => _ageRange = values),
            ),

            // Gender Selection
            const Text("Gender", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                );
              }).toList(),
            ),

            const SizedBox(height: 10),

            // Height Selector
            const Text("Height (cm)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Slider(
              value: _selectedHeight,
              min: 140,
              max: 200,
              divisions: 60,
              label: _selectedHeight.round().toString(),
              onChanged: (value) => setState(() => _selectedHeight = value),
            ),

            // Body Color Selection
            const Text("Body Color", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Apply Filters Button
            Center(
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: const Text("Apply Filters"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
