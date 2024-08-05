import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late bool _gameOver;
  late String _winner;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ''));
      _currentPlayer = 'X';
      _gameOver = false;
      _winner = '';
    });
  }

  void _handleTap(int row, int col) {
    if (_board[row][col] == '' && !_gameOver) {
      setState(() {
        _board[row][col] = _currentPlayer;
        if (_checkWinner(row, col)) {
          _gameOver = true;
          _winner = _currentPlayer;
        } else if (_board.every((row) => row.every((cell) => cell != ''))) {
          _gameOver = true;
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner(int row, int col) {
    // Check row
    if (_board[row].every((cell) => cell == _currentPlayer)) return true;
    // Check column
    if (_board.every((r) => r[col] == _currentPlayer)) return true;
    // Check diagonals
    if (row == col && _board.every((r) => _board[_board.indexOf(r)][_board.indexOf(r)] == _currentPlayer)) return true;
    if (row + col == 2 && _board.every((r) => _board[_board.indexOf(r)][2 - _board.indexOf(r)] == _currentPlayer)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.dstATop),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Center(
              child: Text(
                'TIC TAC TOE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBoard(),
              const SizedBox(height: 20),
              _buildStatus(),
              const SizedBox(height: 20),
              _buildResetButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBoard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            return _buildCell(row, col);
          }),
        );
      }),
    );
  }

  Widget _buildCell(int row, int col) {
    return GestureDetector(
      onTap: () => _handleTap(row, col),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2.0),
        ),
        child: Center(
          child: Text(
            _board[row][col],
            style: const TextStyle(fontSize: 40, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildStatus() {
    if (_gameOver) {
      if (_winner.isNotEmpty) {
        return Text('Player $_winner wins!', style: const TextStyle(fontSize: 24, color: Colors.white));
      } else {
        return const Text('It\'s a draw!', style: TextStyle(fontSize: 24, color: Colors.white));
      }
    } else {
      return Text('Player $_currentPlayer\'s turn', style: const TextStyle(fontSize: 24, color: Colors.white));
    }
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: _initializeGame,
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(255, 247, 65, 250), // Dark pink color
        onPrimary: Colors.white, // Text color
      ),
      child: const Text('Reset Game'),
    );
  }
}
