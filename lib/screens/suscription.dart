import 'dart:io';

import 'package:align_positioned/align_positioned.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'package:residente/models/residente.dart';
import 'package:residente/screens/register2.dart';
import 'package:residente/utils/methos.dart';

class Suscription extends StatefulWidget {
  @override
  _SuscriptionState createState() => _SuscriptionState();
}

final db = Firestore.instance;

class _SuscriptionState extends State<Suscription> {
  final myController = TextEditingController();
  ProgressDialog pr;

  bool codeState = true;

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: SafeArea(child: body(context)),
        backgroundColor: MyColors.white_grey,
      ),
    );
  }

  Widget body(context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Container(
                        width: 50.0,
                        height: 60.0,
                        child: SizedBox(
                          width: 20.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 45.0,
                      child:
                          Image(image: AssetImage("assets/images/reloj.png")),
                    )
                  ],
                ),
                Text(
                  'Suscribete Hoy',
                  style: TextStyle(
                    color: MyColors.sapphire,
                    fontSize: TamanioTexto.logo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ayudanos a innovar',
                  style: TextStyle(
                    color: MyColors.grey30,
                    fontSize: TamanioTexto.texto_pequenio,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Container(
                        width: 60.0,
                        height: 15.0,
                        child: SizedBox(
                          width: 30.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 25.0,
                      child:
                          Image(image: AssetImage("assets/images/directo.png")),
                    )
                  ],
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
                  child: Container(
                    child: Image(image: AssetImage("assets/images/caja.png")),
                  ),
                ),
                /*        AlignPositioned(
                    child:
                        Image(image: AssetImage("assets/images/directo.png")),
                    alignment: Alignment.topLeft,
                    touch: Touch.inside,
                    dx: 15.0, // Move 4 pixels to the right.
                    moveByChildWidth:
                        -0.5, // Move half child width to the left.
                    moveByChildHeight: -0.5),
/**/ */
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Container(
                        width: 0,
                        height: 15.0,
                      ),
                    ),
                    Container(
                      height: 100.0,
                      child:
                          Image(image: AssetImage("assets/images/directo.png")),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '', //global.appName,
                  style: TextStyle(
                    color: MyColors.sapphire,
                    fontSize: TamanioTexto.logo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 45.0,
                ),
                Text(
                  '\$ 0,99 / mes',
                  style: TextStyle(
                    color: MyColors.sapphire,
                    fontSize: TamanioTexto.logo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 80,
                  child: Text(
                    'Emite alertas libremente y se participe de futuras mejoras en la App.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: MyColors.grey60,
                        fontSize: TamanioTexto.subtitulo),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                SizedBox(
                  height: 30.0,
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
                  color: MyColors.sapphire,
                  onPressed: () {
                    _registryVerification(context);
                  },
                  child: Text(
                    'SUSCRIBIRME',
                    style: TextStyle(letterSpacing: 1.5, color: MyColors.white),
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
        )
      ],
    );
  }

  _registryVerification(context) async {
    pr = Methods.getPopUp(context);
    await pr.show();
    try {
      if (myController.text.length > 0) {
        var userQuery = db
            .collection(Coleccion.registro_garita)
            .where(Campos.cod_garita, isEqualTo: myController.text)
            .limit(1);

        userQuery.getDocuments().then((garita) {
          if (garita.documents.length > 0) {
            DocumentSnapshot garitaSnap = garita.documents[0];
            String documentIdGarita = garitaSnap.documentID;

            int generador = garitaSnap[Campos.generador_residente] != null
                ? int.parse(garitaSnap[Campos.generador_residente].toString())
                : 0;

            if (generador != 0) {
              _guardarDb(Coleccion.registro_garita, Campos.generador_residente,
                  (generador + 1).toString(), documentIdGarita);

              Residente residente = new Residente();
              residente.codGarita = garitaSnap['cod_garita'];
              residente.codResidente = generador.toString();
              residente.documentIdGarita = documentIdGarita;
              global.residente = residente;

              pr.hide();
              _continuar(context);
            } else {
              pr.hide();
              _showMessage(
                  'Error generando registro, por favor vuela a intentarlo.',
                  context);
            }
          } else {
            pr.hide();
            _showMessage('El código no existe.', context);
          }
        });
      } else {
        pr.hide();
        _showMessage('El campo esta vacio.', context);
      }
    } catch (e) {
      pr.hide();
    }
  }

  _guardarDb(
      String collection, String field, String value, String documentId) async {
    await db
        .collection(collection)
        .document(documentId)
        .updateData({field: value});
  }

  _showMessage(String _mensaje, context) {
    setState(() {
      global.mensaje = _mensaje;
    });
    return Methods.getMessage(_mensaje, context);
  }

  _continuar(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register2()),
    );
  }
}