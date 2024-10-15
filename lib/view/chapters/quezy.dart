// ignore_for_file: use_build_context_synchronously
import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizy/model/data.dart';
import 'package:quizy/model_view/data_provider.dart';
import 'package:quizy/utils/colors_utils.dart';
import 'package:quizy/utils/icons_constants.dart';
import 'package:quizy/utils/utils.dart';

class QuizQuestionScreen extends StatefulWidget {
  final Chapters chapter;
  final int index;
  const QuizQuestionScreen(
      {super.key, required this.chapter, required this.index});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  List<String> alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L'
  ];
  int questionsIndex = 0;
  int selectedAnswer = -1;
  int timerCountdown = 30; // Countdown timer value
  Timer? timer; // Timer object

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the timer when the widget is initialized
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void startTimer() {
    timerCountdown = 30; // Reset timer to 30 seconds
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timerCountdown > 0) {
        setState(() {
          timerCountdown--;
        });
      } else {
        goToNextQuestion(); // If time is up, go to next question
      }
    });
  }

  void goToNextQuestion() {
    if (mounted) {
      // Check if the widget is still mounted
      if (questionsIndex < widget.chapter.quizQuestions!.length - 1) {
        Future.delayed(const Duration(seconds: 0), () async {
          if (mounted) {
            // Check again inside the Future
            await Provider.of<DataProvider>(context, listen: false)
                .getChapter('chapter${widget.index}');
            List<String> missiondone =
                Provider.of<DataProvider>(context, listen: false).missiondone;
            missiondone[questionsIndex] = '2';
            await Provider.of<DataProvider>(context, listen: false)
                .saveChapter('chapter${widget.index}', missiondone);
          }
        });
        setState(() {
          questionsIndex++;
          selectedAnswer = -1; // Reset the selected answer
          timerCountdown = 30; // Reset the timer for the next question
        });
      } else {
        timer?.cancel(); // Stop the timer if it's the last question
        if (mounted) {
          Navigator.pop(context); // Navigate back when the quiz is done
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Timer display
                      Container(
                        width: 68,
                        height: 30,
                        decoration: ShapeDecoration(
                          color: const Color(0x33FFA452),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            appIcon(
                                IconsConstants.time, false, context, 16, 16),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '$timerCountdown s', // Display the timer countdown
                              style: GoogleFonts.museoModerno(
                                color: const Color(0xFFFFA358),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          timer?.cancel(); // Cancel the timer when exiting
                          Navigator.pop(context);
                        },
                        child: Opacity(
                          opacity: 0.80,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.07),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: appIcon(IconsConstants.close, false,
                                    context, 16, 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Progress bar and question index
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: LinearProgressIndicator(
                          value: questionsIndex /
                              widget.chapter.quizQuestions!.length,
                          minHeight: 21,
                          borderRadius: BorderRadius.circular(100),
                          backgroundColor: Colors.black.withOpacity(0.07),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              hexToColor(value.data.mainColor.toString())),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        height: 21,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF2EFEF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            appIcon(
                                IconsConstants.chapter, false, context, 12, 12),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '$questionsIndex/${widget.chapter.quizQuestions!.length}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.museoModerno(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              // Question text
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  widget.chapter.quizQuestions![questionsIndex].question!,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: GoogleFonts.museoModerno(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Question image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(
                          widget.chapter.quizQuestions![questionsIndex].asset!),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              // Answer options
              Expanded(
                flex: 4,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget
                      .chapter.quizQuestions![questionsIndex].options!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedAnswer = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 49,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedAnswer == index
                                    ? hexToColor(
                                        value.data.mainColor.toString())
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                              color: const Color(0xFFF1EEEE),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 34,
                                  width: 34,
                                  decoration: BoxDecoration(
                                    color: hexToColor(
                                        value.data.mainColor.toString()),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      alphabet[index],
                                      style: GoogleFonts.museoModerno(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  widget.chapter.quizQuestions![questionsIndex]
                                      .options![index],
                                  style: GoogleFonts.abel(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFFC2C1C1)),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x11000000),
                                        blurRadius: 20,
                                        offset: Offset(0, 0),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    if (mounted) {
                      if (selectedAnswer != -1) {
                        if (widget.chapter.quizQuestions![questionsIndex]
                                .options![selectedAnswer] ==
                            widget.chapter.quizQuestions![questionsIndex]
                                .correctOption) {
                          value.incrementScore(250);
                          await value.getChapter('chapter${widget.index}');
                          List<String> missiondone = value.missiondone;
                          missiondone[questionsIndex] = '1';
                          await value.saveChapter(
                              'chapter${widget.index}', missiondone);
                        } else {
                          await value.getChapter('chapter${widget.index}');
                          List<String> missiondone = value.missiondone;
                          missiondone[questionsIndex] = '2';
                          await value.saveChapter(
                              'chapter${widget.index}', missiondone);
                        }
                        if (questionsIndex <
                            widget.chapter.quizQuestions!.length - 1) {
                          startTimer();
                          setState(() {
                            questionsIndex++;
                            selectedAnswer = -1;
                          });
                        } else {
                          if (mounted) {
                            timer?.cancel();
                          }

                          Navigator.pop(context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an answer'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 49,
                    decoration: BoxDecoration(
                      color: hexToColor(value.data.mainColor.toString()),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Next',
                        style: GoogleFonts.museoModerno(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
