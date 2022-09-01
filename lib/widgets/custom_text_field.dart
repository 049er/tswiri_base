import 'package:flutter/material.dart';

import '../colors/colors.dart';

class CustomTextField extends StatefulWidget {
  ///   CustomTextField.
  ///  - ```label```
  ///  - ```initialValue```
  ///  - ```maxLines```
  ///  - ```onSubmitted()```
  ///  - ```onChanged()```
  ///  - ```TextInputType```
  const CustomTextField({
    Key? key,
    this.label,
    this.initialValue,
    this.maxLines,
    this.textInputType,
    this.onSubmitted,
    this.onChanged,
  }) : super(key: key);

  final String? label;
  final String? initialValue;
  final int? maxLines;
  final TextInputType? textInputType;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _controller.text = widget.initialValue ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        textCapitalization: TextCapitalization.sentences,
        maxLines: widget.maxLines ?? 1,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          filled: true,
          fillColor: background[500],
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          labelText: widget.label,
          labelStyle: const TextStyle(fontSize: 15, color: Colors.white),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: sunbirdOrange)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: sunbirdOrange)),
        ),
      ),
    );
  }
}
