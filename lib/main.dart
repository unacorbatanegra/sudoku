import 'package:flutter/material.dart';
import 'package:sudoku/presentation/pages/sudoku_page.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

void main() {
  final a = SudokuGenerator();
  print(a.newSudoku);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SudokuPage(),
    );
  }
}


