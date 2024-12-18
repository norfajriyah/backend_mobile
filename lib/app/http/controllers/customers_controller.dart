import 'package:backend_mobile/app/models/customers.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania/vania.dart';

class CustomersController extends Controller {
  Future<Response> index() async {
    final customerList = await Customers().query().get();
    return Response.json(
        {'message': 'sucess', 'code': 200, 'data': customerList});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'cust_id': 'required|max_length:50',
        'cust_name': 'required|string|max_length:50',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_telp': 'required|string|max_length:15'
      });
      final custId = request.input('cust_id');
      final custName = request.input('cust_name');
      final custAddress = request.input('cust_address');
      final cutsCity = request.input('cust_city');
      final custState = request.input('cust_state');
      final custZip = request.input('cust_zip');
      final custCountry = request.input('cust_country');
      final custTelp = request.input('cust_telp');
      var custID =
          await Customers().query().where('cust_id', '=', custId).first();
      if (custId != null) {
        return Response.json({
          "message": "Data sudah ada",
          "code": 409,
        });
      }
      final customers = await Customers().query().insert({
        "cust_id": custID,
        "cust_name": custName,
        "cust_address": custAddress,
        "cust_city": cutsCity,
        "cust_state": custState,
        "cust_zip": custZip,
        "cust_country": custCountry,
        "cust_telp": custTelp
      });
      return Response.json({
        "message": "sukses menambahkan data customer",
        "code": 201,
        "data": customers
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        var errorMessage = e.message;
        return Response.json({"message": errorMessage, "Code": 401}, 401);
      } else {
        return Response.json(
            {"message": "server error", "code": 500, "data": e}, 500);
      }
    }
  }

  Future<Response> show(int id) async {
    final customers =
        await Customers().query().where('cust_id', '=', id.toString()).first();
    if (customers == null) {
      return Response.json({
        "message": "Data customer tidak ditemukan",
        "code": 404,
      }, 404);
    }
    return Response.json({
      'message': 'data customer tidak ditemukan',
      'code': 200,
      'data': customers
    });
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, dynamic id) async {
    final customers =
        await Customers().query().where('cust_id', '=', id.toString()).first();
    try {
      request.validate({
        'cust_id': 'required|maxt_length:5',
        'cust_name': 'required|string|max_length:50',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_telp': 'required|string|max_length:15'
      });
      final custId = request.input('cust_id');
      final custName = request.input('cust_name');
      final custAddress = request.input('cust_address');
      final custCity = request.input('cust_city');
      final custState = request.input('cust_state');
      final custZip = request.input('cust_zip');
      final custCountry = request.input('cust_country');
      final custTelp = request.input('cust_telp');
      var custID =
          await Customers().query().where('cust_id', '=', custId).first();

      await Customers().query().insert({
        'cust_id': custID,
        "cust_name": custName,
        "cust_address": custAddress,
        "cust_city": custCity,
        "cust_state": custState,
        "cust_zip": custZip,
        "cust_country": custCountry,
        "cust_telp": custTelp,
      });
      return Response.json({
        "message": "sukses perbaharui data customer",
        "code": 200,
        "data": customers
      }, 200);
    } catch (e) {
      return Response.json({
        "message": "server error",
        "code": 500,
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    final customers =
        await Customers().query().where('cust_id', '=', id.toString()).first();
    if (customers == null) {
      return Response.json({
        'message': "data customer tidak ditemukan",
        'code': 200,
        'data': customers
      }, 200);
    }
    await Customers().query().where('cust_id', '=', id).delete();
    return Response.json({
      'success': true,
      'message': 'berhasil menghapus data customer',
      'data': customers
    });
  }
}

final CustomersController customersController = CustomersController();
