import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizy/model_view/data_provider.dart';
import 'package:quizy/model_view/menu_provider.dart';
import 'package:quizy/utils/icons_constants.dart';
import 'package:quizy/utils/utils.dart';
import 'package:quizy/view/chapters/chapter.dart';

class ChaptersPage extends StatefulWidget {
  const ChaptersPage({super.key});

  @override
  State<ChaptersPage> createState() => __ChaptersPagStateState();
}

class __ChaptersPagStateState extends State<ChaptersPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<DataProvider,MenuProvider>(
        builder: (context, value, value2,child) => Scaffold(
              body: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage(value.data.appIcon.toString()),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Step-by-step solve challenges →',
                                style: GoogleFonts.abel(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.60,
                                ),
                              ),
                              Text(
                                value.data.appName.toString(),
                                style: GoogleFonts.museoModerno(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.60,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              value2.setIndex(0);
                            },
                            child: Opacity(
                              opacity: 0.80,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black
                                      .withOpacity(0.07000000029802322),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                    child: appIcon(IconsConstants.close, false,
                                        context, 20, 20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.data.chapters!.length,
                      padding: const EdgeInsets.only(bottom: 100),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chapter(
                                          chapter: value.data.chapters![index],
                                          index: index,
                                        )));
                          },
                          child: Container(
                            height: 200,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(value
                                    .data.chapters![index].icon
                                    .toString()),
                                fit: BoxFit.cover,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black,
                                  Colors.black.withOpacity(0.5),
                                ],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1C000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 0),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Chapter ${index + 1}',
                                        style: GoogleFonts.museoModerno(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.60,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${value.data.chapters![index].quizQuestions!.length.toString()} Questions',
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.museoModerno(
                                          color: Colors.white
                                              .withOpacity(0.899999988079071),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ));
  }
}
