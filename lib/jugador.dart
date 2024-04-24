import 'package:juegouno/carta.dart';

class Jugador {
  String? nombre;
  List<Carta> mano = [];
  Map<int, Carta> cartasAsignadas = {};
  bool? bot;

  Jugador(this.nombre, this.bot);

  recibirCarta() {
    Carta carta = Carta.carta(Carta().elegirColor(), Carta().elegirValor());
    mano.add(carta);
  }

  mostrarMano(jugador) {
    int contador = 1;
    print('tus cartas:');
    for (var jugador in jugador.mano) {
      print('$contador) ${jugador.valor} ${jugador.color}');
      contador += 1;
    }
    print('pulsa 0 para robar');
  }
}
