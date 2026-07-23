import 'package:flutter/material.dart';
import 'package:flutter_starter/models/interview_session.dart';

class DashboardScreen extends StatelessWidget {
  final InterviewSession session;
  const DashboardScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final report = session.report;

    if (report == null) {
      return const Scaffold(body: Center(child: Text('No report available.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Report'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Performance Dashboard',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Course: ${session.courseName}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 32),
                      
                      // Scores Grid
                      if (isMobile)
                        Column(
                          children: [
                            _ScoreCard(title: 'Overall Score', score: report['overallScore'], icon: Icons.star, color: Colors.amber),
                            const SizedBox(height: 16),
                            _ScoreCard(title: 'English Level', score: report['englishLevel'], icon: Icons.language, color: Colors.blue),
                            const SizedBox(height: 16),
                            _ScoreCard(title: 'Market Readiness', score: report['marketReadiness'], icon: Icons.trending_up, color: Colors.green),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(child: _ScoreCard(title: 'Overall Score', score: report['overallScore'], icon: Icons.star, color: Colors.amber)),
                            const SizedBox(width: 16),
                            Expanded(child: _ScoreCard(title: 'English Level', score: report['englishLevel'], icon: Icons.language, color: Colors.blue)),
                            const SizedBox(width: 16),
                            Expanded(child: _ScoreCard(title: 'Market Readiness', score: report['marketReadiness'], icon: Icons.trending_up, color: Colors.green)),
                          ],
                        ),

                      const SizedBox(height: 32),
                      Text(
                        'Detailed Feedback',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Strengths', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(height: 8),
                              ...List<Widget>.from(report['strengths'].map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('• '), Expanded(child: Text(s))]),
                              ))),
                              const SizedBox(height: 24),
                              Text('Areas for Improvement', style: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(height: 8),
                              ...List<Widget>.from(report['improvements'].map((i) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('• '), Expanded(child: Text(i))]),
                              ))),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      Text(
                        'Question Breakdown',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: session.questions.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ExpansionTile(
                              title: Text(session.questions[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: const Text('Tap to see your answer'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(session.answers[index] ?? 'No answer provided.'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 48),
                      Center(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Start New Practice'),
                          onPressed: () {
                            Navigator.popUntil(context, ModalRoute.withName('/'));
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String title;
  final int score;
  final IconData icon;
  final Color color;

  const _ScoreCard({
    required this.title,
    required this.score,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(
              '$score%',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
