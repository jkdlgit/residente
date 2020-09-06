import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:residente/models/residente.dart';
import 'package:residente/screens/register1.dart';

class AdvertenciaTest extends StatefulWidget {
  @override
  _AdvertenciaTestState createState() => _AdvertenciaTestState();
}

class _AdvertenciaTestState extends State<AdvertenciaTest> {
  bool hasConnection = false;
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Text(
                      'Gracias por ayudarnos probando alert, este aún está en ' +
                          'su estado más básico; así que te pedimos por favor lo ' +
                          'uses responsablemente, de esta manera podremos obtener ' +
                          'información valiosa para mejorarlo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, color: MyColors.grey60),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                width: Posiciones.getBottomButtonSize(context),
                height: 50.0,
                child: FlatButton(
                  color: MyColors.sapphire,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register1()),
                    );
                  },
                  child: Text(
                    'DE ACUERDO',
                    style: TextStyle(letterSpacing: 1.5, color: MyColors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(22.0),
                    side: BorderSide(color: MyColors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: Posiciones.separacion_inferior_boton)
          ],
        ),
        backgroundColor: MyColors.white,
      ),
    );
  }
}
