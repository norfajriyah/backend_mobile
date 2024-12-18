import 'package:vania/vania.dart';

class CreateOrderitemsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orderitems', () {
      integer('order_item', length: 11, unique: true);
      primary('order_item');
      integer('user_id', length: 10);
      integer('order_num', length: 11);
      char('prod_id', length: 10);
      integer('quantity', length: 11);
      integer('size', length: 11);

      foreign('order_num', 'orders', 'order_num',
          constrained: true, onDelete: 'CASCADE');
      foreign('prod_id', 'products', 'prod_id',
          constrained: true, onDelete: 'CASCADE');
      foreign('user_id', 'users', 'user_id',
          constrained: true, onDelete: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
