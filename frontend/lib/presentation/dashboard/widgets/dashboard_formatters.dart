import 'package:intl/intl.dart';

class DashboardFormatters {
  DashboardFormatters._();

  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  static final DateFormat _date = DateFormat('dd/MM/yyyy', 'pt_BR');

  static String currency(double value) => _currency.format(value);

  static String date(DateTime value) => _date.format(value);
}
