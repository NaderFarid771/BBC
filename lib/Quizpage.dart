import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindo/provider/questionprovider.dart';
import 'package:mindo/model/questionmodel.dart';
import '../widgets/option_tile.dart';
import '../widgets/question_header.dart';
import '../widgets/next_button.dart';

class QuizPage extends StatefulWidget {
  final String category;
  final int numberOfQuestions;
  
  const QuizPage({
    super.key,
    this.category = '9',
    this.numberOfQuestions = 10,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int timeLeft = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final provider = context.read<QuestionProvider>();
    provider.loadQuestions(widget.category, widget.numberOfQuestions);
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final provider = context.read<QuestionProvider>();
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        t.cancel();
        if (!provider.isAnswered) {
          provider.selectAnswer(provider.correctAnswerIndex);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Time's up!"),
              duration: Duration(seconds: 2),
            ),
          );
          Future.delayed(const Duration(seconds: 2), () {
            goToNextQuestion();
          });
        }
      }
    });
  }

  void goToNextQuestion() {
    final provider = context.read<QuestionProvider>();
    if (provider.currentQuestionIndex < provider.questions.length - 1) {
      provider.nextQuestion();
      startTimer();
    } else {
      timer?.cancel();
      _showResultDialog(provider);
    }
  }

  void _showResultDialog(QuestionProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete!'),
        content: Text(
          'Your Score: ${provider.score}/${provider.questions.length}\n'
          'Percentage: ${((provider.score / provider.questions.length) * 100).toStringAsFixed(1)}%'
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              provider.resetQuiz();
              provider.loadQuestions(widget.category, widget.numberOfQuestions);
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  Question convertToQuestion(QuestionProvider provider) {
    final apiQuestion = provider.currentQuestion!;
    final options = provider.currentQuestionOptions;
    final correctIndex = provider.correctAnswerIndex;

    return Question(
      text: apiQuestion.question,
      options: options,
      correctIndex: correctIndex,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: const Color.fromARGB(255, 100, 63, 163),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<QuestionProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading questions...'),
                    ],
                  ),
                );
              }

              if (provider.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${provider.errorMessage}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          provider.loadQuestions(
                            widget.category,
                            widget.numberOfQuestions
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (provider.questions.isEmpty) {
                return const Center(
                  child: Text('No questions available'),
                );
              }

              final currentQ = convertToQuestion(provider);

              if (timeLeft == 30 && timer == null && !provider.isQuizFinished) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  startTimer();
                });
              }

              return Column(
                children: [
                  QuestionHeader(
                    current: provider.currentQuestionIndex + 1,
                    total: provider.questions.length,
                    timeLeft: timeLeft,
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 100, 63, 163),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currentQ.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQ.options.length,
                      itemBuilder: (context, index) {
                        bool isCorrect = provider.isAnswered &&
                            index == provider.correctAnswerIndex;
                        bool isWrong = provider.isAnswered &&
                            index == provider.selectedAnswerIndex &&
                            !provider.isSelectedAnswerCorrect();

                        return OptionTile(
                          text: currentQ.options[index],
                          isCorrect: isCorrect,
                          isWrong: isWrong,
                          onTap: () {
                            if (!provider.isAnswered) {
                              provider.selectAnswer(index);
                              timer?.cancel();
                            }
                          },
                        );
                      },
                    ),
                  ),

                  NextButton(
                    isLast: provider.currentQuestionIndex ==
                        provider.questions.length - 1,
                    onPressed: () {
                      if (provider.isAnswered) {
                         if (provider.currentQuestionIndex ==
                          provider.questions.length - 1) {
                            timer?.cancel();
                            _showResultDialog(provider);
                        } else {
                          goToNextQuestion();
                        }
                      } else {
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(
                             content: Text('Please select an answer first.'),
                             backgroundColor: Colors.red,
                           ),
                         );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}