import 'package:juegouno/juegoUno.dart';
import 'package:juegouno/jugador.dart';

main() {
  Jugador jugador1 = Jugador('Jugador 1');
  Jugador jugador2 = Jugador('Bot 1');
  Jugador jugador3 = Jugador('Bot 2');

  List<Jugador> jugadores = [
    jugador1,
    jugador2,
    jugador3
  ];
  JuegoUno(jugadores);
}
