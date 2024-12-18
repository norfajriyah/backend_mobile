import 'package:backend_mobile/app/models/products.dart';
import 'package:backend_mobile/app/models/vendors.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania/vania.dart';

class ProductsController extends Controller {
  Future<Response> index() async {
    final product = Products()
        .query()
        .join('vendors', 'vendors.vend_id', '=', 'products.vend_id')
        .leftJoin(
            'productnotes', 'productnotes.note_id', '=', 'products.prod_id')
        .select([
      'products.prod_id',
      'products.prod_name',
      'products.prod_price',
      'products.prod_desc',
      'vendors.vend_name as vendor_name',
      'productnotes.note_text as product_note',
      'productnotes.note_date as note_date'
    ]).get();
    return Response.json({'message': 'success', 'code': 200, 'data': product});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'prod_id': 'required|max_length:10',
        'vend_id': 'required|string|max_length:50',
        'prod_name': 'required|string|max_length:50',
        'prod_price': 'required|string|max_length:20',
        'prod_desc': 'required|string|max_length:5'
      });
      final prodId = request.input('prod_id');
      final vendId = request.input('vend_id');
      final prodName = request.input('prod_name');
      final prodPrice = request.input('prod_price');
      final prodDesc = request.input('prod_desc');

      final vendor = await Vendors()
          .query()
          .where('vend_id', '=', request.input('vend_id').toString())
          .first();
      if (vendor == null) {
        return Response.json(
            {'success': false, 'message': 'Data vendor tidak ditemukan'}, 404);
      }
      var prodID =
          await Products().query().where('prod_id', '=', prodId).first();
      if (prodID != null) {
        return Response.json({
          'message': 'Data sudah ada',
          'code': 409,
        });
      }
      final product = await Products().query().insert({
        'prod_id': prodId,
        'vend_id': vendId,
        'prod_name': prodName,
        'prod_price': prodPrice,
        'prod_desc': prodDesc,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now()
      });
      return Response.json({
        'message': 'sukses menambahkan data produk',
        'code': 201,
        'data': product
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        var errorMesssage = e.message;
        return Response.json(
            {'message': errorMesssage, 'code': 401, 'data': e}, 401);
      } else {
        return Response.json(
            {'message': 'server error', 'code': 500, 'data': e}, 500);
      }
    }
  }

  Future<Response> show(int id) async {
    final product =
        await Products().query().where('prod_id', '=', id.toString()).first();
    return Response.json(
        {'message': 'Data produk ditemukan', 'code': 200, 'data': product},
        200);
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, dynamic id) async {
    final product =
        await Products().query().where('prod_id', '=', id.toString()).first();
    try {
      request.validate({
        'prod_id': 'required|max_length:10',
        'vend_id': 'required|string|max_length:50',
        'prod_name': 'required|string|max_length:50',
        'prod_price': 'required|striing|max_length:20',
        'prod_desc': 'required|string|max_length:5'
      });
      final prodId = request.input('prod_id');
      final vendId = request.input('vend_id');
      final prodName = request.input('prod_name');
      final prodPrice = request.input('prod_price');
      final prodDesc = request.input('prod_desc');

      final vendor = await Vendors()
          .query()
          .where('vend_id', '=', request.input('vend_id').toString())
          .first();
      if (vendor == null) {
        return Response.json(
            {'success': false, 'message': 'data vendor tidak ditemukan'}, 404);
      }
      await Products().query().where('prod_id', '=', id.toString()).update({
        'prod_id': prodId,
        'vend_id': vendId,
        'prod_name': prodName,
        'prod_price': prodPrice,
        'prod_desc': prodDesc,
        'updated_at': DateTime.now()
      });
      return Response.json({
        'message': 'sukses memperbarui data produk',
        'code': 200,
        'data': product
      });
    } catch (e) {
      return Response.json({'message': 'serever error', 'code': 500}, 500);
    }
  }

  Future<Response> destroy(int id) async {
    final product =
        Products().query().where('prod_id', '=', id.toString()).first();

    if (product == null) {
      return Response.json({
        'message': 'Data produk tidak ditemukan',
        'code': 200,
        'data': product
      }, 200);
    }
    await Products().query().where('prod_id', '=', id).delete();
    return Response.json({
      'success': true,
      'message': 'Berhasil menghapus data produk',
      'data': product
    });
  }
}

final ProductsController productsController = ProductsController();
