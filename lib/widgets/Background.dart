import 'package:flutter/material.dart';

/// Preset gradient colors and opacity values used by the [Background] widget.
enum CustomBackgrounds{
  DEFAULT([Color.fromARGB(255, 45, 253, 101),Color.fromARGB(255, 39, 180, 251)], .7),
  QUIZ_SESSION([Color.fromARGB(255, 14, 50, 255),Color.fromARGB(255, 140, 0, 255)], .9),
  PASSED([Color.fromARGB(255, 250, 247, 85), Color.fromARGB(255, 100, 239, 6)], .9),
  FAILED([Color.fromARGB(255, 250, 32, 68),Color.fromARGB(255, 147, 27, 71)], .9);

  /// The colors used to create this gradient.
  final List<Color> colors;

  /// The opacity applied to this background.
  final double opacity;

  /// Creates a background preset from its gradient colors and opacity.
  const CustomBackgrounds(this.colors,this.opacity);
}

/// Holds the current gradient list of colors and opacity currently displayed by [Background].
class BackgroundState{
  final List<Color> _colors;
  final double _opacity;

  /// Creates a background state with the given colors and opacity.
  BackgroundState(this._colors,this._opacity);

  /// Creates a background state using [CustomBackgrounds.DEFAULT].
  BackgroundState.init(): this._colors = CustomBackgrounds.DEFAULT.colors, this._opacity = CustomBackgrounds.DEFAULT.opacity;

  /// Creates a background state from the given preset.
  BackgroundState.custom(CustomBackgrounds bg): this._colors = bg.colors, this._opacity = bg.opacity;
}

/// Notifies [Background] when the active background preset changes.
final ValueNotifier<BackgroundState> bgNotifier = ValueNotifier(BackgroundState.init());

/// Resets the active background to [CustomBackgrounds.DEFAULT].
void setToDefault() => bgNotifier.value = BackgroundState.init();

/// Changes the active background to the given preset from [CustomBackgrounds].
void changeBackGround({required CustomBackgrounds bg}){
  bgNotifier.value = BackgroundState.custom(bg);
}

/// Displays a full-area gradient background.
class Background extends StatefulWidget {
  const new({super.key});

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ValueListenableBuilder<BackgroundState>(
        valueListenable: bgNotifier,
        builder: (context, bg, _) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          layoutBuilder: (current, previous) {
            return Stack(
            fit: StackFit.expand,
            children: [...previous, if (current != null) current],
          );
          },
          child: Opacity(
            key: ObjectKey(bg),
            opacity: bg._opacity,
            child: SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: bg._colors,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
