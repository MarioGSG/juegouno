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
  menuLogin(Jugador jugador) async {
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
        iniciarUno();
        break;
      case '2':
        print('todavía no está implementada esta opción');
        break;
      case '3':
        print('enga chao');
        break;
    }
  }

  //este método crea tres jugadores, uno de ellos con el nombre del jugador registrado, y se define si el jugador es un bot. esos jugadores
  // se meten en una lista que se envía al constructor de juegoUno desde donde se inicia el juego
  iniciarUno() {
    Jugador jugador1 = Jugador.nombre('${Jugador.nombre}', false);
    Jugador jugador2 = Jugador.nombre('bot 1', true);
    Jugador jugador3 = Jugador.nombre('bot 2', true); //seleccionar cantidad bots

    List<Jugador> jugadores = [
      jugador1,
      jugador2,
      jugador3
    ];
    JuegoUno(jugadores);
  }
}
