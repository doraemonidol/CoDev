import 'dart:convert';
import 'package:chiclet/chiclet.dart';
import 'package:codev/helpers/style.dart';
import 'package:codev/providers/quiz_info.dart';
import 'package:codev/screens/endquiz_screen.dart';
import 'package:flutter/cupertino.dart';
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
    if (quiz.quests.isEmpty) return false;
    for (int i = 0; i < quiz.quests.length; ++i) {
      //check if statement is empty
      if (quiz.quests[i].statement.isEmpty) {
        return false;
      }

      //check if quiz have options
      if (quiz.quests[i].options.length != 4) {
        return false;
      } else if (quiz.quests[i].options[0]!.isEmpty ||
          quiz.quests[i].options[1]!.isEmpty ||
          quiz.quests[i].options[2]!.isEmpty ||
          quiz.quests[i].options[3]!.isEmpty) {
        return false;
      }

      //check if answer is in (A, B, C, D)
      if (quiz.quests[i].answer < 0 || quiz.quests[i].answer > 3) return false;
    }

    return true;
  }

  // List<String> attachQuestion(String content) {
  //   RegExp regExp = RegExp(r'(\d.(.|\n)*?[+]{3}> \d)');
  //   List<String> tmp =
  //       regExp.allMatches(content).map((z) => z.group(0)!).toList();
  //   return tmp;
  // }

  // Question createQuestionObject(String rawQuest) {
  //   RegExp statementRegEx = RegExp(r'([\d]{1,2}[.]([^+|\n])*)');
  //   RegExp optionRegEx = RegExp(r'([+|>]{2}[ ]\w[.][ ]{0,1}.*)');
  //   RegExp answerRegEx = RegExp(r'([+|>]+ \d)');

  //   final statement = statementRegEx
  //       .firstMatch(rawQuest)!
  //       .group(0)
  //       .toString()
  //       .split('.')[1]
  //       .trim();

  //   List<String> options = optionRegEx
  //       .allMatches(rawQuest)
  //       .map((z) => z.group(0)!.substring(5).trim())
  //       .toList();

  //   String answer = answerRegEx
  //       .firstMatch(rawQuest)!
  //       .group(0)
  //       .toString()
  //       .substring(4)
  //       .trim();

  //   return Question(
  //       statement: statement,
  //       options: options,
  //       answer: int.parse(answer));
  // }

  List<Question> attachQuestion(List<dynamic> data) {
    List<Question> quests = [];
    for (var element in data) {
      Question q = Question(
          statement: element['question'],
          options: element['options'],
          answer: element['answer']);
      quests.add(q);
    }
    return quests;
  }

  Quiz createQuiz(String content) {
    Map<String, dynamic> jsonObject = json.decode(content);

    return Quiz(
      quizID: "randomQuizThatHasn'tBeenIdentified",
      createDate: DateTime.now(),
      quests: attachQuestion(jsonObject['quiz']),
    );
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
      // return Quiz(
      //   quizID: "randomQuizThatHasn'tBeenIdentified",
      //   createDate: DateTime.now(),
      //   quests: [
      //     Question(
      //         statement: "What is the capital of Vietnam?",
      //         options: ["Hanoi", "Ho Chi Minh", "Da Nang", "Hue"],
      //         answer: 0),
      //     Question(
      //         statement: "What is the capital of Vietnam?",
      //         options: ["Hanoi", "Ho Chi Minh", "Da Nang", "Hue"],
      //         answer: 0),
      //     Question(
      //         statement: "What is the capital of Vietnam?",
      //         options: ["Hanoi", "Ho Chi Minh", "Da Nang", "Hue"],
      //         answer: 0),
      //     Question(
      //         statement: "What is the capital of Vietnam?",
      //         options: ["Hanoi", "Ho Chi Minh", "Da Nang", "Hue"],
      //         answer: 0),
      //     Question(
      //         statement: "What is the capital of Vietnam?",
      //         options: ["Hanoi", "Ho Chi Minh", "Da Nang", "Hue"],
      //         answer: 0),
      //     Question(
      //         statement: "What is the capital of Vietnam?",
      //         options: ["Hanoi", "Ho Chi Minh", "Da Nang", "Hue"],
      //         answer: 0),
      //     Question(
      //         statement: "What is the capital of Vietnam?",
      //         options: ["Hanoi", "Ho Chi Minh", "Da Nang", "Hue"],
      //         answer: 0),
      //     Question(
      //         statement: "What is the capital of Vietnam?",
      //         options: ["Hanoi", "Ho Chi Minh", "Da Nang", "Hue"],
      //         answer: 0),
      //     Question(
      //         statement: "What is the capital of Vietnam?",
      //         options: ["Hanoi", "Ho Chi Minh", "Da Nang", "Hue"],
      //         answer: 0),
      //     Question(
      //         statement: "What is the capital of Vietnam?",
      //         options: ["Hanoi", "Ho Chi Minh", "Da Nang", "Hue"],
      //         answer: 0)
      //   ],
      // );

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
      print(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = Task(
      field: "Frontend",
      stage: "Internet",
      course: "How the Internet works?",
      startTime: DateTime(2023, 9, 2),
      endTime: DateTime(2023, 9, 8),
      state: 1,
    );

    //final task = ModalRoute.of(context)!.settings.arguments as Task;

    return ChangeNotifierProvider<QuizInfo>(
      create: (context) => QuizInfo(),
      child: FutureBuilder<Quiz?>(
          future: prepareQuiz(getPrompt(task.field, task.stage, task.course)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                Provider.of<QuizInfo>(context, listen: false)
                    .setQuiz(snapshot.data!);
                Provider.of<QuizInfo>(context, listen: false)
                    .setQuizTopic(task);
                //debugPrint(Provider.of<QuizInfo>(context, listen: false).field);
                return QuizScreen(task: task);
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
  final Task task;
  static const routeName = '/quiz-screen';
  QuizScreen({super.key, required this.task});
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: onExit,
        ),
        titleSpacing: 0,
        title: Consumer<QuizInfo>(
          builder: (context, system, child) => StepProgressIndicator(
            totalSteps: 10,
            currentStep: system.totalCorrect,
            size: 16,
            padding: 0.001,
            selectedColor: Colors.yellow,
            unselectedColor: Colors.cyan,
            roundedEdges: const Radius.circular(10),
            selectedGradientColor: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                FigmaColors.sUNRISELightCharcoal,
                FigmaColors.sUNRISELightCharcoal,
              ],
            ),
            unselectedGradientColor: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE5E5E5),
                Color(0xFFE5E5E5),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.02),
            child: Consumer<QuizInfo>(
              builder: (context, provider, child) => Text(
                "${provider.totalCorrect}/10",
                style: FigmaTextStyles.h4,
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                                    minimumSize: Size(
                                      300,
                                      deviceSize.height * 0.07,
                                    ),
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
                        padding: EdgeInsets.fromLTRB(
                          0,
                          deviceSize.width * 0.025,
                          0,
                          deviceSize.width * 0.025,
                        ),
                        height: deviceSize.height / 6,
                        decoration: const BoxDecoration(
                          color: FigmaColors.sUNRISELightCoral,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: deviceSize.width * 0.02,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                          height: safeHeight * 0.045,
                                          child: const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 32,
                                          )),
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
                                        if (system.complete) {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                            EndQuiz.routeName,
                                            arguments: widget.task,
                                          );
                                        }

                                        Provider.of<QuizInfo>(context,
                                                listen: false)
                                            .enableButton();
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
                        padding: EdgeInsets.fromLTRB(
                            0,
                            deviceSize.width * 0.025,
                            0,
                            deviceSize.width * 0.025),
                        height: deviceSize.height / 6,
                        color: FigmaColors.sUNRISELightCoral,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: deviceSize.width * 0.02,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        height: safeHeight * 0.045,
                                        child: const Icon(
                                          CupertinoIcons.xmark_circle_fill,
                                          color: FigmaColors.sUNRISEErrorRed,
                                          size: 32,
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
                                        Provider.of<QuizInfo>(context,
                                                listen: false)
                                            .enableButton();
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Choose the correct answers",
              style: FigmaTextStyles.mP.copyWith(
                color: FigmaColors.sUNRISETextGrey,
              ),
            ),
          ),
          SizedBox(
            height: safeHeight * 0.01,
          ),
          Consumer<QuizInfo>(
            builder: (context, system, child) => Align(
              alignment: Alignment.centerLeft,
              child: Text(
                system.getCurrentQuestion().statement,
                style: FigmaTextStyles.h4.copyWith(
                  color: FigmaColors.sUNRISELightCharcoal,
                ),
              ),
            ),
          ),
          SizedBox(
            height: safeHeight * 0.02,
          ),
          Consumer<QuizInfo>(
            builder: (context, system, child) => Column(children: [
              QuizOption(
                deviceSize: deviceSize,
                system: system,
                index: 1,
                borderColor: Color(0xFFFFDD563),
              ),
              SizedBox(
                width: deviceSize.width * 0.05,
                height: deviceSize.width * 0.025,
              ),
              QuizOption(
                deviceSize: deviceSize,
                system: system,
                index: 2,
                borderColor: FigmaColors.sUNRISEWaves,
              ),
              SizedBox(
                width: deviceSize.width * 0.05,
                height: deviceSize.width * 0.025,
              ),
              QuizOption(
                deviceSize: deviceSize,
                system: system,
                index: 3,
                borderColor: Color(0xFFB3B4F7),
              ),
              SizedBox(
                width: deviceSize.width * 0.05,
                height: deviceSize.width * 0.025,
              ),
              QuizOption(
                deviceSize: deviceSize,
                system: system,
                index: 4,
                borderColor: Color(0xFF93B5FF),
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

class QuizOption extends StatelessWidget {
  final Size deviceSize;
  final int index;
  final Color borderColor;
  final QuizInfo system;

  const QuizOption({
    required this.deviceSize,
    required this.index,
    required this.borderColor,
    required this.system,
  });

  @override
  Widget build(BuildContext context) {
    bool isChoosen = system.option == index;
    return OutlinedButton.icon(
      onPressed: () {
        Provider.of<QuizInfo>(context, listen: false).onOptionClicked(index);
      },
      icon: Container(
        width: deviceSize.width * 0.14,
        height: deviceSize.width * 0.14,
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
          alignment: Alignment.center,
          child: Text(
            String.fromCharCode(index + 64),
            style: FigmaTextStyles.h4.copyWith(
              color: FigmaColors.sUNRISEDarkCharcoal,
            ),
          ),
        ),
      ),
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          Provider.of<QuizInfo>(context, listen: false)
              .getCurrentQuestion()
              .options[index - 1]!,
          style: FigmaTextStyles.p.copyWith(
              color: FigmaColors.sUNRISEDarkCharcoal,
              fontWeight: isChoosen ? FontWeight.bold : FontWeight.normal),
        ),
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(
          borderColor,
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
            horizontal: deviceSize.width * 0.025,
            vertical: deviceSize.width * 0.025,
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(deviceSize.width * 0.9, deviceSize.height * 0.08),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          (system.option == index) ? borderColor : FigmaColors.sUNRISEWhite,
        ),
      ).copyWith(
          side: MaterialStateProperty.all(
        BorderSide(
          color: borderColor,
          width: 2,
        ),
      )),
    );
  }
}
