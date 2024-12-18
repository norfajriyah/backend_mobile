import 'package:vania/vania.dart';

class CreateUserTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('users', () {
      integer('user_id', length: 10, unique: true);
      primary('user_id');
      char('username', length: 50);
      char('password', length: 8);
      char('email', length: 25);
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}
