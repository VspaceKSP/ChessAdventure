import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../game/chess_game.dart';

const files = 'abcdefgh';

class ChessBoard extends StatefulWidget {
  final ChessGame chessGame;
  final VoidCallback onGameChanged;
  final int interactionRevision;

  const ChessBoard({
    super.key,
    required this.chessGame,
    required this.onGameChanged,
    required this.interactionRevision,
  });

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  int? selectedIndex;
  int? hoveredTargetIndex;

  Set<int> legalMoveIndexes = {};

  @override
  void didUpdateWidget(covariant ChessBoard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.interactionRevision != widget.interactionRevision) {
      selectedIndex = null;
      hoveredTargetIndex = null;
      legalMoveIndexes.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boardSize = constraints.maxWidth;
          final squareSize = boardSize / 8;

          // L'indicateur dépasse légèrement de la case.
          final targetIndicatorSize = squareSize * 1.60;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              GridView.builder(
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

                  final piece = widget.chessGame.pieceAt(index);

                  final isSelected = selectedIndex == index;
                  final isLegalMove = legalMoveIndexes.contains(index);

                  final rank = 8 - row;
                  final file = files[column];

                  final showRank = column == 0;
                  final showFile = row == 7;

                  final canInteractWithPiece =
                      piece != null && widget.chessGame.canSelectPiece(index);

                  return DragTarget<int>(
                    onWillAcceptWithDetails: (details) {
                      return legalMoveIndexes.contains(index);
                    },

                    onMove: (details) {
                      if (hoveredTargetIndex != index) {
                        setState(() {
                          hoveredTargetIndex = index;
                        });
                      }
                    },

                    onLeave: (_) {
                      if (hoveredTargetIndex == index) {
                        setState(() {
                          hoveredTargetIndex = null;
                        });
                      }
                    },

                    onAcceptWithDetails: (details) {
                      final sourceIndex = details.data;

                      final movePlayed = widget.chessGame.tryMove(
                        sourceIndex,
                        index,
                      );

                      if (movePlayed) {
                        widget.onGameChanged();
                      }

                      setState(() {
                        selectedIndex = null;
                        hoveredTargetIndex = null;
                        legalMoveIndexes.clear();
                      });
                    },

                    builder: (context, candidateData, rejectedData) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedIndex == null) {
                              if (canInteractWithPiece) {
                                selectedIndex = index;

                                legalMoveIndexes = widget.chessGame
                                    .legalMovesFrom(index);
                              }

                              return;
                            }

                            final sourceIndex = selectedIndex!;

                            if (sourceIndex == index) {
                              selectedIndex = null;
                              hoveredTargetIndex = null;
                              legalMoveIndexes.clear();
                              return;
                            }

                            final movePlayed = widget.chessGame.tryMove(
                              sourceIndex,
                              index,
                            );

                            if (movePlayed) {
                              widget.onGameChanged();
                            }

                            selectedIndex = null;
                            hoveredTargetIndex = null;
                            legalMoveIndexes.clear();
                          });
                        },

                        child: Container(
                          color: isSelected
                              ? const Color.fromARGB(255, 251, 223, 130)
                              : isLightSquare
                              ? const Color(0xFFF4EADE)
                              : const Color(0xFF2988BC),

                          child: Stack(
                            children: [
                              if (piece != null)
                                Center(
                                  child: Draggable<int>(
                                    data: index,
                                    maxSimultaneousDrags: canInteractWithPiece
                                        ? 1
                                        : 0,
                                    dragAnchorStrategy:
                                        (draggable, context, position) {
                                          final feedbackSize =
                                              squareSize * 1.35;

                                          return Offset(
                                            feedbackSize / 2,
                                            feedbackSize * 0.85,
                                          );
                                        },
                                    onDragStarted: () {
                                      setState(() {
                                        selectedIndex = index;

                                        legalMoveIndexes = widget.chessGame
                                            .legalMovesFrom(index);
                                      });
                                    },

                                    onDragEnd: (_) {
                                      setState(() {
                                        selectedIndex = null;
                                        hoveredTargetIndex = null;
                                        legalMoveIndexes.clear();
                                      });
                                    },

                                    feedback: Material(
                                      color: Colors.transparent,
                                      child: SvgPicture.asset(
                                        'assets/pieces/classic/$piece.svg',
                                        width: squareSize * 1.35,
                                        height: squareSize * 1.35,
                                      ),
                                    ),

                                    childWhenDragging: Opacity(
                                      opacity: 0.20,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset(
                                          'assets/pieces/classic/$piece.svg',
                                        ),
                                      ),
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: SvgPicture.asset(
                                        'assets/pieces/classic/$piece.svg',
                                      ),
                                    ),
                                  ),
                                ),

                              if (isLegalMove)
                                Center(
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withValues(
                                        alpha: 0.25,
                                      ),
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
                                          ? const Color(0xFF2988BC)
                                          : const Color(0xFFF4EADE),
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
                                          ? const Color(0xFF2988BC)
                                          : const Color(0xFFF4EADE),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              if (hoveredTargetIndex != null)
                Positioned(
                  left:
                      (hoveredTargetIndex! % 8) * squareSize -
                      (targetIndicatorSize - squareSize) / 2,
                  top:
                      (hoveredTargetIndex! ~/ 8) * squareSize -
                      (targetIndicatorSize - squareSize) / 2,
                  child: IgnorePointer(
                    child: Container(
                      width: targetIndicatorSize,
                      height: targetIndicatorSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.40),
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
