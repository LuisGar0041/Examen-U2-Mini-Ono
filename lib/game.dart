import 'dart:math';
import 'card.dart';

class Game {
  int totalPuntos = 0;
  bool isDoubleNext = false;
  List<Card> player = [];
  List<Card> compu = [];
  final Random ran = Random();

  Game() {
    _initializeHands();
  }

  void _initializeHands() {
    player.clear();
    compu.clear();
    totalPuntos = 0;
    isDoubleNext = false;
    for (int i = 0; i < 4; i++) {
      player.add(_drawCard());
      compu.add(_drawCard());
    }
  }

  Card _drawCard() {
    int random = ran.nextInt(100);
    if (random < 70) { // 70% chance to draw normal card
      return Card(ran.nextInt(9) + 1, 'normal');
    } else if (random < 85) { // 15% chance for '-'
      return Card(-10, 'normal');
    } else if (random < 95) { // 10% for 'x2'
      return Card(null, 'x2');
    } else { // 5% for 'HOLD'
      return Card(null, 'HOLD');
    }
  }

  bool playCard(bool isPlayer, int cardIndex) {
    List<Card> hand = isPlayer ? player : compu;
    Card card = hand.removeAt(cardIndex);
    hand.add(_drawCard());

    switch (card.type) {
      case 'normal':
        int value = card.value!;
        if (isDoubleNext) {
          totalPuntos += 2 * value;
          isDoubleNext = false;
        } else {
          totalPuntos += value;
        }
        break;
      case 'x2':
        isDoubleNext = true;
        break;
      case 'HOLD':
      // Skip the turn.
        return true;
    }

    if (totalPuntos >= 98) {
      return false; // Game over
    }
    return true; // Continue playing
  }

  void resetGame() {
    _initializeHands();
  }
}
