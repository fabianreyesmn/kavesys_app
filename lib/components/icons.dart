
import 'package:flutter/material.dart';

class KaveLogo extends StatelessWidget {
  final double width;
  final double height;

  const KaveLogo({Key? key, this.width = 24, this.height = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.business,
      size: width,
    );
  }
}
