import 'package:flutter/material.dart';

class EasyDropdownItem {
  const EasyDropdownItem({
    required this.id,
    required this.widget,
    this.selected = false,
    this.searchableText,
  });

  final String id;
  final Widget widget;
  final bool selected;
  final String? searchableText;

  EasyDropdownItem copyWith({
    String? id,
    Widget? widget,
    bool? selected,
    String? searchableText,
  }) {
    return EasyDropdownItem(
      id: id ?? this.id,
      widget: widget ?? this.widget,
      selected: selected ?? this.selected,
      searchableText: searchableText ?? this.searchableText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EasyDropdownItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
