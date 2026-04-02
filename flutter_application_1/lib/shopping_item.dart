import 'package:floor/floor.dart';

// This class represents one row in the ShoppingItem table
@Entity(tableName: 'ShoppingItem')
class ShoppingItem {
  @PrimaryKey()
  final int id;

  final String name;
  final String quantity;

  // Used to manually generate the next ID
  static int ID = 1;

  ShoppingItem(this.id, this.name, this.quantity) {
    if (id >= ID) {
      ID = id + 1;
    }
  }
}