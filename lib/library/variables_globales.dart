library garita.global;

import 'package:residente/models/residente.dart';

Residente residente;
String mensaje;
UsAlerta usAlerta = new UsAlerta();
String appName = "alert";
bool alertaCancelada = false;
String valor_inicio_defecto_generador_alerta = '1000';
int valor_fin_defecto_generador_alerta = 9990;
String mi_version = '1.0.0';
int contadorAlertaEnviadaBloqueo = 0;
