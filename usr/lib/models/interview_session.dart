import 'package:flutter/material.dart';

class InterviewQuestion {
  final String text;
  String? userAnswer;
  String? feedback;
  int? technicalScore;
  int? englishScore;

  InterviewQuestion({
    required this.text,
    this.userAnswer,
    this.feedback,
    this.technicalScore,
    this.englishScore,
  });
}

class InterviewSession extends ChangeNotifier {
  String courseName = '';
  String? resumeFileName;
  bool isRealTimeMode = true;

  List<InterviewQuestion> questions = [];
  int currentQuestionIndex = 0;

  // Final scores
  double overallMarketScore = 0.0;
  double overallEnglishScore = 0.0;
  double overallTechnicalScore = 0.0;

  void updateCourse(String course) {
    courseName = course;
    notifyListeners();
  }

  void setResume(String filename) {
    resumeFileName = filename;
    notifyListeners();
  }

  void setMode(bool realTime) {
    isRealTimeMode = realTime;
    notifyListeners();
  }

  void startInterview() {
    // Generate dummy questions based on the course
    questions = [
      InterviewQuestion(text: 'Can you tell me about yourself and how your background in $courseName prepares you for this role?'),
      InterviewQuestion(text: 'What are the most important trends in the $courseName market today?'),
      InterviewQuestion(text: 'Describe a challenging project you worked on recently. How did you overcome the obstacles?'),
      InterviewQuestion(text: 'Where do you see yourself in 3 years within this industry?'),
    ];
    currentQuestionIndex = 0;
    notifyListeners();
  }

  void answerCurrentQuestion(String answer) {
    if (currentQuestionIndex < questions.length) {
      questions[currentQuestionIndex].userAnswer = answer;
      
      // Simulate grading
      questions[currentQuestionIndex].technicalScore = 70 + (answer.length % 25);
      questions[currentQuestionIndex].englishScore = 80 + (answer.length % 15);
      questions[currentQuestionIndex].feedback = 'Good attempt. Try to include more specific metrics and examples next time.';

      currentQuestionIndex++;
      
      if (currentQuestionIndex >= questions.length) {
        _calculateFinalScores();
      }
      
      notifyListeners();
    }
  }

  void _calculateFinalScores() {
    double totalTech = 0;
    double totalEng = 0;
    for (var q in questions) {
      totalTech += q.technicalScore ?? 0;
      totalEng += q.englishScore ?? 0;
    }
    
    overallTechnicalScore = totalTech / questions.length;
    overallEnglishScore = totalEng / questions.length;
    overallMarketScore = (overallTechnicalScore * 0.6) + (overallEnglishScore * 0.4);
  }

  void reset() {
    courseName = '';
    resumeFileName = null;
    questions.clear();
    currentQuestionIndex = 0;
    notifyListeners();
  }
}
