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

  void _clearInteraction() {
    if (!mounted) return;

    setState(() {
      selectedIndex = null;
      hoveredTargetIndex = null;
      legalMoveIndexes.clear();
    });
  }

  Future<String?> _choosePromotionPiece({
    required int sourceIndex,
    required int destinationIndex,
    required double squareSize,
  }) {
    final pawn = widget.chessGame.pieceAt(sourceIndex);

    final color = pawn != null && pawn.startsWith('white_') ? 'white' : 'black';

    final renderObject = context.findRenderObject();
    final boardBox = renderObject is RenderBox ? renderObject : null;

    final boardOffset = boardBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    final boardHeight = boardBox?.size.height ?? squareSize * 8;

    final column = destinationIndex % 8;
    final destinationRow = destinationIndex ~/ 8;

    final left = boardOffset.dx + column * squareSize;

    final top = destinationRow == 0
        ? boardOffset.dy
        : boardOffset.dy + boardHeight - squareSize * 4;

    return showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Annuler la promotion',
      barrierColor: Colors.black.withValues(alpha: 0.70),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              child: Column(
                children: [
                  _buildPromotionOption(
                    dialogContext: dialogContext,
                    color: color,
                    type: 'queen',
                    code: 'q',
                    squareSize: squareSize,
                  ),
                  _buildPromotionOption(
                    dialogContext: dialogContext,
                    color: color,
                    type: 'rook',
                    code: 'r',
                    squareSize: squareSize,
                  ),
                  _buildPromotionOption(
                    dialogContext: dialogContext,
                    color: color,
                    type: 'bishop',
                    code: 'b',
                    squareSize: squareSize,
                  ),
                  _buildPromotionOption(
                    dialogContext: dialogContext,
                    color: color,
                    type: 'knight',
                    code: 'n',
                    squareSize: squareSize,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPromotionOption({
    required BuildContext dialogContext,
    required String color,
    required String type,
    required String code,
    required double squareSize,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(dialogContext).pop(code);
        },
        child: Container(
          width: squareSize,
          height: squareSize,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: SvgPicture.asset(
            'assets/pieces/classic/${color}_$type.svg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Future<void> _playMove(
    int sourceIndex,
    int destinationIndex,
    double squareSize,
  ) async {
    if (!legalMoveIndexes.contains(destinationIndex)) {
      _clearInteraction();
      return;
    }

    String? promotion;

    if (widget.chessGame.isPromotionMove(sourceIndex, destinationIndex)) {
            promotion = await _choosePromotionPiece(
        sourceIndex: sourceIndex,
        destinationIndex: destinationIndex,
        squareSize: squareSize,
      );

      if (!mounted) return;

      if (promotion == null) {
        _clearInteraction();
        return;
      }
    }

    final movePlayed = widget.chessGame.tryMove(
      sourceIndex,
      destinationIndex,
      promotion: promotion,
    );

    if (movePlayed) {
      widget.onGameChanged();
    }

    _clearInteraction();
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

                    onAcceptWithDetails: (details) async {
                      final sourceIndex = details.data;

                      await _playMove(sourceIndex, index, squareSize);
                    },

                    builder: (context, candidateData, rejectedData) {
                      return GestureDetector(
                        onTap: () async {
                          if (selectedIndex == null) {
                            if (canInteractWithPiece) {
                              setState(() {
                                selectedIndex = index;
                                legalMoveIndexes = widget.chessGame
                                    .legalMovesFrom(index);
                              });
                            }

                            return;
                          }

                          final sourceIndex = selectedIndex!;

                          if (sourceIndex == index) {
                            _clearInteraction();
                            return;
                          }

                          await _playMove(sourceIndex, index, squareSize);
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
