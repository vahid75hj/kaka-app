import 'package:flutter/material.dart';
import 'package:kaka_domain/kaka_domain.dart';

/// Icon keys stored on category accounts. Keys are stable (saved in the
/// database and backups), glyphs may change. Unknown keys fall back.
abstract final class CategoryIcons {
  static const Map<String, IconData> all = {
    'food': Icons.restaurant_rounded,
    'grocery': Icons.local_grocery_store_outlined,
    'coffee': Icons.local_cafe_outlined,
    'transport': Icons.directions_car_outlined,
    'taxi': Icons.local_taxi_outlined,
    'fuel': Icons.local_gas_station_outlined,
    'shopping': Icons.shopping_bag_outlined,
    'clothes': Icons.checkroom_outlined,
    'bills': Icons.receipt_long_outlined,
    'phone': Icons.phone_android_outlined,
    'internet': Icons.wifi_rounded,
    'health': Icons.medical_services_outlined,
    'fun': Icons.celebration_outlined,
    'travel': Icons.flight_outlined,
    'home': Icons.home_outlined,
    'rent': Icons.key_outlined,
    'education': Icons.school_outlined,
    'kids': Icons.child_care_outlined,
    'pets': Icons.pets_outlined,
    'sport': Icons.fitness_center_outlined,
    'beauty': Icons.content_cut_rounded,
    'charity': Icons.volunteer_activism_outlined,
    'loan': Icons.account_balance_outlined,
    'tax': Icons.gavel_outlined,
    'salary': Icons.work_outline_rounded,
    'gift': Icons.card_giftcard_outlined,
    'business': Icons.storefront_outlined,
    'investment': Icons.trending_up_rounded,
    'savings': Icons.savings_outlined,
    'other': Icons.category_outlined,
  };

  /// Default icons for the categories Kaka seeds (fa + en names).
  static const Map<String, String> _byName = {
    'خوراک': 'food',
    'Food': 'food',
    'رفت‌وآمد': 'transport',
    'Transport': 'transport',
    'خرید': 'shopping',
    'Shopping': 'shopping',
    'قبض‌ها': 'bills',
    'Bills': 'bills',
    'سلامت': 'health',
    'Health': 'health',
    'تفریح': 'fun',
    'Fun': 'fun',
    'خانه': 'home',
    'Home': 'home',
    'سایر': 'other',
    'Other': 'other',
    'حقوق': 'salary',
    'Salary': 'salary',
    'هدیه': 'gift',
    'Gift': 'gift',
    'کسب‌وکار': 'business',
    'Business': 'business',
  };

  static IconData of(String? key, {required String name, required AccountType type}) =>
      all[key] ?? all[_byName[name]] ?? (type == AccountType.income ? Icons.savings_outlined : Icons.sell_outlined);
}
