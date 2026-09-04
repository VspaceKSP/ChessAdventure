import 'package:flutter/material.dart';

import '../game/chess_game.dart';
import 'chess_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final ChessGame chessGame = ChessGame();
  int boardInteractionRevision = 0;

  Future<void> confirmUndo() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Undo Move'),
          content: const Text('Voulez-vous vraiment annuler le dernier coup?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Undo'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return;

      setState(() {
        chessGame.undoMove();
        boardInteractionRevision++;
      });
    }
  }

  Future<void> confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Game'),
          content: const Text('Voulez-vous vraiment recommencer la partie?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return;

      setState(() {
        chessGame.resetGame();
        boardInteractionRevision++;
      });
    }
  }

  void refreshGame() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final history = chessGame.moveHistory();

    final currentMove = history.isNotEmpty ? history[history.length - 1] : '';

    final previousMove = history.length >= 2 ? history[history.length - 2] : '';

    final nextMove = '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChessBoard(
              chessGame: chessGame,
              interactionRevision: boardInteractionRevision,
              onGameChanged: refreshGame,
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 55,
              child: Row(
                children: [
                  IconButton(
                    onPressed: null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: confirmUndo,
                        child: const Text('Undo'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: confirmReset,
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Text(previousMove.isEmpty ? '-' : previousMove),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        currentMove.isEmpty ? 'Début' : currentMove,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(nextMove.isEmpty ? '-' : nextMove),
                    ),
                  ),

                  IconButton(
                    onPressed: null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
