import 'package:flutter/material.dart';

enum CustomBackgrounds{

  DEFAULT([Color.fromARGB(255, 45, 253, 101),Color.fromARGB(255, 39, 180, 251)], .7),
  QUIZ_SESSION([Color.fromARGB(255, 14, 50, 255),Color.fromARGB(255, 140, 0, 255)], .9),
  PASSED([Color.fromARGB(255, 250, 247, 85), Color.fromARGB(255, 100, 239, 6)], .9),
  FAILED([Color.fromARGB(255, 250, 32, 68),Color.fromARGB(255, 147, 27, 71)], .9);

  final List<Color> colors;
  final double opacity;

  const CustomBackgrounds(this.colors,this.opacity);
}

class BackgroundState{
  final List<Color> _colors;
  final double _opacity;

  BackgroundState(this._colors,this._opacity);
  BackgroundState.init(): this._colors = CustomBackgrounds.DEFAULT.colors, this._opacity = CustomBackgrounds.DEFAULT.opacity;
  BackgroundState.custom(CustomBackgrounds bg): this._colors = bg.colors, this._opacity = bg.opacity;
}

final ValueNotifier<BackgroundState> bgNotifier = ValueNotifier(
  BackgroundState.init()
);

void setToDefault() => bgNotifier.value = BackgroundState.init();

void changeBackGround({required CustomBackgrounds bg}){
  bgNotifier.value = BackgroundState.custom(bg);
}

class Background extends StatefulWidget {
  const new({super.key});

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ValueListenableBuilder(
        valueListenable: bgNotifier, 
        builder: (context,bg,_) => Opacity(
          opacity: bg._opacity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: bg._colors
              )
            )
            ),
        )
        )
      );
  }
}