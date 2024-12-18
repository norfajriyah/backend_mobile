import 'package:backend_mobile/app/models/vendors.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania/vania.dart';

class VendorsController extends Controller {
  Future<Response> index() async {
    final vendor = await Vendors().query().get();

    return Response.json(
        {'message': 'success', 'code': 200, 'data': vendor}, 200);
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    print(request.all());
    try {
      request.validate({
        'vend_id': 'required|max_length:5',
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'required|string|max_length:50',
        'vend_kota': 'required|string|mas_length:20',
        'vend_zip': 'required|string|max_length:7',
        'vend_country': 'required|string|max_length:25',
      });
      final vendId = request.input('vend_id');
      final vendName = request.input('vend_name');
      final vendAddress = request.input('vend_address');
      final vendKota = request.input('vend_city');
      final vendState = request.input('vend_state');
      final vendZip = request.input('vend_zip');
      final vendCountry = request.input('vend_country');
      var vendID =
          await Vendors().query().where('vend_id', '=', vendId).first();
      if (vendID != null) {
        return Response.json({'message': 'Data sudah ada', 'code': 409});
      }
      final vendors = await Vendors().query().insert({
        'vend_id': vendId,
        'vend_name': vendName,
        'vend_address': vendAddress,
        'vend_kota': vendKota,
        'vend_state': vendState,
        'vend_zip': vendZip,
        'vend_country': vendCountry,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now()
      });
      return Response.json({
        'message': 'Berhasil menambahkan data vendor',
        'code': 201,
        'data': vendors
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        var errorMessage = e.message;
        return Response.json({'message': errorMessage, 'code': 401}, 401);
      } else {
        return Response.json(
            {'message': 'server error', 'code': 500, 'data': e}, 500);
      }
    }
  }

  Future<Response> show(int id) async {
    final vendors =
        await Vendors().query().where('vend_id', '=', id.toString()).first();
    return Response.json({
      'message': 'Data vendor berhasil ditemukan',
      'code': 200,
      'data': vendors
    }, 200);
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, dynamic id) async {
    final vendors =
        await Vendors().query().where('vend_id', '=', id.toString()).first();
    try {
      request.validate({
        'vend_id': 'required|max_length:5',
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'required|string|max_length:50',
        'vend_kota': 'required|string|mas_length:20',
        'vend_zip': 'required|string|max_length:7',
        'vend_country': 'required|string|max_length:25',
      });
      final vendId = request.input('vend_id');
      final vendName = request.input('vend_name');
      final vendAddress = request.input('vend_address');
      final vendKota = request.input('vend_city');
      final vendState = request.input('vend_state');
      final vendZip = request.input('vend_zip');
      final vendCountry = request.input('vend_country');

      await Vendors().query().where('vend_id', '=', id.toString()).update({
        'vend_id': vendId,
        'vend_name': vendName,
        'vend_address': vendAddress,
        'vend_kota': vendKota,
        'vend_state': vendState,
        'vend_zip': vendZip,
        'vend_country': vendCountry,
        'updated_at': DateTime.now()
      });

      return Response.json({
        'message': 'Berhasil memperbaharui data vendor',
        'code': 200,
        'data': vendors
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'server error',
        'code': 500,
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    final vendors =
        await Vendors().query().where('vend_id', '=', id.toString()).first();
    if (vendors == null) {
      return Response.json({
        'message': 'data vendor tidak ditemukan',
        'code': 200,
        'data': vendors
      }, 200);
    }
    await Vendors().query().where('vend_id', '=', id).delete();
    return Response.json({
      'success':true,
      'message': 'berhasil menghapus data vendor',
      'data':vendors
    });
  }
}

final VendorsController vendorsController = VendorsController();
