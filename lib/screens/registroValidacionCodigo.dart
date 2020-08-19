import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'package:residente/models/residenteModel.dart';
import 'package:residente/screens/registroDatos.dart';
import 'package:residente/utils/metodosGenerales.dart';

class RegistroValidacionCodigo extends StatefulWidget {
  @override
  _RegistroValidacionCodigoState createState() =>
      _RegistroValidacionCodigoState();
}

final fireStore = Firestore.instance;

class _RegistroValidacionCodigoState extends State<RegistroValidacionCodigo> {
  final controladorText = TextEditingController();
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
                      height: 35.0,
                      child:
                          Image(image: AssetImage("assets/images/reloj.png")),
                    )
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Container(
                        width: 50.0,
                        height: 15.0,
                        child: SizedBox(
                          width: 20.0,
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
                    child:
                        Image(image: AssetImage("assets/images/campana2.png")),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  global.nombreApp,
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
                  '¿Cual es tu código?',
                  style: TextStyle(
                    color: MyColors.grey30,
                    fontSize: TamanioTexto.titulo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Text(
                    'Para emitir alertas necesitas verificar el código de tu ciudadela',
                    style: TextStyle(
                        color: MyColors.grey60,
                        fontSize: TamanioTexto.subtitulo),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: TextField(
                      style: TextStyle(
                        fontSize: TamanioTexto.subtitulo,
                        color: MyColors.grey30,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      controller: controladorText,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide:
                              BorderSide(width: 1, color: MyColors.sapphire),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide:
                              BorderSide(width: 1, color: MyColors.grey60),
                        ),
                        hintText: 'Código de ciudadela',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                    _verificarGenerarGuardarCodigo(context);
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

  _verificarGenerarGuardarCodigo(context) async {
    pr = MetodosGenerales.obtenerPopUp(context);
    await pr.show();
    try {
      if (controladorText.text.length > 0) {
        var userQuery = fireStore
            .collection(Coleccion.registro_garita)
            .where(Campos.cod_garita, isEqualTo: controladorText.text)
            .limit(1);

        userQuery.getDocuments().then((garita) {
          if (garita.documents.length > 0) {
            DocumentSnapshot garitaSnap = garita.documents[0];
            String documentIdGarita = garitaSnap.documentID;

            int generador = garitaSnap[Campos.generador_residente] != null
                ? int.parse(garitaSnap[Campos.generador_residente].toString())
                : 0;

            if (generador != 0) {
              _guardarFireStore(
                  Coleccion.registro_garita,
                  Campos.generador_residente,
                  (generador + 1).toString(),
                  documentIdGarita);

              ResidenteModel residente = new ResidenteModel();
              residente.codGarita = garitaSnap['cod_garita'];
              residente.codResidente = generador.toString();
              residente.documentIdGarita = documentIdGarita;
              global.residente = residente;

              pr.hide();
              _continuar(context);
            } else {
              pr.hide();
              _mostratMensaje(
                  'Error generando registro, por favor vuela a intentarlo.',
                  context);
            }
          } else {
            pr.hide();
            _mostratMensaje('El código no existe.', context);
          }
        });
      } else {
        pr.hide();
        _mostratMensaje('El campo esta vacio.', context);
      }
    } catch (e) {
      pr.hide();
    }
  }

  _guardarFireStore(
      String collection, String field, String value, String documentId) async {
    await fireStore
        .collection(collection)
        .document(documentId)
        .updateData({field: value});
  }

  _mostratMensaje(String _mensaje, context) {
    setState(() {
      global.mensaje = _mensaje;
    });
    return MetodosGenerales.obtenerMensaje(_mensaje, context);
  }

  _continuar(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistroDatos()),
    );
  }
}
