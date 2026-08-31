import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const files = 'abcdefgh';

String indexToSquare(int index) {
  final row = index ~/ 8;
  final column = index % 8;

  final file = files[column];
  final rank = 8 - row;

  return '$file$rank';
}

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    const pieces = <int, String>{
      00: 'black_rook',
      01: 'black_knight',
      02: 'black_bishop',
      03: 'black_queen',
      04: 'black_king',
      05: 'black_bishop',
      06: 'black_knight',
      07: 'black_rook',
      08: 'black_pawn',
      09: 'black_pawn',
      10: 'black_pawn',
      11: 'black_pawn',
      12: 'black_pawn',
      13: 'black_pawn',
      14: 'black_pawn',
      15: 'black_pawn',
      48: 'white_pawn',
      49: 'white_pawn',
      50: 'white_pawn',
      51: 'white_pawn',
      52: 'white_pawn',
      53: 'white_pawn',
      54: 'white_pawn',
      55: 'white_pawn',
      56: 'white_rook',
      57: 'white_knight',
      58: 'white_bishop',
      59: 'white_queen',
      60: 'white_king',
      61: 'white_bishop',
      62: 'white_knight',
      63: 'white_rook',
    };

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

          final piece = pieces[index];
          final isSelected = selectedIndex == index;

          final rank = 8 - row;
          final file = files[column];

          final showRank = column == 0;
          final showFile = row == 7;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = piece != null ? index : null;
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
