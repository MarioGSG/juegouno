import 'package:mysql1/mysql1.dart';

class Database {
  final String _host = 'Localhost';
  final int _port = 3306;
  final String _user = 'root';

  //se hace conexión y ejecuta los métodos que crean la base de datos y las tablas
  instalacion() async {
    var setting = ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
    );
    var conn = await MySqlConnection.connect(setting);
    try {
      await _crearDB(conn);
      await _crearTablaJugadores(conn);
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  //crea la base de datos juegouno mediante sentencias SQL
  _crearDB(conn) async {
    await conn.query('CREATE DATABASE IF NOT EXISTS juegouno');
    await conn.query('USE juegouno');
  }

  //crea la tabla jugadores mediante sentencias SQL
  _crearTablaJugadores(conn) async {
    await conn.query(''' CREATE TABLE IF NOT EXISTS jugador(
        idjugador INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(10) NOT NULL,
        partidasJugadas INT DEFAULT 0,
        partidasGanadas INT DEFAULT 0 
      )''');
  }

  //hace conexión con la base de datos
  Future<MySqlConnection> conexion() async {
    var setting = ConnectionSettings(host: _host, port: _port, user: _user, db: 'juegouno');
    return await MySqlConnection.connect(setting);
  }
}
