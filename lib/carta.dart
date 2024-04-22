import 'dart:math';

class Carta {
  String? color;
  int? valor;

  Carta();
  Carta.carta(color, valor);

  elegirColor() {
    Map<int, String> colores = {
      1: 'verde',
      2: 'azul',
      3: 'amarillo',
      4: 'rojo'
    };
    int colorElegido = Random().nextInt(4) + 1;
    return colores[colorElegido];
  }

  elegirValor() {
    return Random().nextInt(9) + 1;
  }
}
