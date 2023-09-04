import 'package:flutter/material.dart';

import '../helpers/style.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String text;
  final String imageUrl;
  final ValueChanged<T?> onChanged;
  final Color borderColor;
  late Size deviceSize;

  MyRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text,
    required this.imageUrl,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _customRadioButton,
        ],
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      width: deviceSize.width * 0.8,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? borderColor : FigmaColors.sUNRISEWhite,
      ),
      padding: EdgeInsets.all(deviceSize.width * 0.025),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: deviceSize.width * 0.16,
            height: deviceSize.width * 0.16,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(deviceSize.width * 0.015),
            child: Container(
              decoration: BoxDecoration(
                color: FigmaColors.sUNRISEWhite,
                borderRadius: BorderRadius.circular(600),
              ),
              child: Image.asset(
                imageUrl,
                width: 64,
                height: 64,
              ),
            ),
          ),
          SizedBox(width: deviceSize.width * 0.025),
          Text(
            text,
            style: FigmaTextStyles.mH3.copyWith(
                color: isSelected
                    ? FigmaColors.sUNRISECharcoal
                    : FigmaColors.sUNRISETextGrey),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
