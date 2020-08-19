import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:residente/main.dart';
import 'package:residente/models/residenteModel.dart';
import 'package:residente/utils/metodosGenerales.dart';

class SinConexionScreen extends StatefulWidget {
  @override
  _SinConexionScreenState createState() => _SinConexionScreenState();
}

class _SinConexionScreenState extends State<SinConexionScreen> {
  bool tieneConexion = false;
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
                children: <Widget>[
                  Text(
                    'Alert',
                    style: TextStyle(
                      color: MyColors.grey30,
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
                        'Por favor, revisa tu conexión a internet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: MyColors.grey60),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.3,
                      heightFactor: 0.3,
                      child: Container(
                        child: Image(
                            image: AssetImage("assets/images/nowifi.png")),
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
                  color: MyColors.sapphire,
                  onPressed: () {
                    _probarConexion(context);
                  },
                  child: Text(
                    'REINTENTAR',
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

  _probarConexion(context) async {
    pr = MetodosGenerales.obtenerPopUp(context);
    await pr.show();

    tieneConexion = await DataConnectionChecker().hasConnection;

    if (tieneConexion) {
      pr.hide();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainHome()),
      );
    } else {
      pr.hide();
      _mostrarMensaje("No tienes conexión a internet.", context);
    }
  }

  _mostrarMensaje(String _mensaje, context) {
    setState(() {
      global.mensaje = _mensaje;
    });
    return MetodosGenerales.obtenerMensaje(_mensaje, context);
  }
}
