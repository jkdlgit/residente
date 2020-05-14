import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:residente/models/residente.dart';

class Methods {

  //POPUP DE ESPERA
  static getPopUp(context) {
    ProgressDialog p = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);

    p.style(
//      message: 'Downloading file...',
      message: 'Espere por favor...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      //progressWidgetAlignment: Alignment.center,
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

}
