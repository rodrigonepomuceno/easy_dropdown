# Easy Dropdown

A highly customizable and efficient dropdown component for Flutter applications, designed to handle both simple and complex selection scenarios with an emphasis on user experience and performance.

![Pub Version](https://img.shields.io/pub/v/easy_dropdown)
![Flutter Platform](https://img.shields.io/badge/platform-flutter-blue.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Introduction 📱

Easy Dropdown is a feature-rich dropdown component that simplifies the implementation of selection interfaces in Flutter applications. It provides a robust solution for managing single and multiple selections while maintaining optimal performance and user experience.

## Features 🎯

- **Smart Overlay Management**
  - Single active dropdown policy (prevents multiple dropdowns open simultaneously)
  - Automatic positioning and stacking context handling
  - Smooth transitions and animations

- **Selection Management**
  - Support for both single and multiple selections
  - Automatic handling of selected/unselected item states
  - Built-in search functionality with real-time filtering
  - Clear visual feedback for selection states

- **User Experience**
  - Intelligent outside click detection
  - Smooth scrolling for large lists
  - Responsive design adapting to different screen sizes
  - Keyboard navigation support

- **Customization**
  - Extensive theming options
  - Custom widget support for all components
  - Flexible layout configuration
  - Custom item rendering capabilities

## Getting Started 🚀

1. Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  easy_dropdown: ^0.0.1
```

2. Import the package:

```dart
import 'package:easy_dropdown/easy_dropdown.dart';
```

3. Use it in your code:

```dart
EasyDropdownComponent(
  items: [
    EasyDropdownItem(id: '1', widget: Text('Item 1')),
    EasyDropdownItem(id: '2', widget: Text('Item 2')),
  ],
  enableSearch: true,
  onSelectionChanged: (item) {
    print('Selected: ${item.id}');
  },
)
```

## Usage Examples 💡

### Basic Dropdown

```dart
EasyDropdownComponent(
  items: items,
  enableSearch: true,
  searchHintText: 'Search...',
  onSelectionChanged: (item) => print('Selected: ${item.id}'),
)
```

### Styled Dropdown

```dart
EasyDropdownComponent(
  items: items,
  dropdownDecoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 8,
      ),
    ],
  ),
  dropdownElevation: 4,
)
```

### Custom Field

```dart
EasyDropdownComponent(
  items: items,
  customField: Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(Icons.list),
        SizedBox(width: 8),
        Text('Select Items'),
        Spacer(),
        Icon(Icons.arrow_drop_down),
      ],
    ),
  ),
)
```

## Why Easy Dropdown? 🤔

### Performance
- Efficient list rendering for large datasets
- Smart filtering algorithms
- Proper resource management
- Smooth animations and transitions

### Developer Experience
- Clear, intuitive API
- Comprehensive documentation
- Type-safe interfaces
- Extensive customization options

### User Experience
- Responsive and fluid interactions
- Intuitive selection management
- Consistent behavior across platforms
- Accessible interface

## Use Cases 📋

Perfect for:
- Forms with complex selection requirements
- Data-heavy applications
- Applications requiring custom dropdown styling
- Projects with specific UX requirements

## Additional Information ℹ️

- **License**: MIT
- **Author**: Rodrigo Nepomuceno
- **Homepage**: [GitHub Repository URL]

## Contribution 🤝

Contributions are welcome! Feel free to:
- Report issues
- Submit pull requests
- Suggest new features
- Improve documentation
