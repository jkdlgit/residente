import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'package:residente/models/residenteModel.dart';
import 'package:residente/screens/InicioScreen.dart';
import 'package:residente/utils/localStorageDB.dart';
import 'package:residente/utils/metodosGenerales.dart';

class RegistroDatos extends StatefulWidget {
  @override
  _RegistroDatosState createState() => _RegistroDatosState();
}

final fireStore = Firestore.instance;
final baseLocal = BaseDatosLocal();
final controladorTexto = TextEditingController();

class _RegistroDatosState extends State<RegistroDatos> {
  final controladorTextoNombre = TextEditingController();
  final controladorTextoFamilia = TextEditingController();
  final controladorTextoDireccion = TextEditingController();
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
                    global.nombreApp,
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
                        controller: controladorTextoNombre,
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
                        controller: controladorTextoFamilia,
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
                        controller: controladorTextoDireccion,
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
                    generarRegistro(context);
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

  generarRegistro(context) async {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    await pr.show();

    try {
      if (MetodosGenerales.camposCorrectos(controladorTextoNombre.text,
          controladorTextoFamilia.text, controladorTextoDireccion.text)) {
        if (global.residente != null) {
          global.residente.nombre = controladorTextoNombre.text;
          global.residente.familia = controladorTextoFamilia.text;
          global.residente.direccion = controladorTextoDireccion.text;

          if (guardarDatosLocalYFirestore(Coleccion.registro_residente) !=
              null) {
            pr.hide();
            baseLocal.guardar(Campos.cod_garita, global.residente.codGarita);
            baseLocal.guardar(
                Campos.cod_residente, global.residente.codResidente);
            baseLocal.guardar(Campos.direccion, global.residente.direccion);
            baseLocal.guardar(
                Campos.document_id_garita, global.residente.documentIdGarita);
            baseLocal.guardar(Campos.familia, global.residente.familia);
            baseLocal.guardar(Campos.documentId, global.residente.documentId);
            baseLocal.guardar(Campos.nombre, global.residente.nombre);

            _continuar(context);
          } else {
            pr.hide();
            _mostrarMensaje('Error generando registro', context);
          }
        } else {
          pr.hide();
          _mostrarMensaje('Error generando registro', context);
        }
      } else {
        pr.hide();
        _mostrarMensaje('Uno de los campos esta vacio.', context);
      }
    } catch (e) {
      pr.hide();
    }
  }

  _mostrarMensaje(String _mensaje, context) {
    setState(
      () {
        global.mensaje = _mensaje;
      },
    );
    return MetodosGenerales.obtenerMensaje(_mensaje, context);
  }

  Future<bool> guardarDatosLocalYFirestore(String collection) async {
    DocumentReference ref = await fireStore.collection(collection).add({
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
      await fireStore
          .collection(collection)
          .document(ref.documentID)
          .updateData({Campos.documentId: ref.documentID});

      //_guardarDb(collection, Campos.documentId, ref.documentID, ref.documentID);

      baseLocal.guardar(Campos.document_id, ref.documentID);
      baseLocal.guardar(Campos.nombre, global.residente.nombre);
      baseLocal.guardar(
          Campos.document_id_garita, global.residente.documentIdGarita);
      baseLocal.guardar(Campos.familia, global.residente.familia);
      baseLocal.guardar(Campos.direccion, global.residente.direccion);

      return true;
    } else {
      return false;
    }
  }

  /*_guardarDb(String collection, String field, String value, String documentId) async {
    await fireStore
        .collection(collection)
        .document(documentId)
        .updateData({field: value});
  }*/

  _continuar(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }
}
