import 'package:intl/intl.dart';

final moneyFormat = NumberFormat.currency(
  locale: 'ru_RU',
  symbol: '₽',
  decimalDigits: 0,
);
