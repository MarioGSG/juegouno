import 'package:juegouno/carta.dart';

class Jugador {
  String? nombre;
  List<Carta> mano = [];

  Jugador(this.nombre);

  recibirCarta() {
    Carta carta = Carta.carta(Carta().elegirColor(), Carta().elegirValor());
    mano.add(carta);
  }

  jugarCarta(carta) {}
}