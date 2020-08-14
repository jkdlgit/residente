import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:residente/screens/home.dart';
import 'package:residente/screens/noConnection.dart';
import 'package:residente/screens/register1.dart';
import 'package:residente/screens/register2.dart';
import 'package:residente/screens/start.dart';
import 'package:residente/screens/suscription.dart';
import 'package:residente/screens/suscriptionTankyou.dart';
import 'package:residente/screens/temp/pay.dart';
import 'package:residente/screens/temp/pay1.dart';
import 'package:residente/screens/temp/paySuscripcion.dart';
import 'package:residente/utils/localStorageDB.dart';
import 'package:residente/library/variables_globales.dart' as global;
//import 'package:true_time/true_time.dart';
import 'models/residente.dart';
import 'package:intl/intl.dart';

//void main() => runApp(MarketScreen());
void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  //runApp(MyApp2());
  runApp(MyApp());
}

final localDb = LocalDataBase();
Residente residente = new Residente();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '...',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainHome(),
      //Suscription(), //Register2(), //SuscriptionTankyou(), //MarketScreen(), //MainHome(),
    );
  }
}

class MainHome extends StatelessWidget {
  _testConnection(context) async {
    //_initPlatformState();

    var today = DateTime.now();
    var fiftyDaysFromNow = today.add(new Duration(days: 2));
    global.endTryDay = false;
    _validateDate1(context);

    var hasConnection = await DataConnectionChecker().hasConnection;

    if (hasConnection) {
      if (!global.endTryDay) {
        _getStart(context);
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoConnection()));
    }
  }

  @override
  Widget build(BuildContext context) {
    _testConnection(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.sapphire,
        elevation: 0.0,
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.3,
          heightFactor: 0.3,
          child: Container(
            child: Image(image: AssetImage("assets/images/campana.png")),
          ),
        ),
      ),
      backgroundColor: MyColors.sapphire,
    );
  }

  _getStart(context) {
    try {
      localDb.read(Campos.cod_residente).then(
        (data) {
          if (data != null) {
            residente.codResidente = data;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );

            _getData();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Start()),
            );
          }
        },
      );
    } catch (e) {}
  }

  _getData() {
    localDb.read(Campos.document_id).then((data) {
      residente.documentId = data;
      global.residente = residente;
    });

    localDb.read(Campos.nombre).then((data) {
      residente.nombre = data;
      global.residente = residente;
    });

    localDb.read(Campos.document_id_garita).then((data) {
      residente.documentIdGarita = data;
      global.residente = residente;
    });

    localDb.read(Campos.familia).then((data) {
      residente.familia = data;
      global.residente = residente;
    });

    localDb.read(Campos.direccion).then((data) {
      residente.direccion = data;
      global.residente = residente;
    });
  }
