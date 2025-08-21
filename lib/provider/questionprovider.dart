
import 'package:flutter/material.dart';
//import 'package:mindo/model/question_model.dart';
import 'package:mindo/model/questionmodel.dart';
import 'package:mindo/service/questionservice.dart';

class QuestionProvider extends ChangeNotifier {
  List<Questionmodel> _questions = [];
  bool _isLoading = false;
  String _errorMessage = '';
  
  int _currentQuestionIndex = 0;        
  int _selectedAnswerIndex = -1;       
  bool _isAnswered = false;            
  int _score = 0;                       
  List<String> _currentQuestionOptions = []; 

  List<Questionmodel> get questions => _questions;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  

  int get currentQuestionIndex => _currentQuestionIndex;
  int get selectedAnswerIndex => _selectedAnswerIndex;
  bool get isAnswered => _isAnswered;
  int get score => _score;
  List<String> get currentQuestionOptions => _currentQuestionOptions;
  

  Questionmodel? get currentQuestion {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return null;
    }
    return _questions[_currentQuestionIndex];
  }
  

  bool get isQuizFinished => _currentQuestionIndex >= _questions.length;
  
  int get correctAnswerIndex {
    if (currentQuestion == null) return -1;
    return _currentQuestionOptions.indexOf(currentQuestion!.correctAnswer);
  }

  Future<void> loadQuestions(String category, int amount) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    final result = await Questionservice.getQuestion(category, amount);

    if (result.isSuccess) {
      _questions = result.data!;
      _errorMessage = '';
      _currentQuestionIndex = 0;
      _score = 0;
      _setupCurrentQuestionOptions();
    } else {
      _questions = [];
      _errorMessage = result.error!;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void _setupCurrentQuestionOptions() {
    if (currentQuestion != null) {
      _currentQuestionOptions = [
        currentQuestion!.correctAnswer,
        ...currentQuestion!.incorrectAnswers,
      ];
      _currentQuestionOptions.shuffle();
      
      _selectedAnswerIndex = -1;
      _isAnswered = false;
    }
  }

  void selectAnswer(int index) {
    if (_isAnswered || currentQuestion == null) return;
    
    _selectedAnswerIndex = index;
    _isAnswered = true;
    
    if (_currentQuestionOptions[index] == currentQuestion!.correctAnswer) {
      _score++;
    }
    
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _setupCurrentQuestionOptions();
      notifyListeners();
    }
  }

  bool isSelectedAnswerCorrect() {
    if (!_isAnswered || currentQuestion == null) return false;
    return _currentQuestionOptions[_selectedAnswerIndex] == currentQuestion!.correctAnswer;
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = -1;
    _isAnswered = false;
    _score = 0;
    _currentQuestionOptions = [];
    
    if (_questions.isNotEmpty) {
      _setupCurrentQuestionOptions();
    }
    
    notifyListeners();
  }
  double get scorePercentage {
    if (_questions.isEmpty) return 0.0;
    return (_score / _questions.length) * 100;
  }
  
  String get performanceText {
    final percentage = scorePercentage;
    if (percentage >= 90) return 'Excellent!';
    if (percentage >= 80) return 'Great Job!';
    if (percentage >= 70) return 'Good Work!';
    if (percentage >= 60) return 'Not Bad!';
    return 'Keep Trying!';
  }
  
  Color get performanceColor {
    final percentage = scorePercentage;
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }
  
  double get progressPercentage {
    if (_questions.isEmpty) return 0.0;
    return ((_currentQuestionIndex + 1) / _questions.length);
  }
}