import 'dart:io';
import 'package:juegouno/app.dart';
import 'package:juegouno/jugador.dart';
import 'carta.dart';

class JuegoUno {
  List<Jugador>? jugadores;
  bool victoria = true;

  //ejecuta el juego mediante una for in metido en un bucle que se repite hasta que un jugador se quede in cartas
  juegoUno(jugadores, jugador) async {
    print('¡Bienvenido a UNO!');
    repartirCartas(jugadores); // se reparte 7 cartas a cada jugador
    Carta cartaEnJuego = Carta.carta(Carta().elegirColor(), Carta().elegirValor()); //se asigna la carta del medio
    do {
      for (Jugador jugadorTurno in jugadores) {
        //recorre la lista de los jugadores
        Jugador.crearPersonaje(jugadorTurno.nombre, jugadorTurno.bot).asignarCartas(jugadorTurno); //cada carta se asigna con un número en un map
        if (jugadorTurno.bot == true) {
          // comprueba si el jugador es un bot o la persona que está jugando
          cartaEnJuego = turnoBot(jugadorTurno, cartaEnJuego); //turno del bot
          victoria = await comprobarVictoria(jugadores, jugador); //comprueba victoria
          if (victoria == false) {
            break;
          }
        } else {
          cartaEnJuego = turnoJugador(jugadorTurno, cartaEnJuego); //turno del jugador
          victoria = await comprobarVictoria(jugadores, jugador); //comprueba victoria
          if (victoria == false) {
            break;
          }
        }
      }
    } while (victoria);
    await Jugador().sumarPartidaJugada(jugador); //suma una partida jugada a las estadísticas de la base de datos
    App().menuLogin(jugador); //devuelve al menú
  }

  //esta función comprueba si alguno de los jugadores tiene la lista jugador.mano vacía, es así devuelve false para que se acabe el bucle y
  //si es el jugador principal el que tiene la mano vacía, le suma una victoria

  comprobarVictoria(jugadores, jugador) async {
    for (Jugador ganador in jugadores) {
      if (ganador.mano.isEmpty) {
        print('${ganador.nombre} ha ganado');
        if (ganador.nombre == jugador.nombre) {
          await Jugador().sumarPartidaGanada(jugador);
        }
        return false;
      }
    }
    return true;
  }

  //esta función pregunta la carta y si es posible la almacena en "respuesta"
  responderJugador(jugador) {
    int? respuesta;
    do {
      stdout.writeln('elige una carta');
      respuesta = int.tryParse(stdin.readLineSync() ?? 'e');
    } while (respuesta == null || respuesta > jugador.mano.length || respuesta < 0);
    return respuesta;
  }

  //esta función dice la carta que has jugado, la elimina de tu mano y la envía a la carta en juego
  jugarCarta(jugador, respuesta) {
    print('has elegido: ${jugador.cartasAsignadas[respuesta]?.valor} ${jugador.cartasAsignadas[respuesta]?.color} ');
    jugador.mano.remove(jugador.cartasAsignadas[respuesta]);
    return jugador.cartasAsignadas[respuesta];
  }

  //esta función crea 7 cartas al azar para cada jugador
  repartirCartas(jugadores) {
    for (Jugador jugador in jugadores) {
      for (var i = 0; i < 7; i++) {
        jugador.recibirCarta();
      }
    }
  }

  //se ejecuta el turno del bot, en él, se coge la respuesta que da el método responderbot y comprueba primero si es 0, en ese caso ve si la carta
  //robada del medio es posible lanzarla, en ese caso lo hace si no, nada. en el caso de que no robe y el método devuelva un número entonces
  // el bot juega la carta eliminadola así de su mano y devolviendo la carta en juego
  turnoBot(jugador, cartaEnJuego) {
    var respuesta = responderbot(jugador, cartaEnJuego);
    if (respuesta == 0) {
      jugador.recibirCarta();
      stdout.writeln('${jugador.nombre} ha robado');
      cartaEnJuego = comprobarCartaRobada(jugador, cartaEnJuego);
      stdout.writeln('a ${jugador.nombre} le quedan ${jugador.mano.length} cartas');
      return cartaEnJuego;
    } else {
      cartaEnJuego = jugarCartaBot(jugador, respuesta);
      stdout.writeln('a ${jugador.nombre} le quedan ${jugador.mano.length} cartas');
      return cartaEnJuego;
    }
  }

