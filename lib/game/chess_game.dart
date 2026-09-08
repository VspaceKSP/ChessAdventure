import 'package:chess/chess.dart';

class ChessGame {
  final Chess game = Chess();
  int? lastMoveFromIndex;
  int? lastMoveToIndex;

  bool get isInCheck => game.in_check;

  bool get isCheckmate => game.in_checkmate;

  int? get checkedKingIndex {
    if (!isInCheck) return null;

    final kingColor = game.turn == Color.WHITE ? 'white' : 'black';

    for (var index = 0; index < 64; index++) {
      if (pieceAt(index) == '${kingColor}_king') {
        return index;
      }
    }

    return null;
  }

  void resetGame() {
    game.reset();

    lastMoveFromIndex = null;
    lastMoveToIndex = null;
  }

  void undoMove() {
    game.undo();

    lastMoveFromIndex = null;
    lastMoveToIndex = null;
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

  bool isPromotionMove(int sourceIndex, int destinationIndex) {
    final from = indexToSquare(sourceIndex);
    final to = indexToSquare(destinationIndex);

    final piece = game.get(from);

    return piece != null &&
        piece.type == Chess.PAWN &&
        (to.endsWith('8') || to.endsWith('1'));
  }

  bool tryMove(int sourceIndex, int destinationIndex, {String? promotion}) {
    final from = indexToSquare(sourceIndex);
    final to = indexToSquare(destinationIndex);

    if (isPromotionMove(sourceIndex, destinationIndex) && promotion == null) {
      return false;
    }

    final move = <String, String>{'from': from, 'to': to};

    if (promotion != null) {
      move['promotion'] = promotion;
    }
    final movePlayed = game.move(move);

    if (movePlayed) {
      lastMoveFromIndex = sourceIndex;
      lastMoveToIndex = destinationIndex;
    }

    return movePlayed;
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
