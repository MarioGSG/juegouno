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
        asignarCartas(jugador);
        if (jugador.bot == true) {
          cartaEnJuego = turnoBot(jugador, cartaEnJuego);
        } else {
          stdout.writeln('carta en juego ${cartaEnJuego.valor} ${cartaEnJuego.color}');
          stdout.writeln('es tu turno!');
          Jugador(jugador.nombre, jugador.bot).mostrarMano(jugador); //cambiar más tarde //cambiar propiedades constructor Jugador
          int respuesta = elegirCarta(jugador);
          if (respuesta == 0) {
            //cambiar que si robas y coincide color o valor se pueda tirar.
            jugador.recibirCarta();
          } else {
            do {
              //refactorizar más tarde
              if (jugador.cartasAsignadas[respuesta]?.valor == cartaEnJuego.valor || jugador.cartasAsignadas[respuesta]?.color == cartaEnJuego.color) {
                cartaEnJuego = jugarCarta(jugador, respuesta);
              } else {
                stdout.writeln('carta no valida');
                stdout.writeln('carta en juego ${cartaEnJuego.valor} ${cartaEnJuego.color} :');
                Jugador(jugador.nombre, jugador.bot).mostrarMano(jugador);
                respuesta = elegirCarta(jugador);
              }
            } while (jugador.cartasAsignadas[respuesta]?.valor != cartaEnJuego.valor || jugador.cartasAsignadas[respuesta]?.color != cartaEnJuego.color);
          }
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
    int? respuesta;
    do {
      stdout.writeln('elige una carta');
      respuesta = int.tryParse(stdin.readLineSync() ?? 'e');
    } while (respuesta == null || respuesta > jugador.mano.length || respuesta < 0);
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

  turnoBot(jugador, cartaEnJuego) {
    var respuesta = responderbot(jugador, cartaEnJuego);
    if (respuesta == 0) {
      jugador.recibirCarta();
      print('${jugador.nombre} ha robado');
      return cartaEnJuego;
    } else {
      cartaEnJuego = jugarCartaBot(jugador, respuesta);
      return cartaEnJuego;
    }
  }

  responderbot(jugador, cartaEnJuego) {
    var respuesta;
    for (Carta carta in jugador.mano) {
      if (carta.valor == cartaEnJuego.valor || carta.color == cartaEnJuego.color) {
        respuesta = carta;
        return respuesta;
      }
    }
    respuesta = 0;
    return respuesta;
  }

  jugarCartaBot(jugador, respuesta) {
    print('${jugador.nombre} ha elegido: ${respuesta.valor} ${respuesta.color} ');
    jugador.mano.remove(respuesta);
    return respuesta;
  }
}
