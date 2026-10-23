import 'package:kaka_domain/kaka_domain.dart';

import 'app_format.dart';

/// Parses an amount typed in the unit the user sees for [c] (e.g. toman for rial).
Money parseUserMoney(AppFormat f, String text, Currency c) => AmountParser.parse(text, f.unitFor(c));

/// A rate typed as `1 X = n` in the base display unit (e.g. toman) → rate per base currency.
Decimal parseUserRate(AppFormat f, String text) => Decimal.parse(text).scaled(f.settings.baseUnit.factorPow10);

/// Inverse of [parseUserRate] for display.
String showUserRate(AppFormat f, Decimal rate) => f.digits(rate.scaled(-f.settings.baseUnit.factorPow10).toString());
