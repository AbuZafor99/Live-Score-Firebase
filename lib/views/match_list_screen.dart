import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/controllers/match_controller.dart';
import 'package:firebase_demo/models/match.dart';
import 'package:firebase_demo/views/match_detail_screen.dart';
import 'package:flutter/material.dart';

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({super.key});

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  final MatchController _matchController = MatchController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match List'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _matchController.getMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No matches found.\nAdd some matches manually to Firebase.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final match = Match.fromFirestore(doc);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    '${match.team1Name} vs ${match.team2Name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Score: ${match.team1Score} : ${match.team2Score}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchDetailScreen(match: match),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMatchDialog(context, _matchController),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddMatchDialog(BuildContext context, MatchController matchController) async {
    final TextEditingController team1Controller = TextEditingController();
    final TextEditingController team2Controller = TextEditingController();
    final TextEditingController score1Controller = TextEditingController();
    final TextEditingController score2Controller = TextEditingController();
    final TextEditingController runningTimeController = TextEditingController();
    final TextEditingController totalTimeController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Match'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: team1Controller,
                  decoration: const InputDecoration(
                    labelText: 'Team 1 Name',
                    hintText: 'e.g., Argentina',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: team2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Team 2 Name',
                    hintText: 'e.g., Africa',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: score1Controller,
                        decoration: const InputDecoration(
                          labelText: 'Team 1 Score',
                          hintText: '0',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(':', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: score2Controller,
                        decoration: const InputDecoration(
                          labelText: 'Team 2 Score',
                          hintText: '0',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: runningTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Running Time (mm:ss)',
                    hintText: '00:00',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: totalTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Total Time (mm:ss)',
                    hintText: '90:00',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                if (team1Controller.text.isNotEmpty &&
                    team2Controller.text.isNotEmpty) {
                  final match = Match(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    team1Name: team1Controller.text,
                    team2Name: team2Controller.text,
                    team1Score: int.tryParse(score1Controller.text) ?? 0,
                    team2Score: int.tryParse(score2Controller.text) ?? 0,
                    runningTime: runningTimeController.text.isNotEmpty
                        ? runningTimeController.text
                        : '00:00',
                    totalTime: totalTimeController.text.isNotEmpty
                        ? totalTimeController.text
                        : '90:00',
                  );

                  await matchController.addMatch(match);

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
