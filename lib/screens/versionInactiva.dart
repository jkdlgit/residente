import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:residente/models/residente.dart';

class VersionInactiva extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.sapphire,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width - 40,
                child: Center(
                  child: Text(
                    'Esta versión no esta disponible, por favor actualiza alert para seguir usándola.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: MyColors.white),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: Posiciones.getBottomButtonSize(context),
                height: 50.0,
                child: FlatButton(
                  color: MyColors.white,
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text(
                    'SALIR',
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
            SizedBox(height: Posiciones.separacion_inferior_boton)
          ],
        ),
        backgroundColor: MyColors.sapphire,
      ),
    );
  }
}
