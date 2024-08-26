import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  var _passwordVisible = true;
  final String name;
  PasswordField({super.key,required this.name});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
      child: TextFormField(
        obscureText: widget._passwordVisible,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: widget.name,
            floatingLabelStyle: const TextStyle(
              fontSize: 20,
            ),
            suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  widget._passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    widget._passwordVisible = !widget._passwordVisible;
                  });
                }),
                ),
        validator: (value) => value!.isEmpty ? 'Enter a password' : null,
      ),
    );
  }
}
