# Easy Dropdown

A Flutter dropdown component that provides a simple and customizable way to handle item selection with separate selected and unselected lists. The component ensures only one dropdown is open at a time and provides a smooth user experience with proper overlay management.

## Features

- Simple list interface with single or multi-select options
- Smart overlay management (only one dropdown open at a time)
- Automatic handling of clicks outside the dropdown
- Separation into selected and unselected lists
- Search functionality with real-time filtering
- Customizable styles and widgets
- Support for simplified and detailed modes
- Fully customizable appearance

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  easy_dropdown: ^0.0.1
```

## Usage

```dart
import 'package:easy_dropdown/easy_dropdown.dart';

// Create some items
final items = [
  EasyDropdownItem(
    id: '1',
    widget: Text('Item 1'),
  ),
  EasyDropdownItem(
    id: '2',
    widget: Text('Item 2'),
    selected: true,
  ),
];

// Use the component
EasyDropdownComponent(
  items: items,
  enableSearch: true,
  searchHintText: 'Search items...',
  onSelectionChanged: (item) {
    print('Item ${item.id} selection changed');
  },
  onClose: (items) {
    print('Dropdown closed with ${items.length} items');
  },
  onListChanged: (items) {
    print('List changed, now has ${items.length} items');
  },
);
```

## Parameters

### Required Parameters

- `items`: List<EasyDropdownItem> - The list of items to display in the dropdown.

### Basic Configuration

- `enableSearch`: bool - Whether to show the search field (default: false).
- `isSimplified`: bool - Use simplified mode without sections (default: false).
- `searchHintText`: String? - Placeholder text for the search field.

### Size and Dimensions

- `listWidth`: double? - Width of the dropdown list. If null, uses maxWidth.
- `listHeight`: double? - Height of the dropdown list. If null, uses maxHeight.
- `maxHeight`: double? - Maximum height constraint for the dropdown list (default: 300).
- `maxWidth`: double? - Maximum width constraint for the dropdown list (default: 350).

### Styling

- `dropdownDecoration`: BoxDecoration? - Custom decoration for the dropdown container.
- `dropdownElevation`: double - Shadow elevation of the dropdown (default: 8).
- `dropdownPadding`: EdgeInsetsGeometry? - Internal padding of the dropdown content.
- `dropdownOuterPadding`: EdgeInsetsGeometry - Spacing between trigger and dropdown (default: EdgeInsets.only(top: 4)).

### Custom Widgets

- `customField`: Widget? - Custom widget for the dropdown field.
- `customSearchField`: Widget? - Custom widget for the search input.
- `customClearButton`: Widget? - Custom widget for the clear selection button.
- `customSelectAllButton`: Widget? - Custom widget for the select all button.
- `customListItem`: Widget Function(EasyDropdownItem item, VoidCallback onTap)? - Builder for list items.
- `customSelectedListItem`: Widget Function(EasyDropdownItem item, VoidCallback onTap)? - Builder for selected items.

### Callbacks

- `onSelectionChanged`: Function(EasyDropdownItem)? - Called when an item's selection state changes.
- `onClose`: Function(List<EasyDropdownItem>)? - Called when the dropdown is closed.
- `onListChanged`: Function(List<EasyDropdownItem>)? - Called when the list content changes.

## Examples

### Basic Usage

```dart
EasyDropdownComponent(
  items: items,
  title: 'Team Members',
  description: 'Select team members for the project',
  enableSearch: true,
  searchHintText: 'Search members...',
);
```

### Custom Styling

```dart
EasyDropdownComponent(
  items: items,
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
  dropdownPadding: EdgeInsets.all(12),
  dropdownOuterPadding: EdgeInsets.only(top: 8),
);
```

### Custom Widgets

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
      prefixIcon: Icon(Icons.search),
    ),
  ),
);
```
