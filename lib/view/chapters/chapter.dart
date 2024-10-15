import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:glass/glass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizy/model/data.dart';
import 'package:quizy/model_view/data_provider.dart';
import 'package:quizy/utils/colors_utils.dart';
import 'package:quizy/utils/icons_constants.dart';
import 'package:quizy/utils/utils.dart';
import 'package:quizy/view/chapters/quezy.dart';

class Chapter extends StatefulWidget {
  final Chapters chapter;
  final int index;
  const Chapter({super.key, required this.chapter, required this.index});

  @override
  State<Chapter> createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await Provider.of<DataProvider>(context, listen: false)
          .getChapter('chapter${widget.index}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) => Scaffold(
        extendBody: true,
        bottomNavigationBar: Container(
          color: Colors.white.withOpacity(0.1),
          height: 80,
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizQuestionScreen(
                      chapter: widget.chapter,
                      index: widget.index,
                    ),
                  ),
                );
              },
              child: Container(
                width: 142,
                height: 41,
                decoration: ShapeDecoration(
                  color: hexToColor(value.data.mainColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Play',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.museoModerno(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ).asGlass(
          blurX: 10,
          blurY: 10,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Blur(
                    blur: 6,
                    colorOpacity: 0.1,
                    blurColor: Colors.white.withOpacity(0.3),
                    child: SizedBox(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        widget.chapter.icon!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 240,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                        child: appIcon(IconsConstants.close,
                                            false, context, 16, 16,
                                            color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Chapter ${widget.index + 1}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.museoModerno(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.08,
                          ),
                        ),
                        Text(
                          '${widget.chapter.quizQuestions!.length} Questions',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.museoModerno(
                            color: Colors.white.withOpacity(0.699999988079071),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.60,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: widget.chapter.quizQuestions!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 66,
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: getQuestionStatusColor(
                                int.parse(value.missiondone[index].toString()))
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: GoogleFonts.museoModerno(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                widget.chapter.quizQuestions![index].question!,
                                maxLines: 2,
                                style: GoogleFonts.museoModerno(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              // width: 52,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              height: 20,
                              decoration: ShapeDecoration(
                                color: getQuestionStatusColor(int.parse(
                                    value.missiondone[index].toString())),
                                shape: RoundedRectangleBorder(
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
                              child: Center(
                                child: Text(
                                  getQuestionSatus(int.parse(
                                      value.missiondone[index].toString())),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.museoModerno(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getQuestionSatus(int status) {
  return status == 1
      ? 'Correct'
      : status == 0
          ? 'Waiting'
          : 'Faild';
}

Color getQuestionStatusColor(int status) {
  return status == 1
      ? const Color(0xFF2ECC71)
      : status == 0
          ? const Color(0xFFC2C1C1)
          : const Color(0xFFEE5253);
}
