import 'package:vania/vania.dart';

class CreateOrdersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orders', () {
      integer('order_num', length: 11, unique: true);
      primary('order_num');
      integer('user_id', length: 10);
      date('order_date');
      char('cust_id', length: 5);

      foreign('cust_id', 'customers', 'cust_id',
          constrained: true, onDelete: 'CASCADE');
      foreign('user_id', 'users', 'user_id',
          constrained: true, onDelete: 'CASCADE');

      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orders');
  }
}
