import 'package:flutter/material.dart';
import 'package:flutter_starter/models/interview_session.dart';

class HomeScreen extends StatefulWidget {
  final InterviewSession session;
  const HomeScreen({super.key, required this.session});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _courseController = TextEditingController();
  bool _isRealTime = true;
  bool _hasResume = false;

  void _startInterview() {
    if (_courseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a course or domain.')),
      );
      return;
    }

    widget.session.startSession(
      courseName: _courseController.text.trim(),
      hasResume: _hasResume,
      isRealTime: _isRealTime,
    );

    Navigator.pushNamed(context, '/interview');
  }

  @override
  void dispose() {
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PrepAI - Interview Setup'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            bool isDesktop = maxWidth > 600;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Let\'s prepare for your next big interview.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _courseController,
                        decoration: InputDecoration(
                          labelText: 'Course or Domain (e.g., Computer Science, Marketing)',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.school),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Resume',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _hasResume ? 'resume_final.pdf uploaded' : 'No resume uploaded. We\'ll ask general domain questions.',
                                      style: TextStyle(
                                        color: _hasResume ? Colors.green[700] : Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _hasResume = !_hasResume;
                                      });
                                    },
                                    icon: Icon(_hasResume ? Icons.check : Icons.upload_file),
                                    label: Text(_hasResume ? 'Uploaded' : 'Upload'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Interview Mode',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(
                            value: true,
                            label: Text('Real-time Mock'),
                            icon: Icon(Icons.timer),
                          ),
                          ButtonSegment(
                            value: false,
                            label: Text('Material Prep'),
                            icon: Icon(Icons.book),
                          ),
                        ],
                        selected: {_isRealTime},
                        onSelectionChanged: (Set<bool> newSelection) {
                          setState(() {
                            _isRealTime = newSelection.first;
                          });
                        },
                      ),
                      const SizedBox(height: 48),
                      FilledButton(
                        onPressed: _startInterview,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Start Interview'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
