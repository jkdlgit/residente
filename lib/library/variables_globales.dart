library garita.global;

import 'package:residente/models/residente.dart';

Residente residente;
String mensaje;
UsAlerta usAlerta = new UsAlerta();
String appName = "Alert Now";
bool alertaCancelada = false;
bool isSuscribed = false;
String suscriptionName = "telefono";
int testDay = 7; //REPRESENTA LA CANTIDAD DE DIAS DE PRUEBAS EN LA APP
bool setMoreTimeSuscription = false;
int testDayWait = 3;
/*REPRESENTA LA CANTIDAD EN DIAS DE GRACIA QUE TENDRA 
                        EL USUARIO*/
bool isActivatedSuscriptionFreeTime = false;
