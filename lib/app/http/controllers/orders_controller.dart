import 'package:backend_mobile/app/models/customers.dart';
import 'package:backend_mobile/app/models/orders.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania/vania.dart';

class OrdersController extends Controller {
  Future<Response> index() async {
    final ordersList = await Orders()
        .query()
        .join("customers", "customers.cust_id", "=", "orders.cust_id")
        .select([
      "orders.order_num",
      "orders.order_date",
      "customers.cust_name as customers_name",
      "customers.cust_address as customers_address",
      "customers.cust_city as customers_city",
      "customers.cust_state as customers_state",
      "customers.cust_zip as customers_zip",
      "customers.cust_country as customers_country",
      "customers.cust_telp as customers_telp"
    ]).get();

    return Response.json(
        {'message': 'success', 'code': 200, "data": ordersList});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_num': 'required|numeric|max_length:11',
        'order_date': 'required|date',
        'cust_id': 'required|string',
      });
      final orderNum = request.input('order_num');
      final orderDate = request.input('order_date');
      final custId = request.input('cust_id');

      final customers = await Customers()
          .query()
          .where('cust_id', '=', request.input('cust_id').toString())
          .first();

      if (customers == null) {
        return Response.json(
            {'success': false, 'message': 'data customer tidak ditemukan'},
            404);
      }
      var ordernum =
          await Orders().query().where('order_num', '=', orderNum).first();
      if (ordernum != null) {
        return Response.json({
          "message": "Data sudah ada",
          "code": 409,
        });
      }
      final orders = await Orders().query().insert(
          {"order_num": orderNum, "order_date": orderDate, "cust_id": custId});
      return Response.json({
        "message": "berhasil menambahkan data order",
        "code": 201,
        "data": orders
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        var errorMessage = e.message;
        return Response.json({"message": errorMessage, "code": 401}, 401);
      } else {
        return Response.json(
            {"message": "server error", "code": 500, "data": e}, 500);
      }
    }
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    final orders =
        await Orders().query().where('order_num', '=', id.toString()).first();
    try {
      request.validate({
        'order_num': 'required|numeric|max_length:11',
        'order_date': 'required|date',
        'cust_id': 'required|string'
      });
      final orderNum = request.input('order_num');
      final orderDate = request.input('order_date');
      final custId = request.input('cust_id');

      final customers = await Customers()
          .query()
          .where('cust_id', '=', request.input('cust_id').toString())
          .first();

      if (customers == null) {
        return Response.json(
            {'success': false, 'message': 'Vendor tidak ditemukan'}, 404);
      }

      await Orders().query().where('order_num', '=', id.toString()).update({
        "order_num": orderNum,
        "order_date": orderDate,
        "cust_id": custId,
      });

      return Response.json(
          {"message": "sukses update data order", "code": 200, "data": orders},
          200);
    } catch (e) {
      return Response.json({
        "message": "seerver error",
        "code": 500,
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    final products =
        await Orders().query().where('order_num', '=', id.toString()).first();

    if (products == null) {
      return Response.json({
        'message': 'data vendor tidak ditemukan',
        'code': 200,
        'data': products
      }, 200);
    }
    await Orders().query().where('order_num', '=', id).delete();
    return Response.json({
      'success' : true,
      'message' : 'sukses menghapus data order',
      'data': products
    });
  }
}

final OrdersController ordersController = OrdersController();
