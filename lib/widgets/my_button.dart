import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Widget label;
  final Function()? onTap;
  const MyButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        width: 143,
        height: 48,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white
        ),
        child: label
    ),
  );
}