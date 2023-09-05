import 'dart:convert';
import 'package:chiclet/chiclet.dart';
import 'package:codev/helpers/style.dart';
import 'package:codev/providers/quiz_info.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/tasks.dart';
import "package:http/http.dart" as http;
import '../providers/quiz.dart';
import '../screens/error_screen.dart';
import '../screens/waiting_screen.dart';
import '../helpers/prompt.dart';

class QScreen extends StatefulWidget {
  const QScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QScreen();
}

class _QScreen extends State<QScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  bool validateQuiz(Quiz quiz) {
    //check if quiz have options
    for (int i = 0; i < quiz.quests.length; ++i) {
      if (quiz.quests[i].options.length < 4) {
        return false;
      } else {
        if (quiz.quests[i].options[0]!.isEmpty ||
            quiz.quests[i].options[1]!.isEmpty ||
            quiz.quests[i].options[2]!.isEmpty ||
            quiz.quests[i].options[3]!.isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  List<String> attachQuestion(String content) {
    RegExp regExp = RegExp(r'(\d.(.|\n)*?[+]{3}> \d)');
    List<String> tmp =
        regExp.allMatches(content).map((z) => z.group(0)!).toList();
    return tmp;
  }

  Question createQuestionObject(String rawQuest) {
    RegExp statementRegEx = RegExp(r'([\d]{1,2}[.]([^+|\n])*)');
    RegExp optionRegEx = RegExp(r'([+|>]{2}[ ]\w[.][ ]{0,1}.*)');
    RegExp answerRegEx = RegExp(r'([+|>]+ \d)');

    final statement = statementRegEx
        .firstMatch(rawQuest)!
        .group(0)
        .toString()
        .split('.')[1]
        .trim();

    List<String> options = optionRegEx
        .allMatches(rawQuest)
        .map((z) => z.group(0)!.substring(5).trim())
        .toList();

    String answer = answerRegEx
        .firstMatch(rawQuest)!
        .group(0)
        .toString()
        .substring(4)
        .trim();

    return Question(
        questID: "randomQuestIDThatHaventBeenGeneratedYet",
        statement: statement,
        options: options,
        answer: int.parse(answer));
  }

  Quiz createQuiz(String content) {
    List<String> rawQuestions = attachQuestion(content);

    List<Question> quests = [];
    for (int i = 0; i < rawQuestions.length; i++) {
      Question cleanQuest = createQuestionObject(rawQuestions[i]);
      quests.add(cleanQuest);
    }
    return Quiz(
        quizID: "randomQuizIDThatHaventBeenGeneratedYet",
        createDate: DateTime.now(),
        quests: quests);
  }

  Future<Quiz?> prepareQuiz(String prompt) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };

    final body = jsonEncode({
      "model": "text-davinci-003",
      "prompt": prompt,
      "max_tokens": 1000,
    });

    try {
      final response = await http.post(
        Uri.parse(apiURL),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        String content = jsonDecode(response.body)['choices'][0]['text'];
        content = content.trim();
        Quiz quiz = createQuiz(content);
        if (validateQuiz(quiz)) {
          return quiz;
        } else {
          throw 'Fail to create a quiz';
        }
      } else {
        throw "Fail to call GPT API ${response.statusCode}";
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = Task(
      field: "Frontend",
      stage: "Internet",
      course: "How the Internet works?",
      chapter: "History",
      startTime: DateTime(2023, 9, 2),
      endTime: DateTime(2023, 9, 8),
      state: 1,
    );

    return ChangeNotifierProvider<QuizInfo>(
      create: (context) => QuizInfo(),
      child: FutureBuilder<Quiz?>(
          future: prepareQuiz(getPrompt(task.field, task.stage, task.course)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                Provider.of<QuizInfo>(context, listen: false)
                    .setQuiz(snapshot.data!);
                return const QuizScreen();
              }
            } else if (snapshot.hasError) {
              //return QuizScreen();
              return const ErrorScreen();
            }
            return WaitingScreen();
          }),
    );
  }
}

class QuizScreen extends StatefulWidget {
  static const routeName = '/quiz-screen';
  const QuizScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _QuizScreen();
}

class _QuizScreen extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    offset = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
        .animate(controller);
  }

  void animationPlaying() {
    setState(() {
      switch (controller.status) {
        case AnimationStatus.completed:
          controller.reverse();
          break;
        case AnimationStatus.dismissed:
          controller.forward();
          break;
        default:
          controller.reverse();
          break;
      }
    });
  }

  void onExit() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;

    //final task = ModalRoute.of(context)!.settings.arguments as Task;

    /*final fieldInfo = Provider.of<FieldList>(
      context,
      listen: false,
    ).findByName(task.field);*/

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /* Top Bar : Exit, Progress, Statistics*/
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(Icons.door_back_door_outlined),
                      onPressed: onExit,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Consumer<QuizInfo>(
                      builder: (context, system, child) =>
                          StepProgressIndicator(
                        totalSteps: 10,
                        currentStep: system.totalCorrect,
                        size: 13,
                        padding: 0.001,
                        selectedColor: Colors.yellow,
                        unselectedColor: Colors.cyan,
                        roundedEdges: const Radius.circular(10),
                        selectedGradientColor: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.yellowAccent, Colors.deepOrange],
                        ),
                        unselectedGradientColor: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.black, Colors.blue],
                        ),
                      ),
                    ),
                  ),
                  Consumer<QuizInfo>(
                    builder: (context, provider, child) => Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${provider.totalCorrect}/10",
                          style: FigmaTextStyles.h4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: safeHeight * 0.01),
            const Expanded(
              flex: 14,
              child: QuizContent(),
            ),
            Consumer<QuizInfo>(
              builder: (context, system, child) => Expanded(
                flex: 3,
                child: IndexedStack(
                  index: system.indexedButton,
                  children: [
                    SizedBox(
                      height: deviceSize.height / 6,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: null,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(deviceSize.width * 0.7,
                                        deviceSize.height * 0.06),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Text(
                                    "CHECK",
                                    style: FigmaTextStyles.h4
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: safeHeight * 0.01),
                          ]),
                    ),
                    SizedBox(
                      height: deviceSize.height / 6,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ChicletOutlinedAnimatedButton(
                                  onPressed: () {
                                    system.updateResult();
                                    animationPlaying();
                                  },
                                  buttonType:
                                      ChicletButtonTypes.roundedRectangle,
                                  width: 300,
                                  buttonColor:
                                      const Color.fromRGBO(63, 142, 21, 100),
                                  backgroundColor: Colors.green,
                                  borderColor: Colors.green,
                                  child: Text(
                                    "CHECK",
                                    style: FigmaTextStyles.h4
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: safeHeight * 0.01),
                          ]),
                    ),
                    SlideTransition(
                      position: offset,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, deviceSize.width * 0.05,
                            0, deviceSize.width * 0.025),
                        height: deviceSize.height / 6,
                        color: FigmaColors.sUNRISELightCoral,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: deviceSize.width * 0.02,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        height: safeHeight * 0.035,
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/img/correct.png'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        "Amazing!",
                                        style: FigmaTextStyles.h4,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ChicletOutlinedAnimatedButton(
                                      onPressed: () {
                                        system.slideNextQuestion();
                                        animationPlaying();
                                      },
                                      buttonType:
                                          ChicletButtonTypes.roundedRectangle,
                                      width: 300,
                                      buttonColor: const Color.fromRGBO(
                                          63, 142, 21, 100),
                                      backgroundColor: Colors.green,
                                      borderColor: Colors.green,
                                      child: Text(
                                        "CONTINUE",
                                        style: FigmaTextStyles.h4
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    SlideTransition(
                      position: offset,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, deviceSize.width * 0.05,
                            0, deviceSize.width * 0.025),
                        height: deviceSize.height / 6,
                        color: FigmaColors.sUNRISELightCoral,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: deviceSize.width * 0.02,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        width: deviceSize.width * 0.08,
                                        height: deviceSize.width * 0.08,
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/img/wrong.png'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        "Incorrect",
                                        style: FigmaTextStyles.h4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ChicletOutlinedAnimatedButton(
                                      onPressed: () {
                                        system.slideNextQuestion();
                                        animationPlaying();
                                      },
                                      buttonType:
                                          ChicletButtonTypes.roundedRectangle,
                                      width: 300,
                                      buttonColor:
                                          const Color.fromRGBO(86, 27, 22, 100),
                                      backgroundColor:
                                          FigmaColors.sUNRISEErrorRed,
                                      borderColor: FigmaColors.sUNRISEErrorRed,
                                      child: Text(
                                        "RETRY",
                                        style: FigmaTextStyles.h4
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizContent extends StatefulWidget {
  const QuizContent({super.key});
  @override
  State<StatefulWidget> createState() => _QuizContent();
}

class _QuizContent extends State<QuizContent> {
  //functionality
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          deviceSize.width * 0.05, 0, deviceSize.width * 0.05, 0),
      child: Column(
        children: [
          Text(
            "Choose the correct answers",
            style: FigmaTextStyles.p.copyWith(),
          ),
          SizedBox(
            height: safeHeight * 0.02,
          ),
          Consumer<QuizInfo>(
            builder: (context, system, child) => Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  system.getCurrentQuestion().statement,
                  style: FigmaTextStyles.h4,
                )),
          ),
          SizedBox(
            height: safeHeight * 0.02,
          ),
          Consumer<QuizInfo>(
            builder: (context, system, child) => Column(children: [
              OutlinedButton.icon(
                onPressed: Provider.of<QuizInfo>(context, listen: false)
                    .onOptionAClicked,
                icon: SizedBox(
                  width: deviceSize.width * 0.17,
                  height: deviceSize.width * 0.17,
                  child: const Image(
                    image: AssetImage('assets/img/OptA.png'),
                  ),
                ),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      Provider.of<QuizInfo>(context, listen: false)
                          .getCurrentQuestion()
                          .options[0]!,
                      style: FigmaTextStyles.mP
                          .copyWith(color: FigmaColors.sUNRISEDarkCharcoal)),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(deviceSize.width * 0.9, deviceSize.height * 0.08),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(FigmaColors.sUNRISEWhite),
                  side: MaterialStateProperty.all(
                    BorderSide(
                      width: 1.0,
                      color: (system.option == 1)
                          ? FigmaColors.sUNRISEBluePrimary
                          : Color(0xFFFFDD563),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: deviceSize.width * 0.05,
                height: deviceSize.width * 0.025,
              ),
              OutlinedButton.icon(
                onPressed: Provider.of<QuizInfo>(context, listen: false)
                    .onOptionBClicked,
                icon: SizedBox(
                  width: deviceSize.width * 0.17,
                  height: deviceSize.width * 0.17,
                  child: const Image(
                    image: AssetImage('assets/img/OptB.png'),
                  ),
                ),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Provider.of<QuizInfo>(context, listen: false)
                        .getCurrentQuestion()
                        .options[1]!,
                    style: FigmaTextStyles.mP
                        .copyWith(color: FigmaColors.sUNRISEDarkCharcoal),
                  ),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(deviceSize.width * 0.9, deviceSize.height * 0.08),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(FigmaColors.sUNRISEWhite),
                  side: MaterialStateProperty.all(
                    BorderSide(
                      width: 1.0,
                      color: (system.option == 2)
                          ? FigmaColors.sUNRISEBluePrimary
                          : Color(0xFFFFDD563),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: deviceSize.width * 0.05,
                height: deviceSize.width * 0.025,
              ),
              OutlinedButton.icon(
                onPressed: Provider.of<QuizInfo>(context, listen: false)
                    .onOptionCClicked,
                icon: SizedBox(
                  width: deviceSize.width * 0.17,
                  height: deviceSize.width * 0.17,
                  child: const Image(
                    image: AssetImage('assets/img/OptC.png'),
                  ),
                ),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Provider.of<QuizInfo>(context, listen: false)
                        .getCurrentQuestion()
                        .options[2]!,
                    style: FigmaTextStyles.mP
                        .copyWith(color: FigmaColors.sUNRISEDarkCharcoal),
                  ),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(deviceSize.width * 0.9, deviceSize.height * 0.08),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(FigmaColors.sUNRISEWhite),
                  side: MaterialStateProperty.all(
                    BorderSide(
                      width: 1.0,
                      color: (system.option == 3)
                          ? FigmaColors.sUNRISEBluePrimary
                          : Color(0xFFFFDD563),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: deviceSize.width * 0.05,
                height: deviceSize.width * 0.025,
              ),
              OutlinedButton.icon(
                onPressed: Provider.of<QuizInfo>(context, listen: false)
                    .onOptionDClicked,
                icon: SizedBox(
                  width: deviceSize.width * 0.17,
                  height: deviceSize.width * 0.17,
                  child: const Image(
                    image: AssetImage('assets/img/OptD.png'),
                  ),
                ),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Provider.of<QuizInfo>(context, listen: false)
                        .getCurrentQuestion()
                        .options[3]!,
                    style: FigmaTextStyles.mP
                        .copyWith(color: FigmaColors.sUNRISEDarkCharcoal),
                  ),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(deviceSize.width * 0.9, deviceSize.height * 0.08),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(FigmaColors.sUNRISEWhite),
                  side: MaterialStateProperty.all(
                    BorderSide(
                      width: 1.0,
                      color: (system.option == 4)
                          ? FigmaColors.sUNRISEBluePrimary
                          : Color(0xFFFFDD563),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(
            width: deviceSize.width * 0.05,
            height: deviceSize.width * 0.025,
          ),
        ],
      ),
    );
  }
}
