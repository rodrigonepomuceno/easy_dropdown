import 'package:flutter/material.dart';

class EasyDropdownItem {
  const EasyDropdownItem({
    required this.id,
    required this.widget,
    this.selected = false,
  });

  final String id;
  final Widget widget;
  final bool selected;

  EasyDropdownItem copyWith({
    String? id,
    Widget? widget,
    bool? selected,
  }) {
    return EasyDropdownItem(
      id: id ?? this.id,
      widget: widget ?? this.widget,
      selected: selected ?? this.selected,
    );
  }
}
