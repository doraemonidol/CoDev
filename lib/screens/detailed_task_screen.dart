import 'dart:async';
import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import 'package:codev/icon/my_icons.dart';
class ToDoCard {
  String date;
  String time;
  String title;
  String description;
  IconData icon;
  Color color;
  ToDoCard(this.date, this.time, this.title, this.description, this.icon, this.color);
}

class DetailedTaskScreen extends StatefulWidget {
  const DetailedTaskScreen({super.key});

  @override
  State<DetailedTaskScreen> createState() => _DetailedTaskScreenState();
}

class _DetailedTaskScreenState extends State<DetailedTaskScreen> {
  final ToDoCard card =
  ToDoCard(
    "Monday 17 August",
    "11:30 AM - 12:30 PM",
    "Math",
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,",
    MyIcons.robot,
    Color(0xFFFF7A7B),
  );

  final states = ['To Do', 'In Progress', 'Completed'];
  int seconds = maxSeconds;
  static int maxSeconds = 60;
  String stringTextTime = sampleTextTime;
  static String sampleTextTime = '1:34h';

  String? value;
  Timer? timer;
  double val = 48;

  void startTimer({bool reset = true}){
    if (reset){
      resetTimer();
    }
    timer = Timer.periodic (const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      }
      else {
        stopTimer(reset: false);
      }
    });
  }

  void resetTimer() => setState(() => seconds = maxSeconds);

  void stopTimer({bool reset = true}){
    if (reset){
      resetTimer();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: FigmaColors.sUNRISELightCoral,
    body: Column(
      children: [
        // Dropdown menu item and edit button
        firstPart(),

        // Card Information
        secondPart(),

        // Card Timer
        thirdPart(),

        SizedBox(height:20),
        //Slider
        SliderTheme(
          data: const SliderThemeData(
              trackHeight: 12,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 20),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 6),
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent
          ),
          child: Container(
            margin: EdgeInsets.all(16),
            child: Slider(
              value: val,
              min: 0,
              max: maxSeconds * 1.0,
              divisions: maxSeconds,
              activeColor: const Color(0xFF2FD1C5),
              inactiveColor: Colors.white,
              label: '${val.round()}%',
              onChanged: (val) => setState(() => this.val = val),
              thumbColor: Colors.white,
            ),
          ),
        ),

        buildButtons(),
        SizedBox(height:15),
        const SelectableText('Study now!', style: TextStyle(fontSize: 22, color: Color(0xFF00394C)),)
      ],
    ),
  );

  Widget firstPart() => Container(
    margin: EdgeInsets.fromLTRB(16,96,16,0),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFC4D7FF), width: 2)
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  focusColor: Colors.white,
                  value: value,
                  iconSize: 36,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_sharp, color: Color(0xFF585A66)),
                  items: states.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() => this.value = value)),
            ),
          ),
        ),
        Container(
          width: 48,
          height: 48,
          padding: EdgeInsets.all(0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: FigmaColors.sUNRISEBluePrimary ,
          ),
          child: IconButton(
            icon: const Icon(Icons.border_color, color: Colors.white),
            onPressed: () {},
          ),
        )
      ],
    ),
  );

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item,
        child: SelectableText(
          item,
          style: FigmaTextStyles.p.copyWith(color: FigmaColors.sUNRISETextGrey),
        ),
      );

  Widget secondPart() => Container(
    margin: const EdgeInsets.fromLTRB(16,14,16,0),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(
      color: FigmaColors.sUNRISEWhite,
      borderRadius: BorderRadius.circular(12),
      border: Border(
        top: BorderSide(color: card.color, width: 1),
        right: BorderSide(color: card.color, width: 1),
        bottom: BorderSide(color: card.color, width: 1),
        left: BorderSide(color: card.color, width:5),
      ),
    ),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(card.icon, color: card.color),
        SizedBox(height: 16),
        SelectableText(card.title, style: FigmaTextStyles.sButton.copyWith(color: FigmaColors.systemDark)),
        Text(card.description,maxLines: 20, overflow: TextOverflow.ellipsis, style: FigmaTextStyles.mT.copyWith(color: FigmaColors.systemGrey)),
      ],
    ),
  );

  Widget thirdPart() {
    String dateString = card.date;
    DateTime parseDate(String dateString) {
      final monthMap = {
        'January': 1,
        'February': 2,
        'March': 3,
        'April': 4,
        'May': 5,
        'June': 6,
        'July': 7,
        'August': 8,
        'September': 9,
        'October': 10,
        'November': 11,
        'December': 12,
      };

      final parts = dateString.split(' ');

      final day = int.tryParse(parts[1]);
      final month = monthMap[parts[2]];
      final year = DateTime.now().year; //this year - assumption

      if (day != null && month != null) {
        return DateTime(year, month, day);
      } else {
        throw FormatException('Invalid date format: $dateString');
      }
    }
    DateTime parsedDate = parseDate(dateString);
    DateTime today = DateTime.now();

    bool isToday = today.year == parsedDate.year &&
        today.month == parsedDate.month &&
        today.day == parsedDate.day;
    return Container(
      width: 329,
      height: 99,
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: FigmaColors.sUNRISEWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: FigmaColors.lightblue, width: 1.5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 26),
              Text.rich(
                TextSpan(
                  text: 'Due. ',
                  style: FigmaTextStyles.mP.copyWith(color: FigmaColors.sUNRISEDarkGrey),
                  children: [
                    TextSpan(
                      text: isToday ? 'Today, ' : '',
                      style: FigmaTextStyles.mB14.copyWith(color: FigmaColors.sUNRISETextGrey),
                    ),
                    TextSpan(
                      text: card.date,
                      style: FigmaTextStyles.mB14.copyWith(color: FigmaColors.sUNRISETextGrey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              SelectableText(
                card.time, style: FigmaTextStyles.mT.copyWith(color: FigmaColors.systemGrey),
              ),
            ],
          ),
          buildTimer(),
        ],
      ),
    );
  }

  Widget buildButtons(){
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0;

    return isRunning || !isCompleted
        ? IconButton(
        onPressed: () {stopTimer(reset: false);},
        style: IconButton.styleFrom(backgroundColor: const Color(0xFF2FD1C5)),
        iconSize: 60,
        icon: const Icon(Icons.stop, color: Colors.white))
        : IconButton(
        onPressed: () {startTimer();},
        style: IconButton.styleFrom(backgroundColor: const Color(0xFF2FD1C5)),
        iconSize: 60,
        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white));
  }

  Widget buildTimer() => SizedBox(
    width: 60,
    height: 60,
    child: Stack(
      fit: StackFit.expand,
      children: [
        CircularProgressIndicator(
          value: seconds / maxSeconds,
          strokeWidth: 4,
          valueColor: const AlwaysStoppedAnimation(Color(0xFFFFB017)),
          backgroundColor: const Color(0xFFE4EDFF),
        ),
        Center(child: buildTime()),
      ],

    ),
  );

  Widget buildTime(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.timer, color: Color(0xFF2FD1C5), size: 20),
        Text('$seconds s', style: FigmaTextStyles.mB14.copyWith(color: FigmaColors.sUNRISETextGrey)),
      ],
    );
  }
}