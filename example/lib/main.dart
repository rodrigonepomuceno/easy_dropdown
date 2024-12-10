import 'package:flutter/material.dart';
import 'screens/complex_example.dart';
import 'screens/simple_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Dropdown Examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExamplesHome(),
    );
  }
}

class ExamplesHome extends StatelessWidget {
  const ExamplesHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Dropdown Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleCard(
            context,
            'Simple Example',
            'Basic dropdown with text items',
            const SimpleExample(),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            'Complex Example',
            'Advanced dropdown with custom widgets and search',
            const ComplexExample(),
          ),
          const SizedBox(height: 16),        
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    Widget destination,
  ) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }
}