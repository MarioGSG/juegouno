import 'dart:io';
import 'dart:math';
import 'package:juegouno/jugador.dart';

import 'carta.dart';

class JuegoUno {
  List<Carta>? cartasJugadas;
  List<Jugador>? jugadores;

  JuegoUno(jugadores) {
    print('¡Bienvenido a UNO!');
    repartirCartas(jugadores);

    for (Jugador elemento in jugadores) {
      do {
        stdout.writeln('Turno de ${elemento.nombre}:');
        mostrarMano(elemento);
        int respuesta = elegirCarta(elemento);
        Map mazoCartas = mapearCarta(elemento, respuesta);
        mazoCartas = jugarCarta(mazoCartas, respuesta);
        comprobarVictoria(jugadores);
      } while (true);
    }
  }

  comprobarVictoria(jugadores) {
    for (Jugador elemento in jugadores) {
      if (elemento.mano.isEmpty) {
        break;
      }
    }
  }

  elegirCarta(jugador) {
    stdout.writeln('elige una carta');
    int? respuesta;
    do {
      respuesta = int.tryParse(stdin.readLineSync() ?? 'e');
    } while (respuesta == null);
    return respuesta;
  }

  mapearCarta(jugador, respuesta) {
    Map<int, Carta> mazoCartas = {};
    int contador = 1;

    for (var elemento in jugador.mano) {
      mazoCartas.addAll({
        contador: elemento
      });
      contador += 1;
    }
    return mazoCartas;
  }

  jugarCarta(mazoCartas, respuesta) {
    print('has elegido: ${mazoCartas[respuesta]?.valor} ${mazoCartas[respuesta]?.color} ');
    mazoCartas.remove(respuesta);
    return mazoCartas;
  }

  repartirCartas(jugadores) {
    for (Jugador jugador in jugadores) {
      for (var i = 0; i < 10; i++) {
        jugador.recibirCarta();
      }
    }
  }

  mostrarMano(jugador) {
    print('cartas ${jugador.nombre}');
    int contador = 1;
    for (var jugador in jugador.mano) {
      print('$contador) ${jugador.valor} ${jugador.color}');
      contador += 1;
    }
  }
}
