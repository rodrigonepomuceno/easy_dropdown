# Custom Easy Dropdown

A Flutter dropdown component that provides a simple and customizable way to handle item selection with separate selected and unselected lists. The component ensures only one dropdown is open at a time and provides a smooth user experience with proper overlay management.

## Features

- Smart overlay management (only one dropdown open at a time)
- Automatic handling of clicks outside the dropdown
- Separation into selected and unselected lists
- Search functionality with real-time filtering
- Customizable styles and widgets
- Support for simplified and detailed modes
- Fully customizable appearance
- Custom search controller support

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  custom_easy_dropdown: ^1.0.0
```

## Usage

```dart
import 'package:custom_easy_dropdown/easy_dropdown.dart';

// Create some items
final items = [
  EasyDropdownItem(
    id: '1',
    widget: ListTile(
      title: Text('John Doe'),
      subtitle: Text('Software Engineer'),
    ),
    searchableText: 'John Doe Software Engineer',
  ),
  EasyDropdownItem(
    id: '2',
    widget: ListTile(
      title: Text('Jane Smith'),
      subtitle: Text('Product Manager'),
    ),
    searchableText: 'Jane Smith Product Manager',
    selected: true,
  ),
];

// Use the component
EasyDropdownComponent(
  items: items,
  enableSearch: true,
  searchHintText: 'Search people...',
  searchController: TextEditingController(), // Optional custom search controller
  customSearchField: TextField(
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      hintText: 'Search people...',
      prefixIcon: const Icon(Icons.search),
    ),
  ),
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
- `searchController`: TextEditingController? - Optional controller for the search field.

### Size and Dimensions

- `listWidth`: double? - Width of the dropdown list. If null, uses maxWidth.
- `listHeight`: double? - Height of the dropdown list. If null, uses maxHeight.
- `maxHeight`: double? - Maximum height constraint for the dropdown list (default: 300).
- `maxWidth`: double? - Maximum width constraint for the dropdown list (default: 350).
- `fieldWidth`: double? - Width of the dropdown field (default: 200).
- `fieldHeight`: double? - Height of the dropdown field (default: 40).

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
- `customSelectedHeader`: Widget? - Custom header for the selected items section.
- `customAvailableHeader`: Widget? - Custom header for the available items section.
- `customEmptyResultsWidget`: Widget? - Custom widget to show when search returns no results. If not provided, a default widget will be used.

### Search Customization
- `enableSearch`: Enable/disable search functionality
- `searchHintText`: Custom placeholder text for search field
- `searchController`: Custom controller for the search field
- `searchMatcher`: Custom function to determine if an item matches the search text

## EasyDropdownItem Properties

- `id`: String - Unique identifier for the item
- `widget`: Widget - The widget to display in the dropdown
- `selected`: bool - Whether the item is initially selected
- `searchableText`: String? - Text used for searching. If not provided, the default matcher will try to extract text from ListTile title and subtitle

### Search Examples

Example with searchable text:
```dart
EasyDropdownItem(
  id: 'user1',
  widget: ListTile(
    title: Text('John Doe'),
    subtitle: Text('Software Engineer'),
  ),
  searchableText: 'John Doe Software Engineer',
)
```

Example with custom search field and controller:
```dart
final searchController = TextEditingController();

EasyDropdownComponent(
  items: items,
  enableSearch: true,
  searchController: searchController,
  customSearchField: TextField(
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      hintText: 'Search people...',
      prefixIcon: const Icon(Icons.search),
    ),
  ),
)
```

Example with custom search matcher:
```dart
EasyDropdownComponent(
  items: items,
  enableSearch: true,
  searchMatcher: (item, searchText) {
    // Custom search logic
    return item.searchableText?.toLowerCase().contains(searchText.toLowerCase()) ?? false;
  },
)
```

### Empty Results Widget

When a search returns no results, the dropdown will display an empty results widget:

1. In simplified mode (`isSimplified: true`):
   - The empty results widget takes up the entire list area
   - Replaces all content except search field and buttons

2. In complex mode (`isSimplified: false`):
   - The empty results widget only appears in the available items section
   - Selected items section remains visible and functional

You can customize the empty results widget:

```dart
EasyDropdownComponent(
  items: items,
  enableSearch: true,
  customEmptyResultsWidget: Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.warning_amber_rounded, 
          size: 48, 
          color: Colors.orange,
        ),
        const SizedBox(height: 8),
        const Text(
          'Nothing matches your search',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Try using different keywords',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
  ),
)
```

If not provided, a default empty results widget will be shown with:
- Search icon
- "No results found" message
- Suggestion to adjust the search

### Callbacks

- `onSelectionChanged`: Function(EasyDropdownItem)? - Called when an item's selection state changes.
- `onClose`: Function(List<EasyDropdownItem>)? - Called when the dropdown is closed.
- `onListChanged`: Function(List<EasyDropdownItem>)? - Called when the list content changes.

## Additional Features

### Simplified vs Complex Mode

The dropdown supports two modes:

1. **Simplified Mode** (`isSimplified: true`):
   - Single list view
   - Items show selection state with checkmarks
   - Simpler UI for basic use cases

2. **Complex Mode** (`isSimplified: false`):
   - Separate lists for selected and available items
   - More structured view for managing selections
   - Ideal for complex selection scenarios

### Search Functionality

The search feature supports:
- Real-time filtering as you type
- Custom search text per item via `searchableText`
- Custom search logic via `searchMatcher`
- Custom search field appearance
- External search control via `searchController`

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
