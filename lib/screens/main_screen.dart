import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

//test for sliders
final titles = [
  'Welcome to CoDev',
  'Choose Your Path',
  'Personalized Learning'
];
final subtitles = [
  'Start your journey into the exciting world of Information Technology with CoDev. Explore various fields, gain valuable skills, and prepare for a successful IT career.',
  'Discover the diverse fields within IT, from cybersecurity to web development. Customize your learning experience by selecting the field that interests you the most. Let\'s begin your IT adventure!',
  'Dive into your chosen IT field with tailored courses, quizzes, and resources. Track your progress, earn badges, and collaborate with peers. CoDev is your partner in mastering Information Technology.'
];

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
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: FigmaColors.sUNRISESunray,
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height * 0.4,
              padding: EdgeInsets.only(
                top: deviceSize.height * 0.1,
              ),
              child: Center(
                child: Image.asset(
                  urlOb,
                ),
              ),
            ),
          ),
          Positioned(
            top: deviceSize.height * 0.4,
            left: 0,
            right: 0,
            child: Container(
              height: deviceSize.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              //margin: EdgeInsets.symmetric(vertical: 25),
              padding: EdgeInsets.all(deviceSize.width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildIndicator(),
                  SizedBox(
                    height: deviceSize.height * 0.025,
                  ),
                  Expanded(
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) =>
                              setState(() => activeIndex = index),
                          viewportFraction: 1.0),
                      itemCount: 3,
                      itemBuilder: (context, index, realIndex) {
                        final title = titles[index];
                        final subtitle = subtitles[index];
                        return buildMainScreen(
                            title, subtitle, index, deviceSize);
                      },
                    ),
                  ),
                  SizedBox(height: deviceSize.height * 0.025),
                  Container(
                    width: deviceSize.width * 0.7,
                    height: deviceSize.height * 0.08,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FigmaColors.sUNRISEBluePrimary,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Get Started',
                        style: FigmaTextStyles.mButton
                            .copyWith(color: FigmaColors.sUNRISEWhite),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMainScreen(
    String title,
    String subtitle,
    int index,
    Size device,
  ) =>
      Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: FigmaTextStyles.h3.copyWith(
              color: FigmaColors.sUNRISELightCharcoal,
            ),
          ),
          SizedBox(height: device.height * 0.025),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: FigmaTextStyles.p.copyWith(
                  color: FigmaColors.sUNRISETextGrey,
                ),
              ),
            ),
          ),
        ],
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 3,
        effect: ExpandingDotsEffect(
          dotWidth: 5,
          dotHeight: 5,
          dotColor: Color.fromARGB(255, 171, 255, 249),
          activeDotColor: Color(0xFF2FD1C5),
        ),
      );
}
