import 'package:backend_mobile/app/models/producnotes.dart';
import 'package:backend_mobile/app/models/products.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania/vania.dart';

class ProductnotesController extends Controller {
  Future<Response> index() async {
    final productNotes = await Producnotes().query().get();
    return Response.json(
        {'message': 'success', 'code': 200, 'data': productNotes});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'note_id': 'required|max_length:5',
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string'
      });
      final noteId = request.input('note_id');
      final prodId = request.input('prod_id');
      final noteDate = request.input('note_date');
      final noteText = request.input('note_text');

      final product = await Products()
          .query()
          .where('prod_id', '=', request.input('prod_id').toString())
          .first();
      if (product == null) {
        return Response.json(
            {'success': false, 'message': 'Data produk note tidak ditemukan'},
            404);
      }
      var noteID =
          await Producnotes().query().where('note_id', '=', prodId).first();
      if (noteID != null) {
        return Response.json({'message': 'Data sudah ada', 'code': 409});
      }
      final notes = await Producnotes().query().insert({
        'note_id': noteId,
        'prod_id': prodId,
        'note_date': noteDate,
        'note_text': noteText,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now()
      });
      return Response.json(
          {'message': 'sukses menambah data note', 'code': 201, 'data': notes},
          201);
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
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, dynamic id) async {
    final note = await Producnotes()
        .query()
        .where('note_id', '=', id.toString())
        .first();
    try {
      request.validate({
        'note_id': 'required|max_length:5',
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string'
      });
      final noteId = request.input('note_id');
      final prodId = request.input('prod_id');
      final noteDate = request.input('note_date');
      final noteText = request.input('note_text');

      final ProdID = await Products()
          .query()
          .where('prod_id', '=', request.input('prod_id').toString())
          .first();
      if (ProdID == null) {
        return Response.json(
            {'success': false, 'message': 'data produk tidak ditemukan'}, 404);
      }
      await Producnotes().query().where('note_id', '=', id.toString()).update({
        'note_id': noteId,
        'prod_id': prodId,
        'note_date': noteDate,
        'note_text': noteText,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now()
      });
      return Response.json({
        'message': 'sukses memperbarui data note',
        'code': 200,
        'data': note
      }, 200);
    } catch (e) {
      return Response.json({
        'messsage': 'server error',
        'code': 500,
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    final products = await Producnotes()
        .query()
        .where('note_id', '=', id.toString())
        .first();
    if (products == null) {
      return Response.json({
        'message': 'Data produk note tidak ditemukan',
        'code': 200,
        'data': products
      }, 200);
    }
    await Producnotes().query().where('note_id', '=', id).delete();
    return Response.json({
      'success':true,
      'message':'Berhasil menghapus data note',
      'data':products
    });
  }
}

final ProductnotesController productnotesController = ProductnotesController();
