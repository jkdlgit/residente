import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:residente/models/residente.dart';
import 'package:residente/models/times.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'package:residente/models/types.dart';
import 'package:residente/screens/end.dart';
import 'package:residente/screens/noConnection.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class Home extends StatefulWidget {
  final String title = "Alerta";
  @override
  HomeState createState() => HomeState();
}

final db = Firestore.instance;
ProgressDialog pr;

class HomeState extends State<Home> {
  int indexSelected = 1;

  @override
  void initState() {
    super.initState();

    _testConnection(context);
    global.usAlerta.codigo = null;
    _getAlertCode();
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
        appBar: AppBar(
          title: Text(
            global.residente.nombre + ' ' + global.residente.familia,
            //'Darwin Cabezas',
            style: TextStyle(color: MyColors.moccasin),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: MyColors.sapphire,
          elevation: 0.0,
        ),
        body: _inicio(),
        backgroundColor: MyColors.sapphire,
      ),
    );
  }

  _cardSuperior() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          color: MyColors.sapphire,
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Center(
                child: Container(
                  child: Image(
                    image: AssetImage("assets/images/campana.png"),
                    width: 65,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Alert Now',
              style: TextStyle(
                  color: MyColors.white,
                  fontSize: TamanioTexto.subtitulo,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ));
  }

  _cardMedia() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
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
      color: MyColors.white_ligth,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: type.length,
        itemBuilder: (BuildContext context, int index) {
          final String tipo = type[index].toString();

          return GestureDetector(
            onTap: () {
              _setAlertData(null, type[index], null);
              try {
                _next(context);
              } catch (e) {}
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: MyColors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 5, top: 10, bottom: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
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
                                  color: MyColors.sapphire,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _inicio() {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        _cardSuperior(),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'Tiempo de espera',
                  style: TextStyle(
                      color: MyColors.white,
                      fontSize: TamanioTexto.subtitulo,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        _cardMedia(),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'Tipo de visita',
            style: TextStyle(
                color: MyColors.white,
                fontSize: TamanioTexto.subtitulo,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: _cardInf(),
        ),
      ],
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
                      fontSize: 40,
                      color: MyColors.sapphire,
                      fontWeight: FontWeight.bold), //Colors.white),
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                setState(() {
                  indexSelected = index;
                });
                _setAlertData(null, null, times[index]);
              },
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: MyColors.sapphire,
                child: Text(
                  times[index].toString(),
                  style: TextStyle(fontSize: 30, color: MyColors.white),
                ),
              ),
            ),
    );
  }

  _getAlertCode() {
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

            _setAlertData(codigo, null, times[indexSelected]);
          } else {
            _mostrarPopUp();
          }
        },
      );
    }
  }

  _setAlertData(String _codigo, String _tipo, String _duracion) {
    try {
      global.usAlerta.codigo =
          (_codigo != null) ? _codigo : global.usAlerta.codigo;
      global.usAlerta.tipo = (_tipo != null) ? _tipo : global.usAlerta.tipo;
      global.usAlerta.duracion =
          (_duracion != null) ? _duracion : global.usAlerta.duracion;
    } catch (e) {}
  }

  _next(context) {
    if (global.usAlerta.codigo != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => End()),
      );
    } else {
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

//REVISAR
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
            _getAlertCode();
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
          }

          if (contWaitCode > 10) {
            contWaitCode = 0;
            timer.cancel();
            pr.hide();
            _mostrarMensaje("No se pudo obtener codigo", context);
          } else {
            contWaitCode = contWaitCode + 1;
          }
        },
      ),
    );
  }
}
