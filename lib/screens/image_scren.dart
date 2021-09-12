import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<String> imageList = [
  "assets/images/nails1.jpeg",
  "assets/images/nails6.jpeg",
  "assets/images/nails3.jpeg",
  "assets/images/nails4.jpeg",
  "assets/images/nails5.jpeg",
  "assets/images/nails7.jpeg",
  "assets/images/nails2.jpeg",
  "assets/images/nails8.jpeg",
  "assets/images/nails9.jpeg",
  "assets/images/nails10.jpeg",
  "assets/images/nails11.jpeg",
  "assets/images/nails12.jpeg",
  "assets/images/nails13.jpeg",
  "assets/images/nails14.jpeg",
  "assets/images/nails15.jpeg",
  "assets/images/nails16.jpeg",
  "assets/images/nails17.jpeg",
  "assets/images/nails18.jpeg",
  "assets/images/nails19.jpeg",
  "assets/images/nails20.jpeg",
  "assets/images/nails21.jpeg",
  "assets/images/nails22.jpeg",
  "assets/images/nails23.jpeg",
];

class DetailImageScreen extends StatefulWidget {
  final int index;

  DetailImageScreen({Key key, @required this.index})
      : assert(index != null),
        super(key: key);

  @override
  _DetailImageScreenState createState() => _DetailImageScreenState();
}

class _DetailImageScreenState extends State<DetailImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoPageScaffold(
            backgroundColor: Color(0xff2d2d2d), child: _showImage())
        : Scaffold(backgroundColor: Color(0xff2d2d2d), body: _showImage());
  }

  Widget _showImage() {
    return GestureDetector(
      child: Center(
        child: Hero(
          tag: widget.index,
          child: Image.asset(
            imageList[widget.index],
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
