import 'package:flutter/material.dart';
import 'package:flutter_starter/models/interview_session.dart';

class InterviewScreen extends StatefulWidget {
  final InterviewSession session;
  const InterviewScreen({super.key, required this.session});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final TextEditingController _answerController = TextEditingController();
  bool _isRecording = false;

  void _submitAnswer() {
    if (_answerController.text.trim().isEmpty && !_isRecording) {
      return;
    }

    widget.session.submitAnswer(_answerController.text.trim());
    _answerController.clear();

    if (widget.session.isComplete) {
      widget.session.generateReport();
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState(() {});
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (!_isRecording) {
        _answerController.text = "[Transcribed Audio Answer]";
      }
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.session.currentQuestion;

    if (currentQuestion == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${widget.session.currentQuestionIndex + 1} of ${widget.session.questions.length}'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (widget.session.currentQuestionIndex) / widget.session.questions.length,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 2,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.record_voice_over, color: Theme.of(context).colorScheme.primary),
                                    const SizedBox(width: 12),
                                    Text('Interviewer', style: Theme.of(context).textTheme.titleMedium),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentQuestion,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text('Your Answer:', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        if (_isRecording)
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.mic, color: Colors.red),
                                const SizedBox(width: 16),
                                Text(
                                  'Recording audio... Speak now.',
                                  style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                                ),
                              ],
                            ),
                          )
                        else
                          TextField(
                            controller: _answerController,
                            maxLines: 6,
                            decoration: const InputDecoration(
                              hintText: 'Type your answer here or use the microphone to record...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                      iconSize: 32,
                      color: _isRecording ? Colors.red : null,
                      onPressed: _toggleRecording,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: FilledButton(
                          onPressed: _submitAnswer,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(widget.session.currentQuestionIndex == widget.session.questions.length - 1 ? 'Finish Interview' : 'Submit & Next'),
                        ),
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
