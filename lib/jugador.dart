import 'package:juegouno/carta.dart';

class Jugador {
  String? nombre;
  List<Carta> mano = [];
  Map<int, Carta> cartasAsignadas = {};
  bool? bot;

  Jugador.nombre(this.nombre, this.bot);

  //accede al contructor de la carta para crear una y almacenarla en la mano del jugador
  recibirCarta() {
    Carta carta = Carta.carta(Carta().elegirColor(), Carta().elegirValor());
    mano.add(carta);
  }

  //imprime la mano del jugador
  mostrarMano(jugador) {
    int contador = 1;
    print('tus cartas:');
    for (var jugador in jugador.mano) {
      print('$contador) ${jugador.valor} ${jugador.color}');
      contador += 1;
    }
    print('pulsa 0 para robar');
  }

  //a cada carta de la lista mano se le asigna un entero dentro de un map
  asignarCartas(jugador) {
    int contador = 1;
    for (Carta carta in jugador.mano) {
      jugador.cartasAsignadas.addAll({
        contador: carta
      });
      contador += 1;
    }
  }
}
