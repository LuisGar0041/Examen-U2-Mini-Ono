import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini ONO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        cardColor: Colors.lightBlueAccent,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black87),
        ),
      ),
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  void _handleCardPlayed(int index) {
    setState(() {
      // Jugador juega una carta
      bool playerContinue = _game.playCard(true, index);
      if (!playerContinue) {
        _showGameOverDialog('¡Ganaste! La computadora perdió.');
        return;
      }

      // Retraso para la jugada de la computadora
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          int compIndex = _game.ran.nextInt(_game.compu.length);
          bool compContinue = _game.playCard(false, compIndex);
          if (!compContinue) {
            _showGameOverDialog('Ganador Computadora');
          }
        });
      });
    });
  }

  void _showGameOverDialog(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text('Jugar de nuevo'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _game.resetGame(); // Reset the game
                  });
                },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini ONO Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Total de Puntos: ${_game.totalPuntos}',
                style: TextStyle(fontSize: 40, color: Colors.red)),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Usuario', style: TextStyle
                  (fontSize: 25, color: Colors.purple
                ),),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _game.player.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _handleCardPlayed(index),
                        child: Card(
                          color: Colors.cyan,
                          child: Container(
                            alignment: Alignment.center,
                            width: 120, // Aumentado el ancho
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 8), // Aumentado el padding
                            child: Text(_game.player[index].toString(),
                                style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text('Computadora', style:
                TextStyle(fontSize: 25, color: Colors.pinkAccent)),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _game.compu.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {}, // No permite que el usuario toque las cartas de la computadora
                        child: Card(
                          color: Colors.deepOrangeAccent,
                          child: Container(
                            alignment: Alignment.center,
                            width: 120, // Consistencia en el ancho
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8), // Consistencia en el padding
                            child: Text(_game.compu[index].toString(), style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


