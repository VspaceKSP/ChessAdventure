import 'package:chess/chess.dart';

class ChessGame {
  final Chess game = Chess();

  void resetGame() {
    game.reset();
  }

  void undoMove() {
    game.undo();
  }

  List<String> moveHistory() {
    return game.san_moves().whereType<String>().toList();
  }

  Set<int> legalMovesFrom(int sourceIndex) {
    final square = indexToSquare(sourceIndex);

    final moves = game.generate_moves({'square': square});

    final destinations = <int>{};

    for (final move in moves) {
      destinations.add(squareToIndex(move.toAlgebraic));
    }

    return destinations;
  }

  bool canSelectPiece(int index) {
    final square = indexToSquare(index);
    final piece = game.get(square);

    if (piece == null) {
      return false;
    }

    return piece.color == game.turn;
  }

  bool tryMove(int sourceIndex, int destinationIndex) {
    final from = indexToSquare(sourceIndex);
    final to = indexToSquare(destinationIndex);

    final piece = game.get(from);

    final move = <String, String>{'from': from, 'to': to};

    if (piece != null &&
        piece.type == Chess.PAWN &&
        (to.endsWith('8') || to.endsWith('1'))) {
      move['promotion'] = 'q';
    }

    return game.move(move);
  }

  String? pieceAt(int index) {
    final square = indexToSquare(index);
    final piece = game.get(square);

    if (piece == null) {
      return null;
    }

    final color = piece.color == Color.WHITE ? 'white' : 'black';

    String type;

    if (piece.type == Chess.PAWN) {
      type = 'pawn';
    } else if (piece.type == Chess.ROOK) {
      type = 'rook';
    } else if (piece.type == Chess.KNIGHT) {
      type = 'knight';
    } else if (piece.type == Chess.BISHOP) {
      type = 'bishop';
    } else if (piece.type == Chess.QUEEN) {
      type = 'queen';
    } else {
      type = 'king';
    }

    return '${color}_$type';
  }

  String indexToSquare(int index) {
    const files = 'abcdefgh';

    final row = index ~/ 8;
    final column = index % 8;

    final file = files[column];
    final rank = 8 - row;

    return '$file$rank';
  }

  int squareToIndex(String square) {
    const files = 'abcdefgh';

    final file = square[0];
    final rank = int.parse(square[1]);

    final column = files.indexOf(file);
    final row = 8 - rank;

    return row * 8 + column;
  }
}
