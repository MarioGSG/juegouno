import 'package:juegouno/carta.dart';
import 'package:juegouno/database.dart';
import 'package:mysql1/mysql1.dart';

class Jugador {
  int? idjugador;
  String? nombre;
  String? password;
  int? partidasJugadas;
  int? partidasGanadas;
  //
  List<Carta> mano = [];
  Map<int, Carta> cartasAsignadas = {};
  bool? bot;

  Jugador();
  Jugador.crearPersonaje(this.nombre, this.bot);
  Jugador.fromMap(ResultRow map) {
    idjugador = map['idjugador'];
    nombre = map['nombre'];
    password = map['password'];
  }
  Jugador.fromMapEstadisticas(ResultRow map) {
    partidasGanadas = map['partidasGanadas'];
    partidasJugadas = map['partidasJugadas'];
  }

  //accede al contructor de la carta para crear una y almacenarla en la mano del jugador
  recibirCarta() {
    Carta carta = Carta.carta(Carta().elegirColor(), Carta().elegirValor());
    mano.add(carta);
  }

  //imprime la mano del jugador
  mostrarMano(jugador) {
    int contador = 1;
    print('tus cartas:');
    for (var jugador in jugador.mano) {
      print('$contador) ${jugador.valor} ${jugador.color}');
      contador += 1;
    }
    print('pulsa 0 para robar');
  }

  //a cada carta de la lista mano se le asigna un entero dentro de un map
  asignarCartas(jugador) {
    int contador = 1;
    for (Carta carta in jugador.mano) {
      jugador.cartasAsignadas.addAll({
        contador: carta
      });
      contador += 1;
    }
  }

  //se comunica con la base de datos enviándole un objeto que se ha creado previamente e insertandolo
  insertarJugador() async {
    var conn = await Database().conexion();
    try {
      await conn.query('INSERT INTO jugador(nombre,password) VALUES (?,?)', [
        nombre,
        password
      ]);
      print('Jugador insertado correctamente');
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  //busca el nombre que se ha elegido en la base de datos y si coinciden, se comparan sus contraseñas, si son iguales, se devuelve
  //el jugador, si no, delvuelve un false
  loginJugador() async {
    var conn = await Database().conexion();
    try {
      var resultado = await conn.query('SELECT * FROM jugador WHERE nombre = ?', [
        nombre
      ]);
      Jugador jugador = Jugador.fromMap(resultado.first);
      if (password == jugador.password) {
        return jugador;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      await conn.close();
    }
  }

  //se conecta con la base de datos y cambia la columna partida ganadas sumandole uno
  sumarPartidaGanada(jugador) async {
    var conn = await Database().conexion();
    await conn.query('''UPDATE jugador
    SET partidasGanadas = jugador.partidasGanadas + 1
    WHERE idjugador = ${jugador.idjugador}
    ''');
  }

  //se conecta con la base de datos y cambia la columna partida jugada sumandole uno
  sumarPartidaJugada(jugador) async {
    var conn = await Database().conexion();
    await conn.query('''UPDATE jugador
    SET partidasJugadas = jugador.partidasJugadas + 1
    WHERE idjugador = ${jugador.idjugador}
    ''');
  }

  //saca las estadísticas del jugador
  all(jugador) async {
    var conn = await Database().conexion();
    try {
      var listado = await conn.query('SELECT * FROM jugador WHERE idjugador = ${jugador.idjugador}');
      List<Jugador> jugadores = listado.map((row) => Jugador.fromMapEstadisticas(row)).toList();
      return jugadores;
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }
}
