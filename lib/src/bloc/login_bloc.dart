import 'dart:async';
import 'package:form_validation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // recuperar los datos el stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (a, b) => true);

  // insertar valores al email
  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  // obtener el ultmo valor ingreaso a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}

// static LoginBloc of ( BuildContext context ){
//    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
// }

// Stream<bool> get formValidStream =>
//        Rx.combineLatest2(emailStream, passwStream, (e, p) => true);
