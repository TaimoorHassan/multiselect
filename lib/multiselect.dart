library multiselect;

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

// Private state class (not used directly in the widget)
class _TheState {}

// Global state variable using StatesRebuilder (for listening to changes)
var _theState = RM.inject(() => _TheState());

// Inherited widget to wrap the dropdown (unused in this example)
class RowWrapper extends InheritedWidget {
  final dynamic data;
  final bool Function() shouldNotify;
  RowWrapper({
    required super.child,
    this.data,
    required this.shouldNotify,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

// Widget for a single selectable row
class _SelectRow extends StatelessWidget {
  final Function(bool) onChange;
  final bool selected;
  final String text;

  const _SelectRow(
      {required this.onChange, required this.selected, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Triggered on tap
      onTap: () {
        // Update selection state and rebuild the widget
        onChange(!selected);
        _theState.notify();
      },
      child: Container(
        height: kMinInteractiveDimension,
        child: Row(
          children: [
            Checkbox(
                // Set checkbox value based on selection
                value: selected,
                // Update selection state and rebuild the widget
                onChanged: (x) {
                  onChange(x!);
                  _theState.notify();
                }),
            Expanded(
              child: Text(
                text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Docstring explaining the widget functionality
///
/// A Dropdown multiselect menu
///
///
class DropDownMultiSelect<T> extends StatefulWidget {
  /// The options form which a user can select
  final List<T> options;

  /// Selected Values
  final List<T> selectedValues;

  /// This function is called whenever a value changes
  final Function(List<T>) onChanged;

  /// defines whether the field is dense
  final bool isDense;

  /// defines whether the widget is enabled;
  final bool enabled;

  /// Input decoration
  final InputDecoration? decoration;

  /// this text is shown when there is no selection
  final String? whenEmpty;

  /// a function to build custom childern
  final Widget Function(List<T> selectedValues)? childBuilder;

  /// a function to build custom menu items
  final Widget Function(T option)? menuItembuilder;

  /// a function to validate
  final String? Function(T? selectedOptions)? validator;

  /// defines whether the widget is read-only
  final bool readOnly;

  /// The maximum height of the menu.
  final double? menuMaxHeight;

  /// icon shown on the right side of the field
  final Widget? icon;

  /// Textstyle for the hint
  final TextStyle? hintStyle;

  /// hint to be shown when there's nothing else to be shown
  final Widget? hint;

  /// selectedValue separator
  final T? separator;

  /// style for the selected values
  final TextStyle? selectedValuesStyle;

  const DropDownMultiSelect({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.whenEmpty,
    this.icon,
    this.hint,
    this.hintStyle,
    this.childBuilder,
    this.selectedValuesStyle,
    this.menuItembuilder,
    this.isDense = true,
    this.enabled = true,
    this.decoration,
    this.validator,
    this.menuMaxHeight,
    this.readOnly = false,
    this.separator,
  });

  @override
  State<DropDownMultiSelect> createState() => _DropDownMultiSelectState<T>();
}

class _DropDownMultiSelectState<TState>
    extends State<DropDownMultiSelect<TState>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Display selected values (custom or default)
          _theState.rebuild(() => widget.childBuilder != null
              ? widget.childBuilder!(widget.selectedValues)
              : Padding(
                  padding: widget.decoration != null
                      ? widget.decoration!.contentPadding != null
                          ? widget.decoration!.contentPadding!
                          : EdgeInsets.symmetric(horizontal: 10)
                      : EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(widget.selectedValues.isNotEmpty
                        ? widget.selectedValues.map((e) => e.toString()).reduce(
                            (a, b) =>
                                a +
                                (widget.separator != null
                                    ? widget.separator.toString()
                                    : ',') +
                                b)
                        : widget.whenEmpty ?? ''),
                  ))),
          // Dropdown button with custom menu items
          Container(
            child: DropdownButtonFormField<TState>(
              menuMaxHeight: widget.menuMaxHeight,
              hint: widget.hint,
              style: widget.hintStyle,
              icon: widget.icon,
              validator: widget.validator,
              decoration: widget.decoration ??
                  InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                  ),
              isDense: widget.isDense,
              onChanged: widget.enabled ? (x) {} : null,
              isExpanded: false,
              value: widget.selectedValues.isNotEmpty
                  ? widget.selectedValues[0]
                  : null,
              selectedItemBuilder: (context) {
                return widget.options
                    .map((e) => DropdownMenuItem(
                          child: Container(),
                        ))
                    .toList();
              },
              items: widget.options
                  .map(
                    (x) => DropdownMenuItem<TState>(
                      child: _theState.rebuild(() {
                        return widget.menuItembuilder != null
                            ? widget.menuItembuilder!(x)
                            : _SelectRow(
                                selected: widget.selectedValues.contains(x),
                                text: x.toString(),
                                onChange: (isSelected) {
                                  if (isSelected) {
                                    var ns = widget.selectedValues;
                                    ns.add(x);
                                    widget.onChanged(ns);
                                  } else {
                                    var ns = widget.selectedValues;
                                    ns.remove(x);
                                    widget.onChanged(ns);
                                  }
                                },
                              );
                      }),
                      value: x,
                      onTap: !widget.readOnly
                          ? () {
                              if (widget.selectedValues.contains(x)) {
                                var ns = widget.selectedValues;
                                ns.remove(x);
                                widget.onChanged(ns);
                              } else {
                                var ns = widget.selectedValues;
                                ns.add(x);
                                widget.onChanged(ns);
                              }
                            }
                          : null,
                    ),
                  )
                  .toList(),
            ),
          ),
          _theState.rebuild(
            () => widget.childBuilder != null
                ? widget.childBuilder!(widget.selectedValues)
                : Padding(
                    padding: widget.decoration != null
                        ? widget.decoration!.contentPadding != null
                            ? widget.decoration!.contentPadding!
                            : EdgeInsets.symmetric(horizontal: 10)
                        : EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.selectedValues.isNotEmpty
                              ? widget.selectedValues
                                  .map((e) => e.toString())
                                  .reduce((a, b) =>
                                      a.toString() +
                                      (widget.separator != null
                                          ? widget.separator.toString()
                                          : ' , ') +
                                      b.toString())
                              : widget.whenEmpty ?? '',
                          style: widget.selectedValuesStyle,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
