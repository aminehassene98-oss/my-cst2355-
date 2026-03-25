import 'package:floor/floor.dart';

@entity
class ShoppingItem {
  @primaryKey
  final int id;

  final String name;
  final String quantity;

  static int ID = 1;

  ShoppingItem(this.id, this.name, this.quantity) {
    if (id >= ID) {
      ID = id + 1;
    }
  }
}