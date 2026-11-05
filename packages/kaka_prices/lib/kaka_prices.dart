/// Pluggable price sources for Kaka. Parsers are JSON data (URL + extract path /
/// CSS / regex), never executable code. The app never fabricates prices.
library;

export 'src/catalog.dart';
export 'src/extract.dart';
export 'src/fetch.dart';
export 'src/formula.dart';
export 'src/money_from_decimal.dart';
export 'src/refresh.dart';
