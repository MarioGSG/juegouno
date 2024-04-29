import 'package:juegouno/app.dart';
import 'package:juegouno/database.dart';

main() async {
  await Database().instalacion();
  App().menuInicial();
}
