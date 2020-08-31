import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:residente/models/residente.dart';

class Methods {
  static final db = Firestore.instance;
  //POPUP DE ESPERA
  static getPopUp(context) {
    ProgressDialog p = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);

    p.style(
      message: 'Espere por favor...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return p;
  }

  static getMessage(String _mensaje, context) {
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

  static bool inputsCorrect(_name, _lastName, address) {
    String name = _name.trim();
    String lasName = _lastName.trim();
    String addres = address.trim();
    if (name.length > 0 && lasName.length > 0 && addres.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  static bool alertCodeValidate(code) {
    if (code != null) {
      if (int.parse(code) > 0) {
        return true;
      }
    }
    return false;
  }

  static guardarLogCloudStore(
      String _archivo, String _metodo, String _error) async {
    var fecha_hora = new DateTime.now();
    String trama = ('$fecha_hora|$_archivo|$_metodo|$_error');
    DocumentReference ref = await db
        .collection('log')
        .document('residente')
        .collection('error')
        .add({
      'trama': trama,
    });
  }
}
