import 'dart:math';

class Carta {
  String? color;
  int? valor;

  Carta();
  Carta.carta(this.color, this.valor);

  //devuelve un color al azar
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

  //devuelve un valor al azar
  elegirValor() {
    return Random().nextInt(9) + 1;
  }
}
