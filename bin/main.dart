import 'package:juegouno/juegoUno.dart';
import 'package:juegouno/jugador.dart';

main() {
  Jugador jugador1 = Jugador('Jugador 1', false); //poder elegir el nombre
  Jugador jugador2 = Jugador('bot 1', true);
  Jugador jugador3 = Jugador('bot 2', true);

  List<Jugador> jugadores = [
    jugador1,
    jugador2,
    jugador3
  ];
  JuegoUno(jugadores);
}
