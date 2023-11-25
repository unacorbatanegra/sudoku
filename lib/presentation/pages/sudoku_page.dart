// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/presentation/widgets/palette.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

const ROWS = 9;
const COLS = 9;

class SudokuPage extends StatefulWidget {
  const SudokuPage({super.key});

  @override
  State<SudokuPage> createState() => _SudokuPageState();
}

class _SudokuPageState extends State<SudokuPage> {
  int? currentRow, currentCol;

  late SudokuGenerator generator;
  final sudoku = <List<int?>>[];
  @override
  void initState() {
    generator = SudokuGenerator();
    sudoku.addAll(generator.newSudoku);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sudoku"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ...sudoku.mapIndexed(
                (row, colList) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: colList
                        .mapIndexed(
                          (col, element) => FieldWidget(
                            value: element,
                            row: row,
                            col: col,
                            error: () {
                              if (element == 0) {
                                return false;
                              }
                              return generator.newSudokuSolved[row][col] !=
                                  element;
                            }(),
                            currentCol: currentCol,
                            currentRow: currentRow,
                            onTap: () => onTap(row, col),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              if (currentRow != null && currentCol != null)
                Padding(
                  padding: const EdgeInsets.only(top: 64),
                  child: Row(
                    children: List.generate(
                      9,
                      (index) => Expanded(
                        // flex: 1,
                        child: CupertinoButton(
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          onPressed: () => onTapOption(index + 1),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6.0)),
                              border: Border.all(
                                width: .8,
                                color: Palette.gray2,
                              ),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                            ),
                            child: Center(
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(color: Palette.gray1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void onTap(int row, int col) {
    setState(() {
      currentRow = currentRow == null ? row : null;
      currentCol = currentCol == null ? col : null;
    });
  }

  void onTapOption(int value) {
    setState(() {
      if (sudoku[currentRow!][currentCol!] == value) {
        sudoku[currentRow!][currentCol!] = 0;
      } else {
        sudoku[currentRow!][currentCol!] = value;
      }
    });
  }
}

class FieldWidget extends StatelessWidget {
  final int? value;
  final int row;
  final int col;
  final int? currentCol;
  final int? currentRow;
  final VoidCallback onTap;
  final bool error;
  const FieldWidget({
    Key? key,
    required this.value,
    required this.row,
    required this.col,
    required this.currentCol,
    required this.currentRow,
    required this.onTap,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedCol = currentCol == col;
    final selectedRow = currentRow == row;
    final selected = selectedRow && selectedCol;
    return Flexible(
      flex: 1,
      child: CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: () {
              if (selected) {
                return Palette.gray4;
              }
              if (selectedCol || selectedRow) {
                return Palette.gray6;
              }
            }(),
            border: renderBorder(row, col),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Text(
              value == 0 ? "" : value.toString(),
              style: const TextStyle(color: Palette.gray1),
            ),
          ),
        ),
      ),
    );
  }

  Border renderBorder(int row, int col) {
    BorderSide? top;
    BorderSide? bottom;
    BorderSide? left;
    BorderSide? right;

    const boldBorder = BorderSide(width: .8, color: Palette.gray1);
    const lightBorder = BorderSide(width: .8, color: Palette.gray5);

    if (row == 0) {
      top = boldBorder;
    }
    if (col == 0) {
      left = boldBorder;
    }
    if (col == COLS - 1) {
      right = boldBorder;
    }
    if (row == ROWS - 1) {
      bottom = boldBorder;
    }
    if ((col + 1) % 3 == 0) {
      right = boldBorder;
    }
    if ((row + 1) % 3 == 0) {
      bottom = boldBorder;
    }
    if (error) {
      return Border.all(width: .8, color: Colors.red);
    }

    return Border(
      top: top ?? lightBorder,
      bottom: bottom ?? lightBorder,
      left: left ?? lightBorder,
      right: right ?? lightBorder,
    );
  }
}
