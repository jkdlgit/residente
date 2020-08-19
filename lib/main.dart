import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
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
final List<String> _suscriptionLists = Platform.isAndroid
    ? [
        'android.test.purchased',
        'point_1000',
        '5000_point',
        'android.test.canceled',
        'pluma_test',
        'tv',
        'telefono',
        'internet',
      ]
    : ['com.cooni.point1000', 'com.cooni.point5000'];

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

_initInappPurchase(context) async {
  try {
    await FlutterInappPurchase.instance.initConnection;
    //print("---------- Connect Billing Button Pressed");

  } catch (e) {
    //Error
  }
}

Future<void> initPlatformState() async {
  String platformVersion;
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    platformVersion = await FlutterInappPurchase.instance.platformVersion;
  } on PlatformException {
    platformVersion = 'Failed to get platform version.';
  }

  // prepare
  var result = await FlutterInappPurchase.instance.initConnection;
  //print('result: $result');

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.

  /* setState(() {
      platformVersion = platformVersion;
    });*/

  // refresh items for android
  try {
    String msg = await FlutterInappPurchase.instance.consumeAllItems;
    //print('consumeAllItems: $msg');
  } catch (err) {
    //ingresa aqui cuando no encuentra productos o suscripciones
    //print('consumeAllItems error: $err');
  }

  conectionSubscription =
      FlutterInappPurchase.connectionUpdated.listen((connected) {
    //print('connected: $connected');
  });
}

class MainHome extends StatelessWidget {
  _testConnection(context) async {
    //_initPlatformState();
    await _iniciaFlutterInappPurchase();

    /*initPlatformState();
    _initInappPurchase(context);
    _getPurchasesSuscription();*/

    //var today = DateTime.now();
    //var fiftyDaysFromNow = today.add(new Duration(days: 2));

    //VERIFICAR SI EXISTE LA PRIMERA PIEDRA
    await _verificarPrimeraPiedra();
    if (!Contenedor.primeraPiedra) {
      await _guardarPrimeraPiedra();
      await _generaPeriodoPrueba();
    }
    //VERIFICAR SUSCRIPCION LOCALMENTE
    await _verificarSuscripcionGoogle();

    if (!Contenedor.suscripcionActiva) {
      await _verificaCaducidad(context);
    }

    //global.endTryDay = false;

    /*if (Contenedor.suscripcionActiva) {
      _validateDate1(context);
    }*/

    var hasConnection = await DataConnectionChecker().hasConnection;

    if (hasConnection) {
      if (!global.mostraPantallaSuscripcion) {
        _getStart(context);
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoConnection()));
    }
  }

  _iniciaFlutterInappPurchase() async {
    //1
    try {
      await FlutterInappPurchase.instance.initConnection;
      //print("---------- Connect Billing Button Pressed");

    } catch (e) {
      //Error
    }

//2

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInappPurchase.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    //print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    /* setState(() {
      platformVersion = platformVersion;
    });*/

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      //print('consumeAllItems: $msg');
    } catch (err) {
      //ingresa aqui cuando no encuentra productos o suscripciones
      //print('consumeAllItems error: $err');
    }

    conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      //print('connected: $connected');
    });
//3
    String productId = "";
    List<PurchasedItem> items =
        await FlutterInappPurchase.instance.getAvailablePurchases();
    global.isSuscribed = false;
    if (items.length > 0) {
      productId = items[0].productId;
      if (productId == global.suscriptionName) {
        global.isSuscribed = true;
      }
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
    } catch (err) {}
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

