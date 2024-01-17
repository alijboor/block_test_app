import 'package:bloc/bloc.dart';
import 'package:block_test_app/cubits/product/orders_state.dart';
import 'package:block_test_app/db/shared_helper.dart';
import 'package:block_test_app/models/product_model.dart';
import 'package:dio/dio.dart';

class ProductCubit extends Cubit<ProductState> {
  List<ProductModule> products = [];
  ProductCubit() : super(InitProductState());

  Future<void> loadData() async {
    emit(LoadingProductState());
    var res = await Dio().get('https://api.escuelajs.co/api/v1/products/');
    List data = res.data ?? [];

    if (res.statusCode == 201 || res.statusCode == 200) {
      if (data.isNotEmpty) {
        for (var e in data) {
          ProductModule item = ProductModule.fromJson(e);
          bool isFav = _checkFavItem('${item.id}');
          item.setFav = isFav;
          products.add(item);
        }
        emit(SuccessProductState());
        return;
      }
    }
    emit(EmptyProductState());
  }

  void toggleFavorite(ProductModule item) {
    String pKey = '${item.id}';

    if (item.isFavorite) {
      SharedHelper.prefs.remove(pKey);
    } else {
      SharedHelper.prefs.setInt(pKey, item.id!);
    }
    item.setFav = !item.isFavorite;
    emit(FavoriteProductState());
  }

  bool _checkFavItem(String key) {
    return SharedHelper.prefs.containsKey(key);
  }
}