  //esta función compara la carta en juego con con la mano del bot, en el caso de que coincida algún color u algún valor se devuelve esa carta
  //y si no, se envía 0 para robar
  responderbot(jugador, cartaEnJuego) {
    var respuesta;
    for (Carta carta in jugador.mano) {
      // opciones al azar (list)
      if (carta.valor == cartaEnJuego.valor || carta.color == cartaEnJuego.color) {
        respuesta = carta;
        return respuesta;
      }
    }
    respuesta = 0;
    return respuesta;
  }

  //recibe la carta de la respuesta, la elimina de su mano y la envía a cartaEnJuego
  jugarCartaBot(jugador, respuesta) {
    print('${jugador.nombre} ha elegido: ${respuesta.valor} ${respuesta.color} ');
    jugador.mano.remove(respuesta);
    return respuesta;
  }

  //recibe la carta de la respuesta, la elimina de su mano y la envía a cartaEnJuego pero con un mensaje diferente
  jugarCartaRobada(jugador, respuesta) {
    stdout.writeln('${jugador.nombre} ha tenido suerte y lanza: ${respuesta.valor} ${respuesta.color}');
    jugador.mano.remove(respuesta);
    return respuesta;
  }

  //se ejecuta el turno del jugador, en él, se coge la respuesta que da el método responderjugador y comprueba primero si es 0, en ese caso ve si la carta
  //robada del medio es posible lanzarla, en ese caso lo hace si no, nada. en el caso de que no robe entonces
  // el jugador juega la carta seleccionada eliminadola así de su mano y devolviendo la carta en juego
  turnoJugador(jugador, cartaEnJuego) {
    stdout.writeln('carta en juego ${cartaEnJuego.valor} ${cartaEnJuego.color}');
    int? respuesta;
    stdout.writeln('es tu turno!');
    Jugador.crearPersonaje(jugador.nombre, jugador.bot).mostrarMano(jugador);
    do {
      respuesta = responderJugador(jugador);
      if (respuesta == 0) {
        jugador.recibirCarta();
        stdout.writeln('has robado un ${jugador.mano.last.valor} ${jugador.mano.last.color}');
        cartaEnJuego = comprobarCartaRobada(jugador, cartaEnJuego);
        return cartaEnJuego;
      } else {
        if (jugador.cartasAsignadas[respuesta]?.valor == cartaEnJuego.valor || jugador.cartasAsignadas[respuesta]?.color == cartaEnJuego.color) {
          cartaEnJuego = jugarCarta(jugador, respuesta);
          return cartaEnJuego;
        } else {
          stdout.writeln('carta no valida');
          stdout.writeln('carta en juego ${cartaEnJuego.valor} ${cartaEnJuego.color}');
          Jugador.crearPersonaje(jugador.nombre, jugador.bot).mostrarMano(jugador);
        }
      }
    } while (jugador.cartasAsignadas[respuesta]?.valor != cartaEnJuego.valor || jugador.cartasAsignadas[respuesta]?.color != cartaEnJuego.color);
  }

  //comprueba si la carta que ha sido robada en el medio se puede lanzar
  comprobarCartaRobada(jugador, cartaEnJuego) {
    if (jugador.mano.last.valor == cartaEnJuego.valor || jugador.mano.last.color == cartaEnJuego.color) {
      cartaEnJuego = jugarCartaRobada(jugador, jugador.mano.last);
      return cartaEnJuego;
    }
    return cartaEnJuego;
  }
}
