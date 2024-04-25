import 'dart:io';
import 'package:juegouno/jugador.dart';
import 'carta.dart';

class JuegoUno {
  List<Jugador>? jugadores;

  JuegoUno(jugadores) {
    print('¡Bienvenido a UNO!');
    repartirCartas(jugadores); // se reparte 7 cartas a cada jugador
    Carta cartaEnJuego = Carta.carta(Carta().elegirColor(), Carta().elegirValor()); //se asigna la carta del medio
    do {
      for (Jugador jugador in jugadores) {
        //recorre la lista de los jugadores
        Jugador.nombre(jugador.nombre, jugador.bot).asignarCartas(jugador); //cada carta se asigna con un número en un map
        if (jugador.bot == true) {
          // comprueba si el jugador es un bot o la persona que está jugando
          cartaEnJuego = turnoBot(jugador, cartaEnJuego); //turno del bot
          comprobarVictoria(jugadores); //comprueba victoria
        } else {
          cartaEnJuego = turnoJugador(jugador, cartaEnJuego); //turno del jugador
          comprobarVictoria(jugadores); //comprueba victoria
        }
      }
    } while (true);
  }

  //esta función comprueba si alguno de los jugadores tiene la lista jugador.mano vacía, es así escribe que ha ganado y le envía de nuevo al menú
  //si no continúa como si nada
  comprobarVictoria(jugadores) {
    for (Jugador jugador in jugadores) {
      if (jugador.mano.isEmpty) {
        print('${jugador.nombre} ha ganado');
        break; //cambiar por menú
      }
    }
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
    print('${jugador.nombre} ha tenido suerte y lanza: ${respuesta.valor} ${respuesta.color} ');
    jugador.mano.remove(respuesta);
    return respuesta;
  }

  //se ejecuta el turno del jugador, en él, se coge la respuesta que da el método responderjugador y comprueba primero si es 0, en ese caso ve si la carta
  //robada del medio es posible lanzarla, en ese caso lo hace si no, nada. en el caso de que no robe entonces
  // el jugador juega la carta seleccionada eliminadola así de su mano y devolviendo la carta en juego
  turnoJugador(jugador, cartaEnJuego) {
    stdout.writeln('carta en juego ${cartaEnJuego.valor} ${cartaEnJuego.color}');
    stdout.writeln('es tu turno!');
    Jugador.nombre(jugador.nombre, jugador.bot).mostrarMano(jugador);
    int respuesta = responderJugador(jugador);
    if (respuesta == 0) {
      jugador.recibirCarta();
      stdout.writeln('has robado un ${jugador.mano.last.valor} ${jugador.mano.last.color}');
      cartaEnJuego = comprobarCartaRobada(jugador, cartaEnJuego);
      return cartaEnJuego;
    } else {
      do {
        if (jugador.cartasAsignadas[respuesta]?.valor == cartaEnJuego.valor || jugador.cartasAsignadas[respuesta]?.color == cartaEnJuego.color) {
          cartaEnJuego = jugarCarta(jugador, respuesta);
          return cartaEnJuego;
        } else {
          stdout.writeln('carta no valida');
          stdout.writeln('carta en juego ${cartaEnJuego.valor} ${cartaEnJuego.color}');
          Jugador.nombre(jugador.nombre, jugador.bot).mostrarMano(jugador);
          respuesta = responderJugador(jugador); //decir uno cuando quede 1
        }
      } while (jugador.cartasAsignadas[respuesta]?.valor != cartaEnJuego.valor || jugador.cartasAsignadas[respuesta]?.color != cartaEnJuego.color);
    }
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
