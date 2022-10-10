library multiselect;

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class _TheState {}

var _theState = RM.inject(() => _TheState());

class SelectItem {
  String text;
  bool enabled;

  SelectItem({
    @required this.text,
    this.enabled = true,
  });

  // for creating SelectItem from json
  factory SelectItem.fromJson(item) {
    return SelectItem(
      text: item['text'],
      enabled: item['enabled'] ?? true,
    );
  }

  // for cloning
  factory SelectItem.from(item) {
    return SelectItem(
      text: item.text,
      enabled: item.enabled ?? true,
    );
  }

  @override
  String toString() {
    return '{ text: $text, enabled: $enabled }';
  }
}

class _SelectRow extends StatelessWidget {
  final Function(bool) onChange;
  final bool selected;
  final String text;
  final bool enabled;

  const _SelectRow({
    Key key,
    @required this.onChange,
    @required this.selected,
    @required this.text,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () {
              onChange(!selected);
              _theState.notify();
            }
          : null,
      child: Container(
        height: kMinInteractiveDimension,
        child: Row(
          children: [
            Checkbox(
              value: selected,
              onChanged: enabled
                  ? (x) {
                      onChange(x);
                      _theState.notify();
                    }
                  : null,
            ),
            Text(
              text,
              style: !enabled
                  ? TextStyle(
                      color: Colors.grey[400],
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }
}

///
/// A Dropdown multiselect menu
///
///
class DropDownMultiSelect extends StatefulWidget {
  /// The options form which a user can select
  final List<SelectItem> options;

  /// Selected Values
  final List<String> selectedValues;

  /// This function is called whenever a value changes
  final Function(List<String>) onChanged;

  /// defines whether the field is dense
  final bool isDense;

  /// defines whether the widget is enabled;
  final bool enabled;

  /// Input decoration
  final InputDecoration decoration;

  /// this text is shown when there is no selection
  final String whenEmpty;

  /// a function to build custom childern
  final Widget Function(List<String> selectedValues) childBuilder;

  /// a function to build custom menu items
  final Widget Function(String option) menuItembuilder;

  /// a function to validate
  final String Function(String selectedOptions) validator;

  /// defines whether the widget is read-only
  final bool readOnly;

  /// icon shown on the right side of the field
  final Widget icon;

  /// Textstyle for the hint
  final TextStyle hintStyle;

  /// hint to be shown when there's nothing else to be shown
  final Widget hint;

  const DropDownMultiSelect({
    Key key,
    @required this.options,
    @required this.selectedValues,
    @required this.onChanged,
    this.whenEmpty,
    this.icon,
    this.hint,
    this.hintStyle,
    this.childBuilder,
    this.menuItembuilder,
    this.isDense = true,
    this.enabled = true,
    this.decoration,
    this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _DropDownMultiSelectState createState() => _DropDownMultiSelectState();
}

class _DropDownMultiSelectState extends State<DropDownMultiSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          _theState.rebuild(() => widget.childBuilder != null
              ? widget.childBuilder(widget.selectedValues)
              : Padding(
                  padding: widget.decoration != null
                      ? widget.decoration.contentPadding != null
                          ? widget.decoration.contentPadding
                          : EdgeInsets.symmetric(horizontal: 10)
                      : EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(widget.selectedValues.length > 0
                        ? widget.selectedValues.reduce((a, b) => a + ' , ' + b)
                        : widget.whenEmpty ?? ''),
                  ))),
          Container(
            child: Theme(
              data: Theme.of(context).copyWith(),
              child: DropdownButtonFormField<String>(
                hint: widget.hint,
                style: widget.hintStyle,
                icon: widget.icon,
                validator: widget.validator != null ? widget.validator : null,
                decoration: widget.decoration != null
                    ? widget.decoration
                    : InputDecoration(
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
                value: widget.selectedValues.length > 0
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
                      (x) => DropdownMenuItem(
                        enabled: x.enabled,
                        child: _theState.rebuild(() {
                          return widget.menuItembuilder != null
                              ? widget.menuItembuilder(x.text)
                              : _SelectRow(
                                  selected:
                                      widget.selectedValues.contains(x.text),
                                  text: x.text,
                                  enabled: x.enabled,
                                  onChange: (isSelected) {
                                    if (isSelected) {
                                      var ns = widget.selectedValues;
                                      ns.add(x.text);
                                      widget.onChanged(ns);
                                    } else {
                                      var ns = widget.selectedValues;
                                      ns.remove(x.text);
                                      widget.onChanged(ns);
                                    }
                                  },
                                );
                        }),
                        value: x.text,
                        onTap: !widget.readOnly || x.enabled
                            ? () {
                                if (widget.selectedValues.contains(x.text)) {
                                  var ns = widget.selectedValues;
                                  ns.remove(x.text);
                                  widget.onChanged(ns);
                                } else {
                                  var ns = widget.selectedValues;
                                  ns.add(x.text);
                                  widget.onChanged(ns);
                                }
                              }
                            : null,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