/*
  DateTime _currentTime;
  //bool _initialized = false;
  _initPlatformState() async {
    var currDt = DateTime.now();
    var currentDay = DateTime.now().month;

    print(currDt.year); // 4
    print(currDt.weekday); // 4
    print(currDt.month); // 4
    print(currDt.day); // 2
    print(currDt.hour); // 15
    print(currDt.minute); // 21
    print(currDt.second); // 49

    //_updateCurrentTime();
  }*/

  _validateDate1(context) async {
    //localDb.save(Campos.futureSuscription, null);
    //localDb.save(Campos.isActivatedSuscriptionFreeTime, null);
    //CARGA FECHA DE SUSCRIPCION SI ES QUE EXISTE
    var futureSuscription;
    var isActivatedSuscriptionFreeTime;
    await localDb.read(Campos.futureSuscription).then((data) {
      try {
        futureSuscription = data;
        print('FUTURE SUSCRIPTION:  ' + futureSuscription.toString());
      } catch (ex) {
        print('ERROR 1' + ex.toString());
      }
    });

    var toDayTime = DateTime.now();
    String toDay = DateFormat('yyyy-MM-dd').format(toDayTime);
    //toDay = DateTime.parse('2020-08-30 02:38:29.121802');
    if (futureSuscription == null) {
      var futureSuscription = toDayTime.add(new Duration(days: global.testDay));
      String futureSuscriptionString =
          DateFormat('yyyy-MM-dd').format(futureSuscription);
      try {
        localDb.save(
            Campos.futureSuscription, futureSuscriptionString.toString());
      } catch (err) {}
      //LANZAR LA MAIN NUEVAMENTE @@@@@@@@@@@@@@
      //CORRECTO!
    } else {
      //toDay = DateTime.parse('2020-08-23 00:13:09.011293');

      if (toDay == futureSuscription.toString()) {
        //FIN DE SUSCRIPCION

        //GUARDA PERIODO DE GRACIA SOLO SI NO EXISTE
        await localDb.read(Campos.isActivatedSuscriptionFreeTime).then((data) {
          try {
            isActivatedSuscriptionFreeTime = data;
            print('FUTURE SUSCRIPTION TIME:  ' +
                isActivatedSuscriptionFreeTime.toString());
          } catch (ex) {
            print('ERROR 2' + ex.toString());
          }
        });
        if (isActivatedSuscriptionFreeTime == null) {
          isActivatedSuscriptionFreeTime = true;
          var futureSuscription =
              toDayTime.add(new Duration(days: global.testDayWait));
          String futureSuscriptionString =
              DateFormat('yyyy-MM-dd').format(futureSuscription);
          //GUARDA EL TIEMPO DE GRACIA
          localDb.save(Campos.futureSuscription, futureSuscriptionString);
          localDb.save(Campos.isActivatedSuscriptionFreeTime,
              isActivatedSuscriptionFreeTime.toString());
          global.endTryDay = true;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Suscription()),
          );
        } else {
          global.endTryDay = true;
          global.isActivatedSuscriptionFreeTime = true;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Suscription()),
          );
          //LANZA LA VENTANA DE SUSCRIPCION SIN BOTON DE GRACIA
        }

        //futureSuscriptionFreeTime =
      }
    }
  }

  _validateDate(context) async {
    int contTestDay = 0;
    int lastDay = 0;
    int toDay = 0;
    //CARGAR EL CONTADOR DE DIA (FECHA) DESDE EL DISPOSITIVO
    await localDb.read(Campos.contTestDay).then((data) {
      try {
        contTestDay = int.parse(data);
        print('CONTADOR DE DIAS TIENE: ' + contTestDay.toString());
      } catch (ex) {
        print('ERROR 1' + ex.toString());
        contTestDay = 0;
      }
    });

    //SI EL CONTADOR SUPERA EL NUMERO DE PRUEBA DE LA APP (15)
    if (contTestDay > global.testDay) {
      print(
          'contTestDay ES MAYOR QUE  global.testDay' + contTestDay.toString());
      //LANZAR VENTANA DE SUSCRIPCION
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Suscription()),
      );
    } else {
      //CARGAR EL DIA (FECHA) DE LA BASE LOCAL
      await localDb.read(Campos.lastDay).then((data) {
        try {
          lastDay = int.parse(data);
          print('ULTIMO DIA TIENE: ' + lastDay.toString());
        } catch (ex) {
          print('ERROR 2' + ex.toString());
          lastDay = 0;
        }

        //OBTENER EL DIA (FECHA) DL DISPOSITIVO
        var toDay = DateTime.now().day;
        toDay = 23;
        print('DIA ACTUAL ES: ' + toDay.toString());
        //COMPARAR: SI SON DIFERENTES,
        if (toDay != lastDay) {
          //SUMAR UN CONTADOR Y GUARDARLO EN LA BASE LOCAL
          contTestDay += 1;
          print('SE INCRMENTO contTestDay: ' + contTestDay.toString());
          //GUARDAR NUEVO CONTADOR
          try {
            localDb.save(Campos.contTestDay, contTestDay.toString());
            localDb.save(Campos.lastDay, toDay.toString());
            print('SE GUARDO CORRECTAMENTE  contTestDay Y toDay: ');
          } catch (ex) {
            print('ERROR 3' + ex.toString());
          }
        }
      });
    }

    //COMPARAR: SI SON DIFERENTES,
    //SUMAR UN CONTADOR Y GUARDARLO EN LA BASE LOCAL
  }
/*
  _updateCurrentTime() async {
    DateTime now = await TrueTime.now();

    print('>' + now.toString() + '<');
  }*/
}
