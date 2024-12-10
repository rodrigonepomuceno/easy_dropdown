import 'package:easy_dropdown/easy_dropdown.dart';
import 'package:flutter/material.dart';

class SimpleExample extends StatefulWidget {
  const SimpleExample({super.key});

  @override
  State<SimpleExample> createState() => _SimpleExampleState();
}

class _SimpleExampleState extends State<SimpleExample> {
  final items = [
    const EasyDropdownItem(
      id: '1',
      widget: Text('Apple'),
    ),
    const EasyDropdownItem(
      id: '2',
      widget: Text('Banana'),
      selected: true,
    ),
    const EasyDropdownItem(
      id: '3',
      widget: Text('Orange'),
    ),
    const EasyDropdownItem(
      id: '4',
      widget: Text('Mango'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Dropdown Example',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A simple dropdown with text-only items and basic functionality.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            EasyDropdownComponent(
              title: 'Fruits',
              description: 'Select your favorite fruits',
              items: items,
              leadingIcon: 'fruit',
              searchHintText: 'Search fruits...',
              enableSearch: true,
              isSimplified: true,
              onSelectionChanged: (item) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selected: ${(item.widget as Text).data}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}