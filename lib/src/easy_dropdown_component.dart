import 'package:easy_dropdown/src/models/easy_dropdown_item.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    this.fieldWidth = 200,
    this.fieldHeight = 40,
    this.listWidth,
    this.listHeight,
    this.onSelectionChanged,
    this.onClose,
    this.onListChanged,
    this.customField,
    this.customSearchField,
    this.customClearButton,
    this.customSelectAllButton,
    this.customListItem,
    this.customSelectedListItem,
    this.dropdownDecoration,
    this.dropdownElevation = 8,
    this.dropdownPadding,
    this.dropdownOuterPadding = const EdgeInsets.only(top: 4),
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
  final double fieldWidth;
  final double fieldHeight;
  final double? listWidth;
  final double? listHeight;
  final Function(EasyDropdownItem)? onSelectionChanged;
  final Function(List<EasyDropdownItem>)? onClose;
  final Function(List<EasyDropdownItem>)? onListChanged;
  final Widget? customField;
  final Widget? customSearchField;
  final Widget? customClearButton;
  final Widget? customSelectAllButton;
  final Widget Function(EasyDropdownItem item, VoidCallback onTap)? customListItem;
  final Widget Function(EasyDropdownItem item, VoidCallback onTap)? customSelectedListItem;
  final BoxDecoration? dropdownDecoration;
  final double dropdownElevation;
  final EdgeInsetsGeometry? dropdownPadding;
  final EdgeInsetsGeometry dropdownOuterPadding;

  @override
  State<EasyDropdownComponent> createState() => _EasyDropdownComponentState();
}

class _EasyDropdownComponentState extends State<EasyDropdownComponent> {
  final TextEditingController _searchController = TextEditingController();
  final List<EasyDropdownItem> _selectedItems = [];
  final List<EasyDropdownItem> _filteredItems = [];
  final List<EasyDropdownItem> _unselectedItems = [];
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
    _searchController.addListener(_filterItems);
    
    for (final item in widget.items) {
      if (item.selected) {
        _selectedItems.add(item);
      } else {
        if (!widget.isSimplified) {
          _unselectedItems.add(item);
        }
      }
    }

