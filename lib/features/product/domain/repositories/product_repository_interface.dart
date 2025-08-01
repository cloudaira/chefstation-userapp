import 'package:chefstation_multivendor/common/enums/data_source_enum.dart';
import 'package:chefstation_multivendor/common/models/product_model.dart';
import 'package:chefstation_multivendor/interface/repository_interface.dart';

abstract class ProductRepositoryInterface implements RepositoryInterface {

  @override
  Future<List<Product>?> getList({int? offset, String? type, DataSourceEnum? source});

  @override
  Future<Product?> get(String? id, {bool isCampaign = false});
}
