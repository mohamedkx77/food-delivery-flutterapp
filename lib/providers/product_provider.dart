import 'package:delivery_food/models/product_model.dart';
import 'package:delivery_food/network/apis.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../locator.dart';

class ProductProvider with ChangeNotifier {
  Api _api = locator<Api>();
  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  // ProductModel findById(String id) =>
  //     _products.firstWhere((prod) => prod.id == id);

  Future<List<ProductModel>> fetchProducts()async {
    var response  = await _api.getDataCollection();
    _products = response.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
    return _products;
  }


  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _api.streamDataCollection();
  }

  Future<ProductModel> getProductById(String id)async{
    var doc = await _api.getDocById(id);
    return ProductModel.fromMap(doc.data(),doc.id);
  }


  Future addProduct(ProductModel productModel) async {
    try {
      await _api.addDoc(productModel.toJson());
      notifyListeners();
      return ;
    } catch (error) {
      throw error;
    }
  }

  Future updateProduct(ProductModel newProd , String id) async {
    await _api.updateDoc(newProd.toJson(), id);
  }

  Future deleteProduct(String id) async {
    await _api.removeDoc(id);
    notifyListeners();
    return ;
  }
}
