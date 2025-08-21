import 'package:flutter/material.dart';
import 'package:routes_mobile/screens/app_dimens.dart';
class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.all(
          AppDimens.widthPercentage(0.01, context)
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          shape: BoxShape.circle
        ),
        child: Center(
          child: Image.asset(
            'assets/animated/bus.gif',
            width: AppDimens.widthPercentage(0.35, context),
            height: AppDimens.widthPercentage(0.35, context)
          )
        )
      ),
    );
  }
}