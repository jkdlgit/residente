import 'package:flutter/material.dart';
import 'package:residente/models/residente.dart';
import 'package:residente/screens/register1.dart';

class Start extends StatelessWidget {
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
              child: Column(
                children: <Widget>[
                  Text(
                    'Alert Now',
                    style: TextStyle(
                      color: MyColors.moccasin,
                      fontSize: 22.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 40,
                    child: Center(
                      child: Text(
                        'La innovación distingue a los líderes de los seguidores.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: MyColors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.3,
                      heightFactor: 0.3,
                      child: Container(
                        child:
                            Image(image: AssetImage("assets/images/campana.png")),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: Container(
                width: Posiciones.getBottomButtonSize(context),
                height: 50.0,
                child: FlatButton(
                  color: MyColors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register1()),
                    );
                  },
                  child: Text(
                    'CONTINUAR',
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
