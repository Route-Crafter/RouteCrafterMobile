import 'package:flutter/material.dart';

class CreationInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final double width;
  final bool isAvaible;
  const CreationInput({
    required this.hintText,
    required this.controller,
    required this.width,
    this.isAvaible = true,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        scrollPadding: EdgeInsets.zero,
        enabled: isAvaible,
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 15
          ),
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          filled: true,
          fillColor: Theme.of(context).colorScheme.tertiaryFixed,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiaryFixedDim
            )
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiaryFixedDim
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary
            )
          )
        )
      ),
    );
  }
}