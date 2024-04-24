import 'package:juegouno/juegoUno.dart';
import 'package:juegouno/jugador.dart';

main() {
  Jugador jugador1 = Jugador('Jugador 1'); //poder elegir el nombre
  Jugador jugador2 = Jugador('Jugador 2');
  Jugador jugador3 = Jugador('Jugador 3');

  List<Jugador> jugadores = [
    jugador1,
    jugador2,
    jugador3
  ];
  JuegoUno(jugadores);
}
