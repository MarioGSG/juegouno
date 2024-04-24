import 'dart:io';
import 'dart:math';
import 'package:juegouno/jugador.dart';

import 'carta.dart';

class JuegoUno {
  List<Jugador>? jugadores;

  JuegoUno(jugadores) {
    print('¡Bienvenido a UNO!');
    repartirCartas(jugadores);
    Carta cartaEnJuego = Carta.carta(Carta().elegirColor(), Carta().elegirValor());
    do {
      for (Jugador jugador in jugadores) {
        stdout.writeln('Turno de ${jugador.nombre}:');
        stdout.writeln('carta en juego ${cartaEnJuego.valor} ${cartaEnJuego.color} :');
        asignarCartas(jugador);
        mostrarMano(jugador); //cambiar más tarde
        int respuesta = elegirCarta(jugador);
        if (respuesta == 0) {
          jugador.recibirCarta();
        } else {
          do {
            //refactorizar más tarde
            if (jugador.cartasAsignadas[respuesta]?.valor == cartaEnJuego.valor || jugador.cartasAsignadas[respuesta]?.color == cartaEnJuego.color) {
              cartaEnJuego = jugarCarta(jugador, respuesta);
            } else {
              stdout.writeln('carta no valida');
              stdout.writeln('carta en juego ${cartaEnJuego.valor} ${cartaEnJuego.color} :');
              mostrarMano(jugador);
              respuesta = elegirCarta(jugador);
            }
          } while (jugador.cartasAsignadas[respuesta]?.valor != cartaEnJuego.valor || jugador.cartasAsignadas[respuesta]?.color != cartaEnJuego.color);
        }
        comprobarVictoria(jugadores);
      }
    } while (true);
  }

  comprobarVictoria(jugadores) {
    for (Jugador jugador in jugadores) {
      if (jugador.mano.isEmpty) {
        print('${jugador.nombre} ha ganado');
        break; //cambiar por menú
      }
    }
  }

  asignarCartas(jugador) {
    int contador = 1;
    for (Carta carta in jugador.mano) {
      jugador.cartasAsignadas.addAll({
        contador: carta
      });
      contador += 1;
    }
  }

  elegirCarta(jugador) {
    stdout.writeln('elige una carta');
    int? respuesta;
    do {
      respuesta = int.tryParse(stdin.readLineSync() ?? 'e');
    } while (respuesta == null); //solucionar error
    return respuesta;
  }

  jugarCarta(jugador, respuesta) {
    print('has elegido: ${jugador.cartasAsignadas[respuesta]?.valor} ${jugador.cartasAsignadas[respuesta]?.color} ');
    jugador.mano.remove(jugador.cartasAsignadas[respuesta]);
    return jugador.cartasAsignadas[respuesta];
  }

  repartirCartas(jugadores) {
    for (Jugador jugador in jugadores) {
      for (var i = 0; i < 10; i++) {
        jugador.recibirCarta();
      }
    }
  }

  mostrarMano(jugador) {
    int contador = 1;
    print('cartas ${jugador.nombre}');
    for (var jugador in jugador.mano) {
      print('$contador) ${jugador.valor} ${jugador.color}');
      contador += 1;
    }
    print('pulsa 0 para robar');
  }
}
