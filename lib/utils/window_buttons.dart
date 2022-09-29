import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class Windowbuttons extends StatelessWidget {
  const Windowbuttons({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: WindowButtonColors(iconNormal: Colors.grey.shade300)),
        MaximizeWindowButton(colors: WindowButtonColors(iconNormal: Colors.grey.shade300)),
        CloseWindowButton(colors: WindowButtonColors(iconNormal: Colors.grey.shade300)),
      ],
    );
  }
}