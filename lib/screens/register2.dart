import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'package:residente/models/residente.dart';
import 'package:residente/screens/home.dart';
import 'package:residente/utils/localStorageDB.dart';
import 'package:residente/utils/methos.dart';

class Register2 extends StatefulWidget {
  @override
  _Register1State createState() => _Register1State();
}

final db = Firestore.instance;
final localDb = LocalDataBase();
final myController = TextEditingController();

class _Register1State extends State<Register2> {
  final myControllerNombre = TextEditingController();
  final myControllerFamilia = TextEditingController();
  final myControllerDireccion = TextEditingController();
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(child: body()),
        backgroundColor: MyColors.white_grey,
      ),
    );
  }

  Widget body() {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FractionallySizedBox(
                    widthFactor: 0.3,
                    child: Container(
                      child: Image(
                          image: AssetImage("assets/images/campana2.png")),
                    ),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    global.appName,
                    style: TextStyle(
                      color: MyColors.sapphire,
                      fontSize: TamanioTexto.logo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 25.0),

                  Text(
                    'Ya casi terminamos..',
                    style: TextStyle(
                        fontSize: TamanioTexto.titulo,
                        color: MyColors.grey30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Center(
                        child: Text(
                          'Por favor, completa los siguientes datos',
                          style: TextStyle(
                            fontSize: TamanioTexto.subtitulo,
                            color: MyColors.grey60,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.0),

                  //NOMBRE
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextField(
                        style: TextStyle(
                          fontSize: TamanioTexto.subtitulo,
                          color: MyColors.grey30,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        controller: myControllerNombre,
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
                          hintText: 'Nombre',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  //FAMILIA
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextField(
                        style: TextStyle(
                          fontSize: TamanioTexto.subtitulo,
                          color: MyColors.grey30,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        controller: myControllerFamilia,
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
                          hintText: 'Familia',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  //DIRECCION
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextField(
                        style: TextStyle(
                          fontSize: TamanioTexto.subtitulo,
                          color: MyColors.grey30,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        controller: myControllerDireccion,
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
                          hintText: 'Dirección',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
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
                    'FINALIZAR',
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
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    await pr.show();

    try {
      if (Methods.inputsCorrect(myControllerNombre.text,
          myControllerFamilia.text, myControllerDireccion.text)) {
        if (global.residente != null) {
          global.residente.nombre = myControllerNombre.text;
          global.residente.familia = myControllerFamilia.text;
          global.residente.direccion = myControllerDireccion.text;

          if (createData(Coleccion.registro_residente) != null) {
            pr.hide();
            localDb.save(Campos.cod_garita, global.residente.codGarita);
            localDb.save(Campos.cod_residente, global.residente.codResidente);
            localDb.save(Campos.direccion, global.residente.direccion);
            localDb.save(
                Campos.document_id_garita, global.residente.documentIdGarita);
            localDb.save(Campos.familia, global.residente.familia);
            localDb.save(Campos.documentId, global.residente.documentId);
            localDb.save(Campos.nombre, global.residente.nombre);

            _continuar(context);
          } else {
            pr.hide();
            _showMessage('Error generando registro', context);
          }
        } else {
          pr.hide();
          _showMessage('Error generando registro', context);
        }
      } else {
        pr.hide();
        _showMessage('Uno de los campos esta vacio.', context);
      }
    } catch (e) {
      pr.hide();
    }
  }

  _showMessage(String _mensaje, context) {
    setState(
      () {
        global.mensaje = _mensaje;
      },
    );
    return Methods.getMessage(_mensaje, context);
  }

  Future<bool> createData(String collection) async {
    DocumentReference ref = await db.collection(collection).add({
      Campos.cod_garita: global.residente.codGarita,
      Campos.cod_residente: global.residente.codResidente,
      Campos.direccion: global.residente.direccion,
      Campos.document_id_garita: global.residente.documentIdGarita,
      Campos.familia: global.residente.familia,
      Campos.documentId: global.residente.documentId,
      Campos.nombre: global.residente.nombre
    });

    if (ref.documentID != null) {
      global.residente.documentId = ref.documentID;
      _guardarDb(collection, Campos.documentId, ref.documentID, ref.documentID);

      localDb.save(Campos.document_id, ref.documentID);
      localDb.save(Campos.nombre, global.residente.nombre);
      localDb.save(
          Campos.document_id_garita, global.residente.documentIdGarita);
      localDb.save(Campos.familia, global.residente.familia);
      localDb.save(Campos.direccion, global.residente.direccion);

      return true;
    } else {
      return false;
    }
  }

  _guardarDb(
      String collection, String field, String value, String documentId) async {
    await db
        .collection(collection)
        .document(documentId)
        .updateData({field: value});
  }

  _continuar(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }
}
