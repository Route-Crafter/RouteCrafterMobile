import 'package:flutter/material.dart';
class GeneralButton extends StatelessWidget {
  final String name;
  final double width;
  final Function() onPressed;
  const GeneralButton({
    super.key,
    required this.name,
    required this.width,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: width,
      padding: const EdgeInsets.symmetric(
        vertical: 5
      ),
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25)
      ),
      child: Text(
        name,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Colors.white
        )
      )
    );
  }
}