import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'package:residente/models/residenteModel.dart';
import 'dart:async';
import 'package:residente/screens/InicioScreen.dart';
import 'package:residente/utils/metodosGenerales.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Fin extends StatefulWidget {
  @override
  _FinState createState() => _FinState();
}

final fireStore = Firestore.instance;
bool alertaEnviada = false;
bool datosEnvioCorrecto = false;

class _FinState extends State<Fin> {
  Timer _timer;
  int _start = 10;
  @override
  void initState() {
    super.initState();
    alertaEnviada = false;
    iniciarReloj();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        body: _body(context),
        backgroundColor: MyColors.sapphire,
      ),
    );
  }

  _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: new LinearPercentIndicator(
              animation: true,
              lineHeight: 4.0,
              animationDuration: 10000,
              percent: 1.0,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: MyColors.tory_blue),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Alerta lista!',
                style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: TamanioTexto.subtitulo,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Envia la alerta antes que esta se cancele.',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: TamanioTexto.texto_pequenio,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  global.usAlerta.codigo,
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: MyColors.moccasin),
                ),
                Text(
                  'Comparte este código  ',
                  style: TextStyle(
                      fontSize: TamanioTexto.subtitulo,
                      color: Colors.grey[400]),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Tipo Visita:  ',
                      style: TextStyle(
                          fontSize: TamanioTexto.subtitulo,
                          color: Colors.grey[300]),
                    ),
                    Text(
                      global.usAlerta.tipo,
                      style: TextStyle(
                          fontSize: TamanioTexto.subtitulo,
                          color: Colors.grey[300]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Builder(
            builder: (context) => Center(
              child: Container(
                width: Posiciones.getBottomButtonSize(context),
                height: 50.0,
                child: FlatButton(
                  color: MyColors.white,
                  onPressed: () {
                    if (!alertaEnviada) {
                      (_timer != null) ? _timer.cancel() : SizedBox.shrink();
                      crearDatosAlertaFireStore();
                      if (datosEnvioCorrecto) {
                        _mostrarPopUp(context, true);
                        alertaEnviada = true;
                      } else {
                        _mostrarPopUp(context, false);
                        alertaEnviada = false;
                      }
                    } else {
                      null;
                    }
                  },
                  child: Text(
                    'ENVIAR',
                    style:
                        TextStyle(letterSpacing: 1.5, color: MyColors.sapphire),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(22.0),
                    side: BorderSide(color: MyColors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: Posiciones.separacion_inferior_boton,
        ),
      ],
    );
  }

  void iniciarReloj() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            Navigator.pop(context);
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  crearDatosAlertaFireStore() async {
    if (MetodosGenerales.validarCodigoAlerta(global.usAlerta.codigo)) {
      datosEnvioCorrecto = true;
      DocumentReference ref = await fireStore
          .collection(Coleccion.registro_garita)
          .document(global.residente.documentIdGarita)
          .collection(Coleccion.alerta)
          .add(
        {
          Campos.codigo: global.usAlerta.codigo,
          Campos.tipo: global.usAlerta.tipo,
          Campos.direccion: global.residente.direccion,
          Campos.familia: global.residente.familia,
          Campos.duracion: global.usAlerta.duracion,
          Campos.documentId: global.residente.documentId,
        },
      );

      DocumentReference ref1 = await fireStore
          .collection(Coleccion.registro_residente)
          .document(global.residente.documentId)
          .collection(Coleccion.alerta)
          .add(
        {
          Campos.codigo: global.usAlerta.codigo,
          Campos.tipo: global.usAlerta.tipo,
          Campos.direccion: global.residente.direccion,
          Campos.familia: global.residente.familia,
          Campos.duracion: global.usAlerta.duracion,
        },
      );
    } else {
      datosEnvioCorrecto = false;
    }
  }

  _mostrarPopUp(context, _estadoEnvio) {
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
        color: (_estadoEnvio) ? MyColors.sapphire : Colors.red,
      ),
    );
    return Alert(
      style: alertStyle,
      context: context,
      type: AlertType.success,
      title: (_estadoEnvio) ? "ALERTA ENVIADA" : "ALERTNA NO ENVIADA",
      buttons: [
        DialogButton(
          child: Text(
            (_estadoEnvio) ? "Inicio" : "Reintentar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
          color: (_estadoEnvio) ? MyColors.sapphire : Colors.red,
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
}
