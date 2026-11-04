import 'package:flutter/material.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../core/app_format.dart';
import '../../l10n/gen/app_localizations.dart';

/// Shared bits for the assets screens.
String qtyText(AppFormat f, Instrument i, int q, bool fa) => '${f.digits(Qty.format(q, i.qtyScale))} ${i.unit(fa)}';

String moneyOrHidden(AppFormat f, Money m, {bool signed = false, required bool hide}) =>
    hide ? '••••' : f.money(m, signed: signed);

/// Percent with one decimal and an explicit sign (not colour alone).
String percentText(AppFormat f, int part, int whole) {
  if (whole == 0) return '';
  final p = part * 1000 ~/ whole;
  final sign = p > 0 ? '+' : (p < 0 ? '−' : '');
  final a = p.abs();
  return f.digits('$sign${a ~/ 10}.${a % 10}%');
}

IconData classIcon(AssetClass c) => switch (c) {
  AssetClass.metal => Icons.diamond_outlined,
  AssetClass.coin => Icons.toll_outlined,
  AssetClass.crypto => Icons.currency_bitcoin,
  AssetClass.stock => Icons.show_chart,
  AssetClass.fund => Icons.pie_chart_outline,
  AssetClass.bond => Icons.receipt_long_outlined,
  AssetClass.realEstate => Icons.home_work_outlined,
  AssetClass.vehicle => Icons.directions_car_outlined,
  AssetClass.collectible => Icons.palette_outlined,
  AssetClass.other => Icons.category_outlined,
};

String className(AppLocalizations l, AssetClass c) => switch (c) {
  AssetClass.metal => l.acMetal,
  AssetClass.coin => l.acCoin,
  AssetClass.crypto => l.acCrypto,
  AssetClass.stock => l.acStock,
  AssetClass.fund => l.acFund,
  AssetClass.bond => l.acBond,
  AssetClass.realEstate => l.acRealEstate,
  AssetClass.vehicle => l.acVehicle,
  AssetClass.collectible => l.acCollectible,
  AssetClass.other => l.acOther,
};

String kindName(AppLocalizations l, EventKind k) => switch (k) {
  EventKind.buy => l.buy,
  EventKind.sell => l.sell,
  EventKind.opening => l.evOpening,
  EventKind.giftIn => l.evGiftIn,
  EventKind.giftOut => l.evGiftOut,
  EventKind.income => l.evIncome,
  EventKind.transferOut => l.evTransferOut,
  EventKind.transferIn => l.evTransferIn,
  EventKind.split => l.evSplit,
  EventKind.adjustIn => l.evAdjustIn,
  EventKind.adjustOut => l.evAdjustOut,
};

String platformKindName(AppLocalizations l, PlatformKind k) => switch (k) {
  PlatformKind.exchange => l.pkExchange,
  PlatformKind.broker => l.pkBroker,
  PlatformKind.wallet => l.pkWallet,
  PlatformKind.app => l.pkApp,
  PlatformKind.bank => l.pkBank,
  PlatformKind.home => l.pkHome,
  PlatformKind.person => l.pkPerson,
  PlatformKind.other => l.pkOther,
};

String portfolioError(AppLocalizations l, String code) => switch (code) {
  'portfolio.oversell' => l.errOversell,
  'portfolio.breaks_later' || 'portfolio.void_breaks_later' => l.errBreaksLater,
  'portfolio.total_required' => l.errTotalRequired,
  'ledger.currency_mismatch' => l.errCurrencyMismatch,
  'portfolio.same_platform' => l.errSamePlatform,
  'instrument.name_required' || 'platform.name_required' => l.errNameRequired,
  _ => l.errAmount,
};
