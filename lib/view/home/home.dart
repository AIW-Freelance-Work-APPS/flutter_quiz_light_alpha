import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizy/model_view/data_provider.dart';
import 'package:quizy/utils/colors_utils.dart';
import 'package:quizy/utils/icons_constants.dart';
import 'package:quizy/utils/image_constants.dart';
import 'package:quizy/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalScore = 0;
  int totalQuestions = 0;
  @override
  void initState() {
    //get total score
    Future.delayed(const Duration(milliseconds: 1), () {
      Provider.of<DataProvider>(context, listen: false).getScore();
      Provider.of<DataProvider>(context, listen: false).getCorrectAnswers();
      Provider.of<DataProvider>(context, listen: false).getWrongAnswers();
    });
    totalScore = Provider.of<DataProvider>(context, listen: false).score;
    //get total questions
    for (var element
        in Provider.of<DataProvider>(context, listen: false).data.chapters!) {
      totalQuestions += element.quizQuestions!.length;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: const Color(0xffFFFCFC),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: hexToColor(value.data.mainColor.toString()),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          ImageConstants.smoke,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Good morning ☀️,\nThis is your leaderboard →',
                                  style: GoogleFonts.abel(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Container(
                                  height: 52,
                                  width: 52,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        color: hexToColor(
                                                value.data.mainColor.toString())
                                            .withOpacity(0.5),
                                        width: 3),
                                  ),
                                  child: Container(
                                    height: 52,
                                    width: 52,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          value.data.appIcon.toString(),
                                        ),
                                      ),
                                      border: Border.all(
                                          color: hexToColor(value.data.mainColor
                                                  .toString())
                                              .withOpacity(0.4),
                                          width: 3),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                appIcon(IconsConstants.coin, false, context, 25,
                                    25),
                                const SizedBox(width: 10),
                                Text(
                                  totalScore.toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.museoModerno(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.08,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Your Score',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.abel(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.45,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 210,
                    ),
                    Container(
                      height: 210,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 40,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Text(
                                          '${(value.correctAnswers * 100 / totalQuestions).floor()}%',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.barlow(
                                            color: const Color(0xFF2ECC71),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.60,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 89,
                                          width: 89,
                                          child: CircularProgressIndicator(
                                            value: value.correctAnswers /
                                                totalQuestions,
                                            strokeWidth: 15,
                                            strokeCap: StrokeCap.round,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(
                                              Color(0xFF2ECC71),
                                            ),
                                            backgroundColor:
                                                const Color(0xFF2ECC71)
                                                    .withOpacity(0.25),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Correct',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.barlow(
                                      color: const Color(0xFF2ECC71),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.72,
                                    ),
                                  ),
                                  Text(
                                    '${value.correctAnswers}/ $totalQuestions',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.barlow(
                                      color: const Color(0xFFD2D2D2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.48,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Text(
                                          '${(value.wrongAnswers * 100 / totalQuestions).floor()}%',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.barlow(
                                            color: const Color(0xFFEE3535),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.60,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 89,
                                          width: 89,
                                          child: CircularProgressIndicator(
                                            value: value.wrongAnswers /
                                                totalQuestions,
                                            strokeWidth: 15,
                                            strokeCap: StrokeCap.round,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(
                                              Color(0xFFEE3535),
                                            ),
                                            backgroundColor:
                                                const Color(0xFFEE3535)
                                                    .withOpacity(0.25),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Wrong',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.barlow(
                                      color: const Color(0xFFEE3535),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.72,
                                    ),
                                  ),
                                  Text(
                                    '${value.wrongAnswers} / $totalQuestions',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.barlow(
                                      color: const Color(0xFFD2D2D2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.48,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    homeItem(
                        context, IconsConstants.refresh, 'Reset and play again',
                        () {
                      value.resetAll();
                      value.getScore();
                      value.getCorrectAnswers();
                      value.getWrongAnswers();
                    }),
                    const SizedBox(height: 20),
                    homeItem(context, IconsConstants.share, 'Share your score',
                        () {
                      Share.share(
                          'I scored $totalScore in ${value.data.appName.toString()} Can you beat me?');
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell homeItem(
      BuildContext context, String icon, String title, Function() onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 40,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  appIcon(icon, false, context, 36, 36),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: GoogleFonts.barlow(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.60,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}

int getDifficult(int index) {
  return index + 3;
}
