import 'package:backend_mobile/app/models/orderitems.dart';
import 'package:backend_mobile/app/models/products.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania/vania.dart';

class OrderitemsController extends Controller {
  Future<Response> index() async {
    final orderitems = await Orderitems()
        .query()
        .join("orders", "orders.order_num", "=", "orderitems.order_nun")
        .join('customers', 'customers.cust_id', "=", 'orders.cust_id')
        .leftJoin('products', 'products.prod_id', "=", "orderitems.prod_id")
        .select([
      "orderitems.order_item",
      "orderitems.quantity",
      "orderitems.size",
      "products.prod_name as products_name",
      "products.prod_desc as products_price",
      "products.prod_desc as products_description",
      "orders.order_date as order_date",
      "customers.cust_name as customer_name",
      "customers.cust_address as customer_address",
      "customers.cust_city as customer_city",
      "customers.cust_country as customer_country",
      "customers.cust_telp as customer_telp"
    ]).get();
    return Response.json(
        {'message': 'success', 'code': 200, 'data': orderitems}, 200);
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    print(request.all());
    try {
      request.validate({
        'order_item': 'required|numeric|max_length:11',
        'order_num': 'required|numeric|max_length:11',
        'prod_id': 'required|string|max_length:10',
        'quantity': 'require|numeric|max_length:11',
        'size': 'required|numeric|max_length:11'
      });
      final orderItem = request.input('order_item');
      final orderNum = request.input('order_num');
      final prodId = request.input('prod_id');
      final quantity = request.input('quantity');
      final size = request.input('size');

      final order = await Orderitems()
          .query()
          .where('order_num', '=', request.input('order_num').toString())
          .first();

      final products = await Products()
          .query()
          .where('prod_id', '=', request.input('prod_id').toString())
          .first();

      if (products == null) {
        return Response.json(
            {'success': false, 'message': 'produk tidak ditemukan'}, 404);
      } else if (order == null) {
        return Response.json(
            {'success': false, 'message': 'Order tidak ditemukan'}, 404);
      }
      var orderitems = await Orderitems()
          .query()
          .where('order_item', '=', orderItem)
          .first();
      if (orderitems != null) {
        return Response.json({
          'message': 'Data sudah ada',
          'code': 409,
        });
      }
      final orders = await Orderitems().query().insert({
        'order_item': orderItem,
        'order_num': orderNum,
        'prod_id': prodId,
        'quantity': quantity,
        'size': size,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now()
      });
      return Response.json({
        'message': 'sukses menambahkan data order',
        'code': 201,
        'data': orders
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        var errorMessage = e.message;
        return Response.json({'message': errorMessage, 'code': 401}, 404);
      } else {
        return Response.json(
            {'message': 'server error', 'code': 500, 'data': e}, 500);
      }
    }
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, dynamic id) async {
    final orderitem = await Orderitems()
        .query()
        .where('order_item', '=', id.toString())
        .first();
    try {
      request.validate({
        'order_item': 'required|numeric|max_length:11',
        'order_num': 'required|numeric|max_length:11',
        'prod_id': 'required|string|max_length:10',
        'quantity': 'required|numeric|max_length:11',
        'size': 'required|numeric|max_length:11'
      });
      final orderItem = request.input('order_item');
      final orderNum = request.input('order_num');
      final prodId = request.input('prod_id');
      final quantity = request.input('quantity');
      final size = request.input('size');

      final order = await Orderitems()
          .query()
          .where('order_num', '=', request.input('order_num').toString())
          .first();
      final product = await Orderitems()
          .query()
          .where('prod_id', '=', request.input('prod_id').toString())
          .first();
      if (product == null) {
        return Response.json(
            {'success': false, 'message': 'produk tidak ditemukan'}, 404);
      } else if (order == null) {
        return Response.json(
            {'success': false, 'message': 'data order tidak ditemukan'}, 404);
      }
      await Orderitems()
          .query()
          .where('order_item', '=', id.toString())
          .update({
        'order_item': orderItem,
        'order_num': orderNum,
        'prod_id': prodId,
        'quantity': quantity,
        'size': size,
        'updated_at': DateTime.now()
      });
      return Response.json({
        'message': 'sukses memperbaharui data order',
        'code': 200,
        'data': orderitem
      }, 200);
    } catch (e) {
      return Response.json({'message': 'server error', 'code': 500}, 500);
    }
  }

  Future<Response> destroy(int id) async {
    final products = await Orderitems()
        .query()
        .where('order_item', '=', id.toString())
        .first();
    if (products == null) {
      return Response.json({
        'message': 'data order item tidak ditemukan',
        'code': 200,
        'data': products
      }, 200);
    }
    await Orderitems().query().where('order_item', '=', id).delete();

    return Response.json({
      'success':true,
      'message':'sukses menghapus data order item',
      'data':products
    });
  }
}

final OrderitemsController orderitemsController = OrderitemsController();
