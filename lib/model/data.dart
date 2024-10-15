class Data {
  String? appName;
  String? appIcon;
  String? cover;
  String? mainColor;
  String? contact;
  String? about;
  String? privacy;
  String? terms;
  List<Intro>? intro;
  List<Chapters>? chapters;

  Data(
      {this.appName,
      this.appIcon,
      this.cover,
      this.mainColor,
      this.contact,
      this.about,
      this.privacy,
      this.terms,
      this.intro,
      this.chapters});

  Data.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    appIcon = json['app_icon'];
    cover = json['cover'];
    mainColor = json['main_color'];
    contact = json['contact'];
    about = json['about'];
    privacy = json['privacy'];
    terms = json['terms'];
    if (json['intro'] != null) {
      intro = <Intro>[];
      json['intro'].forEach((v) {
        intro!.add(Intro.fromJson(v));
      });
    }
    if (json['chapters'] != null) {
      chapters = <Chapters>[];
      json['chapters'].forEach((v) {
        chapters!.add(Chapters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_name'] = appName;
    data['app_icon'] = appIcon;
    data['cover'] = cover;
    data['main_color'] = mainColor;
    data['contact'] = contact;
    data['about'] = about;
    data['privacy'] = privacy;
    data['terms'] = terms;
    if (intro != null) {
      data['intro'] = intro!.map((v) => v.toJson()).toList();
    }
    if (chapters != null) {
      data['chapters'] = chapters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Intro {
  String? title;
  String? description;
  String? icon;

  Intro({this.title, this.description, this.icon});

  Intro.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }
}

class Chapters {
  String? title;
  String? icon;
  List<QuizQuestions>? quizQuestions;

  Chapters({this.title, this.icon, this.quizQuestions});

  Chapters.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    icon = json['icon'];
    if (json['quizQuestions'] != null) {
      quizQuestions = <QuizQuestions>[];
      json['quizQuestions'].forEach((v) {
        quizQuestions!.add(QuizQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['icon'] = icon;
    if (quizQuestions != null) {
      data['quizQuestions'] = quizQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuizQuestions {
  String? question;
  String? asset;
  List<String>? options;
  String? correctOption;

  QuizQuestions({this.question, this.asset, this.options, this.correctOption});

  QuizQuestions.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    asset = json['asset'];
    options = json['options'].cast<String>();
    correctOption = json['correct_option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['asset'] = asset;
    data['options'] = options;
    data['correct_option'] = correctOption;
    return data;
  }
}