/*AQUI ES NECESARIO VALIDAR PRIMERAMENTE SI EXISTE UNA SUSCRIPCION
SI ES ASI, NO SE DEBE EJECUTAR ESTE METODO
SI NO EXISTE, PERO EL USUAIOR GENERA UNA SUSCRIPCION, SE DEBE VALIDAR CORRECTAMENTE 
Y DAR PASO INMEDIATAMENTE*/

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
      toDay = '2020-08-22';

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
          var dtToDay = DateTime.parse(toDay);
          var futureSuscription =
              dtToDay.add(new Duration(days: global.testDayWait));
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
/*
  Future _getSuscription() async {
    try {
      List<IAPItem> items = await FlutterInappPurchase.instance
          .getSubscriptions(_suscriptionLists);
      List<IAPItem> _itemsSuscription = [];

      _itemsSuscription = items;
      //this._purchases = [];

    } catch (err) {}
    /*  for (var item in items) {
      //print('${item.toString()}');
      this._items.add(item);
    }*/
   
  }*/

  Future _getPurchasesSuscription() async {
    String productId = "";
    List<PurchasedItem> items =
        await FlutterInappPurchase.instance.getAvailablePurchases();
    global.isSuscribed = false;
    if (items.length > 0) {
      productId = items[0].productId;
      if (productId == global.suscriptionName) {
        global.isSuscribed = true;
      }
    }
  }

  _verificarPrimeraPiedra() async {
    try {
      await localDb.read(Dato.primeraPiedra).then((data) {
        try {
          if (data != null) {
            Contenedor.primeraPiedra =
                (data.toLowerCase() == "true") ? true : false;
          } else {
            Contenedor.primeraPiedra = false;
          }
          print('Contenedor.app_instalada = ' +
              Contenedor.primeraPiedra.toString());
        } catch (ex) {
          Contenedor.primeraPiedra = false;
          print('ERROR _verificarPrimeraPiedra1  ' + ex.toString());
        }
      });
    } catch (ex) {
      Contenedor.primeraPiedra = false;
      print('ERROR _verificarPrimeraPiedra2 ' + ex.toString());
    }
  }

  _guardarPrimeraPiedra() async {
    try {
      localDb.save(Dato.primeraPiedra, "True");
      print('Se guardo primera piedra');
    } catch (ex) {
      print('ERROR _guardarPrimeraPiedra ' + ex.toString());
    }
  }

  _verificarSuscripcionLocal() async {
    try {
      await localDb.read(Dato.suscripcionActiva).then((data) {
        try {
          if (data != null) {
            Contenedor.suscripcionActiva =
                (data.toLowerCase() == "true") ? true : false;
          } else {
            Contenedor.suscripcionActiva = false;
          }
          print('Contenedor.suscripcionActiva = ' +
              Contenedor.suscripcionActiva.toString());
        } catch (ex) {
          Contenedor.suscripcionActiva = false;
          print('ERROR _verificarSuscripcionLocal1 ' + ex.toString());
        }
      });
    } catch (ex) {
      Contenedor.suscripcionActiva = false;
      print('ERROR _verificarSuscripcionLocal2 ' + ex.toString());
    }
  }

  _verificarSuscripcionGoogle() async {
    try {
      String productId = "";
      List<PurchasedItem> items =
          await FlutterInappPurchase.instance.getAvailablePurchases();
      if (items.length > 0) {
        productId = items[0].productId;
        if (productId == Dato.nombreSuscripcion) {
          Contenedor.suscripcionActiva = true;
        }
      }
    } catch (ex) {
      //Contenedor.suscripcionActiva dejar esto en true por si se genera algun error que no sea culpa del usuario, pueda usar la app
      Contenedor.suscripcionActiva = true;
      print('ERROR _verificarSuscripcionGoogle ' + ex.toString());
    }
  }

  _guardaSuscripcionLocal() async {
    try {
      localDb.save(Dato.suscripcionActiva, "True");
      print('Se guardo suscripcion activa');
    } catch (ex) {
      print('ERROR _guardaSuscripcionLocal ' + ex.toString());
    }
  }

  _generaPeriodoPrueba() async {
    try {
      var fechaActual = DateTime.now();
      //String fechaActualFormato = DateFormat('yyyy-MM-dd').format(fechaActual);

      var fechaCaducidad =
          fechaActual.add(new Duration(days: Contenedor.diasPrueba));

      String fechaCaducidadFormato =
          DateFormat('yyyy-MM-dd').format(fechaCaducidad);
      try {
        localDb.save(Dato.periodoPrueba, fechaCaducidadFormato);
        localDb.save(Dato.periodoGraciaActivo, 'True');
      } catch (err) {}
      //LANZAR LA MAIN NUEVAMENTE @@@@@@@@@@@@@@
      //CORRECTO!

    } catch (ex) {}
  }

  _verificaCaducidad(context) async {
    try {
      var fechaActual = DateTime.now();
      String fechaActualFormato = DateFormat('yyyy-MM-dd').format(fechaActual);

      //CONSULTA SI ESTA ACTIVO EL PERIODO DE GRACIA
      await _consultaPeriodoGraciaActivo(); //Dato.periodoGraciaActivo = True/False
      /*Si el periodo de gracia esta activo, significa que 
   se debera lanzar la ventana de suscripcion 
   mostrando el boton de "Dame Mas Tiempo"*/

      await _consultaPeriodoPrueba(); //Dato.periodoPrueba = 2020-08-26

      await _consultarEstadoCaducado();

      DateTime dtFechaActual = DateTime.parse(fechaActualFormato);
      DateTime dtPeriodoPruena = DateTime.parse(Contenedor.periodoPrueba);

      /*if (dtFechaActual.isAtSameMomentAs(dtPeriodoPruena) ||
          dtPeriodoPruena.isBefore(dtFechaActual)) {
        int p = 0;
        int g = 0;
      }*/

      if (dtFechaActual.isAtSameMomentAs(dtPeriodoPruena) ||
          dtPeriodoPruena.isBefore(dtFechaActual) ||
          (Contenedor.estadoCaducado)) {
        //if (Contenedor.periodoGraciaActivo) {
        //var dtToDay = DateTime.parse(toDay);
        if (Contenedor.periodoGraciaActivo) {
          var fechaCaducidad =
              fechaActual.add(new Duration(days: Contenedor.diasGracia));
          String fechaCaducidadFormato =
              DateFormat('yyyy-MM-dd').format(fechaCaducidad);
          //GUARDA EL TIEMPO DE GRACIA
          localDb.save(Dato.periodoPrueba, fechaCaducidadFormato);
          Contenedor.periodoPrueba = fechaCaducidadFormato;
          //localDb.save(Dato.periodoGraciaActivo, 'False');
        }

        localDb.save(Dato.estadoCaducado, 'True');
        global.mostraPantallaSuscripcion = true;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Suscription()),
        );
        //}
      } else {
        //CONTINUAR A LA PANTALLA HOME
      }
    } catch (ex) {
      print('ERROR _consultaPeriodoPrueba ' + ex.toString());
    }
  }

