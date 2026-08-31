bool isPawnMoveValid({
  required int sourceIndex,
  required int destinationIndex,
  required String piece,
  required Map<int, String> pieces,
}) {
  final sourceRow = sourceIndex ~/ 8;
  final sourceColumn = sourceIndex % 8;

  final destinationRow = destinationIndex ~/ 8;
  final destinationColumn = destinationIndex % 8;

  final isWhite = piece.startsWith('white_');

  final direction = isWhite ? -1 : 1;
  final startingRow = isWhite ? 6 : 1;

  final rowDifference = destinationRow - sourceRow;
  final columnDifference = destinationColumn - sourceColumn;

  final destinationPiece = pieces[destinationIndex];

  // Avancer d'une case.
  if (columnDifference == 0 &&
      rowDifference == direction &&
      destinationPiece == null) {
    return true;
  }

  // Avancer de deux cases depuis la position initiale.
  if (columnDifference == 0 &&
      sourceRow == startingRow &&
      rowDifference == direction * 2 &&
      destinationPiece == null) {
    final middleIndex = sourceIndex + (direction * 8);

    if (pieces[middleIndex] == null) {
      return true;
    }
  }

  // Capture diagonale.
  if (columnDifference.abs() == 1 &&
      rowDifference == direction &&
      destinationPiece != null) {
    final destinationIsWhite = destinationPiece.startsWith('white_');

    if (destinationIsWhite != isWhite) {
      return true;
    }
  }

  return false;
}
bool isRookMoveValid({
  required int sourceIndex,
  required int destinationIndex,
  required String piece,
  required Map<int, String> pieces,
}) {
  final sourceRow = sourceIndex ~/ 8;
  final sourceColumn = sourceIndex % 8;

  final destinationRow = destinationIndex ~/ 8;
  final destinationColumn = destinationIndex % 8;

  final sameRow = sourceRow == destinationRow;
  final sameColumn = sourceColumn == destinationColumn;

  // Une tour doit rester sur la même ligne ou la même colonne.
  if (!sameRow && !sameColumn) {
    return false;
  }

  final rowStep = (destinationRow - sourceRow).sign;
  final columnStep = (destinationColumn - sourceColumn).sign;

  var currentRow = sourceRow + rowStep;
  var currentColumn = sourceColumn + columnStep;

  // Vérifie toutes les cases ENTRE la source et la destination.
  while (currentRow != destinationRow ||
      currentColumn != destinationColumn) {
    final currentIndex = currentRow * 8 + currentColumn;

    if (pieces[currentIndex] != null) {
      return false;
    }

    currentRow += rowStep;
    currentColumn += columnStep;
  }

  final destinationPiece = pieces[destinationIndex];

  // Destination vide = mouvement valide.
  if (destinationPiece == null) {
    return true;
  }

  final isWhite = piece.startsWith('white_');
  final destinationIsWhite = destinationPiece.startsWith('white_');

  // Destination occupée par une pièce adverse = capture valide.
  return isWhite != destinationIsWhite;
}
bool isKnightMoveValid({
  required int sourceIndex,
  required int destinationIndex,
  required String piece,
  required Map<int, String> pieces,
}) {
  final sourceRow = sourceIndex ~/ 8;
  final sourceColumn = sourceIndex % 8;

  final destinationRow = destinationIndex ~/ 8;
  final destinationColumn = destinationIndex % 8;

  final rowDifference = (destinationRow - sourceRow).abs();
  final columnDifference = (destinationColumn - sourceColumn).abs();

  final isKnightShape =
      (rowDifference == 2 && columnDifference == 1) ||
      (rowDifference == 1 && columnDifference == 2);

  if (!isKnightShape) {
    return false;
  }

  final destinationPiece = pieces[destinationIndex];

  // Destination vide.
  if (destinationPiece == null) {
    return true;
  }

  final isWhite = piece.startsWith('white_');
  final destinationIsWhite = destinationPiece.startsWith('white_');

  // Destination occupée par un ennemi.
  return isWhite != destinationIsWhite;
}
bool isBishopMoveValid({
  required int sourceIndex,
  required int destinationIndex,
  required String piece,
  required Map<int, String> pieces,
}) {
  final sourceRow = sourceIndex ~/ 8;
  final sourceColumn = sourceIndex % 8;

  final destinationRow = destinationIndex ~/ 8;
  final destinationColumn = destinationIndex % 8;

  final rowDifference = (destinationRow - sourceRow).abs();
  final columnDifference = (destinationColumn - sourceColumn).abs();

  // Un fou doit se déplacer exactement en diagonale.
  if (rowDifference != columnDifference) {
    return false;
  }

  final rowStep = (destinationRow - sourceRow).sign;
  final columnStep = (destinationColumn - sourceColumn).sign;

  var currentRow = sourceRow + rowStep;
  var currentColumn = sourceColumn + columnStep;

  // Vérifie toutes les cases entre le fou et sa destination.
  while (currentRow != destinationRow &&
      currentColumn != destinationColumn) {
    final currentIndex = currentRow * 8 + currentColumn;

    if (pieces[currentIndex] != null) {
      return false;
    }

    currentRow += rowStep;
    currentColumn += columnStep;
  }

  final destinationPiece = pieces[destinationIndex];

  if (destinationPiece == null) {
    return true;
  }

  final isWhite = piece.startsWith('white_');
  final destinationIsWhite = destinationPiece.startsWith('white_');

  return isWhite != destinationIsWhite;
}