import 'package:flutter/material.dart';

enum ScreenSize { little, mid, big }

enum ScreenOrientation { landscape, portrait }

class AppDimens {
  static double getHeightWithoutContext(double perc) =>
  (MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height) *
  perc;

  static double getWidthWithoutContext(double perc) =>
  (MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width) *
  perc;

  static double safeHeightPercentage(double percentage, BuildContext context) {
    final media = _getMediaFromContext(context);
    return (media.size.height - media.padding.top - media.padding.bottom) *
    percentage;
  }

  static double safeWidthPercentage(double percentage, BuildContext context) {
    final media = _getMediaFromContext(context);
    return (media.size.width - media.padding.left - media.padding.right) *
        percentage;
  }

  static double cardHeaderText(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.054
            : minorSize > 580
                ? 0.063
                : 0.07);
  }

  static double giantText(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.045
            : minorSize > 580
                ? 0.049
                : 0.065);
  }

  static double titleText(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.039
            : minorSize > 580
                ? 0.042
                : 0.05);
  }

  static double subtitleText(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.031
            : minorSize > 580
                ? 0.033
                : 0.045);
  }

  static double normalText(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.027
            : minorSize > 580
                ? 0.030
                : 0.036);
  }

  static double littleText(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.027
            : minorSize > 580
                ? 0.029
                : 0.0345);
  }

  static double tinyText(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.012
            : minorSize > 580
                ? 0.016
                : 0.018);
  }

  static double normalSplashRadius(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize > 780
        ? 10
        : minorSize > 580
            ? 15
            : 20;
  }

  static double giantIcon(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.59
            : minorSize > 580
                ? 0.065
                : 0.09);
  }

  static double bigIcon(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.047
            : minorSize > 580
                ? 0.052
                : 0.07);
  }

  static double normalIcon(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.032
            : minorSize > 580
                ? 0.034
                : 0.046);
  }

  static double littleIcon(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.022
            : minorSize > 580
                ? 0.026
                : 0.034);
  }

  static double tinyIcon(BuildContext context) {
    final minorSize = getSizeByOrientation(1, 1, false, context);
    return minorSize *
        (minorSize > 780
            ? 0.011
            : minorSize > 580
                ? 0.015
                : 0.021);
  }

  static double getSizeByOrientation(
    double onLandscapePercentage,
    double onPortraitPercentage,
    bool takeMajor,
    BuildContext context
  ) {
    final media = _getMediaFromContext(context);
    final isLandScape = _isLandScape(media);
    late double size;
    if (isLandScape) {
      size = onLandscapePercentage;
      if (takeMajor) {
        return size * media.size.width;
      } else {
        return size * media.size.height;
      }
    } else {
      size = onPortraitPercentage;
      if (takeMajor) {
        return size * media.size.height;
      } else {
        return size * media.size.width;
      }
    }
  }

  static double widthPercentage(double percentage, BuildContext context) =>
      _getMediaFromContext(context).size.width * percentage;

  static double heightPercentage(double percentage, BuildContext context) =>
      _getMediaFromContext(context).size.height * percentage;

  static MediaQueryData _getMediaFromContext(BuildContext context) =>
      MediaQuery.of(context);

  static ScreenOrientation getOrientation(BuildContext context) {
    final media = _getMediaFromContext(context);
    return _isLandScape(media)
        ? ScreenOrientation.landscape
        : ScreenOrientation.portrait;
  }

  static bool _isLandScape(MediaQueryData media) =>
      media.orientation == Orientation.landscape;

  static double getSizeMedia(BuildContext context){
    final size = _getMediaFromContext(context).size;
    return (size.height + size.width)/2;
  }

  static ScreenSize getScreenDimension(BuildContext context) {
    final sizeMedia = getSizeMedia(context);
    return (sizeMedia > 750
        ? ScreenSize.big
        : sizeMedia > 550
            ? ScreenSize.mid
            : ScreenSize.little);
  }

  static double getSizeByScreenDimension(
      double bigPercentage,
      double midPercentage,
      double littlePercentage,
      bool isMajorScreenValue,
      BuildContext context) {
    final screenSize = getScreenDimension(context);
    return (screenSize == ScreenSize.big
        ? getSizeByOrientation(
            bigPercentage, bigPercentage, isMajorScreenValue, context)
        : screenSize == ScreenSize.mid
            ? getSizeByOrientation(
                midPercentage, midPercentage, isMajorScreenValue, context)
            : getSizeByOrientation(littlePercentage, littlePercentage,
                isMajorScreenValue, context));
  }
}
