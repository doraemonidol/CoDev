import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              color: FigmaColors.sUNRISESunray,
            ),
            Positioned(
                top: 98,
                right: 0,
                left: 37,
                child: Text(
                  'Education Level',
                  style: FigmaTextStyles.h3.copyWith(color:FigmaColors.sUNRISELightCharcoal),
                )
            ),
            Positioned(
                top: 146,
                right: 0,
                left: 37,
                child: Text(
                  'abc',
                  style: FigmaTextStyles.mP.copyWith(color:FigmaColors.sUNRISETextGrey),
                )
            ),
            Positioned(
              top:210,
              left:32,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // Adjust alignment as needed
                children: [
                  CustomButton(
                    imageUrl: 'assets/images/Group 34181.png',
                    text: 'Year 7-9',
                    borderColor: Color(0xFFFDD563),
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    imageUrl: 'assets/images/Group 34182.png',
                    text: 'Year 10-11',
                    borderColor: Color(0xFF8BE38B),
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    imageUrl: 'assets/images/Group 34183.png',
                    text: 'Year 12-13',
                    borderColor: Color(0xFFB3B4F7),
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    imageUrl: 'assets/images/Group 34184.png',
                    text: 'Bachelors',
                    borderColor: FigmaColors.lightblue,
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    imageUrl: 'assets/images/Group 34185.png',
                    text: 'Masters',
                    borderColor: FigmaColors.sUNRISEWaves,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Positioned(
                top: 742,
                left: 298,
                child: Text(
                  'Skip',
                  style: FigmaTextStyles.mButton.copyWith(color:FigmaColors.sUNRISEBluePrimary),
                )
            ),
          ]
        )
    );
  }
}
class CustomButton extends StatelessWidget {
  final String imageUrl;
  final String text;
  final Color borderColor;

  CustomButton({required this.imageUrl, required this.text, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 311,
      height: 88,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
        ),
        color: FigmaColors.sUNRISEWhite,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top:6, left: 15),
            child: Image.asset(
              imageUrl,
              width: 64,
              height: 64,
            ),
          ),
          SizedBox(width: 16),
          Text(
            text,
            style: FigmaTextStyles.mH3.copyWith(color:FigmaColors.sUNRISETextGrey),
          ),
        ],
      ),
    );
  }
}
