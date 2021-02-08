import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/productos_provider.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductoModel producto = new ProductoModel();
  final productoProvider = new ProductosProvider();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
        initialValue: producto.titulo,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Producto'),
        validator: (value) {
          if (value.length < 2) {
            return 'Ingrese el nombre de producto';
          } else {
            return null;
          }
        },
        onSaved: (value) => producto.titulo = value);
  }

  Widget _crearPrecio() {
    return TextFormField(
        initialValue: producto.valor.toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: 'Producto'),
        validator: (value) {
          if (utils.isNumeric(value)) {
            return null;
          } else {
            return 'Solo numeros perrones';
          }
        },
        onSaved: (value) => producto.valor = double.parse(value));
  }

  Widget _crearBoton(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: _guardando ? null : _submit,
    );
  }

  void _submit() {
    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (producto.id != null) {
      productoProvider.editarProducto(producto);
      mostrarSnackBar('Producto actualizado');
    } else {
      productoProvider.crearProducto(producto);
      mostrarSnackBar('Producto guardado');
    }

    Navigator.pop(context);

    setState(() {
      _guardando = false;
    });
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) {
        setState(() {
          producto.disponible = value;
        });
      },
    );
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      behavior: SnackBarBehavior.floating,
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return Container();
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300,
        fit: BoxFit.cover,
      );
    }
  }

  void _seleccionarFoto() async {
    final pciker = ImagePicker();

    final pickedFile = await pciker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        foto = File(pickedFile.path);
      } else {
        mostrarSnackBar('No seleccionó ninguna imagen');
      }
    });
  }

  void _tomarFoto() async {
    final pciker = ImagePicker();

    final pickedFile = await pciker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        foto = File(pickedFile.path);
      } else {
        mostrarSnackBar('No seleccionó ninguna imagen');
      }
    });
  }
}