//&&&& se necesita que en la primera este true
  _consultaPeriodoGraciaActivo() async {
    try {
      await localDb.read(Dato.periodoGraciaActivo).then((data) {
        try {
          if (data != null) {
            Contenedor.periodoGraciaActivo =
                (data.toLowerCase() == "true") ? true : false;
          } else {
            Contenedor.periodoGraciaActivo = true;
          }
          print('Contenedor.periodoGraciaActivo = ' +
              Contenedor.periodoGraciaActivo.toString());
        } catch (ex) {
          Contenedor.periodoGraciaActivo = true;
          print('ERROR _consultaPeriodoGraciaActivo1 ' + ex.toString());
        }
      });
    } catch (ex) {
      Contenedor.periodoGraciaActivo = true;
      print('ERROR _consultaPeriodoGraciaActivo2 ' + ex.toString());
    }
  }

  _consultaPeriodoPrueba() async {
    try {
      await localDb.read(Dato.periodoPrueba).then((data) {
        try {
          if (data != null) {
            Contenedor.periodoPrueba = data;
          } else {
            Contenedor.periodoPrueba = null;
          }
          print('Contenedor.periodoPrueba = ' + Contenedor.periodoPrueba);
        } catch (ex) {
          Contenedor.periodoPrueba = null;
          print('ERROR _consultaPeriodoPrueba1 ' + ex.toString());
        }
      });
    } catch (ex) {
      Contenedor.periodoPrueba = null;
      print('ERROR _consultaPeriodoPrueba2 ' + ex.toString());
    }
  }

  _consultarEstadoCaducado() async {
    try {
      await localDb.read(Dato.estadoCaducado).then((data) {
        try {
          if (data != null) {
            Contenedor.estadoCaducado =
                (data.toLowerCase() == 'true') ? true : false;
          } else {
            Contenedor.estadoCaducado = false;
          }
          print('Contenedor.estadoCaducado = ' +
              Contenedor.estadoCaducado.toString());
        } catch (ex) {
          Contenedor.periodoPrueba = null;
          print('ERROR estadoCaducado1 ' + ex.toString());
        }
      });
    } catch (ex) {}
  }
}
