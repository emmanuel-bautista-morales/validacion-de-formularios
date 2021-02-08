import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _crearFondo(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: screenSize.height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1),
      ])),
    );

    final circulo = Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: [
        fondoMorado,
        Positioned(
          child: circulo,
          top: 90,
          left: 30,
        ),
        Positioned(
          child: circulo,
          top: -40,
          right: -30,
        ),
        Positioned(
          child: circulo,
          bottom: -50,
          right: -10,
        ),
        Positioned(
          child: circulo,
          bottom: 70,
          right: 20,
        ),
        Container(
            padding: EdgeInsets.only(top: 80),
            child: Column(children: [
              Icon(
                Icons.person_pin_circle,
                color: Colors.white,
                size: 100,
              ),
              SizedBox(height: 10, width: double.infinity),
              Text('Login', style: TextStyle(color: Colors.white, fontSize: 25))
            ]))
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 200,
            ),
          ),
          Container(
            width: screenSize.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30),
            padding: EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      offset: Offset(0, 5),
                      spreadRadius: 3)
                ]),
            child: Column(
              children: [
                Text(
                  'Ingreso',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 60,
                ),
                _crearEmail(bloc),
                SizedBox(
                  height: 30,
                ),
                _crearPassword(bloc),
                SizedBox(
                  height: 30,
                ),
                _crearBoton(bloc)
              ],
            ),
          ),
          Text('¿Olvidó su contraseña?'),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'Ejemplo correo@ejemplo.com',
                  labelText: 'Correo electrónico',
                  counterText: snapshot.data,
                  errorText: snapshot.error,
                ),
                onChanged: (value) => bloc.changeEmail(value)));
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            child: TextField(
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: 'Contraseña',
                    errorText: snapshot.error,
                    counterText: snapshot.data),
                onChanged: (value) => bloc.changePassword(value)));
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            child: Text('Ingresar'),
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: (snapshot.hasData ? () => _login(bloc, context) : null),
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) {
    Navigator.pushReplacementNamed(context, 'home');
  }
}