    if (widget.isSimplified) {
      _filteredItems.addAll(widget.items);
    } else {
      _filteredItems.addAll(_unselectedItems);
    }
  }

  void _filterItems() {
    setState(() {
      final searchText = _searchController.text.toLowerCase();
      
      if (widget.isSimplified) {
        _filteredItems
          ..clear()
          ..addAll(
            widget.items.where((item) {
              if (item.widget is Text) {
                return (item.widget as Text).data!.toLowerCase().contains(searchText);
              } else if (item.widget is ListTile) {
                final title = ((item.widget as ListTile).title as Text?)?.data?.toLowerCase();
                return title?.contains(searchText) ?? false;
              }
              return false;
            }),
          );
      } else {
        if (searchText.isEmpty) {
          _filteredItems
            ..clear()
            ..addAll(_unselectedItems);
        } else {
          _filteredItems
            ..clear()
            ..addAll(
              _unselectedItems.where((item) {
                if (item.widget is Text) {
                  return (item.widget as Text).data!.toLowerCase().contains(searchText);
                } else if (item.widget is ListTile) {
                  final title = ((item.widget as ListTile).title as Text?)?.data?.toLowerCase();
                  return title?.contains(searchText) ?? false;
                }
                return false;
              }),
            );
        }
      }
    });
  }

  void _toggleItem(EasyDropdownItem item, StateSetter? dialogSetState) {
    setState(() {
      final updatedItem = item.copyWith(selected: !item.selected);
      
      final itemIndex = widget.items.indexOf(item);
      if (itemIndex != -1) {
        widget.items[itemIndex] = updatedItem;
      }

      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
        if (!widget.isSimplified) {
          _unselectedItems.add(updatedItem);
          _filteredItems.add(updatedItem);
        } else {
          final filteredIndex = _filteredItems.indexOf(item);
          if (filteredIndex != -1) {
            _filteredItems[filteredIndex] = updatedItem;
          }
        }
      } else {
        _selectedItems.add(updatedItem);
        if (!widget.isSimplified) {
          _unselectedItems.remove(item);
          _filteredItems.remove(item);
        } else {
          final filteredIndex = _filteredItems.indexOf(item);
          if (filteredIndex != -1) {
            _filteredItems[filteredIndex] = updatedItem;
          }
        }
      }

      widget.onSelectionChanged?.call(updatedItem);
    });

    dialogSetState?.call(() {});
  }

  void _clearSelection(StateSetter? dialogSetState) {
    setState(() {
      final updatedItems = _selectedItems.map((item) {
        final updatedItem = item.copyWith(selected: false); 
        final itemIndex = widget.items.indexOf(item);
        if (itemIndex != -1) {
          widget.items[itemIndex] = updatedItem;
        }
        return updatedItem;
      }).toList();

      if (!widget.isSimplified) {
        _unselectedItems.addAll(updatedItems);
        _filteredItems.addAll(updatedItems);
      } else {
        // Update the filtered items for simplified mode
        for (var item in updatedItems) {
          final index = _filteredItems.indexWhere((i) => i.id == item.id);
          if (index != -1) {
            _filteredItems[index] = item;
          }
        }
      }
      _selectedItems.clear();
      
      widget.onListChanged?.call([...widget.items]);
    });

    dialogSetState?.call(() {});
  }

  void _selectAll(StateSetter? dialogSetState) {
    setState(() {
      if (widget.isSimplified) {
        final updatedItems = _filteredItems.map((item) {
          if (!item.selected) {
            final updatedItem = item.copyWith(selected: true);
            final itemIndex = widget.items.indexOf(item);
            if (itemIndex != -1) {
              widget.items[itemIndex] = updatedItem;
            }
            return updatedItem;
          }
          return item;
        }).toList();

        // Update filtered items and selected items
        for (var i = 0; i < _filteredItems.length; i++) {
          _filteredItems[i] = updatedItems[i];
          if (!_selectedItems.any((item) => item.id == updatedItems[i].id) && 
              updatedItems[i].selected) {
            _selectedItems.add(updatedItems[i]);
          }
        }
      } else {
        final updatedItems = _unselectedItems.map((item) {
          final updatedItem = item.copyWith(selected: true);
          final itemIndex = widget.items.indexOf(item);
          if (itemIndex != -1) {
            widget.items[itemIndex] = updatedItem;
          }
          return updatedItem;
        }).toList();

        _selectedItems.addAll(updatedItems);
        _unselectedItems.clear();
        _filteredItems.clear();
      }

      widget.onListChanged?.call([...widget.items]);
    });

    dialogSetState?.call(() {});
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
                        child: widget.customSearchField ?? TextField(
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
                              _filterItems();
                            });
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.customClearButton ?? TextButton(
                            onPressed: () => _clearSelection(setState),
                            child: const Text('Clear'),
                          ),
                          widget.customSelectAllButton ?? TextButton(
                            onPressed: () => _selectAll(setState),
                            child: const Text('Select All'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.isSimplified)
                              ...List.generate(
                                _filteredItems.length,
                                (index) {
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
                              )
                            else ...[
                              if (_selectedItems.isNotEmpty) ...[
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Selected', style: TextStyle(fontWeight: FontWeight.bold)),
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
                                      trailing: const Icon(Icons.check, size: 20),
                                      onTap: () => _toggleItem(item, setState),
                                    );
                                  },
                                ),
                              ],
                              if (_filteredItems.isNotEmpty) ...[
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Available', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                ...List.generate(
                                  _filteredItems.length,
                                  (index) {
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
                            ],
                          ],
                        ),
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

    // Add a listener to close the dropdown when clicking outside
    bool handlePointerRoute(PointerEvent event) {
      if (event is! PointerDownEvent) return false;
      
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box == null) return false;
      
      final result = BoxHitTestResult();
      box.hitTest(result, position: box.globalToLocal(event.position));
      
      // Check if the click is outside both the field and the dropdown
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
