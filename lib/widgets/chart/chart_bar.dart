import 'package:flutter/material.dart';

/// A widget that represents a bar in a chart.
///
/// The bar is represented as a fraction of the available height, with a color
/// that depends on the current theme and the provided fill value.
///
/// The [fill] parameter is a double value between 0 and 1 that represents the
/// fraction of the available height that should be filled by the bar.
///
/// The widget automatically adjusts to the current platform brightness, using
/// a darker color scheme for dark mode.
class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
  });

  final double fill;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FractionallySizedBox(
          heightFactor: fill, // 0 <> 1
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              color: isDarkMode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.65),
            ),
          ),
        ),
      ),
    );
  }
}
