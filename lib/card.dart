class Card {
  final int? value;
  final String type;

  Card(this.value, this.type);

  @override
  String toString() {
    if (type == 'normal') {
      return 'Tarjeta $value';
    }
    return 'Tarjeta $type';
  }
}
