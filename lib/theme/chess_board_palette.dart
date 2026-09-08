import 'package:flutter/material.dart';

class ChessBoardPalette {
  final Color lightSquare;
  final Color darkSquare;
  final Color selectedSquare;
  final Color lastMoveFrom;
  final Color lastMoveTo;
  final Color checkSquare;
  final Color mateSquare;
  final Color legalMoveDot;
  final Color dragTargetBorder;

  const ChessBoardPalette({
    required this.lightSquare,
    required this.darkSquare,
    required this.selectedSquare,
    required this.lastMoveFrom,
    required this.lastMoveTo,
    required this.checkSquare,
    required this.mateSquare,
    required this.legalMoveDot,
    required this.dragTargetBorder,
  });
}

const classicChessPalette = ChessBoardPalette(
  lightSquare: Color(0xFFF4EADE),
  darkSquare: Color(0xFF2988BC),
  selectedSquare: Color(0xFFED8C72),
  lastMoveFrom: Color(0x802F496E),
  lastMoveTo: Color(0x992F496E),
  checkSquare: Color(0xFFE53935),
  mateSquare: Color(0xFFB71C1C),
  legalMoveDot: Color(0x40000000),
  dragTargetBorder: Color(0x66000000),
);
