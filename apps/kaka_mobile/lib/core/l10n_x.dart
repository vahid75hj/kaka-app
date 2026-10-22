import 'package:flutter/widgets.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../l10n/gen/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Maps a [DomainException] code to a user-facing message.
  String domainError(Object error) {
    final code = error is DomainException ? error.code : '';
    return switch (code) {
      'amount.invalid' || 'amount.not_positive' => l10n.errAmount,
      'amount.too_precise' => l10n.errTooPrecise,
      'account.name_required' => l10n.errName,
      'ledger.same_account' => l10n.errSameAccount,
      'ledger.cross_currency_transfer' => l10n.errCrossCurrency,
      _ => l10n.errGeneric,
    };
  }
}
