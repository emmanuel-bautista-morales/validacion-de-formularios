import 'dart:convert';

import 'package:form_validation/src/models/producto_model.dart';
import 'package:http/http.dart' as http;

class ProductosProvider {
  final String _url = 'https://flutter-90648-default-rtdb.firebaseio.com/';

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';

    final res = await http.post(url, body: productoModelToJson(producto));
    final decodedData = json.decode(res.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json';
    final resp = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();
    if (decodedData == null) return [];

    decodedData.forEach((id, producto) {
      final temp = ProductoModel.fromJson(producto);
      temp.id = id;
      productos.add(temp);
    });
    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json';
    final resp = await http.delete(url);
    print(resp);

    return 1;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json';

    final res = await http.put(url, body: productoModelToJson(producto));
    final decodedData = json.decode(res.body);

    // print(decodedData);

    return true;
  }
}
