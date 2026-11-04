// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 8),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, type, currency, isSystem, archived, createdAt, icon];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<AccountRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(_typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta, isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta, archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(_iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      isSystem: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      archived: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      icon: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}icon']),
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final String name;
  final String type;
  final String currency;
  final bool isSystem;
  final bool archived;
  final DateTime createdAt;
  final String? icon;
  const AccountRow({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    required this.isSystem,
    required this.archived,
    required this.createdAt,
    this.icon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['currency'] = Variable<String>(currency);
    map['is_system'] = Variable<bool>(isSystem);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      currency: Value(currency),
      isSystem: Value(isSystem),
      archived: Value(archived),
      createdAt: Value(createdAt),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory AccountRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      currency: serializer.fromJson<String>(json['currency']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      icon: serializer.fromJson<String?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'currency': serializer.toJson<String>(currency),
      'isSystem': serializer.toJson<bool>(isSystem),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'icon': serializer.toJson<String?>(icon),
    };
  }

  AccountRow copyWith({
    String? id,
    String? name,
    String? type,
    String? currency,
    bool? isSystem,
    bool? archived,
    DateTime? createdAt,
    Value<String?> icon = const Value.absent(),
  }) => AccountRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    currency: currency ?? this.currency,
    isSystem: isSystem ?? this.isSystem,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    icon: icon.present ? icon.value : this.icon,
  );
  AccountRow copyWithCompanion(AccountsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      currency: data.currency.present ? data.currency.value : this.currency,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currency: $currency, ')
          ..write('isSystem: $isSystem, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, currency, isSystem, archived, createdAt, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.currency == this.currency &&
          other.isSystem == this.isSystem &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.icon == this.icon);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> currency;
  final Value<bool> isSystem;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<String?> icon;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currency = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String currency,
    this.isSystem = const Value.absent(),
    this.archived = const Value.absent(),
    required DateTime createdAt,
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       currency = Value(currency),
       createdAt = Value(createdAt);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? currency,
    Expression<bool>? isSystem,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<String>? icon,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currency != null) 'currency': currency,
      if (isSystem != null) 'is_system': isSystem,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (icon != null) 'icon': icon,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? currency,
    Value<bool>? isSystem,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<String?>? icon,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      isSystem: isSystem ?? this.isSystem,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      icon: icon ?? this.icon,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currency: $currency, ')
          ..write('isSystem: $isSystem, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('icon: $icon, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _voidedAtMeta = const VerificationMeta('voidedAt');
  @override
  late final GeneratedColumn<DateTime> voidedAt = GeneratedColumn<DateTime>(
    'voided_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, occurredAt, note, voidedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(_kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(_occurredAtMeta, occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('voided_at')) {
      context.handle(_voidedAtMeta, voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      occurredAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      voidedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}voided_at']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final String id;
  final String kind;
  final DateTime occurredAt;
  final String note;
  final DateTime? voidedAt;
  const TransactionRow({
    required this.id,
    required this.kind,
    required this.occurredAt,
    required this.note,
    this.voidedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<DateTime>(voidedAt);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      kind: Value(kind),
      occurredAt: Value(occurredAt),
      note: Value(note),
      voidedAt: voidedAt == null && nullToAbsent ? const Value.absent() : Value(voidedAt),
    );
  }

  factory TransactionRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      note: serializer.fromJson<String>(json['note']),
      voidedAt: serializer.fromJson<DateTime?>(json['voidedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'note': serializer.toJson<String>(note),
      'voidedAt': serializer.toJson<DateTime?>(voidedAt),
    };
  }

  TransactionRow copyWith({
    String? id,
    String? kind,
    DateTime? occurredAt,
    String? note,
    Value<DateTime?> voidedAt = const Value.absent(),
  }) => TransactionRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    occurredAt: occurredAt ?? this.occurredAt,
    note: note ?? this.note,
    voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
  );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      occurredAt: data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      note: data.note.present ? data.note.value : this.note,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('voidedAt: $voidedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, occurredAt, note, voidedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.occurredAt == this.occurredAt &&
          other.note == this.note &&
          other.voidedAt == this.voidedAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<DateTime> occurredAt;
  final Value<String> note;
  final Value<DateTime?> voidedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.note = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String kind,
    required DateTime occurredAt,
    this.note = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       occurredAt = Value(occurredAt);
  static Insertable<TransactionRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<DateTime>? occurredAt,
    Expression<String>? note,
    Expression<DateTime>? voidedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (note != null) 'note': note,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<DateTime>? occurredAt,
    Value<String>? note,
    Value<DateTime?>? voidedAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      occurredAt: occurredAt ?? this.occurredAt,
      note: note ?? this.note,
      voidedAt: voidedAt ?? this.voidedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<DateTime>(voidedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostingsTable extends Postings with TableInfo<$PostingsTable, PostingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _txnIdMeta = const VerificationMeta('txnId');
  @override
  late final GeneratedColumn<String> txnId = GeneratedColumn<String>(
    'txn_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES transactions (id)'),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, txnId, accountId, amountMinor, currency];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'postings';
  @override
  VerificationContext validateIntegrity(Insertable<PostingRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('txn_id')) {
      context.handle(_txnIdMeta, txnId.isAcceptableOrUnknown(data['txn_id']!, _txnIdMeta));
    } else if (isInserting) {
      context.missing(_txnIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta, accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(_amountMinorMeta, amountMinor.isAcceptableOrUnknown(data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostingRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      txnId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}txn_id'])!,
      accountId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      amountMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
    );
  }

  @override
  $PostingsTable createAlias(String alias) {
    return $PostingsTable(attachedDatabase, alias);
  }
}

class PostingRow extends DataClass implements Insertable<PostingRow> {
  final String id;
  final String txnId;
  final String accountId;

  /// Integer minor units of [currency]. Never a float.
  final int amountMinor;
  final String currency;
  const PostingRow({
    required this.id,
    required this.txnId,
    required this.accountId,
    required this.amountMinor,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['txn_id'] = Variable<String>(txnId);
    map['account_id'] = Variable<String>(accountId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  PostingsCompanion toCompanion(bool nullToAbsent) {
    return PostingsCompanion(
      id: Value(id),
      txnId: Value(txnId),
      accountId: Value(accountId),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
    );
  }

  factory PostingRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostingRow(
      id: serializer.fromJson<String>(json['id']),
      txnId: serializer.fromJson<String>(json['txnId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'txnId': serializer.toJson<String>(txnId),
      'accountId': serializer.toJson<String>(accountId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
    };
  }

  PostingRow copyWith({String? id, String? txnId, String? accountId, int? amountMinor, String? currency}) => PostingRow(
    id: id ?? this.id,
    txnId: txnId ?? this.txnId,
    accountId: accountId ?? this.accountId,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
  );
  PostingRow copyWithCompanion(PostingsCompanion data) {
    return PostingRow(
      id: data.id.present ? data.id.value : this.id,
      txnId: data.txnId.present ? data.txnId.value : this.txnId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      amountMinor: data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostingRow(')
          ..write('id: $id, ')
          ..write('txnId: $txnId, ')
          ..write('accountId: $accountId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, txnId, accountId, amountMinor, currency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostingRow &&
          other.id == this.id &&
          other.txnId == this.txnId &&
          other.accountId == this.accountId &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency);
}

class PostingsCompanion extends UpdateCompanion<PostingRow> {
  final Value<String> id;
  final Value<String> txnId;
  final Value<String> accountId;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<int> rowid;
  const PostingsCompanion({
    this.id = const Value.absent(),
    this.txnId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostingsCompanion.insert({
    required String id,
    required String txnId,
    required String accountId,
    required int amountMinor,
    required String currency,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       txnId = Value(txnId),
       accountId = Value(accountId),
       amountMinor = Value(amountMinor),
       currency = Value(currency);
  static Insertable<PostingRow> custom({
    Expression<String>? id,
    Expression<String>? txnId,
    Expression<String>? accountId,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (txnId != null) 'txn_id': txnId,
      if (accountId != null) 'account_id': accountId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostingsCompanion copyWith({
    Value<String>? id,
    Value<String>? txnId,
    Value<String>? accountId,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<int>? rowid,
  }) {
    return PostingsCompanion(
      id: id ?? this.id,
      txnId: txnId ?? this.txnId,
      accountId: accountId ?? this.accountId,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (txnId.present) {
      map['txn_id'] = Variable<String>(txnId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostingsCompanion(')
          ..write('id: $id, ')
          ..write('txnId: $txnId, ')
          ..write('accountId: $accountId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<SettingRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(key: serializer.fromJson<String>(json['key']), value: serializer.fromJson<String>(json['value']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'key': serializer.toJson<String>(key), 'value': serializer.toJson<String>(value)};
  }

  SettingRow copyWith({String? key, String? value}) => SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SettingRow && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({required String key, required String value, this.rowid = const Value.absent()})
    : key = Value(key),
      value = Value(value);
  static Insertable<SettingRow> custom({Expression<String>? key, Expression<String>? value, Expression<int>? rowid}) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsCompanion(key: key ?? this.key, value: value ?? this.value, rowid: rowid ?? this.rowid);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DraftsTable extends Drafts with TableInfo<$DraftsTable, DraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isExpenseMeta = const VerificationMeta('isExpense');
  @override
  late final GeneratedColumn<bool> isExpense = GeneratedColumn<bool>(
    'is_expense',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_expense" IN (0, 1))'),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawTextMeta = const VerificationMeta('rawText');
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
    'raw_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<String> bankId = GeneratedColumn<String>(
    'bank_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
    'last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dedupKeyMeta = const VerificationMeta('dedupKey');
  @override
  late final GeneratedColumn<String> dedupKey = GeneratedColumn<String>(
    'dedup_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceMinorMeta = const VerificationMeta('balanceMinor');
  @override
  late final GeneratedColumn<int> balanceMinor = GeneratedColumn<int>(
    'balance_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta('toAccountId');
  @override
  late final GeneratedColumn<String> toAccountId = GeneratedColumn<String>(
    'to_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    source,
    status,
    isExpense,
    amountMinor,
    currency,
    createdAt,
    occurredAt,
    rawText,
    note,
    bankId,
    last4,
    dedupKey,
    accountId,
    balanceMinor,
    sender,
    confidence,
    toAccountId,
    category,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drafts';
  @override
  VerificationContext validateIntegrity(Insertable<DraftRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta, source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('is_expense')) {
      context.handle(_isExpenseMeta, isExpense.isAcceptableOrUnknown(data['is_expense']!, _isExpenseMeta));
    } else if (isInserting) {
      context.missing(_isExpenseMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(_amountMinorMeta, amountMinor.isAcceptableOrUnknown(data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(_occurredAtMeta, occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta));
    }
    if (data.containsKey('raw_text')) {
      context.handle(_rawTextMeta, rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta));
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('bank_id')) {
      context.handle(_bankIdMeta, bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta));
    }
    if (data.containsKey('last4')) {
      context.handle(_last4Meta, last4.isAcceptableOrUnknown(data['last4']!, _last4Meta));
    }
    if (data.containsKey('dedup_key')) {
      context.handle(_dedupKeyMeta, dedupKey.isAcceptableOrUnknown(data['dedup_key']!, _dedupKeyMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta, accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('balance_minor')) {
      context.handle(_balanceMinorMeta, balanceMinor.isAcceptableOrUnknown(data['balance_minor']!, _balanceMinorMeta));
    }
    if (data.containsKey('sender')) {
      context.handle(_senderMeta, sender.isAcceptableOrUnknown(data['sender']!, _senderMeta));
    }
    if (data.containsKey('confidence')) {
      context.handle(_confidenceMeta, confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('to_account_id')) {
      context.handle(_toAccountIdMeta, toAccountId.isAcceptableOrUnknown(data['to_account_id']!, _toAccountIdMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DraftRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      source: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      status: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      isExpense: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_expense'])!,
      amountMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      occurredAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at']),
      rawText: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}raw_text'])!,
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      bankId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}bank_id']),
      last4: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}last4']),
      dedupKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}dedup_key']),
      accountId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      balanceMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}balance_minor']),
      sender: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sender']),
      confidence: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}confidence']),
      toAccountId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}to_account_id']),
      category: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category']),
    );
  }

  @override
  $DraftsTable createAlias(String alias) {
    return $DraftsTable(attachedDatabase, alias);
  }
}

class DraftRow extends DataClass implements Insertable<DraftRow> {
  final String id;
  final String source;
  final String status;
  final bool isExpense;
  final int amountMinor;
  final String currency;
  final DateTime createdAt;
  final DateTime? occurredAt;
  final String rawText;
  final String note;
  final String? bankId;
  final String? last4;
  final String? dedupKey;
  final String? accountId;
  final int? balanceMinor;
  final String? sender;
  final double? confidence;
  final String? toAccountId;
  final String? category;
  const DraftRow({
    required this.id,
    required this.source,
    required this.status,
    required this.isExpense,
    required this.amountMinor,
    required this.currency,
    required this.createdAt,
    this.occurredAt,
    required this.rawText,
    required this.note,
    this.bankId,
    this.last4,
    this.dedupKey,
    this.accountId,
    this.balanceMinor,
    this.sender,
    this.confidence,
    this.toAccountId,
    this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source'] = Variable<String>(source);
    map['status'] = Variable<String>(status);
    map['is_expense'] = Variable<bool>(isExpense);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || occurredAt != null) {
      map['occurred_at'] = Variable<DateTime>(occurredAt);
    }
    map['raw_text'] = Variable<String>(rawText);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || bankId != null) {
      map['bank_id'] = Variable<String>(bankId);
    }
    if (!nullToAbsent || last4 != null) {
      map['last4'] = Variable<String>(last4);
    }
    if (!nullToAbsent || dedupKey != null) {
      map['dedup_key'] = Variable<String>(dedupKey);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || balanceMinor != null) {
      map['balance_minor'] = Variable<int>(balanceMinor);
    }
    if (!nullToAbsent || sender != null) {
      map['sender'] = Variable<String>(sender);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<String>(toAccountId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  DraftsCompanion toCompanion(bool nullToAbsent) {
    return DraftsCompanion(
      id: Value(id),
      source: Value(source),
      status: Value(status),
      isExpense: Value(isExpense),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      createdAt: Value(createdAt),
      occurredAt: occurredAt == null && nullToAbsent ? const Value.absent() : Value(occurredAt),
      rawText: Value(rawText),
      note: Value(note),
      bankId: bankId == null && nullToAbsent ? const Value.absent() : Value(bankId),
      last4: last4 == null && nullToAbsent ? const Value.absent() : Value(last4),
      dedupKey: dedupKey == null && nullToAbsent ? const Value.absent() : Value(dedupKey),
      accountId: accountId == null && nullToAbsent ? const Value.absent() : Value(accountId),
      balanceMinor: balanceMinor == null && nullToAbsent ? const Value.absent() : Value(balanceMinor),
      sender: sender == null && nullToAbsent ? const Value.absent() : Value(sender),
      confidence: confidence == null && nullToAbsent ? const Value.absent() : Value(confidence),
      toAccountId: toAccountId == null && nullToAbsent ? const Value.absent() : Value(toAccountId),
      category: category == null && nullToAbsent ? const Value.absent() : Value(category),
    );
  }

  factory DraftRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DraftRow(
      id: serializer.fromJson<String>(json['id']),
      source: serializer.fromJson<String>(json['source']),
      status: serializer.fromJson<String>(json['status']),
      isExpense: serializer.fromJson<bool>(json['isExpense']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      occurredAt: serializer.fromJson<DateTime?>(json['occurredAt']),
      rawText: serializer.fromJson<String>(json['rawText']),
      note: serializer.fromJson<String>(json['note']),
      bankId: serializer.fromJson<String?>(json['bankId']),
      last4: serializer.fromJson<String?>(json['last4']),
      dedupKey: serializer.fromJson<String?>(json['dedupKey']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      balanceMinor: serializer.fromJson<int?>(json['balanceMinor']),
      sender: serializer.fromJson<String?>(json['sender']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      toAccountId: serializer.fromJson<String?>(json['toAccountId']),
      category: serializer.fromJson<String?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'source': serializer.toJson<String>(source),
      'status': serializer.toJson<String>(status),
      'isExpense': serializer.toJson<bool>(isExpense),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'occurredAt': serializer.toJson<DateTime?>(occurredAt),
      'rawText': serializer.toJson<String>(rawText),
      'note': serializer.toJson<String>(note),
      'bankId': serializer.toJson<String?>(bankId),
      'last4': serializer.toJson<String?>(last4),
      'dedupKey': serializer.toJson<String?>(dedupKey),
      'accountId': serializer.toJson<String?>(accountId),
      'balanceMinor': serializer.toJson<int?>(balanceMinor),
      'sender': serializer.toJson<String?>(sender),
      'confidence': serializer.toJson<double?>(confidence),
      'toAccountId': serializer.toJson<String?>(toAccountId),
      'category': serializer.toJson<String?>(category),
    };
  }

  DraftRow copyWith({
    String? id,
    String? source,
    String? status,
    bool? isExpense,
    int? amountMinor,
    String? currency,
    DateTime? createdAt,
    Value<DateTime?> occurredAt = const Value.absent(),
    String? rawText,
    String? note,
    Value<String?> bankId = const Value.absent(),
    Value<String?> last4 = const Value.absent(),
    Value<String?> dedupKey = const Value.absent(),
    Value<String?> accountId = const Value.absent(),
    Value<int?> balanceMinor = const Value.absent(),
    Value<String?> sender = const Value.absent(),
    Value<double?> confidence = const Value.absent(),
    Value<String?> toAccountId = const Value.absent(),
    Value<String?> category = const Value.absent(),
  }) => DraftRow(
    id: id ?? this.id,
    source: source ?? this.source,
    status: status ?? this.status,
    isExpense: isExpense ?? this.isExpense,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    createdAt: createdAt ?? this.createdAt,
    occurredAt: occurredAt.present ? occurredAt.value : this.occurredAt,
    rawText: rawText ?? this.rawText,
    note: note ?? this.note,
    bankId: bankId.present ? bankId.value : this.bankId,
    last4: last4.present ? last4.value : this.last4,
    dedupKey: dedupKey.present ? dedupKey.value : this.dedupKey,
    accountId: accountId.present ? accountId.value : this.accountId,
    balanceMinor: balanceMinor.present ? balanceMinor.value : this.balanceMinor,
    sender: sender.present ? sender.value : this.sender,
    confidence: confidence.present ? confidence.value : this.confidence,
    toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
    category: category.present ? category.value : this.category,
  );
  DraftRow copyWithCompanion(DraftsCompanion data) {
    return DraftRow(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      status: data.status.present ? data.status.value : this.status,
      isExpense: data.isExpense.present ? data.isExpense.value : this.isExpense,
      amountMinor: data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      occurredAt: data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      note: data.note.present ? data.note.value : this.note,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      last4: data.last4.present ? data.last4.value : this.last4,
      dedupKey: data.dedupKey.present ? data.dedupKey.value : this.dedupKey,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      balanceMinor: data.balanceMinor.present ? data.balanceMinor.value : this.balanceMinor,
      sender: data.sender.present ? data.sender.value : this.sender,
      confidence: data.confidence.present ? data.confidence.value : this.confidence,
      toAccountId: data.toAccountId.present ? data.toAccountId.value : this.toAccountId,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DraftRow(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('isExpense: $isExpense, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rawText: $rawText, ')
          ..write('note: $note, ')
          ..write('bankId: $bankId, ')
          ..write('last4: $last4, ')
          ..write('dedupKey: $dedupKey, ')
          ..write('accountId: $accountId, ')
          ..write('balanceMinor: $balanceMinor, ')
          ..write('sender: $sender, ')
          ..write('confidence: $confidence, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    source,
    status,
    isExpense,
    amountMinor,
    currency,
    createdAt,
    occurredAt,
    rawText,
    note,
    bankId,
    last4,
    dedupKey,
    accountId,
    balanceMinor,
    sender,
    confidence,
    toAccountId,
    category,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DraftRow &&
          other.id == this.id &&
          other.source == this.source &&
          other.status == this.status &&
          other.isExpense == this.isExpense &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.createdAt == this.createdAt &&
          other.occurredAt == this.occurredAt &&
          other.rawText == this.rawText &&
          other.note == this.note &&
          other.bankId == this.bankId &&
          other.last4 == this.last4 &&
          other.dedupKey == this.dedupKey &&
          other.accountId == this.accountId &&
          other.balanceMinor == this.balanceMinor &&
          other.sender == this.sender &&
          other.confidence == this.confidence &&
          other.toAccountId == this.toAccountId &&
          other.category == this.category);
}

class DraftsCompanion extends UpdateCompanion<DraftRow> {
  final Value<String> id;
  final Value<String> source;
  final Value<String> status;
  final Value<bool> isExpense;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<DateTime> createdAt;
  final Value<DateTime?> occurredAt;
  final Value<String> rawText;
  final Value<String> note;
  final Value<String?> bankId;
  final Value<String?> last4;
  final Value<String?> dedupKey;
  final Value<String?> accountId;
  final Value<int?> balanceMinor;
  final Value<String?> sender;
  final Value<double?> confidence;
  final Value<String?> toAccountId;
  final Value<String?> category;
  final Value<int> rowid;
  const DraftsCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.status = const Value.absent(),
    this.isExpense = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rawText = const Value.absent(),
    this.note = const Value.absent(),
    this.bankId = const Value.absent(),
    this.last4 = const Value.absent(),
    this.dedupKey = const Value.absent(),
    this.accountId = const Value.absent(),
    this.balanceMinor = const Value.absent(),
    this.sender = const Value.absent(),
    this.confidence = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.category = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DraftsCompanion.insert({
    required String id,
    required String source,
    required String status,
    required bool isExpense,
    required int amountMinor,
    required String currency,
    required DateTime createdAt,
    this.occurredAt = const Value.absent(),
    this.rawText = const Value.absent(),
    this.note = const Value.absent(),
    this.bankId = const Value.absent(),
    this.last4 = const Value.absent(),
    this.dedupKey = const Value.absent(),
    this.accountId = const Value.absent(),
    this.balanceMinor = const Value.absent(),
    this.sender = const Value.absent(),
    this.confidence = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.category = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       source = Value(source),
       status = Value(status),
       isExpense = Value(isExpense),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       createdAt = Value(createdAt);
  static Insertable<DraftRow> custom({
    Expression<String>? id,
    Expression<String>? source,
    Expression<String>? status,
    Expression<bool>? isExpense,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? occurredAt,
    Expression<String>? rawText,
    Expression<String>? note,
    Expression<String>? bankId,
    Expression<String>? last4,
    Expression<String>? dedupKey,
    Expression<String>? accountId,
    Expression<int>? balanceMinor,
    Expression<String>? sender,
    Expression<double>? confidence,
    Expression<String>? toAccountId,
    Expression<String>? category,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (status != null) 'status': status,
      if (isExpense != null) 'is_expense': isExpense,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (createdAt != null) 'created_at': createdAt,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rawText != null) 'raw_text': rawText,
      if (note != null) 'note': note,
      if (bankId != null) 'bank_id': bankId,
      if (last4 != null) 'last4': last4,
      if (dedupKey != null) 'dedup_key': dedupKey,
      if (accountId != null) 'account_id': accountId,
      if (balanceMinor != null) 'balance_minor': balanceMinor,
      if (sender != null) 'sender': sender,
      if (confidence != null) 'confidence': confidence,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (category != null) 'category': category,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? source,
    Value<String>? status,
    Value<bool>? isExpense,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<DateTime>? createdAt,
    Value<DateTime?>? occurredAt,
    Value<String>? rawText,
    Value<String>? note,
    Value<String?>? bankId,
    Value<String?>? last4,
    Value<String?>? dedupKey,
    Value<String?>? accountId,
    Value<int?>? balanceMinor,
    Value<String?>? sender,
    Value<double?>? confidence,
    Value<String?>? toAccountId,
    Value<String?>? category,
    Value<int>? rowid,
  }) {
    return DraftsCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      status: status ?? this.status,
      isExpense: isExpense ?? this.isExpense,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      occurredAt: occurredAt ?? this.occurredAt,
      rawText: rawText ?? this.rawText,
      note: note ?? this.note,
      bankId: bankId ?? this.bankId,
      last4: last4 ?? this.last4,
      dedupKey: dedupKey ?? this.dedupKey,
      accountId: accountId ?? this.accountId,
      balanceMinor: balanceMinor ?? this.balanceMinor,
      sender: sender ?? this.sender,
      confidence: confidence ?? this.confidence,
      toAccountId: toAccountId ?? this.toAccountId,
      category: category ?? this.category,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isExpense.present) {
      map['is_expense'] = Variable<bool>(isExpense.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (bankId.present) {
      map['bank_id'] = Variable<String>(bankId.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (dedupKey.present) {
      map['dedup_key'] = Variable<String>(dedupKey.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (balanceMinor.present) {
      map['balance_minor'] = Variable<int>(balanceMinor.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<String>(toAccountId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DraftsCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('isExpense: $isExpense, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rawText: $rawText, ')
          ..write('note: $note, ')
          ..write('bankId: $bankId, ')
          ..write('last4: $last4, ')
          ..write('dedupKey: $dedupKey, ')
          ..write('accountId: $accountId, ')
          ..write('balanceMinor: $balanceMinor, ')
          ..write('sender: $sender, ')
          ..write('confidence: $confidence, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('category: $category, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SmsLinksTable extends SmsLinks with TableInfo<$SmsLinksTable, SmsLinkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmsLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountNumberMeta = const VerificationMeta('accountNumber');
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
    'account_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, sender, accountId, accountNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sms_links';
  @override
  VerificationContext validateIntegrity(Insertable<SmsLinkRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(_senderMeta, sender.isAcceptableOrUnknown(data['sender']!, _senderMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta, accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('account_number')) {
      context.handle(
        _accountNumberMeta,
        accountNumber.isAcceptableOrUnknown(data['account_number']!, _accountNumberMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmsLinkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsLinkRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sender: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sender']),
      accountId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      accountNumber: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}account_number']),
    );
  }

  @override
  $SmsLinksTable createAlias(String alias) {
    return $SmsLinksTable(attachedDatabase, alias);
  }
}

class SmsLinkRow extends DataClass implements Insertable<SmsLinkRow> {
  final String id;
  final String? sender;
  final String? accountId;
  final String? accountNumber;
  const SmsLinkRow({required this.id, this.sender, this.accountId, this.accountNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || sender != null) {
      map['sender'] = Variable<String>(sender);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || accountNumber != null) {
      map['account_number'] = Variable<String>(accountNumber);
    }
    return map;
  }

  SmsLinksCompanion toCompanion(bool nullToAbsent) {
    return SmsLinksCompanion(
      id: Value(id),
      sender: sender == null && nullToAbsent ? const Value.absent() : Value(sender),
      accountId: accountId == null && nullToAbsent ? const Value.absent() : Value(accountId),
      accountNumber: accountNumber == null && nullToAbsent ? const Value.absent() : Value(accountNumber),
    );
  }

  factory SmsLinkRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsLinkRow(
      id: serializer.fromJson<String>(json['id']),
      sender: serializer.fromJson<String?>(json['sender']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      accountNumber: serializer.fromJson<String?>(json['accountNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sender': serializer.toJson<String?>(sender),
      'accountId': serializer.toJson<String?>(accountId),
      'accountNumber': serializer.toJson<String?>(accountNumber),
    };
  }

  SmsLinkRow copyWith({
    String? id,
    Value<String?> sender = const Value.absent(),
    Value<String?> accountId = const Value.absent(),
    Value<String?> accountNumber = const Value.absent(),
  }) => SmsLinkRow(
    id: id ?? this.id,
    sender: sender.present ? sender.value : this.sender,
    accountId: accountId.present ? accountId.value : this.accountId,
    accountNumber: accountNumber.present ? accountNumber.value : this.accountNumber,
  );
  SmsLinkRow copyWithCompanion(SmsLinksCompanion data) {
    return SmsLinkRow(
      id: data.id.present ? data.id.value : this.id,
      sender: data.sender.present ? data.sender.value : this.sender,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      accountNumber: data.accountNumber.present ? data.accountNumber.value : this.accountNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmsLinkRow(')
          ..write('id: $id, ')
          ..write('sender: $sender, ')
          ..write('accountId: $accountId, ')
          ..write('accountNumber: $accountNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sender, accountId, accountNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsLinkRow &&
          other.id == this.id &&
          other.sender == this.sender &&
          other.accountId == this.accountId &&
          other.accountNumber == this.accountNumber);
}

class SmsLinksCompanion extends UpdateCompanion<SmsLinkRow> {
  final Value<String> id;
  final Value<String?> sender;
  final Value<String?> accountId;
  final Value<String?> accountNumber;
  final Value<int> rowid;
  const SmsLinksCompanion({
    this.id = const Value.absent(),
    this.sender = const Value.absent(),
    this.accountId = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SmsLinksCompanion.insert({
    required String id,
    this.sender = const Value.absent(),
    this.accountId = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<SmsLinkRow> custom({
    Expression<String>? id,
    Expression<String>? sender,
    Expression<String>? accountId,
    Expression<String>? accountNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sender != null) 'sender': sender,
      if (accountId != null) 'account_id': accountId,
      if (accountNumber != null) 'account_number': accountNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SmsLinksCompanion copyWith({
    Value<String>? id,
    Value<String?>? sender,
    Value<String?>? accountId,
    Value<String?>? accountNumber,
    Value<int>? rowid,
  }) {
    return SmsLinksCompanion(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      accountId: accountId ?? this.accountId,
      accountNumber: accountNumber ?? this.accountNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmsLinksCompanion(')
          ..write('id: $id, ')
          ..write('sender: $sender, ')
          ..write('accountId: $accountId, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FxRatesTable extends FxRates with TableInfo<$FxRatesTable, FxRateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FxRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseMeta = const VerificationMeta('base');
  @override
  late final GeneratedColumn<String> base = GeneratedColumn<String>(
    'base',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateDateMeta = const VerificationMeta('rateDate');
  @override
  late final GeneratedColumn<DateTime> rateDate = GeneratedColumn<DateTime>(
    'rate_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<String> rate = GeneratedColumn<String>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, currency, base, rateDate, rate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fx_rates';
  @override
  VerificationContext validateIntegrity(Insertable<FxRateRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('base')) {
      context.handle(_baseMeta, base.isAcceptableOrUnknown(data['base']!, _baseMeta));
    } else if (isInserting) {
      context.missing(_baseMeta);
    }
    if (data.containsKey('rate_date')) {
      context.handle(_rateDateMeta, rateDate.isAcceptableOrUnknown(data['rate_date']!, _rateDateMeta));
    } else if (isInserting) {
      context.missing(_rateDateMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(_rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FxRateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FxRateRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      base: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}base'])!,
      rateDate: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}rate_date'])!,
      rate: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}rate'])!,
    );
  }

  @override
  $FxRatesTable createAlias(String alias) {
    return $FxRatesTable(attachedDatabase, alias);
  }
}

class FxRateRow extends DataClass implements Insertable<FxRateRow> {
  final String id;
  final String currency;
  final String base;
  final DateTime rateDate;

  /// Exact decimal string ("1050000", "0.00095").
  final String rate;
  const FxRateRow({
    required this.id,
    required this.currency,
    required this.base,
    required this.rateDate,
    required this.rate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['currency'] = Variable<String>(currency);
    map['base'] = Variable<String>(base);
    map['rate_date'] = Variable<DateTime>(rateDate);
    map['rate'] = Variable<String>(rate);
    return map;
  }

  FxRatesCompanion toCompanion(bool nullToAbsent) {
    return FxRatesCompanion(
      id: Value(id),
      currency: Value(currency),
      base: Value(base),
      rateDate: Value(rateDate),
      rate: Value(rate),
    );
  }

  factory FxRateRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FxRateRow(
      id: serializer.fromJson<String>(json['id']),
      currency: serializer.fromJson<String>(json['currency']),
      base: serializer.fromJson<String>(json['base']),
      rateDate: serializer.fromJson<DateTime>(json['rateDate']),
      rate: serializer.fromJson<String>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'currency': serializer.toJson<String>(currency),
      'base': serializer.toJson<String>(base),
      'rateDate': serializer.toJson<DateTime>(rateDate),
      'rate': serializer.toJson<String>(rate),
    };
  }

  FxRateRow copyWith({String? id, String? currency, String? base, DateTime? rateDate, String? rate}) => FxRateRow(
    id: id ?? this.id,
    currency: currency ?? this.currency,
    base: base ?? this.base,
    rateDate: rateDate ?? this.rateDate,
    rate: rate ?? this.rate,
  );
  FxRateRow copyWithCompanion(FxRatesCompanion data) {
    return FxRateRow(
      id: data.id.present ? data.id.value : this.id,
      currency: data.currency.present ? data.currency.value : this.currency,
      base: data.base.present ? data.base.value : this.base,
      rateDate: data.rateDate.present ? data.rateDate.value : this.rateDate,
      rate: data.rate.present ? data.rate.value : this.rate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FxRateRow(')
          ..write('id: $id, ')
          ..write('currency: $currency, ')
          ..write('base: $base, ')
          ..write('rateDate: $rateDate, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currency, base, rateDate, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FxRateRow &&
          other.id == this.id &&
          other.currency == this.currency &&
          other.base == this.base &&
          other.rateDate == this.rateDate &&
          other.rate == this.rate);
}

class FxRatesCompanion extends UpdateCompanion<FxRateRow> {
  final Value<String> id;
  final Value<String> currency;
  final Value<String> base;
  final Value<DateTime> rateDate;
  final Value<String> rate;
  final Value<int> rowid;
  const FxRatesCompanion({
    this.id = const Value.absent(),
    this.currency = const Value.absent(),
    this.base = const Value.absent(),
    this.rateDate = const Value.absent(),
    this.rate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FxRatesCompanion.insert({
    required String id,
    required String currency,
    required String base,
    required DateTime rateDate,
    required String rate,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       currency = Value(currency),
       base = Value(base),
       rateDate = Value(rateDate),
       rate = Value(rate);
  static Insertable<FxRateRow> custom({
    Expression<String>? id,
    Expression<String>? currency,
    Expression<String>? base,
    Expression<DateTime>? rateDate,
    Expression<String>? rate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currency != null) 'currency': currency,
      if (base != null) 'base': base,
      if (rateDate != null) 'rate_date': rateDate,
      if (rate != null) 'rate': rate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FxRatesCompanion copyWith({
    Value<String>? id,
    Value<String>? currency,
    Value<String>? base,
    Value<DateTime>? rateDate,
    Value<String>? rate,
    Value<int>? rowid,
  }) {
    return FxRatesCompanion(
      id: id ?? this.id,
      currency: currency ?? this.currency,
      base: base ?? this.base,
      rateDate: rateDate ?? this.rateDate,
      rate: rate ?? this.rate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (base.present) {
      map['base'] = Variable<String>(base.value);
    }
    if (rateDate.present) {
      map['rate_date'] = Variable<DateTime>(rateDate.value);
    }
    if (rate.present) {
      map['rate'] = Variable<String>(rate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FxRatesCompanion(')
          ..write('id: $id, ')
          ..write('currency: $currency, ')
          ..write('base: $base, ')
          ..write('rateDate: $rateDate, ')
          ..write('rate: $rate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InstrumentsTable extends Instruments with TableInfo<$InstrumentsTable, InstrumentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstrumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetClassMeta = const VerificationMeta('assetClass');
  @override
  late final GeneratedColumn<String> assetClass = GeneratedColumn<String>(
    'asset_class',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameFaMeta = const VerificationMeta('nameFa');
  @override
  late final GeneratedColumn<String> nameFa = GeneratedColumn<String>(
    'name_fa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitFaMeta = const VerificationMeta('unitFa');
  @override
  late final GeneratedColumn<String> unitFa = GeneratedColumn<String>(
    'unit_fa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitEnMeta = const VerificationMeta('unitEn');
  @override
  late final GeneratedColumn<String> unitEn = GeneratedColumn<String>(
    'unit_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyScaleMeta = const VerificationMeta('qtyScale');
  @override
  late final GeneratedColumn<int> qtyScale = GeneratedColumn<int>(
    'qty_scale',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _quoteCurrencyMeta = const VerificationMeta('quoteCurrency');
  @override
  late final GeneratedColumn<String> quoteCurrency = GeneratedColumn<String>(
    'quote_currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costMethodMeta = const VerificationMeta('costMethod');
  @override
  late final GeneratedColumn<String> costMethod = GeneratedColumn<String>(
    'cost_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('average'),
  );
  static const VerificationMeta _catalogIdMeta = const VerificationMeta('catalogId');
  @override
  late final GeneratedColumn<String> catalogId = GeneratedColumn<String>(
    'catalog_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assetClass,
    nameFa,
    nameEn,
    unitFa,
    unitEn,
    qtyScale,
    symbol,
    quoteCurrency,
    costMethod,
    catalogId,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'instruments';
  @override
  VerificationContext validateIntegrity(Insertable<InstrumentRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_class')) {
      context.handle(_assetClassMeta, assetClass.isAcceptableOrUnknown(data['asset_class']!, _assetClassMeta));
    } else if (isInserting) {
      context.missing(_assetClassMeta);
    }
    if (data.containsKey('name_fa')) {
      context.handle(_nameFaMeta, nameFa.isAcceptableOrUnknown(data['name_fa']!, _nameFaMeta));
    } else if (isInserting) {
      context.missing(_nameFaMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta, nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('unit_fa')) {
      context.handle(_unitFaMeta, unitFa.isAcceptableOrUnknown(data['unit_fa']!, _unitFaMeta));
    } else if (isInserting) {
      context.missing(_unitFaMeta);
    }
    if (data.containsKey('unit_en')) {
      context.handle(_unitEnMeta, unitEn.isAcceptableOrUnknown(data['unit_en']!, _unitEnMeta));
    } else if (isInserting) {
      context.missing(_unitEnMeta);
    }
    if (data.containsKey('qty_scale')) {
      context.handle(_qtyScaleMeta, qtyScale.isAcceptableOrUnknown(data['qty_scale']!, _qtyScaleMeta));
    } else if (isInserting) {
      context.missing(_qtyScaleMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta, symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    }
    if (data.containsKey('quote_currency')) {
      context.handle(
        _quoteCurrencyMeta,
        quoteCurrency.isAcceptableOrUnknown(data['quote_currency']!, _quoteCurrencyMeta),
      );
    }
    if (data.containsKey('cost_method')) {
      context.handle(_costMethodMeta, costMethod.isAcceptableOrUnknown(data['cost_method']!, _costMethodMeta));
    }
    if (data.containsKey('catalog_id')) {
      context.handle(_catalogIdMeta, catalogId.isAcceptableOrUnknown(data['catalog_id']!, _catalogIdMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta, archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InstrumentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstrumentRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      assetClass: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}asset_class'])!,
      nameFa: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name_fa'])!,
      nameEn: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      unitFa: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}unit_fa'])!,
      unitEn: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}unit_en'])!,
      qtyScale: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}qty_scale'])!,
      symbol: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      quoteCurrency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}quote_currency']),
      costMethod: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}cost_method'])!,
      catalogId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}catalog_id']),
      archived: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
    );
  }

  @override
  $InstrumentsTable createAlias(String alias) {
    return $InstrumentsTable(attachedDatabase, alias);
  }
}

class InstrumentRow extends DataClass implements Insertable<InstrumentRow> {
  final String id;
  final String assetClass;
  final String nameFa;
  final String nameEn;
  final String unitFa;
  final String unitEn;
  final int qtyScale;
  final String symbol;
  final String? quoteCurrency;
  final String costMethod;
  final String? catalogId;
  final bool archived;
  const InstrumentRow({
    required this.id,
    required this.assetClass,
    required this.nameFa,
    required this.nameEn,
    required this.unitFa,
    required this.unitEn,
    required this.qtyScale,
    required this.symbol,
    this.quoteCurrency,
    required this.costMethod,
    this.catalogId,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_class'] = Variable<String>(assetClass);
    map['name_fa'] = Variable<String>(nameFa);
    map['name_en'] = Variable<String>(nameEn);
    map['unit_fa'] = Variable<String>(unitFa);
    map['unit_en'] = Variable<String>(unitEn);
    map['qty_scale'] = Variable<int>(qtyScale);
    map['symbol'] = Variable<String>(symbol);
    if (!nullToAbsent || quoteCurrency != null) {
      map['quote_currency'] = Variable<String>(quoteCurrency);
    }
    map['cost_method'] = Variable<String>(costMethod);
    if (!nullToAbsent || catalogId != null) {
      map['catalog_id'] = Variable<String>(catalogId);
    }
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  InstrumentsCompanion toCompanion(bool nullToAbsent) {
    return InstrumentsCompanion(
      id: Value(id),
      assetClass: Value(assetClass),
      nameFa: Value(nameFa),
      nameEn: Value(nameEn),
      unitFa: Value(unitFa),
      unitEn: Value(unitEn),
      qtyScale: Value(qtyScale),
      symbol: Value(symbol),
      quoteCurrency: quoteCurrency == null && nullToAbsent ? const Value.absent() : Value(quoteCurrency),
      costMethod: Value(costMethod),
      catalogId: catalogId == null && nullToAbsent ? const Value.absent() : Value(catalogId),
      archived: Value(archived),
    );
  }

  factory InstrumentRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstrumentRow(
      id: serializer.fromJson<String>(json['id']),
      assetClass: serializer.fromJson<String>(json['assetClass']),
      nameFa: serializer.fromJson<String>(json['nameFa']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      unitFa: serializer.fromJson<String>(json['unitFa']),
      unitEn: serializer.fromJson<String>(json['unitEn']),
      qtyScale: serializer.fromJson<int>(json['qtyScale']),
      symbol: serializer.fromJson<String>(json['symbol']),
      quoteCurrency: serializer.fromJson<String?>(json['quoteCurrency']),
      costMethod: serializer.fromJson<String>(json['costMethod']),
      catalogId: serializer.fromJson<String?>(json['catalogId']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetClass': serializer.toJson<String>(assetClass),
      'nameFa': serializer.toJson<String>(nameFa),
      'nameEn': serializer.toJson<String>(nameEn),
      'unitFa': serializer.toJson<String>(unitFa),
      'unitEn': serializer.toJson<String>(unitEn),
      'qtyScale': serializer.toJson<int>(qtyScale),
      'symbol': serializer.toJson<String>(symbol),
      'quoteCurrency': serializer.toJson<String?>(quoteCurrency),
      'costMethod': serializer.toJson<String>(costMethod),
      'catalogId': serializer.toJson<String?>(catalogId),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  InstrumentRow copyWith({
    String? id,
    String? assetClass,
    String? nameFa,
    String? nameEn,
    String? unitFa,
    String? unitEn,
    int? qtyScale,
    String? symbol,
    Value<String?> quoteCurrency = const Value.absent(),
    String? costMethod,
    Value<String?> catalogId = const Value.absent(),
    bool? archived,
  }) => InstrumentRow(
    id: id ?? this.id,
    assetClass: assetClass ?? this.assetClass,
    nameFa: nameFa ?? this.nameFa,
    nameEn: nameEn ?? this.nameEn,
    unitFa: unitFa ?? this.unitFa,
    unitEn: unitEn ?? this.unitEn,
    qtyScale: qtyScale ?? this.qtyScale,
    symbol: symbol ?? this.symbol,
    quoteCurrency: quoteCurrency.present ? quoteCurrency.value : this.quoteCurrency,
    costMethod: costMethod ?? this.costMethod,
    catalogId: catalogId.present ? catalogId.value : this.catalogId,
    archived: archived ?? this.archived,
  );
  InstrumentRow copyWithCompanion(InstrumentsCompanion data) {
    return InstrumentRow(
      id: data.id.present ? data.id.value : this.id,
      assetClass: data.assetClass.present ? data.assetClass.value : this.assetClass,
      nameFa: data.nameFa.present ? data.nameFa.value : this.nameFa,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      unitFa: data.unitFa.present ? data.unitFa.value : this.unitFa,
      unitEn: data.unitEn.present ? data.unitEn.value : this.unitEn,
      qtyScale: data.qtyScale.present ? data.qtyScale.value : this.qtyScale,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      quoteCurrency: data.quoteCurrency.present ? data.quoteCurrency.value : this.quoteCurrency,
      costMethod: data.costMethod.present ? data.costMethod.value : this.costMethod,
      catalogId: data.catalogId.present ? data.catalogId.value : this.catalogId,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstrumentRow(')
          ..write('id: $id, ')
          ..write('assetClass: $assetClass, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn, ')
          ..write('unitFa: $unitFa, ')
          ..write('unitEn: $unitEn, ')
          ..write('qtyScale: $qtyScale, ')
          ..write('symbol: $symbol, ')
          ..write('quoteCurrency: $quoteCurrency, ')
          ..write('costMethod: $costMethod, ')
          ..write('catalogId: $catalogId, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    assetClass,
    nameFa,
    nameEn,
    unitFa,
    unitEn,
    qtyScale,
    symbol,
    quoteCurrency,
    costMethod,
    catalogId,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstrumentRow &&
          other.id == this.id &&
          other.assetClass == this.assetClass &&
          other.nameFa == this.nameFa &&
          other.nameEn == this.nameEn &&
          other.unitFa == this.unitFa &&
          other.unitEn == this.unitEn &&
          other.qtyScale == this.qtyScale &&
          other.symbol == this.symbol &&
          other.quoteCurrency == this.quoteCurrency &&
          other.costMethod == this.costMethod &&
          other.catalogId == this.catalogId &&
          other.archived == this.archived);
}

class InstrumentsCompanion extends UpdateCompanion<InstrumentRow> {
  final Value<String> id;
  final Value<String> assetClass;
  final Value<String> nameFa;
  final Value<String> nameEn;
  final Value<String> unitFa;
  final Value<String> unitEn;
  final Value<int> qtyScale;
  final Value<String> symbol;
  final Value<String?> quoteCurrency;
  final Value<String> costMethod;
  final Value<String?> catalogId;
  final Value<bool> archived;
  final Value<int> rowid;
  const InstrumentsCompanion({
    this.id = const Value.absent(),
    this.assetClass = const Value.absent(),
    this.nameFa = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.unitFa = const Value.absent(),
    this.unitEn = const Value.absent(),
    this.qtyScale = const Value.absent(),
    this.symbol = const Value.absent(),
    this.quoteCurrency = const Value.absent(),
    this.costMethod = const Value.absent(),
    this.catalogId = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InstrumentsCompanion.insert({
    required String id,
    required String assetClass,
    required String nameFa,
    required String nameEn,
    required String unitFa,
    required String unitEn,
    required int qtyScale,
    this.symbol = const Value.absent(),
    this.quoteCurrency = const Value.absent(),
    this.costMethod = const Value.absent(),
    this.catalogId = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assetClass = Value(assetClass),
       nameFa = Value(nameFa),
       nameEn = Value(nameEn),
       unitFa = Value(unitFa),
       unitEn = Value(unitEn),
       qtyScale = Value(qtyScale);
  static Insertable<InstrumentRow> custom({
    Expression<String>? id,
    Expression<String>? assetClass,
    Expression<String>? nameFa,
    Expression<String>? nameEn,
    Expression<String>? unitFa,
    Expression<String>? unitEn,
    Expression<int>? qtyScale,
    Expression<String>? symbol,
    Expression<String>? quoteCurrency,
    Expression<String>? costMethod,
    Expression<String>? catalogId,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetClass != null) 'asset_class': assetClass,
      if (nameFa != null) 'name_fa': nameFa,
      if (nameEn != null) 'name_en': nameEn,
      if (unitFa != null) 'unit_fa': unitFa,
      if (unitEn != null) 'unit_en': unitEn,
      if (qtyScale != null) 'qty_scale': qtyScale,
      if (symbol != null) 'symbol': symbol,
      if (quoteCurrency != null) 'quote_currency': quoteCurrency,
      if (costMethod != null) 'cost_method': costMethod,
      if (catalogId != null) 'catalog_id': catalogId,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InstrumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? assetClass,
    Value<String>? nameFa,
    Value<String>? nameEn,
    Value<String>? unitFa,
    Value<String>? unitEn,
    Value<int>? qtyScale,
    Value<String>? symbol,
    Value<String?>? quoteCurrency,
    Value<String>? costMethod,
    Value<String?>? catalogId,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return InstrumentsCompanion(
      id: id ?? this.id,
      assetClass: assetClass ?? this.assetClass,
      nameFa: nameFa ?? this.nameFa,
      nameEn: nameEn ?? this.nameEn,
      unitFa: unitFa ?? this.unitFa,
      unitEn: unitEn ?? this.unitEn,
      qtyScale: qtyScale ?? this.qtyScale,
      symbol: symbol ?? this.symbol,
      quoteCurrency: quoteCurrency ?? this.quoteCurrency,
      costMethod: costMethod ?? this.costMethod,
      catalogId: catalogId ?? this.catalogId,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetClass.present) {
      map['asset_class'] = Variable<String>(assetClass.value);
    }
    if (nameFa.present) {
      map['name_fa'] = Variable<String>(nameFa.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (unitFa.present) {
      map['unit_fa'] = Variable<String>(unitFa.value);
    }
    if (unitEn.present) {
      map['unit_en'] = Variable<String>(unitEn.value);
    }
    if (qtyScale.present) {
      map['qty_scale'] = Variable<int>(qtyScale.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (quoteCurrency.present) {
      map['quote_currency'] = Variable<String>(quoteCurrency.value);
    }
    if (costMethod.present) {
      map['cost_method'] = Variable<String>(costMethod.value);
    }
    if (catalogId.present) {
      map['catalog_id'] = Variable<String>(catalogId.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstrumentsCompanion(')
          ..write('id: $id, ')
          ..write('assetClass: $assetClass, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn, ')
          ..write('unitFa: $unitFa, ')
          ..write('unitEn: $unitEn, ')
          ..write('qtyScale: $qtyScale, ')
          ..write('symbol: $symbol, ')
          ..write('quoteCurrency: $quoteCurrency, ')
          ..write('costMethod: $costMethod, ')
          ..write('catalogId: $catalogId, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlatformsTable extends Platforms with TableInfo<$PlatformsTable, PlatformRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlatformsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, kind, archived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'platforms';
  @override
  VerificationContext validateIntegrity(Insertable<PlatformRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(_kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta, archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlatformRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlatformRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      archived: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
    );
  }

  @override
  $PlatformsTable createAlias(String alias) {
    return $PlatformsTable(attachedDatabase, alias);
  }
}

class PlatformRow extends DataClass implements Insertable<PlatformRow> {
  final String id;
  final String name;
  final String kind;
  final bool archived;
  const PlatformRow({required this.id, required this.name, required this.kind, required this.archived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  PlatformsCompanion toCompanion(bool nullToAbsent) {
    return PlatformsCompanion(id: Value(id), name: Value(name), kind: Value(kind), archived: Value(archived));
  }

  factory PlatformRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlatformRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  PlatformRow copyWith({String? id, String? name, String? kind, bool? archived}) => PlatformRow(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    archived: archived ?? this.archived,
  );
  PlatformRow copyWithCompanion(PlatformsCompanion data) {
    return PlatformRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlatformRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, kind, archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlatformRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.archived == this.archived);
}

class PlatformsCompanion extends UpdateCompanion<PlatformRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> kind;
  final Value<bool> archived;
  final Value<int> rowid;
  const PlatformsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlatformsCompanion.insert({
    required String id,
    required String name,
    required String kind,
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       kind = Value(kind);
  static Insertable<PlatformRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlatformsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? kind,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return PlatformsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlatformsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PortfolioEventsTable extends PortfolioEvents with TableInfo<$PortfolioEventsTable, PortfolioEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PortfolioEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instrumentIdMeta = const VerificationMeta('instrumentId');
  @override
  late final GeneratedColumn<String> instrumentId = GeneratedColumn<String>(
    'instrument_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES instruments (id)'),
  );
  static const VerificationMeta _platformIdMeta = const VerificationMeta('platformId');
  @override
  late final GeneratedColumn<String> platformId = GeneratedColumn<String>(
    'platform_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _grossMeta = const VerificationMeta('gross');
  @override
  late final GeneratedColumn<int> gross = GeneratedColumn<int>(
    'gross',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _feeMeta = const VerificationMeta('fee');
  @override
  late final GeneratedColumn<int> fee = GeneratedColumn<int>(
    'fee',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _costModeMeta = const VerificationMeta('costMode');
  @override
  late final GeneratedColumn<String> costMode = GeneratedColumn<String>(
    'cost_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('paid'),
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _splitNumMeta = const VerificationMeta('splitNum');
  @override
  late final GeneratedColumn<int> splitNum = GeneratedColumn<int>(
    'split_num',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _splitDenMeta = const VerificationMeta('splitDen');
  @override
  late final GeneratedColumn<int> splitDen = GeneratedColumn<int>(
    'split_den',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cashAccountIdMeta = const VerificationMeta('cashAccountId');
  @override
  late final GeneratedColumn<String> cashAccountId = GeneratedColumn<String>(
    'cash_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _txnIdMeta = const VerificationMeta('txnId');
  @override
  late final GeneratedColumn<String> txnId = GeneratedColumn<String>(
    'txn_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _txnSigMeta = const VerificationMeta('txnSig');
  @override
  late final GeneratedColumn<String> txnSig = GeneratedColumn<String>(
    'txn_sig',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _voidedAtMeta = const VerificationMeta('voidedAt');
  @override
  late final GeneratedColumn<DateTime> voidedAt = GeneratedColumn<DateTime>(
    'voided_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    instrumentId,
    platformId,
    kind,
    at,
    currency,
    qty,
    gross,
    fee,
    costMode,
    cost,
    splitNum,
    splitDen,
    groupId,
    cashAccountId,
    txnId,
    txnSig,
    source,
    note,
    voidedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'portfolio_events';
  @override
  VerificationContext validateIntegrity(Insertable<PortfolioEventRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('instrument_id')) {
      context.handle(_instrumentIdMeta, instrumentId.isAcceptableOrUnknown(data['instrument_id']!, _instrumentIdMeta));
    } else if (isInserting) {
      context.missing(_instrumentIdMeta);
    }
    if (data.containsKey('platform_id')) {
      context.handle(_platformIdMeta, platformId.isAcceptableOrUnknown(data['platform_id']!, _platformIdMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(_kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(_qtyMeta, qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta));
    }
    if (data.containsKey('gross')) {
      context.handle(_grossMeta, gross.isAcceptableOrUnknown(data['gross']!, _grossMeta));
    }
    if (data.containsKey('fee')) {
      context.handle(_feeMeta, fee.isAcceptableOrUnknown(data['fee']!, _feeMeta));
    }
    if (data.containsKey('cost_mode')) {
      context.handle(_costModeMeta, costMode.isAcceptableOrUnknown(data['cost_mode']!, _costModeMeta));
    }
    if (data.containsKey('cost')) {
      context.handle(_costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    }
    if (data.containsKey('split_num')) {
      context.handle(_splitNumMeta, splitNum.isAcceptableOrUnknown(data['split_num']!, _splitNumMeta));
    }
    if (data.containsKey('split_den')) {
      context.handle(_splitDenMeta, splitDen.isAcceptableOrUnknown(data['split_den']!, _splitDenMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta, groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('cash_account_id')) {
      context.handle(
        _cashAccountIdMeta,
        cashAccountId.isAcceptableOrUnknown(data['cash_account_id']!, _cashAccountIdMeta),
      );
    }
    if (data.containsKey('txn_id')) {
      context.handle(_txnIdMeta, txnId.isAcceptableOrUnknown(data['txn_id']!, _txnIdMeta));
    }
    if (data.containsKey('txn_sig')) {
      context.handle(_txnSigMeta, txnSig.isAcceptableOrUnknown(data['txn_sig']!, _txnSigMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta, source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('voided_at')) {
      context.handle(_voidedAtMeta, voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PortfolioEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PortfolioEventRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      instrumentId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}instrument_id'])!,
      platformId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}platform_id']),
      kind: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      at: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}at'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      qty: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}qty'])!,
      gross: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}gross']),
      fee: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}fee'])!,
      costMode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}cost_mode'])!,
      cost: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}cost']),
      splitNum: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}split_num']),
      splitDen: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}split_den']),
      groupId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}group_id']),
      cashAccountId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}cash_account_id']),
      txnId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}txn_id']),
      txnSig: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}txn_sig']),
      source: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      voidedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}voided_at']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $PortfolioEventsTable createAlias(String alias) {
    return $PortfolioEventsTable(attachedDatabase, alias);
  }
}

class PortfolioEventRow extends DataClass implements Insertable<PortfolioEventRow> {
  final String id;
  final String instrumentId;
  final String? platformId;
  final String kind;
  final DateTime at;
  final String currency;
  final int qty;
  final int? gross;
  final int fee;
  final String costMode;
  final int? cost;
  final int? splitNum;
  final int? splitDen;
  final String? groupId;
  final String? cashAccountId;
  final String? txnId;
  final String? txnSig;
  final String source;
  final String note;
  final DateTime? voidedAt;
  final DateTime? createdAt;
  const PortfolioEventRow({
    required this.id,
    required this.instrumentId,
    this.platformId,
    required this.kind,
    required this.at,
    required this.currency,
    required this.qty,
    this.gross,
    required this.fee,
    required this.costMode,
    this.cost,
    this.splitNum,
    this.splitDen,
    this.groupId,
    this.cashAccountId,
    this.txnId,
    this.txnSig,
    required this.source,
    required this.note,
    this.voidedAt,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['instrument_id'] = Variable<String>(instrumentId);
    if (!nullToAbsent || platformId != null) {
      map['platform_id'] = Variable<String>(platformId);
    }
    map['kind'] = Variable<String>(kind);
    map['at'] = Variable<DateTime>(at);
    map['currency'] = Variable<String>(currency);
    map['qty'] = Variable<int>(qty);
    if (!nullToAbsent || gross != null) {
      map['gross'] = Variable<int>(gross);
    }
    map['fee'] = Variable<int>(fee);
    map['cost_mode'] = Variable<String>(costMode);
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<int>(cost);
    }
    if (!nullToAbsent || splitNum != null) {
      map['split_num'] = Variable<int>(splitNum);
    }
    if (!nullToAbsent || splitDen != null) {
      map['split_den'] = Variable<int>(splitDen);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    if (!nullToAbsent || cashAccountId != null) {
      map['cash_account_id'] = Variable<String>(cashAccountId);
    }
    if (!nullToAbsent || txnId != null) {
      map['txn_id'] = Variable<String>(txnId);
    }
    if (!nullToAbsent || txnSig != null) {
      map['txn_sig'] = Variable<String>(txnSig);
    }
    map['source'] = Variable<String>(source);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<DateTime>(voidedAt);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  PortfolioEventsCompanion toCompanion(bool nullToAbsent) {
    return PortfolioEventsCompanion(
      id: Value(id),
      instrumentId: Value(instrumentId),
      platformId: platformId == null && nullToAbsent ? const Value.absent() : Value(platformId),
      kind: Value(kind),
      at: Value(at),
      currency: Value(currency),
      qty: Value(qty),
      gross: gross == null && nullToAbsent ? const Value.absent() : Value(gross),
      fee: Value(fee),
      costMode: Value(costMode),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
      splitNum: splitNum == null && nullToAbsent ? const Value.absent() : Value(splitNum),
      splitDen: splitDen == null && nullToAbsent ? const Value.absent() : Value(splitDen),
      groupId: groupId == null && nullToAbsent ? const Value.absent() : Value(groupId),
      cashAccountId: cashAccountId == null && nullToAbsent ? const Value.absent() : Value(cashAccountId),
      txnId: txnId == null && nullToAbsent ? const Value.absent() : Value(txnId),
      txnSig: txnSig == null && nullToAbsent ? const Value.absent() : Value(txnSig),
      source: Value(source),
      note: Value(note),
      voidedAt: voidedAt == null && nullToAbsent ? const Value.absent() : Value(voidedAt),
      createdAt: createdAt == null && nullToAbsent ? const Value.absent() : Value(createdAt),
    );
  }

  factory PortfolioEventRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PortfolioEventRow(
      id: serializer.fromJson<String>(json['id']),
      instrumentId: serializer.fromJson<String>(json['instrumentId']),
      platformId: serializer.fromJson<String?>(json['platformId']),
      kind: serializer.fromJson<String>(json['kind']),
      at: serializer.fromJson<DateTime>(json['at']),
      currency: serializer.fromJson<String>(json['currency']),
      qty: serializer.fromJson<int>(json['qty']),
      gross: serializer.fromJson<int?>(json['gross']),
      fee: serializer.fromJson<int>(json['fee']),
      costMode: serializer.fromJson<String>(json['costMode']),
      cost: serializer.fromJson<int?>(json['cost']),
      splitNum: serializer.fromJson<int?>(json['splitNum']),
      splitDen: serializer.fromJson<int?>(json['splitDen']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      cashAccountId: serializer.fromJson<String?>(json['cashAccountId']),
      txnId: serializer.fromJson<String?>(json['txnId']),
      txnSig: serializer.fromJson<String?>(json['txnSig']),
      source: serializer.fromJson<String>(json['source']),
      note: serializer.fromJson<String>(json['note']),
      voidedAt: serializer.fromJson<DateTime?>(json['voidedAt']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'instrumentId': serializer.toJson<String>(instrumentId),
      'platformId': serializer.toJson<String?>(platformId),
      'kind': serializer.toJson<String>(kind),
      'at': serializer.toJson<DateTime>(at),
      'currency': serializer.toJson<String>(currency),
      'qty': serializer.toJson<int>(qty),
      'gross': serializer.toJson<int?>(gross),
      'fee': serializer.toJson<int>(fee),
      'costMode': serializer.toJson<String>(costMode),
      'cost': serializer.toJson<int?>(cost),
      'splitNum': serializer.toJson<int?>(splitNum),
      'splitDen': serializer.toJson<int?>(splitDen),
      'groupId': serializer.toJson<String?>(groupId),
      'cashAccountId': serializer.toJson<String?>(cashAccountId),
      'txnId': serializer.toJson<String?>(txnId),
      'txnSig': serializer.toJson<String?>(txnSig),
      'source': serializer.toJson<String>(source),
      'note': serializer.toJson<String>(note),
      'voidedAt': serializer.toJson<DateTime?>(voidedAt),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  PortfolioEventRow copyWith({
    String? id,
    String? instrumentId,
    Value<String?> platformId = const Value.absent(),
    String? kind,
    DateTime? at,
    String? currency,
    int? qty,
    Value<int?> gross = const Value.absent(),
    int? fee,
    String? costMode,
    Value<int?> cost = const Value.absent(),
    Value<int?> splitNum = const Value.absent(),
    Value<int?> splitDen = const Value.absent(),
    Value<String?> groupId = const Value.absent(),
    Value<String?> cashAccountId = const Value.absent(),
    Value<String?> txnId = const Value.absent(),
    Value<String?> txnSig = const Value.absent(),
    String? source,
    String? note,
    Value<DateTime?> voidedAt = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
  }) => PortfolioEventRow(
    id: id ?? this.id,
    instrumentId: instrumentId ?? this.instrumentId,
    platformId: platformId.present ? platformId.value : this.platformId,
    kind: kind ?? this.kind,
    at: at ?? this.at,
    currency: currency ?? this.currency,
    qty: qty ?? this.qty,
    gross: gross.present ? gross.value : this.gross,
    fee: fee ?? this.fee,
    costMode: costMode ?? this.costMode,
    cost: cost.present ? cost.value : this.cost,
    splitNum: splitNum.present ? splitNum.value : this.splitNum,
    splitDen: splitDen.present ? splitDen.value : this.splitDen,
    groupId: groupId.present ? groupId.value : this.groupId,
    cashAccountId: cashAccountId.present ? cashAccountId.value : this.cashAccountId,
    txnId: txnId.present ? txnId.value : this.txnId,
    txnSig: txnSig.present ? txnSig.value : this.txnSig,
    source: source ?? this.source,
    note: note ?? this.note,
    voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  PortfolioEventRow copyWithCompanion(PortfolioEventsCompanion data) {
    return PortfolioEventRow(
      id: data.id.present ? data.id.value : this.id,
      instrumentId: data.instrumentId.present ? data.instrumentId.value : this.instrumentId,
      platformId: data.platformId.present ? data.platformId.value : this.platformId,
      kind: data.kind.present ? data.kind.value : this.kind,
      at: data.at.present ? data.at.value : this.at,
      currency: data.currency.present ? data.currency.value : this.currency,
      qty: data.qty.present ? data.qty.value : this.qty,
      gross: data.gross.present ? data.gross.value : this.gross,
      fee: data.fee.present ? data.fee.value : this.fee,
      costMode: data.costMode.present ? data.costMode.value : this.costMode,
      cost: data.cost.present ? data.cost.value : this.cost,
      splitNum: data.splitNum.present ? data.splitNum.value : this.splitNum,
      splitDen: data.splitDen.present ? data.splitDen.value : this.splitDen,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      cashAccountId: data.cashAccountId.present ? data.cashAccountId.value : this.cashAccountId,
      txnId: data.txnId.present ? data.txnId.value : this.txnId,
      txnSig: data.txnSig.present ? data.txnSig.value : this.txnSig,
      source: data.source.present ? data.source.value : this.source,
      note: data.note.present ? data.note.value : this.note,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PortfolioEventRow(')
          ..write('id: $id, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('platformId: $platformId, ')
          ..write('kind: $kind, ')
          ..write('at: $at, ')
          ..write('currency: $currency, ')
          ..write('qty: $qty, ')
          ..write('gross: $gross, ')
          ..write('fee: $fee, ')
          ..write('costMode: $costMode, ')
          ..write('cost: $cost, ')
          ..write('splitNum: $splitNum, ')
          ..write('splitDen: $splitDen, ')
          ..write('groupId: $groupId, ')
          ..write('cashAccountId: $cashAccountId, ')
          ..write('txnId: $txnId, ')
          ..write('txnSig: $txnSig, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    instrumentId,
    platformId,
    kind,
    at,
    currency,
    qty,
    gross,
    fee,
    costMode,
    cost,
    splitNum,
    splitDen,
    groupId,
    cashAccountId,
    txnId,
    txnSig,
    source,
    note,
    voidedAt,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PortfolioEventRow &&
          other.id == this.id &&
          other.instrumentId == this.instrumentId &&
          other.platformId == this.platformId &&
          other.kind == this.kind &&
          other.at == this.at &&
          other.currency == this.currency &&
          other.qty == this.qty &&
          other.gross == this.gross &&
          other.fee == this.fee &&
          other.costMode == this.costMode &&
          other.cost == this.cost &&
          other.splitNum == this.splitNum &&
          other.splitDen == this.splitDen &&
          other.groupId == this.groupId &&
          other.cashAccountId == this.cashAccountId &&
          other.txnId == this.txnId &&
          other.txnSig == this.txnSig &&
          other.source == this.source &&
          other.note == this.note &&
          other.voidedAt == this.voidedAt &&
          other.createdAt == this.createdAt);
}

class PortfolioEventsCompanion extends UpdateCompanion<PortfolioEventRow> {
  final Value<String> id;
  final Value<String> instrumentId;
  final Value<String?> platformId;
  final Value<String> kind;
  final Value<DateTime> at;
  final Value<String> currency;
  final Value<int> qty;
  final Value<int?> gross;
  final Value<int> fee;
  final Value<String> costMode;
  final Value<int?> cost;
  final Value<int?> splitNum;
  final Value<int?> splitDen;
  final Value<String?> groupId;
  final Value<String?> cashAccountId;
  final Value<String?> txnId;
  final Value<String?> txnSig;
  final Value<String> source;
  final Value<String> note;
  final Value<DateTime?> voidedAt;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const PortfolioEventsCompanion({
    this.id = const Value.absent(),
    this.instrumentId = const Value.absent(),
    this.platformId = const Value.absent(),
    this.kind = const Value.absent(),
    this.at = const Value.absent(),
    this.currency = const Value.absent(),
    this.qty = const Value.absent(),
    this.gross = const Value.absent(),
    this.fee = const Value.absent(),
    this.costMode = const Value.absent(),
    this.cost = const Value.absent(),
    this.splitNum = const Value.absent(),
    this.splitDen = const Value.absent(),
    this.groupId = const Value.absent(),
    this.cashAccountId = const Value.absent(),
    this.txnId = const Value.absent(),
    this.txnSig = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PortfolioEventsCompanion.insert({
    required String id,
    required String instrumentId,
    this.platformId = const Value.absent(),
    required String kind,
    required DateTime at,
    required String currency,
    this.qty = const Value.absent(),
    this.gross = const Value.absent(),
    this.fee = const Value.absent(),
    this.costMode = const Value.absent(),
    this.cost = const Value.absent(),
    this.splitNum = const Value.absent(),
    this.splitDen = const Value.absent(),
    this.groupId = const Value.absent(),
    this.cashAccountId = const Value.absent(),
    this.txnId = const Value.absent(),
    this.txnSig = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       instrumentId = Value(instrumentId),
       kind = Value(kind),
       at = Value(at),
       currency = Value(currency);
  static Insertable<PortfolioEventRow> custom({
    Expression<String>? id,
    Expression<String>? instrumentId,
    Expression<String>? platformId,
    Expression<String>? kind,
    Expression<DateTime>? at,
    Expression<String>? currency,
    Expression<int>? qty,
    Expression<int>? gross,
    Expression<int>? fee,
    Expression<String>? costMode,
    Expression<int>? cost,
    Expression<int>? splitNum,
    Expression<int>? splitDen,
    Expression<String>? groupId,
    Expression<String>? cashAccountId,
    Expression<String>? txnId,
    Expression<String>? txnSig,
    Expression<String>? source,
    Expression<String>? note,
    Expression<DateTime>? voidedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (instrumentId != null) 'instrument_id': instrumentId,
      if (platformId != null) 'platform_id': platformId,
      if (kind != null) 'kind': kind,
      if (at != null) 'at': at,
      if (currency != null) 'currency': currency,
      if (qty != null) 'qty': qty,
      if (gross != null) 'gross': gross,
      if (fee != null) 'fee': fee,
      if (costMode != null) 'cost_mode': costMode,
      if (cost != null) 'cost': cost,
      if (splitNum != null) 'split_num': splitNum,
      if (splitDen != null) 'split_den': splitDen,
      if (groupId != null) 'group_id': groupId,
      if (cashAccountId != null) 'cash_account_id': cashAccountId,
      if (txnId != null) 'txn_id': txnId,
      if (txnSig != null) 'txn_sig': txnSig,
      if (source != null) 'source': source,
      if (note != null) 'note': note,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PortfolioEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? instrumentId,
    Value<String?>? platformId,
    Value<String>? kind,
    Value<DateTime>? at,
    Value<String>? currency,
    Value<int>? qty,
    Value<int?>? gross,
    Value<int>? fee,
    Value<String>? costMode,
    Value<int?>? cost,
    Value<int?>? splitNum,
    Value<int?>? splitDen,
    Value<String?>? groupId,
    Value<String?>? cashAccountId,
    Value<String?>? txnId,
    Value<String?>? txnSig,
    Value<String>? source,
    Value<String>? note,
    Value<DateTime?>? voidedAt,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return PortfolioEventsCompanion(
      id: id ?? this.id,
      instrumentId: instrumentId ?? this.instrumentId,
      platformId: platformId ?? this.platformId,
      kind: kind ?? this.kind,
      at: at ?? this.at,
      currency: currency ?? this.currency,
      qty: qty ?? this.qty,
      gross: gross ?? this.gross,
      fee: fee ?? this.fee,
      costMode: costMode ?? this.costMode,
      cost: cost ?? this.cost,
      splitNum: splitNum ?? this.splitNum,
      splitDen: splitDen ?? this.splitDen,
      groupId: groupId ?? this.groupId,
      cashAccountId: cashAccountId ?? this.cashAccountId,
      txnId: txnId ?? this.txnId,
      txnSig: txnSig ?? this.txnSig,
      source: source ?? this.source,
      note: note ?? this.note,
      voidedAt: voidedAt ?? this.voidedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (instrumentId.present) {
      map['instrument_id'] = Variable<String>(instrumentId.value);
    }
    if (platformId.present) {
      map['platform_id'] = Variable<String>(platformId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (gross.present) {
      map['gross'] = Variable<int>(gross.value);
    }
    if (fee.present) {
      map['fee'] = Variable<int>(fee.value);
    }
    if (costMode.present) {
      map['cost_mode'] = Variable<String>(costMode.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (splitNum.present) {
      map['split_num'] = Variable<int>(splitNum.value);
    }
    if (splitDen.present) {
      map['split_den'] = Variable<int>(splitDen.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (cashAccountId.present) {
      map['cash_account_id'] = Variable<String>(cashAccountId.value);
    }
    if (txnId.present) {
      map['txn_id'] = Variable<String>(txnId.value);
    }
    if (txnSig.present) {
      map['txn_sig'] = Variable<String>(txnSig.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<DateTime>(voidedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PortfolioEventsCompanion(')
          ..write('id: $id, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('platformId: $platformId, ')
          ..write('kind: $kind, ')
          ..write('at: $at, ')
          ..write('currency: $currency, ')
          ..write('qty: $qty, ')
          ..write('gross: $gross, ')
          ..write('fee: $fee, ')
          ..write('costMode: $costMode, ')
          ..write('cost: $cost, ')
          ..write('splitNum: $splitNum, ')
          ..write('splitDen: $splitDen, ')
          ..write('groupId: $groupId, ')
          ..write('cashAccountId: $cashAccountId, ')
          ..write('txnId: $txnId, ')
          ..write('txnSig: $txnSig, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceQuotesTable extends PriceQuotes with TableInfo<$PriceQuotesTable, PriceQuoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceQuotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instrumentIdMeta = const VerificationMeta('instrumentId');
  @override
  late final GeneratedColumn<String> instrumentId = GeneratedColumn<String>(
    'instrument_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES instruments (id)'),
  );
  static const VerificationMeta _priceMinorMeta = const VerificationMeta('priceMinor');
  @override
  late final GeneratedColumn<int> priceMinor = GeneratedColumn<int>(
    'price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _asOfMeta = const VerificationMeta('asOf');
  @override
  late final GeneratedColumn<DateTime> asOf = GeneratedColumn<DateTime>(
    'as_of',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, instrumentId, priceMinor, currency, asOf, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_quotes';
  @override
  VerificationContext validateIntegrity(Insertable<PriceQuoteRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('instrument_id')) {
      context.handle(_instrumentIdMeta, instrumentId.isAcceptableOrUnknown(data['instrument_id']!, _instrumentIdMeta));
    } else if (isInserting) {
      context.missing(_instrumentIdMeta);
    }
    if (data.containsKey('price_minor')) {
      context.handle(_priceMinorMeta, priceMinor.isAcceptableOrUnknown(data['price_minor']!, _priceMinorMeta));
    } else if (isInserting) {
      context.missing(_priceMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('as_of')) {
      context.handle(_asOfMeta, asOf.isAcceptableOrUnknown(data['as_of']!, _asOfMeta));
    } else if (isInserting) {
      context.missing(_asOfMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta, source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceQuoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceQuoteRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      instrumentId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}instrument_id'])!,
      priceMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}price_minor'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      asOf: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}as_of'])!,
      source: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source'])!,
    );
  }

  @override
  $PriceQuotesTable createAlias(String alias) {
    return $PriceQuotesTable(attachedDatabase, alias);
  }
}

class PriceQuoteRow extends DataClass implements Insertable<PriceQuoteRow> {
  final String id;
  final String instrumentId;
  final int priceMinor;
  final String currency;
  final DateTime asOf;
  final String source;
  const PriceQuoteRow({
    required this.id,
    required this.instrumentId,
    required this.priceMinor,
    required this.currency,
    required this.asOf,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['instrument_id'] = Variable<String>(instrumentId);
    map['price_minor'] = Variable<int>(priceMinor);
    map['currency'] = Variable<String>(currency);
    map['as_of'] = Variable<DateTime>(asOf);
    map['source'] = Variable<String>(source);
    return map;
  }

  PriceQuotesCompanion toCompanion(bool nullToAbsent) {
    return PriceQuotesCompanion(
      id: Value(id),
      instrumentId: Value(instrumentId),
      priceMinor: Value(priceMinor),
      currency: Value(currency),
      asOf: Value(asOf),
      source: Value(source),
    );
  }

  factory PriceQuoteRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceQuoteRow(
      id: serializer.fromJson<String>(json['id']),
      instrumentId: serializer.fromJson<String>(json['instrumentId']),
      priceMinor: serializer.fromJson<int>(json['priceMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      asOf: serializer.fromJson<DateTime>(json['asOf']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'instrumentId': serializer.toJson<String>(instrumentId),
      'priceMinor': serializer.toJson<int>(priceMinor),
      'currency': serializer.toJson<String>(currency),
      'asOf': serializer.toJson<DateTime>(asOf),
      'source': serializer.toJson<String>(source),
    };
  }

  PriceQuoteRow copyWith({
    String? id,
    String? instrumentId,
    int? priceMinor,
    String? currency,
    DateTime? asOf,
    String? source,
  }) => PriceQuoteRow(
    id: id ?? this.id,
    instrumentId: instrumentId ?? this.instrumentId,
    priceMinor: priceMinor ?? this.priceMinor,
    currency: currency ?? this.currency,
    asOf: asOf ?? this.asOf,
    source: source ?? this.source,
  );
  PriceQuoteRow copyWithCompanion(PriceQuotesCompanion data) {
    return PriceQuoteRow(
      id: data.id.present ? data.id.value : this.id,
      instrumentId: data.instrumentId.present ? data.instrumentId.value : this.instrumentId,
      priceMinor: data.priceMinor.present ? data.priceMinor.value : this.priceMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      asOf: data.asOf.present ? data.asOf.value : this.asOf,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceQuoteRow(')
          ..write('id: $id, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('asOf: $asOf, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, instrumentId, priceMinor, currency, asOf, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceQuoteRow &&
          other.id == this.id &&
          other.instrumentId == this.instrumentId &&
          other.priceMinor == this.priceMinor &&
          other.currency == this.currency &&
          other.asOf == this.asOf &&
          other.source == this.source);
}

class PriceQuotesCompanion extends UpdateCompanion<PriceQuoteRow> {
  final Value<String> id;
  final Value<String> instrumentId;
  final Value<int> priceMinor;
  final Value<String> currency;
  final Value<DateTime> asOf;
  final Value<String> source;
  final Value<int> rowid;
  const PriceQuotesCompanion({
    this.id = const Value.absent(),
    this.instrumentId = const Value.absent(),
    this.priceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.asOf = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PriceQuotesCompanion.insert({
    required String id,
    required String instrumentId,
    required int priceMinor,
    required String currency,
    required DateTime asOf,
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       instrumentId = Value(instrumentId),
       priceMinor = Value(priceMinor),
       currency = Value(currency),
       asOf = Value(asOf);
  static Insertable<PriceQuoteRow> custom({
    Expression<String>? id,
    Expression<String>? instrumentId,
    Expression<int>? priceMinor,
    Expression<String>? currency,
    Expression<DateTime>? asOf,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (instrumentId != null) 'instrument_id': instrumentId,
      if (priceMinor != null) 'price_minor': priceMinor,
      if (currency != null) 'currency': currency,
      if (asOf != null) 'as_of': asOf,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PriceQuotesCompanion copyWith({
    Value<String>? id,
    Value<String>? instrumentId,
    Value<int>? priceMinor,
    Value<String>? currency,
    Value<DateTime>? asOf,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return PriceQuotesCompanion(
      id: id ?? this.id,
      instrumentId: instrumentId ?? this.instrumentId,
      priceMinor: priceMinor ?? this.priceMinor,
      currency: currency ?? this.currency,
      asOf: asOf ?? this.asOf,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (instrumentId.present) {
      map['instrument_id'] = Variable<String>(instrumentId.value);
    }
    if (priceMinor.present) {
      map['price_minor'] = Variable<int>(priceMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (asOf.present) {
      map['as_of'] = Variable<DateTime>(asOf.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceQuotesCompanion(')
          ..write('id: $id, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('asOf: $asOf, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ValuationSnapshotsTable extends ValuationSnapshots
    with TableInfo<$ValuationSnapshotsTable, ValuationSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ValuationSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseMeta = const VerificationMeta('base');
  @override
  late final GeneratedColumn<String> base = GeneratedColumn<String>(
    'base',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netWorthMeta = const VerificationMeta('netWorth');
  @override
  late final GeneratedColumn<int> netWorth = GeneratedColumn<int>(
    'net_worth',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetsValueMeta = const VerificationMeta('assetsValue');
  @override
  late final GeneratedColumn<int> assetsValue = GeneratedColumn<int>(
    'assets_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unrealizedMeta = const VerificationMeta('unrealized');
  @override
  late final GeneratedColumn<int> unrealized = GeneratedColumn<int>(
    'unrealized',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, at, base, netWorth, assetsValue, unrealized];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'valuation_snapshots';
  @override
  VerificationContext validateIntegrity(Insertable<ValuationSnapshotRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('base')) {
      context.handle(_baseMeta, base.isAcceptableOrUnknown(data['base']!, _baseMeta));
    } else if (isInserting) {
      context.missing(_baseMeta);
    }
    if (data.containsKey('net_worth')) {
      context.handle(_netWorthMeta, netWorth.isAcceptableOrUnknown(data['net_worth']!, _netWorthMeta));
    } else if (isInserting) {
      context.missing(_netWorthMeta);
    }
    if (data.containsKey('assets_value')) {
      context.handle(_assetsValueMeta, assetsValue.isAcceptableOrUnknown(data['assets_value']!, _assetsValueMeta));
    } else if (isInserting) {
      context.missing(_assetsValueMeta);
    }
    if (data.containsKey('unrealized')) {
      context.handle(_unrealizedMeta, unrealized.isAcceptableOrUnknown(data['unrealized']!, _unrealizedMeta));
    } else if (isInserting) {
      context.missing(_unrealizedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ValuationSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ValuationSnapshotRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      at: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}at'])!,
      base: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}base'])!,
      netWorth: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}net_worth'])!,
      assetsValue: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}assets_value'])!,
      unrealized: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}unrealized'])!,
    );
  }

  @override
  $ValuationSnapshotsTable createAlias(String alias) {
    return $ValuationSnapshotsTable(attachedDatabase, alias);
  }
}

class ValuationSnapshotRow extends DataClass implements Insertable<ValuationSnapshotRow> {
  final String id;
  final DateTime at;
  final String base;
  final int netWorth;
  final int assetsValue;
  final int unrealized;
  const ValuationSnapshotRow({
    required this.id,
    required this.at,
    required this.base,
    required this.netWorth,
    required this.assetsValue,
    required this.unrealized,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['at'] = Variable<DateTime>(at);
    map['base'] = Variable<String>(base);
    map['net_worth'] = Variable<int>(netWorth);
    map['assets_value'] = Variable<int>(assetsValue);
    map['unrealized'] = Variable<int>(unrealized);
    return map;
  }

  ValuationSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return ValuationSnapshotsCompanion(
      id: Value(id),
      at: Value(at),
      base: Value(base),
      netWorth: Value(netWorth),
      assetsValue: Value(assetsValue),
      unrealized: Value(unrealized),
    );
  }

  factory ValuationSnapshotRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ValuationSnapshotRow(
      id: serializer.fromJson<String>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      base: serializer.fromJson<String>(json['base']),
      netWorth: serializer.fromJson<int>(json['netWorth']),
      assetsValue: serializer.fromJson<int>(json['assetsValue']),
      unrealized: serializer.fromJson<int>(json['unrealized']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'at': serializer.toJson<DateTime>(at),
      'base': serializer.toJson<String>(base),
      'netWorth': serializer.toJson<int>(netWorth),
      'assetsValue': serializer.toJson<int>(assetsValue),
      'unrealized': serializer.toJson<int>(unrealized),
    };
  }

  ValuationSnapshotRow copyWith({
    String? id,
    DateTime? at,
    String? base,
    int? netWorth,
    int? assetsValue,
    int? unrealized,
  }) => ValuationSnapshotRow(
    id: id ?? this.id,
    at: at ?? this.at,
    base: base ?? this.base,
    netWorth: netWorth ?? this.netWorth,
    assetsValue: assetsValue ?? this.assetsValue,
    unrealized: unrealized ?? this.unrealized,
  );
  ValuationSnapshotRow copyWithCompanion(ValuationSnapshotsCompanion data) {
    return ValuationSnapshotRow(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      base: data.base.present ? data.base.value : this.base,
      netWorth: data.netWorth.present ? data.netWorth.value : this.netWorth,
      assetsValue: data.assetsValue.present ? data.assetsValue.value : this.assetsValue,
      unrealized: data.unrealized.present ? data.unrealized.value : this.unrealized,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ValuationSnapshotRow(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('base: $base, ')
          ..write('netWorth: $netWorth, ')
          ..write('assetsValue: $assetsValue, ')
          ..write('unrealized: $unrealized')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, base, netWorth, assetsValue, unrealized);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ValuationSnapshotRow &&
          other.id == this.id &&
          other.at == this.at &&
          other.base == this.base &&
          other.netWorth == this.netWorth &&
          other.assetsValue == this.assetsValue &&
          other.unrealized == this.unrealized);
}

class ValuationSnapshotsCompanion extends UpdateCompanion<ValuationSnapshotRow> {
  final Value<String> id;
  final Value<DateTime> at;
  final Value<String> base;
  final Value<int> netWorth;
  final Value<int> assetsValue;
  final Value<int> unrealized;
  final Value<int> rowid;
  const ValuationSnapshotsCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.base = const Value.absent(),
    this.netWorth = const Value.absent(),
    this.assetsValue = const Value.absent(),
    this.unrealized = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ValuationSnapshotsCompanion.insert({
    required String id,
    required DateTime at,
    required String base,
    required int netWorth,
    required int assetsValue,
    required int unrealized,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       at = Value(at),
       base = Value(base),
       netWorth = Value(netWorth),
       assetsValue = Value(assetsValue),
       unrealized = Value(unrealized);
  static Insertable<ValuationSnapshotRow> custom({
    Expression<String>? id,
    Expression<DateTime>? at,
    Expression<String>? base,
    Expression<int>? netWorth,
    Expression<int>? assetsValue,
    Expression<int>? unrealized,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (base != null) 'base': base,
      if (netWorth != null) 'net_worth': netWorth,
      if (assetsValue != null) 'assets_value': assetsValue,
      if (unrealized != null) 'unrealized': unrealized,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ValuationSnapshotsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? at,
    Value<String>? base,
    Value<int>? netWorth,
    Value<int>? assetsValue,
    Value<int>? unrealized,
    Value<int>? rowid,
  }) {
    return ValuationSnapshotsCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      base: base ?? this.base,
      netWorth: netWorth ?? this.netWorth,
      assetsValue: assetsValue ?? this.assetsValue,
      unrealized: unrealized ?? this.unrealized,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (base.present) {
      map['base'] = Variable<String>(base.value);
    }
    if (netWorth.present) {
      map['net_worth'] = Variable<int>(netWorth.value);
    }
    if (assetsValue.present) {
      map['assets_value'] = Variable<int>(assetsValue.value);
    }
    if (unrealized.present) {
      map['unrealized'] = Variable<int>(unrealized.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ValuationSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('base: $base, ')
          ..write('netWorth: $netWorth, ')
          ..write('assetsValue: $assetsValue, ')
          ..write('unrealized: $unrealized, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomParsersTable extends CustomParsers with TableInfo<$CustomParsersTable, CustomParserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomParsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, json, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_parsers';
  @override
  VerificationContext validateIntegrity(Insertable<CustomParserRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('json')) {
      context.handle(_jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomParserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomParserRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      json: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}json'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomParsersTable createAlias(String alias) {
    return $CustomParsersTable(attachedDatabase, alias);
  }
}

class CustomParserRow extends DataClass implements Insertable<CustomParserRow> {
  final String id;
  final String json;
  final DateTime createdAt;
  const CustomParserRow({required this.id, required this.json, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['json'] = Variable<String>(json);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomParsersCompanion toCompanion(bool nullToAbsent) {
    return CustomParsersCompanion(id: Value(id), json: Value(json), createdAt: Value(createdAt));
  }

  factory CustomParserRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomParserRow(
      id: serializer.fromJson<String>(json['id']),
      json: serializer.fromJson<String>(json['json']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'json': serializer.toJson<String>(json),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomParserRow copyWith({String? id, String? json, DateTime? createdAt}) =>
      CustomParserRow(id: id ?? this.id, json: json ?? this.json, createdAt: createdAt ?? this.createdAt);
  CustomParserRow copyWithCompanion(CustomParsersCompanion data) {
    return CustomParserRow(
      id: data.id.present ? data.id.value : this.id,
      json: data.json.present ? data.json.value : this.json,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomParserRow(')
          ..write('id: $id, ')
          ..write('json: $json, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, json, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomParserRow && other.id == this.id && other.json == this.json && other.createdAt == this.createdAt);
}

class CustomParsersCompanion extends UpdateCompanion<CustomParserRow> {
  final Value<String> id;
  final Value<String> json;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CustomParsersCompanion({
    this.id = const Value.absent(),
    this.json = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomParsersCompanion.insert({
    required String id,
    required String json,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       json = Value(json),
       createdAt = Value(createdAt);
  static Insertable<CustomParserRow> custom({
    Expression<String>? id,
    Expression<String>? json,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (json != null) 'json': json,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomParsersCompanion copyWith({
    Value<String>? id,
    Value<String>? json,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CustomParsersCompanion(
      id: id ?? this.id,
      json: json ?? this.json,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomParsersCompanion(')
          ..write('id: $id, ')
          ..write('json: $json, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _limitMinorMeta = const VerificationMeta('limitMinor');
  @override
  late final GeneratedColumn<int> limitMinor = GeneratedColumn<int>(
    'limit_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, category, limitMinor, currency];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(Insertable<BudgetRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('limit_minor')) {
      context.handle(_limitMinorMeta, limitMinor.isAcceptableOrUnknown(data['limit_minor']!, _limitMinorMeta));
    } else if (isInserting) {
      context.missing(_limitMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      limitMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}limit_minor'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class BudgetRow extends DataClass implements Insertable<BudgetRow> {
  final String id;
  final String category;
  final int limitMinor;
  final String currency;
  const BudgetRow({required this.id, required this.category, required this.limitMinor, required this.currency});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['limit_minor'] = Variable<int>(limitMinor);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      category: Value(category),
      limitMinor: Value(limitMinor),
      currency: Value(currency),
    );
  }

  factory BudgetRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRow(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      limitMinor: serializer.fromJson<int>(json['limitMinor']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'limitMinor': serializer.toJson<int>(limitMinor),
      'currency': serializer.toJson<String>(currency),
    };
  }

  BudgetRow copyWith({String? id, String? category, int? limitMinor, String? currency}) => BudgetRow(
    id: id ?? this.id,
    category: category ?? this.category,
    limitMinor: limitMinor ?? this.limitMinor,
    currency: currency ?? this.currency,
  );
  BudgetRow copyWithCompanion(BudgetsCompanion data) {
    return BudgetRow(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      limitMinor: data.limitMinor.present ? data.limitMinor.value : this.limitMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRow(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('limitMinor: $limitMinor, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, limitMinor, currency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRow &&
          other.id == this.id &&
          other.category == this.category &&
          other.limitMinor == this.limitMinor &&
          other.currency == this.currency);
}

class BudgetsCompanion extends UpdateCompanion<BudgetRow> {
  final Value<String> id;
  final Value<String> category;
  final Value<int> limitMinor;
  final Value<String> currency;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.limitMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    required String category,
    required int limitMinor,
    required String currency,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       category = Value(category),
       limitMinor = Value(limitMinor),
       currency = Value(currency);
  static Insertable<BudgetRow> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<int>? limitMinor,
    Expression<String>? currency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (limitMinor != null) 'limit_minor': limitMinor,
      if (currency != null) 'currency': currency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<String>? id,
    Value<String>? category,
    Value<int>? limitMinor,
    Value<String>? currency,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      limitMinor: limitMinor ?? this.limitMinor,
      currency: currency ?? this.currency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (limitMinor.present) {
      map['limit_minor'] = Variable<int>(limitMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('limitMinor: $limitMinor, ')
          ..write('currency: $currency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringRulesTable extends RecurringRules with TableInfo<$RecurringRulesTable, RecurringRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isExpenseMeta = const VerificationMeta('isExpense');
  @override
  late final GeneratedColumn<bool> isExpense = GeneratedColumn<bool>(
    'is_expense',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_expense" IN (0, 1))'),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta('toAccountId');
  @override
  late final GeneratedColumn<String> toAccountId = GeneratedColumn<String>(
    'to_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _everyMeta = const VerificationMeta('every');
  @override
  late final GeneratedColumn<String> every = GeneratedColumn<String>(
    'every',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
    'start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastDoneMeta = const VerificationMeta('lastDone');
  @override
  late final GeneratedColumn<DateTime> lastDone = GeneratedColumn<DateTime>(
    'last_done',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    isExpense,
    accountId,
    toAccountId,
    category,
    amountMinor,
    currency,
    note,
    every,
    start,
    lastDone,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_rules';
  @override
  VerificationContext validateIntegrity(Insertable<RecurringRuleRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('is_expense')) {
      context.handle(_isExpenseMeta, isExpense.isAcceptableOrUnknown(data['is_expense']!, _isExpenseMeta));
    } else if (isInserting) {
      context.missing(_isExpenseMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta, accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('to_account_id')) {
      context.handle(_toAccountIdMeta, toAccountId.isAcceptableOrUnknown(data['to_account_id']!, _toAccountIdMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('amount_minor')) {
      context.handle(_amountMinorMeta, amountMinor.isAcceptableOrUnknown(data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('every')) {
      context.handle(_everyMeta, every.isAcceptableOrUnknown(data['every']!, _everyMeta));
    } else if (isInserting) {
      context.missing(_everyMeta);
    }
    if (data.containsKey('start')) {
      context.handle(_startMeta, start.isAcceptableOrUnknown(data['start']!, _startMeta));
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('last_done')) {
      context.handle(_lastDoneMeta, lastDone.isAcceptableOrUnknown(data['last_done']!, _lastDoneMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta, active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringRuleRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      isExpense: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_expense'])!,
      accountId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      toAccountId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}to_account_id']),
      category: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category']),
      amountMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      every: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}every'])!,
      start: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}start'])!,
      lastDone: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}last_done']),
      active: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
    );
  }

  @override
  $RecurringRulesTable createAlias(String alias) {
    return $RecurringRulesTable(attachedDatabase, alias);
  }
}

class RecurringRuleRow extends DataClass implements Insertable<RecurringRuleRow> {
  final String id;
  final bool isExpense;
  final String accountId;
  final String? toAccountId;
  final String? category;
  final int amountMinor;
  final String currency;
  final String note;
  final String every;
  final DateTime start;
  final DateTime? lastDone;
  final bool active;
  const RecurringRuleRow({
    required this.id,
    required this.isExpense,
    required this.accountId,
    this.toAccountId,
    this.category,
    required this.amountMinor,
    required this.currency,
    required this.note,
    required this.every,
    required this.start,
    this.lastDone,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['is_expense'] = Variable<bool>(isExpense);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<String>(toAccountId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    map['note'] = Variable<String>(note);
    map['every'] = Variable<String>(every);
    map['start'] = Variable<DateTime>(start);
    if (!nullToAbsent || lastDone != null) {
      map['last_done'] = Variable<DateTime>(lastDone);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  RecurringRulesCompanion toCompanion(bool nullToAbsent) {
    return RecurringRulesCompanion(
      id: Value(id),
      isExpense: Value(isExpense),
      accountId: Value(accountId),
      toAccountId: toAccountId == null && nullToAbsent ? const Value.absent() : Value(toAccountId),
      category: category == null && nullToAbsent ? const Value.absent() : Value(category),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      note: Value(note),
      every: Value(every),
      start: Value(start),
      lastDone: lastDone == null && nullToAbsent ? const Value.absent() : Value(lastDone),
      active: Value(active),
    );
  }

  factory RecurringRuleRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringRuleRow(
      id: serializer.fromJson<String>(json['id']),
      isExpense: serializer.fromJson<bool>(json['isExpense']),
      accountId: serializer.fromJson<String>(json['accountId']),
      toAccountId: serializer.fromJson<String?>(json['toAccountId']),
      category: serializer.fromJson<String?>(json['category']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      note: serializer.fromJson<String>(json['note']),
      every: serializer.fromJson<String>(json['every']),
      start: serializer.fromJson<DateTime>(json['start']),
      lastDone: serializer.fromJson<DateTime?>(json['lastDone']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'isExpense': serializer.toJson<bool>(isExpense),
      'accountId': serializer.toJson<String>(accountId),
      'toAccountId': serializer.toJson<String?>(toAccountId),
      'category': serializer.toJson<String?>(category),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'note': serializer.toJson<String>(note),
      'every': serializer.toJson<String>(every),
      'start': serializer.toJson<DateTime>(start),
      'lastDone': serializer.toJson<DateTime?>(lastDone),
      'active': serializer.toJson<bool>(active),
    };
  }

  RecurringRuleRow copyWith({
    String? id,
    bool? isExpense,
    String? accountId,
    Value<String?> toAccountId = const Value.absent(),
    Value<String?> category = const Value.absent(),
    int? amountMinor,
    String? currency,
    String? note,
    String? every,
    DateTime? start,
    Value<DateTime?> lastDone = const Value.absent(),
    bool? active,
  }) => RecurringRuleRow(
    id: id ?? this.id,
    isExpense: isExpense ?? this.isExpense,
    accountId: accountId ?? this.accountId,
    toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
    category: category.present ? category.value : this.category,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    note: note ?? this.note,
    every: every ?? this.every,
    start: start ?? this.start,
    lastDone: lastDone.present ? lastDone.value : this.lastDone,
    active: active ?? this.active,
  );
  RecurringRuleRow copyWithCompanion(RecurringRulesCompanion data) {
    return RecurringRuleRow(
      id: data.id.present ? data.id.value : this.id,
      isExpense: data.isExpense.present ? data.isExpense.value : this.isExpense,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      toAccountId: data.toAccountId.present ? data.toAccountId.value : this.toAccountId,
      category: data.category.present ? data.category.value : this.category,
      amountMinor: data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      note: data.note.present ? data.note.value : this.note,
      every: data.every.present ? data.every.value : this.every,
      start: data.start.present ? data.start.value : this.start,
      lastDone: data.lastDone.present ? data.lastDone.value : this.lastDone,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRuleRow(')
          ..write('id: $id, ')
          ..write('isExpense: $isExpense, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('category: $category, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('note: $note, ')
          ..write('every: $every, ')
          ..write('start: $start, ')
          ..write('lastDone: $lastDone, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    isExpense,
    accountId,
    toAccountId,
    category,
    amountMinor,
    currency,
    note,
    every,
    start,
    lastDone,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringRuleRow &&
          other.id == this.id &&
          other.isExpense == this.isExpense &&
          other.accountId == this.accountId &&
          other.toAccountId == this.toAccountId &&
          other.category == this.category &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.note == this.note &&
          other.every == this.every &&
          other.start == this.start &&
          other.lastDone == this.lastDone &&
          other.active == this.active);
}

class RecurringRulesCompanion extends UpdateCompanion<RecurringRuleRow> {
  final Value<String> id;
  final Value<bool> isExpense;
  final Value<String> accountId;
  final Value<String?> toAccountId;
  final Value<String?> category;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String> note;
  final Value<String> every;
  final Value<DateTime> start;
  final Value<DateTime?> lastDone;
  final Value<bool> active;
  final Value<int> rowid;
  const RecurringRulesCompanion({
    this.id = const Value.absent(),
    this.isExpense = const Value.absent(),
    this.accountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.category = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.note = const Value.absent(),
    this.every = const Value.absent(),
    this.start = const Value.absent(),
    this.lastDone = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringRulesCompanion.insert({
    required String id,
    required bool isExpense,
    required String accountId,
    this.toAccountId = const Value.absent(),
    this.category = const Value.absent(),
    required int amountMinor,
    required String currency,
    this.note = const Value.absent(),
    required String every,
    required DateTime start,
    this.lastDone = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       isExpense = Value(isExpense),
       accountId = Value(accountId),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       every = Value(every),
       start = Value(start);
  static Insertable<RecurringRuleRow> custom({
    Expression<String>? id,
    Expression<bool>? isExpense,
    Expression<String>? accountId,
    Expression<String>? toAccountId,
    Expression<String>? category,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? note,
    Expression<String>? every,
    Expression<DateTime>? start,
    Expression<DateTime>? lastDone,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isExpense != null) 'is_expense': isExpense,
      if (accountId != null) 'account_id': accountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (category != null) 'category': category,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (note != null) 'note': note,
      if (every != null) 'every': every,
      if (start != null) 'start': start,
      if (lastDone != null) 'last_done': lastDone,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringRulesCompanion copyWith({
    Value<String>? id,
    Value<bool>? isExpense,
    Value<String>? accountId,
    Value<String?>? toAccountId,
    Value<String?>? category,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<String>? note,
    Value<String>? every,
    Value<DateTime>? start,
    Value<DateTime?>? lastDone,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return RecurringRulesCompanion(
      id: id ?? this.id,
      isExpense: isExpense ?? this.isExpense,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      category: category ?? this.category,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      note: note ?? this.note,
      every: every ?? this.every,
      start: start ?? this.start,
      lastDone: lastDone ?? this.lastDone,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (isExpense.present) {
      map['is_expense'] = Variable<bool>(isExpense.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<String>(toAccountId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (every.present) {
      map['every'] = Variable<String>(every.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (lastDone.present) {
      map['last_done'] = Variable<DateTime>(lastDone.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRulesCompanion(')
          ..write('id: $id, ')
          ..write('isExpense: $isExpense, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('category: $category, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('note: $note, ')
          ..write('every: $every, ')
          ..write('start: $start, ')
          ..write('lastDone: $lastDone, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$KakaDatabase extends GeneratedDatabase {
  _$KakaDatabase(QueryExecutor e) : super(e);
  $KakaDatabaseManager get managers => $KakaDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $PostingsTable postings = $PostingsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $DraftsTable drafts = $DraftsTable(this);
  late final $SmsLinksTable smsLinks = $SmsLinksTable(this);
  late final $FxRatesTable fxRates = $FxRatesTable(this);
  late final $InstrumentsTable instruments = $InstrumentsTable(this);
  late final $PlatformsTable platforms = $PlatformsTable(this);
  late final $PortfolioEventsTable portfolioEvents = $PortfolioEventsTable(this);
  late final $PriceQuotesTable priceQuotes = $PriceQuotesTable(this);
  late final $ValuationSnapshotsTable valuationSnapshots = $ValuationSnapshotsTable(this);
  late final $CustomParsersTable customParsers = $CustomParsersTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $RecurringRulesTable recurringRules = $RecurringRulesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    transactions,
    postings,
    settings,
    drafts,
    smsLinks,
    fxRates,
    instruments,
    platforms,
    portfolioEvents,
    priceQuotes,
    valuationSnapshots,
    customParsers,
    budgets,
    recurringRules,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      required String id,
      required String name,
      required String type,
      required String currency,
      Value<bool> isSystem,
      Value<bool> archived,
      required DateTime createdAt,
      Value<String?> icon,
      Value<int> rowid,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String> currency,
      Value<bool> isSystem,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<String?> icon,
      Value<int> rowid,
    });

final class $$AccountsTableReferences extends BaseReferences<_$KakaDatabase, $AccountsTable, AccountRow> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PostingsTable, List<PostingRow>> _postingsRefsTable(_$KakaDatabase db) =>
      MultiTypedResultKey.fromTable(db.postings, aliasName: 'accounts__id__postings__account_id');

  $$PostingsTableProcessedTableManager get postingsRefs {
    final manager = $$PostingsTableTableManager(
      $_db,
      $_db.postings,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_postingsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AccountsTableFilterComposer extends Composer<_$KakaDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(column: $table.icon, builder: (column) => ColumnFilters(column));

  Expression<bool> postingsRefs(Expression<bool> Function($$PostingsTableFilterComposer f) f) {
    final $$PostingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postings,
      getReferencedColumn: (t) => t.accountId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostingsTableFilterComposer(
            $db: $db,
            $table: $db.postings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer extends Composer<_$KakaDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableAnnotationComposer extends Composer<_$KakaDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type => $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get isSystem => $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get archived => $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get icon => $composableBuilder(column: $table.icon, builder: (column) => column);

  Expression<T> postingsRefs<T extends Object>(Expression<T> Function($$PostingsTableAnnotationComposer a) f) {
    final $$PostingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postings,
      getReferencedColumn: (t) => t.accountId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostingsTableAnnotationComposer(
            $db: $db,
            $table: $db.postings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $AccountsTable,
          AccountRow,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (AccountRow, $$AccountsTableReferences),
          AccountRow,
          PrefetchHooks Function({bool postingsRefs})
        > {
  $$AccountsTableTableManager(_$KakaDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                type: type,
                currency: currency,
                isSystem: isSystem,
                archived: archived,
                createdAt: createdAt,
                icon: icon,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required String currency,
                Value<bool> isSystem = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                Value<String?> icon = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                type: type,
                currency: currency,
                isSystem: isSystem,
                archived: archived,
                createdAt: createdAt,
                icon: icon,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable<$AccountsTable, AccountRow>(table), $$AccountsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({postingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (postingsRefs) db.postings],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (postingsRefs)
                    await $_getPrefetchedData<AccountRow, $AccountsTable, PostingRow>(
                      currentTable: table,
                      referencedTable: $$AccountsTableReferences._postingsRefsTable(db),
                      managerFromTypedResult: (p0) => $$AccountsTableReferences(db, table, p0).postingsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.accountId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $AccountsTable,
      AccountRow,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (AccountRow, $$AccountsTableReferences),
      AccountRow,
      PrefetchHooks Function({bool postingsRefs})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required String kind,
      required DateTime occurredAt,
      Value<String> note,
      Value<DateTime?> voidedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<DateTime> occurredAt,
      Value<String> note,
      Value<DateTime?> voidedAt,
      Value<int> rowid,
    });

final class $$TransactionsTableReferences extends BaseReferences<_$KakaDatabase, $TransactionsTable, TransactionRow> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PostingsTable, List<PostingRow>> _postingsRefsTable(_$KakaDatabase db) =>
      MultiTypedResultKey.fromTable(db.postings, aliasName: 'transactions__id__postings__txn_id');

  $$PostingsTableProcessedTableManager get postingsRefs {
    final manager = $$PostingsTableTableManager(
      $_db,
      $_db.postings,
    ).filter((f) => f.txnId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_postingsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TransactionsTableFilterComposer extends Composer<_$KakaDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> postingsRefs(Expression<bool> Function($$PostingsTableFilterComposer f) f) {
    final $$PostingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postings,
      getReferencedColumn: (t) => t.txnId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostingsTableFilterComposer(
            $db: $db,
            $table: $db.postings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer extends Composer<_$KakaDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer extends Composer<_$KakaDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<String> get note => $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get voidedAt => $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  Expression<T> postingsRefs<T extends Object>(Expression<T> Function($$PostingsTableAnnotationComposer a) f) {
    final $$PostingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postings,
      getReferencedColumn: (t) => t.txnId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostingsTableAnnotationComposer(
            $db: $db,
            $table: $db.postings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $TransactionsTable,
          TransactionRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (TransactionRow, $$TransactionsTableReferences),
          TransactionRow,
          PrefetchHooks Function({bool postingsRefs})
        > {
  $$TransactionsTableTableManager(_$KakaDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                kind: kind,
                occurredAt: occurredAt,
                note: note,
                voidedAt: voidedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required DateTime occurredAt,
                Value<String> note = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                kind: kind,
                occurredAt: occurredAt,
                note: note,
                voidedAt: voidedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, TransactionRow>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({postingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (postingsRefs) db.postings],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (postingsRefs)
                    await $_getPrefetchedData<TransactionRow, $TransactionsTable, PostingRow>(
                      currentTable: table,
                      referencedTable: $$TransactionsTableReferences._postingsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TransactionsTableReferences(db, table, p0).postingsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.txnId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $TransactionsTable,
      TransactionRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (TransactionRow, $$TransactionsTableReferences),
      TransactionRow,
      PrefetchHooks Function({bool postingsRefs})
    >;
typedef $$PostingsTableCreateCompanionBuilder =
    PostingsCompanion Function({
      required String id,
      required String txnId,
      required String accountId,
      required int amountMinor,
      required String currency,
      Value<int> rowid,
    });
typedef $$PostingsTableUpdateCompanionBuilder =
    PostingsCompanion Function({
      Value<String> id,
      Value<String> txnId,
      Value<String> accountId,
      Value<int> amountMinor,
      Value<String> currency,
      Value<int> rowid,
    });

final class $$PostingsTableReferences extends BaseReferences<_$KakaDatabase, $PostingsTable, PostingRow> {
  $$PostingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TransactionsTable _txnIdTable(_$KakaDatabase db) =>
      db.transactions.createAlias('postings__txn_id__transactions__id');

  $$TransactionsTableProcessedTableManager get txnId {
    final $_column = $_itemColumn<String>('txn_id')!;

    final manager = $$TransactionsTableTableManager($_db, $_db.transactions).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_txnIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AccountsTable _accountIdTable(_$KakaDatabase db) =>
      db.accounts.createAlias('postings__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager($_db, $_db.accounts).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PostingsTableFilterComposer extends Composer<_$KakaDatabase, $PostingsTable> {
  $$PostingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));

  $$TransactionsTableFilterComposer get txnId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.txnId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostingsTableOrderingComposer extends Composer<_$KakaDatabase, $PostingsTable> {
  $$PostingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));

  $$TransactionsTableOrderingComposer get txnId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.txnId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostingsTableAnnotationComposer extends Composer<_$KakaDatabase, $PostingsTable> {
  $$PostingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get txnId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.txnId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostingsTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $PostingsTable,
          PostingRow,
          $$PostingsTableFilterComposer,
          $$PostingsTableOrderingComposer,
          $$PostingsTableAnnotationComposer,
          $$PostingsTableCreateCompanionBuilder,
          $$PostingsTableUpdateCompanionBuilder,
          (PostingRow, $$PostingsTableReferences),
          PostingRow,
          PrefetchHooks Function({bool txnId, bool accountId})
        > {
  $$PostingsTableTableManager(_$KakaDatabase db, $PostingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PostingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PostingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PostingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> txnId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostingsCompanion(
                id: id,
                txnId: txnId,
                accountId: accountId,
                amountMinor: amountMinor,
                currency: currency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String txnId,
                required String accountId,
                required int amountMinor,
                required String currency,
                Value<int> rowid = const Value.absent(),
              }) => PostingsCompanion.insert(
                id: id,
                txnId: txnId,
                accountId: accountId,
                amountMinor: amountMinor,
                currency: currency,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable<$PostingsTable, PostingRow>(table), $$PostingsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({txnId = false, accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (txnId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.txnId,
                                referencedTable: $$PostingsTableReferences._txnIdTable(db),
                                referencedColumn: $$PostingsTableReferences._txnIdTable(db).id,
                              )
                              as T;
                    }
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$PostingsTableReferences._accountIdTable(db),
                                referencedColumn: $$PostingsTableReferences._accountIdTable(db).id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PostingsTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $PostingsTable,
      PostingRow,
      $$PostingsTableFilterComposer,
      $$PostingsTableOrderingComposer,
      $$PostingsTableAnnotationComposer,
      $$PostingsTableCreateCompanionBuilder,
      $$PostingsTableUpdateCompanionBuilder,
      (PostingRow, $$PostingsTableReferences),
      PostingRow,
      PrefetchHooks Function({bool txnId, bool accountId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({required String key, required String value, Value<int> rowid});
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({Value<String> key, Value<String> value, Value<int> rowid});

class $$SettingsTableFilterComposer extends Composer<_$KakaDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer extends Composer<_$KakaDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer extends Composer<_$KakaDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key => $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value => $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $SettingsTable,
          SettingRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (SettingRow, BaseReferences<_$KakaDatabase, $SettingsTable, SettingRow>),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$KakaDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({required String key, required String value, Value<int> rowid = const Value.absent()}) =>
                  SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, SettingRow>(table),
                  BaseReferences<_$KakaDatabase, $SettingsTable, SettingRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $SettingsTable,
      SettingRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingRow, BaseReferences<_$KakaDatabase, $SettingsTable, SettingRow>),
      SettingRow,
      PrefetchHooks Function()
    >;
typedef $$DraftsTableCreateCompanionBuilder =
    DraftsCompanion Function({
      required String id,
      required String source,
      required String status,
      required bool isExpense,
      required int amountMinor,
      required String currency,
      required DateTime createdAt,
      Value<DateTime?> occurredAt,
      Value<String> rawText,
      Value<String> note,
      Value<String?> bankId,
      Value<String?> last4,
      Value<String?> dedupKey,
      Value<String?> accountId,
      Value<int?> balanceMinor,
      Value<String?> sender,
      Value<double?> confidence,
      Value<String?> toAccountId,
      Value<String?> category,
      Value<int> rowid,
    });
typedef $$DraftsTableUpdateCompanionBuilder =
    DraftsCompanion Function({
      Value<String> id,
      Value<String> source,
      Value<String> status,
      Value<bool> isExpense,
      Value<int> amountMinor,
      Value<String> currency,
      Value<DateTime> createdAt,
      Value<DateTime?> occurredAt,
      Value<String> rawText,
      Value<String> note,
      Value<String?> bankId,
      Value<String?> last4,
      Value<String?> dedupKey,
      Value<String?> accountId,
      Value<int?> balanceMinor,
      Value<String?> sender,
      Value<double?> confidence,
      Value<String?> toAccountId,
      Value<String?> category,
      Value<int> rowid,
    });

class $$DraftsTableFilterComposer extends Composer<_$KakaDatabase, $DraftsTable> {
  $$DraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isExpense =>
      $composableBuilder(column: $table.isExpense, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankId =>
      $composableBuilder(column: $table.bankId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dedupKey =>
      $composableBuilder(column: $table.dedupKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balanceMinor =>
      $composableBuilder(column: $table.balanceMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence =>
      $composableBuilder(column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toAccountId =>
      $composableBuilder(column: $table.toAccountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnFilters(column));
}

class $$DraftsTableOrderingComposer extends Composer<_$KakaDatabase, $DraftsTable> {
  $$DraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isExpense =>
      $composableBuilder(column: $table.isExpense, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankId =>
      $composableBuilder(column: $table.bankId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dedupKey =>
      $composableBuilder(column: $table.dedupKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balanceMinor =>
      $composableBuilder(column: $table.balanceMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence =>
      $composableBuilder(column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toAccountId =>
      $composableBuilder(column: $table.toAccountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnOrderings(column));
}

class $$DraftsTableAnnotationComposer extends Composer<_$KakaDatabase, $DraftsTable> {
  $$DraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source => $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get status => $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isExpense => $composableBuilder(column: $table.isExpense, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<String> get rawText => $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<String> get note => $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get bankId => $composableBuilder(column: $table.bankId, builder: (column) => column);

  GeneratedColumn<String> get last4 => $composableBuilder(column: $table.last4, builder: (column) => column);

  GeneratedColumn<String> get dedupKey => $composableBuilder(column: $table.dedupKey, builder: (column) => column);

  GeneratedColumn<String> get accountId => $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get balanceMinor => $composableBuilder(column: $table.balanceMinor, builder: (column) => column);

  GeneratedColumn<String> get sender => $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(column: $table.confidence, builder: (column) => column);

  GeneratedColumn<String> get toAccountId =>
      $composableBuilder(column: $table.toAccountId, builder: (column) => column);

  GeneratedColumn<String> get category => $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$DraftsTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $DraftsTable,
          DraftRow,
          $$DraftsTableFilterComposer,
          $$DraftsTableOrderingComposer,
          $$DraftsTableAnnotationComposer,
          $$DraftsTableCreateCompanionBuilder,
          $$DraftsTableUpdateCompanionBuilder,
          (DraftRow, BaseReferences<_$KakaDatabase, $DraftsTable, DraftRow>),
          DraftRow,
          PrefetchHooks Function()
        > {
  $$DraftsTableTableManager(_$KakaDatabase db, $DraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$DraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$DraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$DraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isExpense = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> occurredAt = const Value.absent(),
                Value<String> rawText = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> bankId = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<String?> dedupKey = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<int?> balanceMinor = const Value.absent(),
                Value<String?> sender = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DraftsCompanion(
                id: id,
                source: source,
                status: status,
                isExpense: isExpense,
                amountMinor: amountMinor,
                currency: currency,
                createdAt: createdAt,
                occurredAt: occurredAt,
                rawText: rawText,
                note: note,
                bankId: bankId,
                last4: last4,
                dedupKey: dedupKey,
                accountId: accountId,
                balanceMinor: balanceMinor,
                sender: sender,
                confidence: confidence,
                toAccountId: toAccountId,
                category: category,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String source,
                required String status,
                required bool isExpense,
                required int amountMinor,
                required String currency,
                required DateTime createdAt,
                Value<DateTime?> occurredAt = const Value.absent(),
                Value<String> rawText = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> bankId = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<String?> dedupKey = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<int?> balanceMinor = const Value.absent(),
                Value<String?> sender = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DraftsCompanion.insert(
                id: id,
                source: source,
                status: status,
                isExpense: isExpense,
                amountMinor: amountMinor,
                currency: currency,
                createdAt: createdAt,
                occurredAt: occurredAt,
                rawText: rawText,
                note: note,
                bankId: bankId,
                last4: last4,
                dedupKey: dedupKey,
                accountId: accountId,
                balanceMinor: balanceMinor,
                sender: sender,
                confidence: confidence,
                toAccountId: toAccountId,
                category: category,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DraftsTable, DraftRow>(table),
                  BaseReferences<_$KakaDatabase, $DraftsTable, DraftRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $DraftsTable,
      DraftRow,
      $$DraftsTableFilterComposer,
      $$DraftsTableOrderingComposer,
      $$DraftsTableAnnotationComposer,
      $$DraftsTableCreateCompanionBuilder,
      $$DraftsTableUpdateCompanionBuilder,
      (DraftRow, BaseReferences<_$KakaDatabase, $DraftsTable, DraftRow>),
      DraftRow,
      PrefetchHooks Function()
    >;
typedef $$SmsLinksTableCreateCompanionBuilder =
    SmsLinksCompanion Function({
      required String id,
      Value<String?> sender,
      Value<String?> accountId,
      Value<String?> accountNumber,
      Value<int> rowid,
    });
typedef $$SmsLinksTableUpdateCompanionBuilder =
    SmsLinksCompanion Function({
      Value<String> id,
      Value<String?> sender,
      Value<String?> accountId,
      Value<String?> accountNumber,
      Value<int> rowid,
    });

class $$SmsLinksTableFilterComposer extends Composer<_$KakaDatabase, $SmsLinksTable> {
  $$SmsLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountNumber =>
      $composableBuilder(column: $table.accountNumber, builder: (column) => ColumnFilters(column));
}

class $$SmsLinksTableOrderingComposer extends Composer<_$KakaDatabase, $SmsLinksTable> {
  $$SmsLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountNumber =>
      $composableBuilder(column: $table.accountNumber, builder: (column) => ColumnOrderings(column));
}

class $$SmsLinksTableAnnotationComposer extends Composer<_$KakaDatabase, $SmsLinksTable> {
  $$SmsLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sender => $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get accountId => $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get accountNumber =>
      $composableBuilder(column: $table.accountNumber, builder: (column) => column);
}

class $$SmsLinksTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $SmsLinksTable,
          SmsLinkRow,
          $$SmsLinksTableFilterComposer,
          $$SmsLinksTableOrderingComposer,
          $$SmsLinksTableAnnotationComposer,
          $$SmsLinksTableCreateCompanionBuilder,
          $$SmsLinksTableUpdateCompanionBuilder,
          (SmsLinkRow, BaseReferences<_$KakaDatabase, $SmsLinksTable, SmsLinkRow>),
          SmsLinkRow,
          PrefetchHooks Function()
        > {
  $$SmsLinksTableTableManager(_$KakaDatabase db, $SmsLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SmsLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SmsLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SmsLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> sender = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SmsLinksCompanion(
                id: id,
                sender: sender,
                accountId: accountId,
                accountNumber: accountNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> sender = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SmsLinksCompanion.insert(
                id: id,
                sender: sender,
                accountId: accountId,
                accountNumber: accountNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SmsLinksTable, SmsLinkRow>(table),
                  BaseReferences<_$KakaDatabase, $SmsLinksTable, SmsLinkRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SmsLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $SmsLinksTable,
      SmsLinkRow,
      $$SmsLinksTableFilterComposer,
      $$SmsLinksTableOrderingComposer,
      $$SmsLinksTableAnnotationComposer,
      $$SmsLinksTableCreateCompanionBuilder,
      $$SmsLinksTableUpdateCompanionBuilder,
      (SmsLinkRow, BaseReferences<_$KakaDatabase, $SmsLinksTable, SmsLinkRow>),
      SmsLinkRow,
      PrefetchHooks Function()
    >;
typedef $$FxRatesTableCreateCompanionBuilder =
    FxRatesCompanion Function({
      required String id,
      required String currency,
      required String base,
      required DateTime rateDate,
      required String rate,
      Value<int> rowid,
    });
typedef $$FxRatesTableUpdateCompanionBuilder =
    FxRatesCompanion Function({
      Value<String> id,
      Value<String> currency,
      Value<String> base,
      Value<DateTime> rateDate,
      Value<String> rate,
      Value<int> rowid,
    });

class $$FxRatesTableFilterComposer extends Composer<_$KakaDatabase, $FxRatesTable> {
  $$FxRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get base => $composableBuilder(column: $table.base, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get rateDate =>
      $composableBuilder(column: $table.rateDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rate => $composableBuilder(column: $table.rate, builder: (column) => ColumnFilters(column));
}

class $$FxRatesTableOrderingComposer extends Composer<_$KakaDatabase, $FxRatesTable> {
  $$FxRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get base =>
      $composableBuilder(column: $table.base, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get rateDate =>
      $composableBuilder(column: $table.rateDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => ColumnOrderings(column));
}

class $$FxRatesTableAnnotationComposer extends Composer<_$KakaDatabase, $FxRatesTable> {
  $$FxRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get base => $composableBuilder(column: $table.base, builder: (column) => column);

  GeneratedColumn<DateTime> get rateDate => $composableBuilder(column: $table.rateDate, builder: (column) => column);

  GeneratedColumn<String> get rate => $composableBuilder(column: $table.rate, builder: (column) => column);
}

class $$FxRatesTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $FxRatesTable,
          FxRateRow,
          $$FxRatesTableFilterComposer,
          $$FxRatesTableOrderingComposer,
          $$FxRatesTableAnnotationComposer,
          $$FxRatesTableCreateCompanionBuilder,
          $$FxRatesTableUpdateCompanionBuilder,
          (FxRateRow, BaseReferences<_$KakaDatabase, $FxRatesTable, FxRateRow>),
          FxRateRow,
          PrefetchHooks Function()
        > {
  $$FxRatesTableTableManager(_$KakaDatabase db, $FxRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$FxRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$FxRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$FxRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> base = const Value.absent(),
                Value<DateTime> rateDate = const Value.absent(),
                Value<String> rate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FxRatesCompanion(
                id: id,
                currency: currency,
                base: base,
                rateDate: rateDate,
                rate: rate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String currency,
                required String base,
                required DateTime rateDate,
                required String rate,
                Value<int> rowid = const Value.absent(),
              }) => FxRatesCompanion.insert(
                id: id,
                currency: currency,
                base: base,
                rateDate: rateDate,
                rate: rate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FxRatesTable, FxRateRow>(table),
                  BaseReferences<_$KakaDatabase, $FxRatesTable, FxRateRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FxRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $FxRatesTable,
      FxRateRow,
      $$FxRatesTableFilterComposer,
      $$FxRatesTableOrderingComposer,
      $$FxRatesTableAnnotationComposer,
      $$FxRatesTableCreateCompanionBuilder,
      $$FxRatesTableUpdateCompanionBuilder,
      (FxRateRow, BaseReferences<_$KakaDatabase, $FxRatesTable, FxRateRow>),
      FxRateRow,
      PrefetchHooks Function()
    >;
typedef $$InstrumentsTableCreateCompanionBuilder =
    InstrumentsCompanion Function({
      required String id,
      required String assetClass,
      required String nameFa,
      required String nameEn,
      required String unitFa,
      required String unitEn,
      required int qtyScale,
      Value<String> symbol,
      Value<String?> quoteCurrency,
      Value<String> costMethod,
      Value<String?> catalogId,
      Value<bool> archived,
      Value<int> rowid,
    });
typedef $$InstrumentsTableUpdateCompanionBuilder =
    InstrumentsCompanion Function({
      Value<String> id,
      Value<String> assetClass,
      Value<String> nameFa,
      Value<String> nameEn,
      Value<String> unitFa,
      Value<String> unitEn,
      Value<int> qtyScale,
      Value<String> symbol,
      Value<String?> quoteCurrency,
      Value<String> costMethod,
      Value<String?> catalogId,
      Value<bool> archived,
      Value<int> rowid,
    });

final class $$InstrumentsTableReferences extends BaseReferences<_$KakaDatabase, $InstrumentsTable, InstrumentRow> {
  $$InstrumentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PortfolioEventsTable, List<PortfolioEventRow>> _portfolioEventsRefsTable(
    _$KakaDatabase db,
  ) => MultiTypedResultKey.fromTable(db.portfolioEvents, aliasName: 'instruments__id__portfolio_events__instrument_id');

  $$PortfolioEventsTableProcessedTableManager get portfolioEventsRefs {
    final manager = $$PortfolioEventsTableTableManager(
      $_db,
      $_db.portfolioEvents,
    ).filter((f) => f.instrumentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_portfolioEventsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PriceQuotesTable, List<PriceQuoteRow>> _priceQuotesRefsTable(_$KakaDatabase db) =>
      MultiTypedResultKey.fromTable(db.priceQuotes, aliasName: 'instruments__id__price_quotes__instrument_id');

  $$PriceQuotesTableProcessedTableManager get priceQuotesRefs {
    final manager = $$PriceQuotesTableTableManager(
      $_db,
      $_db.priceQuotes,
    ).filter((f) => f.instrumentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_priceQuotesRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InstrumentsTableFilterComposer extends Composer<_$KakaDatabase, $InstrumentsTable> {
  $$InstrumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assetClass =>
      $composableBuilder(column: $table.assetClass, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameFa =>
      $composableBuilder(column: $table.nameFa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitFa =>
      $composableBuilder(column: $table.unitFa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitEn =>
      $composableBuilder(column: $table.unitEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get qtyScale =>
      $composableBuilder(column: $table.qtyScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quoteCurrency =>
      $composableBuilder(column: $table.quoteCurrency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get costMethod =>
      $composableBuilder(column: $table.costMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnFilters(column));

  Expression<bool> portfolioEventsRefs(Expression<bool> Function($$PortfolioEventsTableFilterComposer f) f) {
    final $$PortfolioEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.portfolioEvents,
      getReferencedColumn: (t) => t.instrumentId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PortfolioEventsTableFilterComposer(
            $db: $db,
            $table: $db.portfolioEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> priceQuotesRefs(Expression<bool> Function($$PriceQuotesTableFilterComposer f) f) {
    final $$PriceQuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.priceQuotes,
      getReferencedColumn: (t) => t.instrumentId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PriceQuotesTableFilterComposer(
            $db: $db,
            $table: $db.priceQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InstrumentsTableOrderingComposer extends Composer<_$KakaDatabase, $InstrumentsTable> {
  $$InstrumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assetClass =>
      $composableBuilder(column: $table.assetClass, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameFa =>
      $composableBuilder(column: $table.nameFa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitFa =>
      $composableBuilder(column: $table.unitFa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitEn =>
      $composableBuilder(column: $table.unitEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get qtyScale =>
      $composableBuilder(column: $table.qtyScale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quoteCurrency =>
      $composableBuilder(column: $table.quoteCurrency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get costMethod =>
      $composableBuilder(column: $table.costMethod, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnOrderings(column));
}

class $$InstrumentsTableAnnotationComposer extends Composer<_$KakaDatabase, $InstrumentsTable> {
  $$InstrumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assetClass => $composableBuilder(column: $table.assetClass, builder: (column) => column);

  GeneratedColumn<String> get nameFa => $composableBuilder(column: $table.nameFa, builder: (column) => column);

  GeneratedColumn<String> get nameEn => $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get unitFa => $composableBuilder(column: $table.unitFa, builder: (column) => column);

  GeneratedColumn<String> get unitEn => $composableBuilder(column: $table.unitEn, builder: (column) => column);

  GeneratedColumn<int> get qtyScale => $composableBuilder(column: $table.qtyScale, builder: (column) => column);

  GeneratedColumn<String> get symbol => $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get quoteCurrency =>
      $composableBuilder(column: $table.quoteCurrency, builder: (column) => column);

  GeneratedColumn<String> get costMethod => $composableBuilder(column: $table.costMethod, builder: (column) => column);

  GeneratedColumn<String> get catalogId => $composableBuilder(column: $table.catalogId, builder: (column) => column);

  GeneratedColumn<bool> get archived => $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> portfolioEventsRefs<T extends Object>(
    Expression<T> Function($$PortfolioEventsTableAnnotationComposer a) f,
  ) {
    final $$PortfolioEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.portfolioEvents,
      getReferencedColumn: (t) => t.instrumentId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PortfolioEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.portfolioEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> priceQuotesRefs<T extends Object>(Expression<T> Function($$PriceQuotesTableAnnotationComposer a) f) {
    final $$PriceQuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.priceQuotes,
      getReferencedColumn: (t) => t.instrumentId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PriceQuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.priceQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InstrumentsTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $InstrumentsTable,
          InstrumentRow,
          $$InstrumentsTableFilterComposer,
          $$InstrumentsTableOrderingComposer,
          $$InstrumentsTableAnnotationComposer,
          $$InstrumentsTableCreateCompanionBuilder,
          $$InstrumentsTableUpdateCompanionBuilder,
          (InstrumentRow, $$InstrumentsTableReferences),
          InstrumentRow,
          PrefetchHooks Function({bool portfolioEventsRefs, bool priceQuotesRefs})
        > {
  $$InstrumentsTableTableManager(_$KakaDatabase db, $InstrumentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$InstrumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$InstrumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$InstrumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> assetClass = const Value.absent(),
                Value<String> nameFa = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> unitFa = const Value.absent(),
                Value<String> unitEn = const Value.absent(),
                Value<int> qtyScale = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<String?> quoteCurrency = const Value.absent(),
                Value<String> costMethod = const Value.absent(),
                Value<String?> catalogId = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstrumentsCompanion(
                id: id,
                assetClass: assetClass,
                nameFa: nameFa,
                nameEn: nameEn,
                unitFa: unitFa,
                unitEn: unitEn,
                qtyScale: qtyScale,
                symbol: symbol,
                quoteCurrency: quoteCurrency,
                costMethod: costMethod,
                catalogId: catalogId,
                archived: archived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String assetClass,
                required String nameFa,
                required String nameEn,
                required String unitFa,
                required String unitEn,
                required int qtyScale,
                Value<String> symbol = const Value.absent(),
                Value<String?> quoteCurrency = const Value.absent(),
                Value<String> costMethod = const Value.absent(),
                Value<String?> catalogId = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstrumentsCompanion.insert(
                id: id,
                assetClass: assetClass,
                nameFa: nameFa,
                nameEn: nameEn,
                unitFa: unitFa,
                unitEn: unitEn,
                qtyScale: qtyScale,
                symbol: symbol,
                quoteCurrency: quoteCurrency,
                costMethod: costMethod,
                catalogId: catalogId,
                archived: archived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable<$InstrumentsTable, InstrumentRow>(table), $$InstrumentsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({portfolioEventsRefs = false, priceQuotesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (portfolioEventsRefs) db.portfolioEvents,
                if (priceQuotesRefs) db.priceQuotes,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (portfolioEventsRefs)
                    await $_getPrefetchedData<InstrumentRow, $InstrumentsTable, PortfolioEventRow>(
                      currentTable: table,
                      referencedTable: $$InstrumentsTableReferences._portfolioEventsRefsTable(db),
                      managerFromTypedResult: (p0) => $$InstrumentsTableReferences(db, table, p0).portfolioEventsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.instrumentId == item.id),
                      typedResults: items,
                    ),
                  if (priceQuotesRefs)
                    await $_getPrefetchedData<InstrumentRow, $InstrumentsTable, PriceQuoteRow>(
                      currentTable: table,
                      referencedTable: $$InstrumentsTableReferences._priceQuotesRefsTable(db),
                      managerFromTypedResult: (p0) => $$InstrumentsTableReferences(db, table, p0).priceQuotesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.instrumentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$InstrumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $InstrumentsTable,
      InstrumentRow,
      $$InstrumentsTableFilterComposer,
      $$InstrumentsTableOrderingComposer,
      $$InstrumentsTableAnnotationComposer,
      $$InstrumentsTableCreateCompanionBuilder,
      $$InstrumentsTableUpdateCompanionBuilder,
      (InstrumentRow, $$InstrumentsTableReferences),
      InstrumentRow,
      PrefetchHooks Function({bool portfolioEventsRefs, bool priceQuotesRefs})
    >;
typedef $$PlatformsTableCreateCompanionBuilder =
    PlatformsCompanion Function({
      required String id,
      required String name,
      required String kind,
      Value<bool> archived,
      Value<int> rowid,
    });
typedef $$PlatformsTableUpdateCompanionBuilder =
    PlatformsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> kind,
      Value<bool> archived,
      Value<int> rowid,
    });

class $$PlatformsTableFilterComposer extends Composer<_$KakaDatabase, $PlatformsTable> {
  $$PlatformsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnFilters(column));
}

class $$PlatformsTableOrderingComposer extends Composer<_$KakaDatabase, $PlatformsTable> {
  $$PlatformsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnOrderings(column));
}

class $$PlatformsTableAnnotationComposer extends Composer<_$KakaDatabase, $PlatformsTable> {
  $$PlatformsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<bool> get archived => $composableBuilder(column: $table.archived, builder: (column) => column);
}

class $$PlatformsTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $PlatformsTable,
          PlatformRow,
          $$PlatformsTableFilterComposer,
          $$PlatformsTableOrderingComposer,
          $$PlatformsTableAnnotationComposer,
          $$PlatformsTableCreateCompanionBuilder,
          $$PlatformsTableUpdateCompanionBuilder,
          (PlatformRow, BaseReferences<_$KakaDatabase, $PlatformsTable, PlatformRow>),
          PlatformRow,
          PrefetchHooks Function()
        > {
  $$PlatformsTableTableManager(_$KakaDatabase db, $PlatformsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlatformsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlatformsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlatformsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlatformsCompanion(id: id, name: name, kind: kind, archived: archived, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String kind,
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlatformsCompanion.insert(id: id, name: name, kind: kind, archived: archived, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlatformsTable, PlatformRow>(table),
                  BaseReferences<_$KakaDatabase, $PlatformsTable, PlatformRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlatformsTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $PlatformsTable,
      PlatformRow,
      $$PlatformsTableFilterComposer,
      $$PlatformsTableOrderingComposer,
      $$PlatformsTableAnnotationComposer,
      $$PlatformsTableCreateCompanionBuilder,
      $$PlatformsTableUpdateCompanionBuilder,
      (PlatformRow, BaseReferences<_$KakaDatabase, $PlatformsTable, PlatformRow>),
      PlatformRow,
      PrefetchHooks Function()
    >;
typedef $$PortfolioEventsTableCreateCompanionBuilder =
    PortfolioEventsCompanion Function({
      required String id,
      required String instrumentId,
      Value<String?> platformId,
      required String kind,
      required DateTime at,
      required String currency,
      Value<int> qty,
      Value<int?> gross,
      Value<int> fee,
      Value<String> costMode,
      Value<int?> cost,
      Value<int?> splitNum,
      Value<int?> splitDen,
      Value<String?> groupId,
      Value<String?> cashAccountId,
      Value<String?> txnId,
      Value<String?> txnSig,
      Value<String> source,
      Value<String> note,
      Value<DateTime?> voidedAt,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$PortfolioEventsTableUpdateCompanionBuilder =
    PortfolioEventsCompanion Function({
      Value<String> id,
      Value<String> instrumentId,
      Value<String?> platformId,
      Value<String> kind,
      Value<DateTime> at,
      Value<String> currency,
      Value<int> qty,
      Value<int?> gross,
      Value<int> fee,
      Value<String> costMode,
      Value<int?> cost,
      Value<int?> splitNum,
      Value<int?> splitDen,
      Value<String?> groupId,
      Value<String?> cashAccountId,
      Value<String?> txnId,
      Value<String?> txnSig,
      Value<String> source,
      Value<String> note,
      Value<DateTime?> voidedAt,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

final class $$PortfolioEventsTableReferences
    extends BaseReferences<_$KakaDatabase, $PortfolioEventsTable, PortfolioEventRow> {
  $$PortfolioEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InstrumentsTable _instrumentIdTable(_$KakaDatabase db) =>
      db.instruments.createAlias('portfolio_events__instrument_id__instruments__id');

  $$InstrumentsTableProcessedTableManager get instrumentId {
    final $_column = $_itemColumn<String>('instrument_id')!;

    final manager = $$InstrumentsTableTableManager($_db, $_db.instruments).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_instrumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PortfolioEventsTableFilterComposer extends Composer<_$KakaDatabase, $PortfolioEventsTable> {
  $$PortfolioEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get platformId =>
      $composableBuilder(column: $table.platformId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get at => $composableBuilder(column: $table.at, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get qty => $composableBuilder(column: $table.qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gross => $composableBuilder(column: $table.gross, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fee => $composableBuilder(column: $table.fee, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get costMode =>
      $composableBuilder(column: $table.costMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cost => $composableBuilder(column: $table.cost, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get splitNum =>
      $composableBuilder(column: $table.splitNum, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get splitDen =>
      $composableBuilder(column: $table.splitDen, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cashAccountId =>
      $composableBuilder(column: $table.cashAccountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get txnId =>
      $composableBuilder(column: $table.txnId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get txnSig =>
      $composableBuilder(column: $table.txnSig, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$InstrumentsTableFilterComposer get instrumentId {
    final $$InstrumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instrumentId,
      referencedTable: $db.instruments,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$InstrumentsTableFilterComposer(
            $db: $db,
            $table: $db.instruments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PortfolioEventsTableOrderingComposer extends Composer<_$KakaDatabase, $PortfolioEventsTable> {
  $$PortfolioEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get platformId =>
      $composableBuilder(column: $table.platformId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get qty => $composableBuilder(column: $table.qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gross =>
      $composableBuilder(column: $table.gross, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fee => $composableBuilder(column: $table.fee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get costMode =>
      $composableBuilder(column: $table.costMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get splitNum =>
      $composableBuilder(column: $table.splitNum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get splitDen =>
      $composableBuilder(column: $table.splitDen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cashAccountId =>
      $composableBuilder(column: $table.cashAccountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get txnId =>
      $composableBuilder(column: $table.txnId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get txnSig =>
      $composableBuilder(column: $table.txnSig, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$InstrumentsTableOrderingComposer get instrumentId {
    final $$InstrumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instrumentId,
      referencedTable: $db.instruments,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$InstrumentsTableOrderingComposer(
            $db: $db,
            $table: $db.instruments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PortfolioEventsTableAnnotationComposer extends Composer<_$KakaDatabase, $PortfolioEventsTable> {
  $$PortfolioEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get platformId => $composableBuilder(column: $table.platformId, builder: (column) => column);

  GeneratedColumn<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get at => $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get qty => $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get gross => $composableBuilder(column: $table.gross, builder: (column) => column);

  GeneratedColumn<int> get fee => $composableBuilder(column: $table.fee, builder: (column) => column);

  GeneratedColumn<String> get costMode => $composableBuilder(column: $table.costMode, builder: (column) => column);

  GeneratedColumn<int> get cost => $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<int> get splitNum => $composableBuilder(column: $table.splitNum, builder: (column) => column);

  GeneratedColumn<int> get splitDen => $composableBuilder(column: $table.splitDen, builder: (column) => column);

  GeneratedColumn<String> get groupId => $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get cashAccountId =>
      $composableBuilder(column: $table.cashAccountId, builder: (column) => column);

  GeneratedColumn<String> get txnId => $composableBuilder(column: $table.txnId, builder: (column) => column);

  GeneratedColumn<String> get txnSig => $composableBuilder(column: $table.txnSig, builder: (column) => column);

  GeneratedColumn<String> get source => $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get note => $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get voidedAt => $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InstrumentsTableAnnotationComposer get instrumentId {
    final $$InstrumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instrumentId,
      referencedTable: $db.instruments,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$InstrumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.instruments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PortfolioEventsTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $PortfolioEventsTable,
          PortfolioEventRow,
          $$PortfolioEventsTableFilterComposer,
          $$PortfolioEventsTableOrderingComposer,
          $$PortfolioEventsTableAnnotationComposer,
          $$PortfolioEventsTableCreateCompanionBuilder,
          $$PortfolioEventsTableUpdateCompanionBuilder,
          (PortfolioEventRow, $$PortfolioEventsTableReferences),
          PortfolioEventRow,
          PrefetchHooks Function({bool instrumentId})
        > {
  $$PortfolioEventsTableTableManager(_$KakaDatabase db, $PortfolioEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PortfolioEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PortfolioEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PortfolioEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> instrumentId = const Value.absent(),
                Value<String?> platformId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int?> gross = const Value.absent(),
                Value<int> fee = const Value.absent(),
                Value<String> costMode = const Value.absent(),
                Value<int?> cost = const Value.absent(),
                Value<int?> splitNum = const Value.absent(),
                Value<int?> splitDen = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String?> cashAccountId = const Value.absent(),
                Value<String?> txnId = const Value.absent(),
                Value<String?> txnSig = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PortfolioEventsCompanion(
                id: id,
                instrumentId: instrumentId,
                platformId: platformId,
                kind: kind,
                at: at,
                currency: currency,
                qty: qty,
                gross: gross,
                fee: fee,
                costMode: costMode,
                cost: cost,
                splitNum: splitNum,
                splitDen: splitDen,
                groupId: groupId,
                cashAccountId: cashAccountId,
                txnId: txnId,
                txnSig: txnSig,
                source: source,
                note: note,
                voidedAt: voidedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String instrumentId,
                Value<String?> platformId = const Value.absent(),
                required String kind,
                required DateTime at,
                required String currency,
                Value<int> qty = const Value.absent(),
                Value<int?> gross = const Value.absent(),
                Value<int> fee = const Value.absent(),
                Value<String> costMode = const Value.absent(),
                Value<int?> cost = const Value.absent(),
                Value<int?> splitNum = const Value.absent(),
                Value<int?> splitDen = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String?> cashAccountId = const Value.absent(),
                Value<String?> txnId = const Value.absent(),
                Value<String?> txnSig = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PortfolioEventsCompanion.insert(
                id: id,
                instrumentId: instrumentId,
                platformId: platformId,
                kind: kind,
                at: at,
                currency: currency,
                qty: qty,
                gross: gross,
                fee: fee,
                costMode: costMode,
                cost: cost,
                splitNum: splitNum,
                splitDen: splitDen,
                groupId: groupId,
                cashAccountId: cashAccountId,
                txnId: txnId,
                txnSig: txnSig,
                source: source,
                note: note,
                voidedAt: voidedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PortfolioEventsTable, PortfolioEventRow>(table),
                  $$PortfolioEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({instrumentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (instrumentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.instrumentId,
                                referencedTable: $$PortfolioEventsTableReferences._instrumentIdTable(db),
                                referencedColumn: $$PortfolioEventsTableReferences._instrumentIdTable(db).id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PortfolioEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $PortfolioEventsTable,
      PortfolioEventRow,
      $$PortfolioEventsTableFilterComposer,
      $$PortfolioEventsTableOrderingComposer,
      $$PortfolioEventsTableAnnotationComposer,
      $$PortfolioEventsTableCreateCompanionBuilder,
      $$PortfolioEventsTableUpdateCompanionBuilder,
      (PortfolioEventRow, $$PortfolioEventsTableReferences),
      PortfolioEventRow,
      PrefetchHooks Function({bool instrumentId})
    >;
typedef $$PriceQuotesTableCreateCompanionBuilder =
    PriceQuotesCompanion Function({
      required String id,
      required String instrumentId,
      required int priceMinor,
      required String currency,
      required DateTime asOf,
      Value<String> source,
      Value<int> rowid,
    });
typedef $$PriceQuotesTableUpdateCompanionBuilder =
    PriceQuotesCompanion Function({
      Value<String> id,
      Value<String> instrumentId,
      Value<int> priceMinor,
      Value<String> currency,
      Value<DateTime> asOf,
      Value<String> source,
      Value<int> rowid,
    });

final class $$PriceQuotesTableReferences extends BaseReferences<_$KakaDatabase, $PriceQuotesTable, PriceQuoteRow> {
  $$PriceQuotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InstrumentsTable _instrumentIdTable(_$KakaDatabase db) =>
      db.instruments.createAlias('price_quotes__instrument_id__instruments__id');

  $$InstrumentsTableProcessedTableManager get instrumentId {
    final $_column = $_itemColumn<String>('instrument_id')!;

    final manager = $$InstrumentsTableTableManager($_db, $_db.instruments).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_instrumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PriceQuotesTableFilterComposer extends Composer<_$KakaDatabase, $PriceQuotesTable> {
  $$PriceQuotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priceMinor =>
      $composableBuilder(column: $table.priceMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get asOf =>
      $composableBuilder(column: $table.asOf, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnFilters(column));

  $$InstrumentsTableFilterComposer get instrumentId {
    final $$InstrumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instrumentId,
      referencedTable: $db.instruments,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$InstrumentsTableFilterComposer(
            $db: $db,
            $table: $db.instruments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PriceQuotesTableOrderingComposer extends Composer<_$KakaDatabase, $PriceQuotesTable> {
  $$PriceQuotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priceMinor =>
      $composableBuilder(column: $table.priceMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get asOf =>
      $composableBuilder(column: $table.asOf, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnOrderings(column));

  $$InstrumentsTableOrderingComposer get instrumentId {
    final $$InstrumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instrumentId,
      referencedTable: $db.instruments,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$InstrumentsTableOrderingComposer(
            $db: $db,
            $table: $db.instruments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PriceQuotesTableAnnotationComposer extends Composer<_$KakaDatabase, $PriceQuotesTable> {
  $$PriceQuotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get priceMinor => $composableBuilder(column: $table.priceMinor, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get asOf => $composableBuilder(column: $table.asOf, builder: (column) => column);

  GeneratedColumn<String> get source => $composableBuilder(column: $table.source, builder: (column) => column);

  $$InstrumentsTableAnnotationComposer get instrumentId {
    final $$InstrumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instrumentId,
      referencedTable: $db.instruments,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$InstrumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.instruments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PriceQuotesTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $PriceQuotesTable,
          PriceQuoteRow,
          $$PriceQuotesTableFilterComposer,
          $$PriceQuotesTableOrderingComposer,
          $$PriceQuotesTableAnnotationComposer,
          $$PriceQuotesTableCreateCompanionBuilder,
          $$PriceQuotesTableUpdateCompanionBuilder,
          (PriceQuoteRow, $$PriceQuotesTableReferences),
          PriceQuoteRow,
          PrefetchHooks Function({bool instrumentId})
        > {
  $$PriceQuotesTableTableManager(_$KakaDatabase db, $PriceQuotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PriceQuotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PriceQuotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PriceQuotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> instrumentId = const Value.absent(),
                Value<int> priceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> asOf = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PriceQuotesCompanion(
                id: id,
                instrumentId: instrumentId,
                priceMinor: priceMinor,
                currency: currency,
                asOf: asOf,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String instrumentId,
                required int priceMinor,
                required String currency,
                required DateTime asOf,
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PriceQuotesCompanion.insert(
                id: id,
                instrumentId: instrumentId,
                priceMinor: priceMinor,
                currency: currency,
                asOf: asOf,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable<$PriceQuotesTable, PriceQuoteRow>(table), $$PriceQuotesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({instrumentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (instrumentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.instrumentId,
                                referencedTable: $$PriceQuotesTableReferences._instrumentIdTable(db),
                                referencedColumn: $$PriceQuotesTableReferences._instrumentIdTable(db).id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PriceQuotesTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $PriceQuotesTable,
      PriceQuoteRow,
      $$PriceQuotesTableFilterComposer,
      $$PriceQuotesTableOrderingComposer,
      $$PriceQuotesTableAnnotationComposer,
      $$PriceQuotesTableCreateCompanionBuilder,
      $$PriceQuotesTableUpdateCompanionBuilder,
      (PriceQuoteRow, $$PriceQuotesTableReferences),
      PriceQuoteRow,
      PrefetchHooks Function({bool instrumentId})
    >;
typedef $$ValuationSnapshotsTableCreateCompanionBuilder =
    ValuationSnapshotsCompanion Function({
      required String id,
      required DateTime at,
      required String base,
      required int netWorth,
      required int assetsValue,
      required int unrealized,
      Value<int> rowid,
    });
typedef $$ValuationSnapshotsTableUpdateCompanionBuilder =
    ValuationSnapshotsCompanion Function({
      Value<String> id,
      Value<DateTime> at,
      Value<String> base,
      Value<int> netWorth,
      Value<int> assetsValue,
      Value<int> unrealized,
      Value<int> rowid,
    });

class $$ValuationSnapshotsTableFilterComposer extends Composer<_$KakaDatabase, $ValuationSnapshotsTable> {
  $$ValuationSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get at => $composableBuilder(column: $table.at, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get base => $composableBuilder(column: $table.base, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get netWorth =>
      $composableBuilder(column: $table.netWorth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get assetsValue =>
      $composableBuilder(column: $table.assetsValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unrealized =>
      $composableBuilder(column: $table.unrealized, builder: (column) => ColumnFilters(column));
}

class $$ValuationSnapshotsTableOrderingComposer extends Composer<_$KakaDatabase, $ValuationSnapshotsTable> {
  $$ValuationSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get base =>
      $composableBuilder(column: $table.base, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get netWorth =>
      $composableBuilder(column: $table.netWorth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get assetsValue =>
      $composableBuilder(column: $table.assetsValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unrealized =>
      $composableBuilder(column: $table.unrealized, builder: (column) => ColumnOrderings(column));
}

class $$ValuationSnapshotsTableAnnotationComposer extends Composer<_$KakaDatabase, $ValuationSnapshotsTable> {
  $$ValuationSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at => $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get base => $composableBuilder(column: $table.base, builder: (column) => column);

  GeneratedColumn<int> get netWorth => $composableBuilder(column: $table.netWorth, builder: (column) => column);

  GeneratedColumn<int> get assetsValue => $composableBuilder(column: $table.assetsValue, builder: (column) => column);

  GeneratedColumn<int> get unrealized => $composableBuilder(column: $table.unrealized, builder: (column) => column);
}

class $$ValuationSnapshotsTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $ValuationSnapshotsTable,
          ValuationSnapshotRow,
          $$ValuationSnapshotsTableFilterComposer,
          $$ValuationSnapshotsTableOrderingComposer,
          $$ValuationSnapshotsTableAnnotationComposer,
          $$ValuationSnapshotsTableCreateCompanionBuilder,
          $$ValuationSnapshotsTableUpdateCompanionBuilder,
          (ValuationSnapshotRow, BaseReferences<_$KakaDatabase, $ValuationSnapshotsTable, ValuationSnapshotRow>),
          ValuationSnapshotRow,
          PrefetchHooks Function()
        > {
  $$ValuationSnapshotsTableTableManager(_$KakaDatabase db, $ValuationSnapshotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ValuationSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ValuationSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ValuationSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> base = const Value.absent(),
                Value<int> netWorth = const Value.absent(),
                Value<int> assetsValue = const Value.absent(),
                Value<int> unrealized = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ValuationSnapshotsCompanion(
                id: id,
                at: at,
                base: base,
                netWorth: netWorth,
                assetsValue: assetsValue,
                unrealized: unrealized,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime at,
                required String base,
                required int netWorth,
                required int assetsValue,
                required int unrealized,
                Value<int> rowid = const Value.absent(),
              }) => ValuationSnapshotsCompanion.insert(
                id: id,
                at: at,
                base: base,
                netWorth: netWorth,
                assetsValue: assetsValue,
                unrealized: unrealized,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ValuationSnapshotsTable, ValuationSnapshotRow>(table),
                  BaseReferences<_$KakaDatabase, $ValuationSnapshotsTable, ValuationSnapshotRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ValuationSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $ValuationSnapshotsTable,
      ValuationSnapshotRow,
      $$ValuationSnapshotsTableFilterComposer,
      $$ValuationSnapshotsTableOrderingComposer,
      $$ValuationSnapshotsTableAnnotationComposer,
      $$ValuationSnapshotsTableCreateCompanionBuilder,
      $$ValuationSnapshotsTableUpdateCompanionBuilder,
      (ValuationSnapshotRow, BaseReferences<_$KakaDatabase, $ValuationSnapshotsTable, ValuationSnapshotRow>),
      ValuationSnapshotRow,
      PrefetchHooks Function()
    >;
typedef $$CustomParsersTableCreateCompanionBuilder =
    CustomParsersCompanion Function({
      required String id,
      required String json,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CustomParsersTableUpdateCompanionBuilder =
    CustomParsersCompanion Function({
      Value<String> id,
      Value<String> json,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CustomParsersTableFilterComposer extends Composer<_$KakaDatabase, $CustomParsersTable> {
  $$CustomParsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get json => $composableBuilder(column: $table.json, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CustomParsersTableOrderingComposer extends Composer<_$KakaDatabase, $CustomParsersTable> {
  $$CustomParsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomParsersTableAnnotationComposer extends Composer<_$KakaDatabase, $CustomParsersTable> {
  $$CustomParsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get json => $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomParsersTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $CustomParsersTable,
          CustomParserRow,
          $$CustomParsersTableFilterComposer,
          $$CustomParsersTableOrderingComposer,
          $$CustomParsersTableAnnotationComposer,
          $$CustomParsersTableCreateCompanionBuilder,
          $$CustomParsersTableUpdateCompanionBuilder,
          (CustomParserRow, BaseReferences<_$KakaDatabase, $CustomParsersTable, CustomParserRow>),
          CustomParserRow,
          PrefetchHooks Function()
        > {
  $$CustomParsersTableTableManager(_$KakaDatabase db, $CustomParsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$CustomParsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$CustomParsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$CustomParsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomParsersCompanion(id: id, json: json, createdAt: createdAt, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String json,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CustomParsersCompanion.insert(id: id, json: json, createdAt: createdAt, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomParsersTable, CustomParserRow>(table),
                  BaseReferences<_$KakaDatabase, $CustomParsersTable, CustomParserRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomParsersTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $CustomParsersTable,
      CustomParserRow,
      $$CustomParsersTableFilterComposer,
      $$CustomParsersTableOrderingComposer,
      $$CustomParsersTableAnnotationComposer,
      $$CustomParsersTableCreateCompanionBuilder,
      $$CustomParsersTableUpdateCompanionBuilder,
      (CustomParserRow, BaseReferences<_$KakaDatabase, $CustomParsersTable, CustomParserRow>),
      CustomParserRow,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      required String id,
      required String category,
      required int limitMinor,
      required String currency,
      Value<int> rowid,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<String> id,
      Value<String> category,
      Value<int> limitMinor,
      Value<String> currency,
      Value<int> rowid,
    });

class $$BudgetsTableFilterComposer extends Composer<_$KakaDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get limitMinor =>
      $composableBuilder(column: $table.limitMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));
}

class $$BudgetsTableOrderingComposer extends Composer<_$KakaDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get limitMinor =>
      $composableBuilder(column: $table.limitMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));
}

class $$BudgetsTableAnnotationComposer extends Composer<_$KakaDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category => $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get limitMinor => $composableBuilder(column: $table.limitMinor, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $BudgetsTable,
          BudgetRow,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (BudgetRow, BaseReferences<_$KakaDatabase, $BudgetsTable, BudgetRow>),
          BudgetRow,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$KakaDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> limitMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                category: category,
                limitMinor: limitMinor,
                currency: currency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String category,
                required int limitMinor,
                required String currency,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                category: category,
                limitMinor: limitMinor,
                currency: currency,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, BudgetRow>(table),
                  BaseReferences<_$KakaDatabase, $BudgetsTable, BudgetRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $BudgetsTable,
      BudgetRow,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (BudgetRow, BaseReferences<_$KakaDatabase, $BudgetsTable, BudgetRow>),
      BudgetRow,
      PrefetchHooks Function()
    >;
typedef $$RecurringRulesTableCreateCompanionBuilder =
    RecurringRulesCompanion Function({
      required String id,
      required bool isExpense,
      required String accountId,
      Value<String?> toAccountId,
      Value<String?> category,
      required int amountMinor,
      required String currency,
      Value<String> note,
      required String every,
      required DateTime start,
      Value<DateTime?> lastDone,
      Value<bool> active,
      Value<int> rowid,
    });
typedef $$RecurringRulesTableUpdateCompanionBuilder =
    RecurringRulesCompanion Function({
      Value<String> id,
      Value<bool> isExpense,
      Value<String> accountId,
      Value<String?> toAccountId,
      Value<String?> category,
      Value<int> amountMinor,
      Value<String> currency,
      Value<String> note,
      Value<String> every,
      Value<DateTime> start,
      Value<DateTime?> lastDone,
      Value<bool> active,
      Value<int> rowid,
    });

class $$RecurringRulesTableFilterComposer extends Composer<_$KakaDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isExpense =>
      $composableBuilder(column: $table.isExpense, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toAccountId =>
      $composableBuilder(column: $table.toAccountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get every =>
      $composableBuilder(column: $table.every, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastDone =>
      $composableBuilder(column: $table.lastDone, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => ColumnFilters(column));
}

class $$RecurringRulesTableOrderingComposer extends Composer<_$KakaDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isExpense =>
      $composableBuilder(column: $table.isExpense, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toAccountId =>
      $composableBuilder(column: $table.toAccountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get every =>
      $composableBuilder(column: $table.every, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastDone =>
      $composableBuilder(column: $table.lastDone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => ColumnOrderings(column));
}

class $$RecurringRulesTableAnnotationComposer extends Composer<_$KakaDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isExpense => $composableBuilder(column: $table.isExpense, builder: (column) => column);

  GeneratedColumn<String> get accountId => $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get toAccountId =>
      $composableBuilder(column: $table.toAccountId, builder: (column) => column);

  GeneratedColumn<String> get category => $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get note => $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get every => $composableBuilder(column: $table.every, builder: (column) => column);

  GeneratedColumn<DateTime> get start => $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<DateTime> get lastDone => $composableBuilder(column: $table.lastDone, builder: (column) => column);

  GeneratedColumn<bool> get active => $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$RecurringRulesTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $RecurringRulesTable,
          RecurringRuleRow,
          $$RecurringRulesTableFilterComposer,
          $$RecurringRulesTableOrderingComposer,
          $$RecurringRulesTableAnnotationComposer,
          $$RecurringRulesTableCreateCompanionBuilder,
          $$RecurringRulesTableUpdateCompanionBuilder,
          (RecurringRuleRow, BaseReferences<_$KakaDatabase, $RecurringRulesTable, RecurringRuleRow>),
          RecurringRuleRow,
          PrefetchHooks Function()
        > {
  $$RecurringRulesTableTableManager(_$KakaDatabase db, $RecurringRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$RecurringRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$RecurringRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$RecurringRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<bool> isExpense = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> every = const Value.absent(),
                Value<DateTime> start = const Value.absent(),
                Value<DateTime?> lastDone = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringRulesCompanion(
                id: id,
                isExpense: isExpense,
                accountId: accountId,
                toAccountId: toAccountId,
                category: category,
                amountMinor: amountMinor,
                currency: currency,
                note: note,
                every: every,
                start: start,
                lastDone: lastDone,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required bool isExpense,
                required String accountId,
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                required int amountMinor,
                required String currency,
                Value<String> note = const Value.absent(),
                required String every,
                required DateTime start,
                Value<DateTime?> lastDone = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringRulesCompanion.insert(
                id: id,
                isExpense: isExpense,
                accountId: accountId,
                toAccountId: toAccountId,
                category: category,
                amountMinor: amountMinor,
                currency: currency,
                note: note,
                every: every,
                start: start,
                lastDone: lastDone,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecurringRulesTable, RecurringRuleRow>(table),
                  BaseReferences<_$KakaDatabase, $RecurringRulesTable, RecurringRuleRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurringRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $RecurringRulesTable,
      RecurringRuleRow,
      $$RecurringRulesTableFilterComposer,
      $$RecurringRulesTableOrderingComposer,
      $$RecurringRulesTableAnnotationComposer,
      $$RecurringRulesTableCreateCompanionBuilder,
      $$RecurringRulesTableUpdateCompanionBuilder,
      (RecurringRuleRow, BaseReferences<_$KakaDatabase, $RecurringRulesTable, RecurringRuleRow>),
      RecurringRuleRow,
      PrefetchHooks Function()
    >;

class $KakaDatabaseManager {
  final _$KakaDatabase _db;
  $KakaDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts => $$AccountsTableTableManager(_db, _db.accounts);
  $$TransactionsTableTableManager get transactions => $$TransactionsTableTableManager(_db, _db.transactions);
  $$PostingsTableTableManager get postings => $$PostingsTableTableManager(_db, _db.postings);
  $$SettingsTableTableManager get settings => $$SettingsTableTableManager(_db, _db.settings);
  $$DraftsTableTableManager get drafts => $$DraftsTableTableManager(_db, _db.drafts);
  $$SmsLinksTableTableManager get smsLinks => $$SmsLinksTableTableManager(_db, _db.smsLinks);
  $$FxRatesTableTableManager get fxRates => $$FxRatesTableTableManager(_db, _db.fxRates);
  $$InstrumentsTableTableManager get instruments => $$InstrumentsTableTableManager(_db, _db.instruments);
  $$PlatformsTableTableManager get platforms => $$PlatformsTableTableManager(_db, _db.platforms);
  $$PortfolioEventsTableTableManager get portfolioEvents =>
      $$PortfolioEventsTableTableManager(_db, _db.portfolioEvents);
  $$PriceQuotesTableTableManager get priceQuotes => $$PriceQuotesTableTableManager(_db, _db.priceQuotes);
  $$ValuationSnapshotsTableTableManager get valuationSnapshots =>
      $$ValuationSnapshotsTableTableManager(_db, _db.valuationSnapshots);
  $$CustomParsersTableTableManager get customParsers => $$CustomParsersTableTableManager(_db, _db.customParsers);
  $$BudgetsTableTableManager get budgets => $$BudgetsTableTableManager(_db, _db.budgets);
  $$RecurringRulesTableTableManager get recurringRules => $$RecurringRulesTableTableManager(_db, _db.recurringRules);
}
