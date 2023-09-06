import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/style.dart';
import '../icon/my_icons.dart';

// create horizontal list of any widget with any number of items in it, each widget is rendered as a button that only one widget of the list is chosen at a time

class HorizontalIconList extends StatefulWidget {
  @override
  State<HorizontalIconList> createState() => _HorizontalIconListState();
}

class _HorizontalIconListState extends State<HorizontalIconList> {
  final int numberOfIcons = 9;

  final List<IconData> iconDataList = [
    MyIcons.robot,
    MyIcons.cube_outline,
    CupertinoIcons.device_laptop,
    CupertinoIcons.double_music_note,
    CupertinoIcons.ant,
    CupertinoIcons.bolt,
    MyIcons.play,
    CupertinoIcons.chevron_left_slash_chevron_right,
    CupertinoIcons.cloud_sun,
  ];

  int currentIconIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 48,
        child: Row(
          children: List.generate(numberOfIcons, (index) {
            final iconData = iconDataList[index % iconDataList.length];
            final iconColor = FigmaColors.sUNRISEBluePrimary;
            return Container(
              margin: EdgeInsets.only(right: 12),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentIconIndex = index;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentIconIndex == index
                      ? FigmaColors.sUNRISEBluePrimary
                      : FigmaColors.sUNRISEWhite,
                  minimumSize: Size(48.0, 48.0),
                  padding: EdgeInsets.all(0),
                  shape: CircleBorder(),
                ),
                child: Icon(
                  iconData,
                  color: currentIconIndex == index
                      ? FigmaColors.sUNRISESunray
                      : iconColor,
                  size: 28.0,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class HorizontalColorList extends StatefulWidget {
  @override
  _HorizontalColorListState createState() => _HorizontalColorListState();
}

class _HorizontalColorListState extends State<HorizontalColorList> {
  final int numberOfColors = 8;
  List<Color> iconColors = [
    FigmaColors.sUNRISEBluePrimary,
    FigmaColors.sUNRISELightCharcoal,
    Color(0xFF004E8E),
    Color(0xFF26BFBF),
    Color(0xFF57E597),
    Color(0xFFFF7A7B),
    Color(0xFFFFB017),
    FigmaColors.sUNRISEWaves,
  ];

  int currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize iconColors with random colors
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: FigmaColors.lightblue,
            width: 1.0,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(numberOfColors, (index) {
            final iconColor = iconColors[index % iconColors.length];
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  currentColorIndex = index;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
                shape: CircleBorder(),
                minimumSize: Size(32.0, 32.0),
                padding: EdgeInsets.all(0),
              ),
              child: Icon(
                Icons.circle,
                color: currentColorIndex == index
                    ? FigmaColors.sUNRISEWhite
                    : iconColor,
                size: 16.0,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class HorizontalTextButtonList extends StatefulWidget {
  late int numberOfTexts;
  final List<String> texts;

  HorizontalTextButtonList({required this.texts}) {
    numberOfTexts = texts.length;
  }

  @override
  _HorizontalTextButtonListState createState() =>
      _HorizontalTextButtonListState();
}

class _HorizontalTextButtonListState extends State<HorizontalTextButtonList> {
  int currentTextIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: FigmaColors.lightblue,
            width: 1.0,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(widget.numberOfTexts, (index) {
            final text = widget.texts[index % widget.texts.length];
            return Container(
              height: 40,
              margin: EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    currentTextIndex = index;
                  });
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: FigmaColors.sUNRISEBluePrimary,
                      width: 1.5,
                    ),
                  ),
                  backgroundColor: currentTextIndex == index
                      ? FigmaColors.sUNRISEBluePrimary
                      : FigmaColors.sUNRISEWhite,
                  minimumSize: Size(64.0, 32.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                child: Text(
                  text,
                  style: FigmaTextStyles.sButton.copyWith(
                    color: currentTextIndex == index
                        ? FigmaColors.sUNRISEWhite
                        : FigmaColors.sUNRISEBluePrimary,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
