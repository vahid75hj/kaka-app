import 'package:uuid/uuid.dart';

/// Time-ordered UUIDv7 ids: sortable, safe to merge across devices later.
abstract final class Ids {
  static const _uuid = Uuid();
  static String next() => _uuid.v7();
}
