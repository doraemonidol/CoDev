import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

//test for sliders
final titles = ['Study Planner', 'Build Your Future', 'Early Bird'];
final subtitles = ['abcd', 'efgh', 'ijkl'];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    final urlOb = 'assets/images/OBJECTS.png';
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: FigmaColors.sUNRISESunray,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 375,
              height: 433,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
            ),
          ),
          Positioned(
            right:44,
            top:163.54,
            child: Image.asset(
                  urlOb,
                ),
          ),
          Positioned(
            top: 379,
            left: 0,
              right: 0,
              child: Center(
                  child: Container(
                    height: 433,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0)
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildIndicator(),
                          SizedBox(height: 87),
                          Center(
                            child: CarouselSlider.builder(
                              options: CarouselOptions(
                                  height: 150,
                                  enableInfiniteScroll: false,
                                  onPageChanged: (index, reason) => setState(() => activeIndex = index)
                              ),
                              itemCount: 3,
                              itemBuilder: (context, index, realIndex) {
                                final title = titles[index];
                                final subtitle = subtitles[index];
                                return buildMainScreen(title, subtitle, index);
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Positioned(
                            top: 0,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 34, vertical: 14),
                                child: SizedBox(
                                  width: 250,
                                  height: 64,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: FigmaColors.sUNRISEBluePrimary,
                                          shape: ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.circular(24.0),
                                          )),
                                      onPressed: (){},
                                      child: Text(
                                        'Get Started',
                                        style: FigmaTextStyles.mButton.copyWith(color: FigmaColors.sUNRISEWhite),
                                      )
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
          )
          ),
        ],
      ),
    );
  }
  Widget buildMainScreen(String title, String subtitle, int index) => Column(
      children: [
          SizedBox(
            width: 250,
            child: Center(
              child: Text(
                title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                style: FigmaTextStyles.h3.copyWith(color: FigmaColors.sUNRISELightCharcoal),
              ),
            ),
          ),
        SizedBox(height: 24),
        SizedBox(
            width: 250,
            child: Center(
                child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: FigmaTextStyles.p.copyWith(color:FigmaColors.sUNRISETextGrey)))),
      ],
  );

  Widget buildIndicator() => AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: 3,
    effect: ExpandingDotsEffect(
        dotWidth: 5,
        dotHeight: 5,
        dotColor: Color.fromARGB(255, 171, 255, 249),
        activeDotColor: Color(0xFF2FD1C5)
    ),
  );
}
