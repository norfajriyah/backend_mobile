import 'package:backend_mobile/app/http/controllers/customers_controller.dart';
import 'package:backend_mobile/app/http/controllers/orderitems_controller.dart';
import 'package:backend_mobile/app/http/controllers/orders_controller.dart';
import 'package:backend_mobile/app/http/controllers/productnotes_controller.dart';
import 'package:backend_mobile/app/http/controllers/products_controller.dart';
import 'package:backend_mobile/app/http/controllers/vendors_controller.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.resource("customers", customersController);
    Router.resource("orders", ordersController);
    Router.resource("orderitems", orderitemsController);
    Router.resource("products", productsController);
    Router.resource("productnotes", productnotesController);
    Router.resource("vendors", vendorsController);
  }
}
