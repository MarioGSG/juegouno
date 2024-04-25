import 'package:juegouno/juegoUno.dart';
import 'package:juegouno/jugador.dart';

main() {
  Jugador jugador1 = Jugador.nombre('Jugador 1', false); //poder elegir el nombre
  Jugador jugador2 = Jugador.nombre('bot 1', true);
  Jugador jugador3 = Jugador.nombre('bot 2', true);

  List<Jugador> jugadores = [
    jugador1,
    jugador2,
    jugador3
  ];
  JuegoUno(jugadores);
}

//hacer un menu
//poder registrarse con estadisticas
//meter las cartas
