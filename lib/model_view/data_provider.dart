import 'package:quizy/model/data.dart';
import 'package:flutter/material.dart';
import 'package:quizy/services/local_storage.dart';

class DataProvider extends ChangeNotifier {
  Data data = Data();
  int score = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  List<String> missiondone = List.generate(100, (index) => '0');

  void setData(Data data) {
    this.data = data;
    notifyListeners();
  }

  Data getData() {
    return data;
  }

  //get score
  void getScore() {
    LocalStorage.getscore().then((value) {
      if (value == null) {
        score = 0;
      } else {
        score = value;
      }
      notifyListeners();
    });
  }

  //set score
  void setScore(int score) {
    this.score = score;
    LocalStorage.savescore(score);
    notifyListeners();
  }

  void incrementScore(int def) {
    int exp = 100 * def;
    score = score + exp;
    LocalStorage.savescore(score);
    notifyListeners();
  }

  Future saveChapter(String chapter, List<String> value) async {
    await LocalStorage.saveChapter(chapter, value);
    notifyListeners();
  }

  Future getChapter(String chapter) async {
    await LocalStorage.getChapter(chapter).then((value) {
      if (value == null) {
        missiondone = List.generate(100, (index) => '0');
      } else {
        missiondone = value;
      }
      notifyListeners();
    });
    return missiondone;
  }

  void reset() {
    score = 0;
    LocalStorage.savescore(0);
    notifyListeners();
  }

  void resetChapter() {
    missiondone = List.generate(100, (index) => '0');
    for (var element in data.chapters!) {
      saveChapter('chapter${data.chapters!.indexOf(element)}', missiondone);
    }
    notifyListeners();
  }

  void resetAll() {
    reset();
    resetChapter();
  }

  //get all correct answers form local storage
  Future getCorrectAnswers() async {
    int total = 0;
    for (var element in data.chapters!) {
      List<String> answers =
          await getChapter('chapter${data.chapters!.indexOf(element)}');
      for (var i = 0; i < answers.length; i++) {
        if (answers[i] == '1') {
          total++;
        }
      }
    }
    correctAnswers = total;
    notifyListeners();
  }

  //get all wrong answers form local storage
  Future getWrongAnswers() async {
    int total = 0;
    for (var element in data.chapters!) {
      List<String> answers =
          await getChapter('chapter${data.chapters!.indexOf(element)}');
      for (var i = 0; i < answers.length; i++) {
        if (answers[i] == '2') {
          total++;
        }
      }
    }
    wrongAnswers = total;
    notifyListeners();
  }
}
