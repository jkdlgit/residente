import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:residente/models/residente.dart';
import 'package:residente/models/temp.dart';
import 'package:residente/models/times.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'package:residente/screens/end.dart';
import 'package:residente/screens/noConnection.dart';
import 'package:residente/utils/methos.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:data_connection_checker/data_connection_checker.dart';

class Home extends StatefulWidget {
  //Home() : super();

  final String title = "Alerta";

  @override
  HomeState createState() => HomeState();
}

final db = Firestore.instance;
bool mostrarMensaje = false;
ProgressDialog pr;

class HomeState extends State<Home> {
  //

  int indexSelected = 1;

  @override
  void initState() {
    super.initState();

    _testConnection(context);
    //_testConnection().timeout(const Duration(seconds: 10));
    global.usAlerta.codigo = null;
    _obtenerCodigoAlerta();
    //_cancelAlert();
  }

  _testConnection(context) async {
    var hasConnection = await DataConnectionChecker().hasConnection;

    if (!hasConnection) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoConnection()),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        body: _inicio(),
        backgroundColor: MyColors.white,
      ),
    );
  }

  _cardSuperior() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      color: MyColors.white,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: FractionallySizedBox(
            widthFactor: 0.3,
            child: Center(
              child: Container(
                child: Image(image: AssetImage("assets/images/campana2.png")),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _cardMedia() {
    return Card(
      color: MyColors.white,
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              height: 120.0,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 10.0, top: 0.0),
                scrollDirection: Axis.horizontal,
                itemCount: times.length,
                itemBuilder: (BuildContext contex, int index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        _buildCircleAvatar(index),
                      ],
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }

  _cardInf() {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: tipos.length,
        itemBuilder: (BuildContext context, int index) {
          final String tipo = tipos[index].toString();

          return GestureDetector(
            onTap: () {
              //print('hola');

              _estabecerDatosAlerta(null, tipos[index], null);

              _continuar(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25.0),
              decoration: BoxDecoration(color: MyColors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Center(
                        child: Text(
                          tipo,
                          style: TextStyle(
                              color: MyColors.grey60,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _inicio() {
    return Padding(
      padding: EdgeInsets.only(top: 25.0),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[


          Expanded(
            //flex: 11,
            child: _cardSuperior(),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              'Tiempo de espera',
              style: TextStyle(
                  color: MyColors.sapphire, fontSize: TamanioTexto.subtitulo),
            ),
          ),
          _cardMedia(),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              'Tipo de visita',
              style: TextStyle(
                  color: MyColors.sapphire, fontSize: TamanioTexto.subtitulo),
            ),
          ),
          Expanded(
            child: _cardInf(),
          ),
        ],
      ),
    );
  }

  _buildCircleAvatar(int index) {
    return Container(
      child: (indexSelected == index)
          ? GestureDetector(
              onTap: () {
                setState(() {
                  indexSelected = index;
                });
              },
              child: CircleAvatar(
                radius: 45.0,
                backgroundColor: MyColors.moccasin,
                child: Text(
                  times[index].toString(),
                  style: TextStyle(
                      fontSize: 45, color: MyColors.sapphire), //Colors.white),
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                setState(() {
                  indexSelected = index;
                });
                // print(index);
                _estabecerDatosAlerta(null, null, times[index]);
              },
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: MyColors.lavender_blue, //Color(0xffD2F6F3),
                child: Text(
                  times[index].toString(),
                  style: TextStyle(fontSize: 30, color: MyColors.sapphire),
                ),
              ),
            ),
    );
  }

  _obtenerCodigoAlerta() {
    if (global.usAlerta.codigo == null) {
      DocumentReference userQuery = db
          .collection(Coleccion.registro_garita)
          .document(global.residente.documentIdGarita);

      userQuery.get().then(
        (garita) {
          if (garita != null) {
            String codigo = garita.data[Campos.generador_alerta];

            _guardarDb(
                Coleccion.registro_garita,
                Campos.generador_alerta,
                (int.parse(codigo) + 1).toString(),
                global.residente.documentIdGarita);

            _estabecerDatosAlerta(codigo, null, times[indexSelected]);
          } else {
            _mostrarPopUp();
          }
        },
      );
    }
  }

  _estabecerDatosAlerta(String _codigo, String _tipo, String _duracion) {
    global.usAlerta.codigo =
        (_codigo != null) ? _codigo : global.usAlerta.codigo;
    global.usAlerta.tipo = (_tipo != null) ? _tipo : global.usAlerta.tipo;
    global.usAlerta.duracion =
        (_duracion != null) ? _duracion : global.usAlerta.duracion;
/*
    print('CODIGO: ' +
        ((global.usAlerta.codigo != null) ? global.usAlerta.codigo : '') +
        '  TIPO: ' +
        ((global.usAlerta.tipo != null) ? global.usAlerta.tipo : '') +
        ' DURACION: ' +
        ((global.usAlerta.duracion != null) ? global.usAlerta.duracion : '')
            .toString());*/
  }

  _continuar(context) {
    if (global.usAlerta.codigo != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => End()),
      );
    } else {
      //_mostrarMensaje("Generando código, por favor espere...",context);
      startTimer();
    }
  }

  _guardarDb(
      String collection, String field, String value, String documentId) async {
    await db
        .collection(collection)
        .document(documentId)
        .updateData({field: value});
  }

  _mostrarPopUp() {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: MyColors.sapphire,
      ),
    );
    return Alert(
      style: alertStyle,
      context: context,
      type: AlertType.warning,
      title: "ERROR DE CONXIÓN",
      buttons: [
        DialogButton(
          child: Text(
            "Reconectar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            _obtenerCodigoAlerta();

            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );*/
          },
          color: MyColors.sapphire,
        ),
        DialogButton(
          child: Text(
            "Salir",
            style: TextStyle(color: MyColors.sapphire, fontSize: 20),
          ),
          onPressed: () => SystemNavigator.pop(),
          color: MyColors.white,
        )
      ],
    ).show();
  }

  _mostrarMensaje(String _mensaje, context) {
    setState(() {
      global.mensaje = _mensaje;
      mostrarMensaje = true;
    });

    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      title: "Alerta!",
      messageText: Text(
        _mensaje,
        style: TextStyle(
            fontSize: 18.0,
            color: MyColors.moccasin,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
      backgroundColor: MyColors.sapphire,
      duration: Duration(seconds: 3),
    )..show(context);
  }

//            startTimer();
  int contWaitCode = 0;
  Timer _timer;
  void startTimer() async {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    await pr.show();

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (global.usAlerta.codigo != null) {
            contWaitCode = 0;
            timer.cancel();
            pr.hide();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => End()),
            );
            //corrcto, lanzar siguiente ventana
          }

          if (contWaitCode > 10) {
            contWaitCode = 0;
            timer.cancel();
            pr.hide();
            _mostrarMensaje("No se pudo obtener codigo", context);
            //mostrar mensaje de error, no se pudo obtener el codigo y
            //volver a intentarlo,
            //lanzando nuevamente esta ventana
            //pero como pop up con dos opcines
            //reintentar o salir
          } else {
            contWaitCode = contWaitCode + 1;
          }
        },
      ),
    );
  }

  

  // _testConnection() async{
/*
    try {
      final result = await InternetAddress.lookup('google.com').timeout();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
      else{
        print('No connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }*/
  //}
}
