import 'dart:io';
import 'package:juegouno/juegoUno.dart';
import 'package:juegouno/jugador.dart';

class App {
  //menú en el que se elige una opción
  menuInicial() async {
    String? respuesta;
    do {
      stdout.writeln(''' Bienvenido a UNO !!
    elige una de estas opciones:
      1 -> Iniciar sesión
      2 -> registrarse
      3 -> salir de la App''');
      respuesta = stdin.readLineSync();
    } while (respuesta != '1' && respuesta != '2' && respuesta != '3');

    switch (respuesta) {
      case '1':
        await login();
        break;
      case '2':
        await crearJugador();
        menuInicial();
        break;
      case '3':
        stdout.writeln('Adiós!!');
        break;
    }
  }

  //instancia un jugador, se le asgina un nombre, una contraseña y un id automáticamente, y , mediante el método insertarJugador
  //se inserta en la base de datos
  crearJugador() async {
    Jugador jugador = Jugador();
    stdout.writeln('Introduce un nombre');
    jugador.nombre = stdin.readLineSync();
    stdout.writeln('Introduce una contraseña');
    jugador.password = stdin.readLineSync();
    await jugador.insertarJugador();
    stdout.writeln('Jugador creado correctamente');
  }

  //instancia un jugador, se le asigna un nombre y una contraseña, y , mediante el método loginJugador comprueba si esos datos
  //asignados coinciden con algún jugador de la base de datos
  login() async {
    Jugador jugador = Jugador();
    stdout.writeln('Introduce tu nombre de jugador:');
    jugador.nombre = stdin.readLineSync();
    stdout.writeln('Introduce tu contraseña:');
    jugador.password = stdin.readLineSync();
    var resultado = await jugador.loginJugador();
    if (resultado == false) {
      stdout.writeln('Tu nombre de jugador o contraseña son incorrectos');
      menuInicial();
    } else {
      menuLogin(resultado);
    }
  }

  //menú en el que se elige una opción una vez se ha registrado
  menuLogin(jugador) async {
    String? respuesta;
    do {
      stdout.writeln('''hola ${jugador.nombre} elige una de estas opciones:
    1 -> Jugar al UNO
    2 -> Ver estadísticas
    3 -> Salir''');
      respuesta = stdin.readLineSync();
    } while (respuesta != '1' && respuesta != '2' && respuesta != '3');

    switch (respuesta) {
      case '1':
        iniciarUno(jugador);
        break;
      case '2':
        await imprimirEstadisticas(jugador);
        menuLogin(jugador);
      case '3':
        print('enga chao');
        break;
    }
  }

  //este método crea tres jugadores, uno de ellos con el nombre del jugador registrado, y se define si el jugador es un bot. esos jugadores
  // se meten en una lista que se envía al constructor de juegoUno desde donde se inicia el juego
  iniciarUno(jugador) {
    List<Jugador> jugadores = crearJugadores(jugador);
    JuegoUno().juegoUno(jugadores, jugador);
  }

  //imprime las estadisticas que le ha enviado el método all
  imprimirEstadisticas(jugador) async {
    List estadisticasJugador = await Jugador().all(jugador);

    for (Jugador elemento in estadisticasJugador) {
      stdout.writeln('''
    partidas Jugadas -> ${elemento.partidasJugadas}
    partidas Ganadas -> ${elemento.partidasGanadas}
      ''');
    }
  }

  //almacena la respuesta del usuario, crea al jugador principal y según la respuesta crea una cantidad de bots
  crearJugadores(jugador) {
    int contador = preguntarCantidadBot();
    Jugador jugadorPrincipal = Jugador.crearPersonaje('${jugador.nombre}', false);
    List<Jugador> jugadores = [
      jugadorPrincipal
    ];
    for (int i = 1; i < contador; i++) {
      Jugador bot = Jugador.crearPersonaje('bot $i', true);
      jugadores.add(bot);
    }
    return jugadores;
  }

  //pregunta la cantidad y devuelve la respuesta
  preguntarCantidadBot() {
    int? opcion;

    do {
      stdout.writeln('elige la cantidad de bots (1-5)');
      opcion = int.tryParse(stdin.readLineSync() ?? 'e');
    } while (opcion == null || opcion > 5 && opcion < 0);
    return opcion + 1;
  }
}
