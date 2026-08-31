import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../game/chess_game.dart';

const files = 'abcdefgh';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  int? selectedIndex;
  final ChessGame chessGame = ChessGame();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: 64,
        itemBuilder: (context, index) {
          final row = index ~/ 8;
          final column = index % 8;
          final isLightSquare = (row + column) % 2 == 0;
          final piece = chessGame.pieceAt(index);
          final isSelected = selectedIndex == index;

          final rank = 8 - row;
          final file = files[column];

          final showRank = column == 0;
          final showFile = row == 7;

          return GestureDetector(
            onTap: () {
              setState(() {
                // Aucune pièce sélectionnée : on essaie d'en sélectionner une.
                if (selectedIndex == null) {
                  if (piece != null) {
                    selectedIndex = index;
                  }
                  return;
                }

                // Une pièce est déjà sélectionnée.
                final sourceIndex = selectedIndex!;

                // Si on retouche la même case, on annule la sélection.
                if (sourceIndex == index) {
                  selectedIndex = null;
                  return;
                }

                chessGame.tryMove(sourceIndex, index);

                selectedIndex = null;
              });
            },
            child: Container(
              color: isSelected
                  ? Colors.amber.shade300
                  : isLightSquare
                  ? Colors.brown.shade200
                  : Colors.brown.shade700,
              child: Stack(
                children: [
                  if (piece != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: SvgPicture.asset(
                          'assets/pieces/classic/$piece.svg',
                        ),
                      ),
                    ),
                  if (showRank)
                    Positioned(
                      top: 2,
                      left: 3,
                      child: Text(
                        '$rank',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isLightSquare
                              ? Colors.brown.shade700
                              : Colors.brown.shade200,
                        ),
                      ),
                    ),
                  if (showFile)
                    Positioned(
                      bottom: 1,
                      right: 3,
                      child: Text(
                        file,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isLightSquare
                              ? Colors.brown.shade700
                              : Colors.brown.shade200,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
