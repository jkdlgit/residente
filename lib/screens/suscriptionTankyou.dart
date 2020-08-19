//import 'dart:io';

//import 'package:align_positioned/align_positioned.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:residente/library/variables_globales.dart' as global;
import 'package:residente/models/residente.dart';
import 'package:residente/screens/home.dart';

import '../main.dart';
//import 'package:residente/screens/register2.dart';
//import 'package:residente/utils/methos.dart';

class SuscriptionTankyou extends StatefulWidget {
  @override
  _SuscriptionTankyouState createState() => _SuscriptionTankyouState();
}

final db = Firestore.instance;

class _SuscriptionTankyouState extends State<SuscriptionTankyou> {
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 35.0,
                      child: Image(image: AssetImage("assets/images/t1.png")),
                    ),
                    Container(
                      child: Container(
                        width: 50.0,
                        height: 60.0,
                        child: SizedBox(
                          width: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Container(
                        width: 80.0,
                        height: 60.0,
                        child: SizedBox(
                          width: 20.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 55.0,
                      child: Image(image: AssetImage("assets/images/t2.png")),
                    )
                  ],
                ),
                Text(
                  'Gracias!',
                  style: TextStyle(
                    color: MyColors.sapphire,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
                  child: Container(
                    child: Image(image: AssetImage("assets/images/t3.png")),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Container(
                        width: 110.0,
                        height: 60.0,
                        child: SizedBox(
                          width: 20.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 70.0,
                      child: Image(image: AssetImage("assets/images/t1.png")),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 65.0,
                      child: Image(image: AssetImage("assets/images/t4.png")),
                    ),
                    Container(
                      child: Container(
                        width: 50.0,
                        height: 60.0,
                        child: SizedBox(
                          width: 20.0,
                        ),
                      ),
                    ),
                  ],
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
                /*
                Text(
                  'Gracias! por suscribirte, estamos muy contentos y haremos nuestro mejor esfuerzo por mejorar cada día y seguir innovando.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyColors.grey60, fontSize: TamanioTexto.titulo),
                ),*/
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 5,
                    child: Text(
                      'Gracias por suscribirte, estamos muy contentos y haremos nuestro mejor esfuerzo por mejorar cada día y seguir innovando.',
                      //'Este es un texto de ejemplo, como podran ver hay palabras que se cortan en la pantalla, lo que deberia suceder es que algun widget ubique esa palabra en la siguiente linea no entiendo por que ahora si funciona correctamente y antes no funcionaba',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyColors.grey60,
                          fontSize: TamanioTexto.titulo),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
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
                    _continuar(context);
                    //_registryVerification(context);
                  },
                  child: Text(
                    'CONTINUAR',
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
/*
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
  }*/
/*
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
  }*/

  _continuar(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainHome()),
    );
  }
}
