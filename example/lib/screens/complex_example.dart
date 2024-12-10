import 'package:easy_dropdown/easy_dropdown.dart';
import 'package:flutter/material.dart';

class ComplexExample extends StatefulWidget {
  const ComplexExample({super.key});

  @override
  State<ComplexExample> createState() => _ComplexExampleState();
}

class _ComplexExampleState extends State<ComplexExample> {
  final items = [
    const EasyDropdownItem(
      id: 'user1',
      widget: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text('JD'),
        ),
        title: Text('John Doe'),
        subtitle: Text('Software Engineer'),
      ),
    ),
    const EasyDropdownItem(
      id: 'user2',
      widget: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Text('AS'),
        ),
        title: Text('Alice Smith'),
        subtitle: Text('Product Manager'),
      ),
      selected: true,
    ),
    const EasyDropdownItem(
      id: 'user3',
      widget: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: Text('RJ'),
        ),
        title: Text('Robert Johnson'),
        subtitle: Text('UX Designer'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complex Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Advanced Dropdown Example',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A complex dropdown with custom widgets and advanced features.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            EasyDropdownComponent(
              items: items,
              onClose: (p0) => debugPrint('onClose: $p0'),
              onListChanged: (p0) => debugPrint('onListChanged: $p0'),
              onSelectionChanged: (p0) => debugPrint('onSelectionChanged: $p0'),
              maxHeight: 500,
              customField: Container(
                padding: const EdgeInsets.all(8),
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Custom Field'),
                    Spacer(),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              customSearchField: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              customClearButton: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear All'),
              ),
              customSelectAllButton: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.select_all),
                label: const Text('Select All'),
              ),
              customListItem: (item, onTap) => ListTile(
                leading: const Icon(Icons.person_outline),
                title: item.widget,
                trailing: item.selected ? const Icon(Icons.check_circle) : null,
                onTap: onTap,
              ),
              customSelectedListItem: (item, onTap) => ListTile(
                leading: const Icon(Icons.person),
                title: item.widget,
                trailing: const Icon(Icons.check_circle, color: Colors.green),
                onTap: onTap,
              ),
              dropdownDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              dropdownElevation: 4,
              dropdownPadding: const EdgeInsets.all(5),
              dropdownOuterPadding: const EdgeInsets.only(top: 8, left: 4),
            )
          ],
        ),
      ),
    );
  }
}