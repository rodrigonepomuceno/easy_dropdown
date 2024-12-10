import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'models/easy_dropdown_item.dart';

class EasyDropdownComponent extends StatefulWidget {
  const EasyDropdownComponent({
    super.key,
    required this.items,
    this.title = '',
    this.description = '',
    this.leadingIcon,
    this.searchHintText,
    this.enableSearch = false,
    this.isSimplified = false,
    this.maxHeight,
    this.maxWidth,
    this.listHeight,
    this.listWidth,
    this.fieldWidth = 200,
    this.fieldHeight = 40,
    this.onSelectionChanged,
    this.onClose,
    this.onListChanged,
    this.customField,
    this.customSearchField,
    this.searchController,
    this.customClearButton,
    this.customSelectAllButton,
    this.customListItem,
    this.customSelectedListItem,
    this.customSelectedHeader,
    this.customAvailableHeader,
    this.customEmptyResultsWidget,
    this.dropdownDecoration,
    this.dropdownElevation = 8,
    this.dropdownPadding,
    this.dropdownOuterPadding = const EdgeInsets.only(top: 4),
    this.searchMatcher,
  });

  final List<EasyDropdownItem> items;
  final String title;
  final String description;
  final String? leadingIcon;
  final String? searchHintText;
  final bool enableSearch;
  final bool isSimplified;
  final double? maxHeight;
  final double? maxWidth;
  final double? listHeight;
  final double? listWidth;
  final double fieldWidth;
  final double fieldHeight;
  final Function(EasyDropdownItem)? onSelectionChanged;
  final Function(List<EasyDropdownItem>)? onClose;
  final Function(List<EasyDropdownItem>)? onListChanged;
  final Widget? customField;
  final Widget? customSearchField;
  final TextEditingController? searchController;
  final Widget? customClearButton;
  final Widget? customSelectAllButton;
  final Widget Function(EasyDropdownItem item, VoidCallback onTap)? customListItem;
  final Widget Function(EasyDropdownItem item, VoidCallback onTap)? customSelectedListItem;
  final Widget? customSelectedHeader;
  final Widget? customAvailableHeader;
  final Widget? customEmptyResultsWidget;
  final BoxDecoration? dropdownDecoration;
  final double dropdownElevation;
  final EdgeInsetsGeometry? dropdownPadding;
  final EdgeInsetsGeometry dropdownOuterPadding;
  final bool Function(EasyDropdownItem item, String searchText)? searchMatcher;

  @override
  State<EasyDropdownComponent> createState() => _EasyDropdownComponentState();
}

class _EasyDropdownComponentState extends State<EasyDropdownComponent> {
  late final TextEditingController _searchController;
  final List<EasyDropdownItem> _selectedItems = [];
  List<EasyDropdownItem> _filteredItems = [];
  bool _isOpen = false;
  static _EasyDropdownComponentState? _openDropdown;
  OverlayEntry? _overlayEntry;
  VoidCallback? _removeGlobalListener;

  final selectedItems = ValueNotifier<List<EasyDropdownItem>>([]);
  final notSelectedItems = ValueNotifier<List<EasyDropdownItem>>([]);
  final totalSelected = ValueNotifier<int>(0);
  final totalNotSelected = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? TextEditingController();
    _searchController.addListener(() {
      _filterItems(_searchController.text);
    });
    
    for (final item in widget.items) {
      if (item.selected) {
        _selectedItems.add(item);
      }
    }
    
