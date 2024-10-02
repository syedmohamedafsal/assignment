import 'package:flutter/material.dart';

class CustomTexField extends StatefulWidget {
  const CustomTexField({
    super.key,
    required TextEditingController controller,
    required this.validator,
    required this.hinttext,
    this.obscure,
    required this.customicon,
  }) : controller = controller;

  final TextEditingController controller;
  final String? Function(String?) validator;
  final String hinttext;
  final bool? obscure;
  final Icon customicon;

  @override
  State<CustomTexField> createState() => _CustomTexFieldState();
}

class _CustomTexFieldState extends State<CustomTexField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscure == true ? _obscurePassword : false,
      decoration: InputDecoration(
        prefixIcon: widget.customicon,
        labelText: widget.hinttext,
        hintStyle:
            const TextStyle(color: Colors.grey,fontSize: 14), // Set hint text color to grey
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        suffixIcon: widget.obscure == true
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