    _filterItems('');
  }

  void _filterItems(String value) {
    bool defaultMatcher(EasyDropdownItem item, String searchText) {
      final searchLower = searchText.toLowerCase();
      
      if (item.searchableText != null) {
        return item.searchableText!.toLowerCase().contains(searchLower);
      }
    
      if (item.widget is ListTile) {
        final listTile = item.widget as ListTile;
        final title = (listTile.title as Text?)?.data?.toLowerCase() ?? '';
        final subtitle = (listTile.subtitle as Text?)?.data?.toLowerCase() ?? '';
        return title.contains(searchLower) || subtitle.contains(searchLower);
      } else if (item.widget is Text) {
        final text = (item.widget as Text).data;
        return text != null ? text.toLowerCase().contains(searchLower) : true;
      }
      return true;
    }

    final matcher = widget.searchMatcher ?? defaultMatcher;
    final searchText = value.trim();
    
    if (mounted) {
      setState(() {
        if (widget.isSimplified) {
          _filteredItems = searchText.isEmpty 
              ? List.from(widget.items)
              : widget.items.where((item) => matcher(item, searchText)).toList();
        } else {
          final selectedIds = _selectedItems.map((item) => item.id).toSet();
          final availableItems = widget.items.where((item) => !selectedIds.contains(item.id)).toList();
          
          if (searchText.isEmpty) {
            _filteredItems = availableItems;
          } else {
            _filteredItems = availableItems.where((item) => matcher(item, searchText)).toList();
          }
        }
      });
    }
  }

  void _toggleItem(EasyDropdownItem item, StateSetter? dialogSetState) {
    setState(() {
      if (widget.isSimplified) {
        final updatedItem = item.copyWith(selected: !item.selected);
        final itemIndex = widget.items.indexOf(item);
        if (itemIndex != -1) {
          widget.items[itemIndex] = updatedItem;
        }
        
        if (updatedItem.selected) {
          _selectedItems.add(updatedItem);
        } else {
          _selectedItems.removeWhere((i) => i.id == item.id);
        }
        
        final filteredIndex = _filteredItems.indexOf(item);
        if (filteredIndex != -1) {
          _filteredItems[filteredIndex] = updatedItem;
        }
      } else {
        if (_selectedItems.any((i) => i.id == item.id)) {
          _selectedItems.removeWhere((i) => i.id == item.id);
          _filteredItems.add(item);
        } else {
          _selectedItems.add(item);
          _filteredItems.removeWhere((i) => i.id == item.id);
        }
      }
      
      widget.onSelectionChanged?.call(item);
    });
    
    dialogSetState?.call(() {});
  }

  void _clearSelection(StateSetter? dialogSetState) {
    setState(() {
      if (widget.isSimplified) {
        for (final item in _selectedItems) {
          final index = _filteredItems.indexWhere((i) => i.id == item.id);
          if (index != -1) {
            _filteredItems[index] = _filteredItems[index].copyWith(selected: false);
          }
        }
        _selectedItems.clear();
      } else {      
        _selectedItems.forEach((item) {
          final index = widget.items.indexWhere((i) => i.id == item.id);
          if (index != -1) {
            widget.items[index] = widget.items[index].copyWith(selected: false);
          }
        });
        _selectedItems.clear();
        _filterItems(_searchController.text);
      }
    });

    widget.onListChanged?.call(_selectedItems);
    dialogSetState?.call(() {});
  }

  void _selectAll(StateSetter? dialogSetState) {
    setState(() {
      if (widget.isSimplified) {
        for (final item in _filteredItems) {
          if (!item.selected) {
            final updatedItem = item.copyWith(selected: true);
            final index = _filteredItems.indexWhere((i) => i.id == item.id);
            if (index != -1) {
              _filteredItems[index] = updatedItem;
              if (!_selectedItems.contains(item)) {
                _selectedItems.add(updatedItem);
              }
            }
          }
        }
      } else {
        for (final item in _filteredItems) {
          final unselectedItem = item.copyWith(selected: false);
          if (!_selectedItems.contains(item)) {
            _selectedItems.add(unselectedItem);
            final index = widget.items.indexWhere((i) => i.id == item.id);
            if (index != -1) {
              widget.items[index] = unselectedItem;
            }
          }
        }
        _filterItems(_searchController.text);
      }
    });

    widget.onListChanged?.call(_selectedItems);
    dialogSetState?.call(() {});
  }

  Widget _buildDefaultEmptyResults() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your search',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showSelectionDialog() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final overlay = Overlay.of(context);
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + widget.dropdownOuterPadding.resolve(TextDirection.ltr).top,
        left: offset.dx + widget.dropdownOuterPadding.resolve(TextDirection.ltr).left,
        child: Material(
          elevation: widget.dropdownElevation,
          borderRadius: widget.dropdownDecoration?.borderRadius?.resolve(TextDirection.ltr) ?? BorderRadius.circular(4),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: widget.listHeight ?? widget.maxHeight ?? 300,
              maxWidth: widget.listWidth ?? widget.maxWidth ?? 350,
              minWidth: widget.listWidth ?? size.width,
            ),
            decoration: widget.dropdownDecoration?.copyWith(
              borderRadius: widget.dropdownDecoration?.borderRadius ?? BorderRadius.circular(4),
            ) ?? BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            padding: widget.dropdownPadding,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.enableSearch)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: widget.customSearchField?.copyWith(
                          controller: _searchController,
                           onChanged: (value) {
                            setState(() {
                              _filterItems(value);
                            });
                          },
                        ) ?? TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: widget.searchHintText ?? 'Search...',
                            prefixIcon: const Icon(Icons.search),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _filterItems(value);
                            });
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => _clearSelection(setState),
                            child: widget.customClearButton ?? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.clear_all, size: 16, color: Colors.red),
                                  SizedBox(width: 4),
                                  Text('Clear All', 
                                    style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _selectAll(setState),
                            child: widget.customSelectAllButton ?? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.select_all, size: 16, color: Colors.blue),
                                  SizedBox(width: 4),
                                  Text('Select All', 
                                    style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: SingleChildScrollView(
                        child: _buildList(setState),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);

    bool handlePointerRoute(PointerEvent event) {
      if (event is! PointerDownEvent) return false;
      
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box == null) return false;
      
      final result = BoxHitTestResult();
      box.hitTest(result, position: box.globalToLocal(event.position));
      
      if (result.path.isEmpty && _overlayEntry != null) {
        _closeDropdown();
      }
      return true;
    }

    GestureBinding.instance.pointerRouter.addRoute(1, handlePointerRoute);
    _removeGlobalListener = () {
      GestureBinding.instance.pointerRouter.removeRoute(1, handlePointerRoute);
    };
  }

  Widget _buildList(StateSetter setState) {
    if (widget.isSimplified) {
      if (_filteredItems.isEmpty && _searchController.text.isNotEmpty) {
        return widget.customEmptyResultsWidget ?? _buildDefaultEmptyResults();
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return widget.customListItem?.call(
            item,
            () => _toggleItem(item, setState),
          ) ?? ListTile(
            dense: true,
            title: item.widget,
            trailing: item.selected ? const Icon(Icons.check, size: 20) : null,
            onTap: () => _toggleItem(item, setState),
          );
        },
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedItems.isNotEmpty) ...[
            widget.customSelectedHeader ?? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                  SizedBox(width: 4),
                  Text(
                    'Selected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            ...List.generate(
              _selectedItems.length,
              (index) {
                final item = _selectedItems[index];
                return widget.customSelectedListItem?.call(
                  item,
                  () => _toggleItem(item, setState),
                ) ?? ListTile(
                  dense: true,
                  title: item.widget,
                  onTap: () => _toggleItem(item, setState),
                );
              },
            ),
            const Divider(),
          ],
          if (_filteredItems.isEmpty && _searchController.text.isNotEmpty)
            widget.customEmptyResultsWidget ?? _buildDefaultEmptyResults()
          else
            ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return widget.customListItem?.call(
                  item,
                  () => _toggleItem(item, setState),
                ) ?? ListTile(
                  dense: true,
                  title: item.widget,
                  onTap: () => _toggleItem(item, setState),
                );
              },
            ),
        ],
      );
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _removeGlobalListener?.call();
    _removeGlobalListener = null;
    setState(() {
      _isOpen = false;
      _openDropdown = null;
    });
    widget.onClose?.call([...widget.items]);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          if (_isOpen) {
            _closeDropdown();
          } else {
            if (_openDropdown != null && _openDropdown != this) {
              _openDropdown!.setState(() {
                _openDropdown!._isOpen = false;
              });
            }
            setState(() {
              _isOpen = true;
              _openDropdown = this;
            });
            _showSelectionDialog();
          }
        },
        child: widget.customField ?? Container(
          width: widget.fieldWidth,
          height: widget.fieldHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_drop_down),
              ),
              Expanded(
                child: Text(
                  '${_selectedItems.length} selected',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _overlayEntry?.remove();
    _removeGlobalListener?.call();
    super.dispose();
  }
}

extension on Widget? {
  copyWith({required TextEditingController controller, required Function(String)? onChanged}) {}
}
