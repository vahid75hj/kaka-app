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
  @override
  List<GeneratedColumn> get $columns => [id, name, type, currency, isSystem, archived, createdAt];
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
  const AccountRow({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    required this.isSystem,
    required this.archived,
    required this.createdAt,
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
  }) => AccountRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    currency: currency ?? this.currency,
    isSystem: isSystem ?? this.isSystem,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
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
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, currency, isSystem, archived, createdAt);
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
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> currency;
  final Value<bool> isSystem;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currency = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
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

class $AssetTypesTable extends AssetTypes with TableInfo<$AssetTypesTable, AssetTypeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
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
  List<GeneratedColumn> get $columns => [id, nameFa, nameEn, unit, archived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_types';
  @override
  VerificationContext validateIntegrity(Insertable<AssetTypeRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('unit')) {
      context.handle(_unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta, archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetTypeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetTypeRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nameFa: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name_fa'])!,
      nameEn: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      unit: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      archived: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
    );
  }

  @override
  $AssetTypesTable createAlias(String alias) {
    return $AssetTypesTable(attachedDatabase, alias);
  }
}

class AssetTypeRow extends DataClass implements Insertable<AssetTypeRow> {
  final String id;
  final String nameFa;
  final String nameEn;
  final String unit;
  final bool archived;
  const AssetTypeRow({
    required this.id,
    required this.nameFa,
    required this.nameEn,
    required this.unit,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_fa'] = Variable<String>(nameFa);
    map['name_en'] = Variable<String>(nameEn);
    map['unit'] = Variable<String>(unit);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  AssetTypesCompanion toCompanion(bool nullToAbsent) {
    return AssetTypesCompanion(
      id: Value(id),
      nameFa: Value(nameFa),
      nameEn: Value(nameEn),
      unit: Value(unit),
      archived: Value(archived),
    );
  }

  factory AssetTypeRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetTypeRow(
      id: serializer.fromJson<String>(json['id']),
      nameFa: serializer.fromJson<String>(json['nameFa']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      unit: serializer.fromJson<String>(json['unit']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameFa': serializer.toJson<String>(nameFa),
      'nameEn': serializer.toJson<String>(nameEn),
      'unit': serializer.toJson<String>(unit),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  AssetTypeRow copyWith({String? id, String? nameFa, String? nameEn, String? unit, bool? archived}) => AssetTypeRow(
    id: id ?? this.id,
    nameFa: nameFa ?? this.nameFa,
    nameEn: nameEn ?? this.nameEn,
    unit: unit ?? this.unit,
    archived: archived ?? this.archived,
  );
  AssetTypeRow copyWithCompanion(AssetTypesCompanion data) {
    return AssetTypeRow(
      id: data.id.present ? data.id.value : this.id,
      nameFa: data.nameFa.present ? data.nameFa.value : this.nameFa,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      unit: data.unit.present ? data.unit.value : this.unit,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetTypeRow(')
          ..write('id: $id, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn, ')
          ..write('unit: $unit, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameFa, nameEn, unit, archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetTypeRow &&
          other.id == this.id &&
          other.nameFa == this.nameFa &&
          other.nameEn == this.nameEn &&
          other.unit == this.unit &&
          other.archived == this.archived);
}

class AssetTypesCompanion extends UpdateCompanion<AssetTypeRow> {
  final Value<String> id;
  final Value<String> nameFa;
  final Value<String> nameEn;
  final Value<String> unit;
  final Value<bool> archived;
  final Value<int> rowid;
  const AssetTypesCompanion({
    this.id = const Value.absent(),
    this.nameFa = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.unit = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetTypesCompanion.insert({
    required String id,
    required String nameFa,
    required String nameEn,
    required String unit,
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameFa = Value(nameFa),
       nameEn = Value(nameEn),
       unit = Value(unit);
  static Insertable<AssetTypeRow> custom({
    Expression<String>? id,
    Expression<String>? nameFa,
    Expression<String>? nameEn,
    Expression<String>? unit,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameFa != null) 'name_fa': nameFa,
      if (nameEn != null) 'name_en': nameEn,
      if (unit != null) 'unit': unit,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetTypesCompanion copyWith({
    Value<String>? id,
    Value<String>? nameFa,
    Value<String>? nameEn,
    Value<String>? unit,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return AssetTypesCompanion(
      id: id ?? this.id,
      nameFa: nameFa ?? this.nameFa,
      nameEn: nameEn ?? this.nameEn,
      unit: unit ?? this.unit,
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
    if (nameFa.present) {
      map['name_fa'] = Variable<String>(nameFa.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
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
    return (StringBuffer('AssetTypesCompanion(')
          ..write('id: $id, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn, ')
          ..write('unit: $unit, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetMovementsTable extends AssetMovements with TableInfo<$AssetMovementsTable, AssetMovementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetTypeIdMeta = const VerificationMeta('assetTypeId');
  @override
  late final GeneratedColumn<String> assetTypeId = GeneratedColumn<String>(
    'asset_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES asset_types (id)'),
  );
  static const VerificationMeta _quantityMilliMeta = const VerificationMeta('quantityMilli');
  @override
  late final GeneratedColumn<int> quantityMilli = GeneratedColumn<int>(
    'quantity_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movedAtMeta = const VerificationMeta('movedAt');
  @override
  late final GeneratedColumn<DateTime> movedAt = GeneratedColumn<DateTime>(
    'moved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMinorMeta = const VerificationMeta('totalMinor');
  @override
  late final GeneratedColumn<int> totalMinor = GeneratedColumn<int>(
    'total_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalCurrencyMeta = const VerificationMeta('totalCurrency');
  @override
  late final GeneratedColumn<String> totalCurrency = GeneratedColumn<String>(
    'total_currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _transactionIdMeta = const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assetTypeId,
    quantityMilli,
    movedAt,
    totalMinor,
    totalCurrency,
    note,
    voidedAt,
    transactionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_movements';
  @override
  VerificationContext validateIntegrity(Insertable<AssetMovementRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_type_id')) {
      context.handle(_assetTypeIdMeta, assetTypeId.isAcceptableOrUnknown(data['asset_type_id']!, _assetTypeIdMeta));
    } else if (isInserting) {
      context.missing(_assetTypeIdMeta);
    }
    if (data.containsKey('quantity_milli')) {
      context.handle(
        _quantityMilliMeta,
        quantityMilli.isAcceptableOrUnknown(data['quantity_milli']!, _quantityMilliMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMilliMeta);
    }
    if (data.containsKey('moved_at')) {
      context.handle(_movedAtMeta, movedAt.isAcceptableOrUnknown(data['moved_at']!, _movedAtMeta));
    } else if (isInserting) {
      context.missing(_movedAtMeta);
    }
    if (data.containsKey('total_minor')) {
      context.handle(_totalMinorMeta, totalMinor.isAcceptableOrUnknown(data['total_minor']!, _totalMinorMeta));
    }
    if (data.containsKey('total_currency')) {
      context.handle(
        _totalCurrencyMeta,
        totalCurrency.isAcceptableOrUnknown(data['total_currency']!, _totalCurrencyMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('voided_at')) {
      context.handle(_voidedAtMeta, voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(data['transaction_id']!, _transactionIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetMovementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetMovementRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      assetTypeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}asset_type_id'])!,
      quantityMilli: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}quantity_milli'])!,
      movedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}moved_at'])!,
      totalMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}total_minor']),
      totalCurrency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}total_currency']),
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      voidedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}voided_at']),
      transactionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}transaction_id']),
    );
  }

  @override
  $AssetMovementsTable createAlias(String alias) {
    return $AssetMovementsTable(attachedDatabase, alias);
  }
}

class AssetMovementRow extends DataClass implements Insertable<AssetMovementRow> {
  final String id;
  final String assetTypeId;
  final int quantityMilli;
  final DateTime movedAt;
  final int? totalMinor;
  final String? totalCurrency;
  final String note;
  final DateTime? voidedAt;

  /// v5: the ledger transaction that moved cash for this buy/sell.
  final String? transactionId;
  const AssetMovementRow({
    required this.id,
    required this.assetTypeId,
    required this.quantityMilli,
    required this.movedAt,
    this.totalMinor,
    this.totalCurrency,
    required this.note,
    this.voidedAt,
    this.transactionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_type_id'] = Variable<String>(assetTypeId);
    map['quantity_milli'] = Variable<int>(quantityMilli);
    map['moved_at'] = Variable<DateTime>(movedAt);
    if (!nullToAbsent || totalMinor != null) {
      map['total_minor'] = Variable<int>(totalMinor);
    }
    if (!nullToAbsent || totalCurrency != null) {
      map['total_currency'] = Variable<String>(totalCurrency);
    }
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<DateTime>(voidedAt);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    return map;
  }

  AssetMovementsCompanion toCompanion(bool nullToAbsent) {
    return AssetMovementsCompanion(
      id: Value(id),
      assetTypeId: Value(assetTypeId),
      quantityMilli: Value(quantityMilli),
      movedAt: Value(movedAt),
      totalMinor: totalMinor == null && nullToAbsent ? const Value.absent() : Value(totalMinor),
      totalCurrency: totalCurrency == null && nullToAbsent ? const Value.absent() : Value(totalCurrency),
      note: Value(note),
      voidedAt: voidedAt == null && nullToAbsent ? const Value.absent() : Value(voidedAt),
      transactionId: transactionId == null && nullToAbsent ? const Value.absent() : Value(transactionId),
    );
  }

  factory AssetMovementRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetMovementRow(
      id: serializer.fromJson<String>(json['id']),
      assetTypeId: serializer.fromJson<String>(json['assetTypeId']),
      quantityMilli: serializer.fromJson<int>(json['quantityMilli']),
      movedAt: serializer.fromJson<DateTime>(json['movedAt']),
      totalMinor: serializer.fromJson<int?>(json['totalMinor']),
      totalCurrency: serializer.fromJson<String?>(json['totalCurrency']),
      note: serializer.fromJson<String>(json['note']),
      voidedAt: serializer.fromJson<DateTime?>(json['voidedAt']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetTypeId': serializer.toJson<String>(assetTypeId),
      'quantityMilli': serializer.toJson<int>(quantityMilli),
      'movedAt': serializer.toJson<DateTime>(movedAt),
      'totalMinor': serializer.toJson<int?>(totalMinor),
      'totalCurrency': serializer.toJson<String?>(totalCurrency),
      'note': serializer.toJson<String>(note),
      'voidedAt': serializer.toJson<DateTime?>(voidedAt),
      'transactionId': serializer.toJson<String?>(transactionId),
    };
  }

  AssetMovementRow copyWith({
    String? id,
    String? assetTypeId,
    int? quantityMilli,
    DateTime? movedAt,
    Value<int?> totalMinor = const Value.absent(),
    Value<String?> totalCurrency = const Value.absent(),
    String? note,
    Value<DateTime?> voidedAt = const Value.absent(),
    Value<String?> transactionId = const Value.absent(),
  }) => AssetMovementRow(
    id: id ?? this.id,
    assetTypeId: assetTypeId ?? this.assetTypeId,
    quantityMilli: quantityMilli ?? this.quantityMilli,
    movedAt: movedAt ?? this.movedAt,
    totalMinor: totalMinor.present ? totalMinor.value : this.totalMinor,
    totalCurrency: totalCurrency.present ? totalCurrency.value : this.totalCurrency,
    note: note ?? this.note,
    voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
    transactionId: transactionId.present ? transactionId.value : this.transactionId,
  );
  AssetMovementRow copyWithCompanion(AssetMovementsCompanion data) {
    return AssetMovementRow(
      id: data.id.present ? data.id.value : this.id,
      assetTypeId: data.assetTypeId.present ? data.assetTypeId.value : this.assetTypeId,
      quantityMilli: data.quantityMilli.present ? data.quantityMilli.value : this.quantityMilli,
      movedAt: data.movedAt.present ? data.movedAt.value : this.movedAt,
      totalMinor: data.totalMinor.present ? data.totalMinor.value : this.totalMinor,
      totalCurrency: data.totalCurrency.present ? data.totalCurrency.value : this.totalCurrency,
      note: data.note.present ? data.note.value : this.note,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      transactionId: data.transactionId.present ? data.transactionId.value : this.transactionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetMovementRow(')
          ..write('id: $id, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('movedAt: $movedAt, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('totalCurrency: $totalCurrency, ')
          ..write('note: $note, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, assetTypeId, quantityMilli, movedAt, totalMinor, totalCurrency, note, voidedAt, transactionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetMovementRow &&
          other.id == this.id &&
          other.assetTypeId == this.assetTypeId &&
          other.quantityMilli == this.quantityMilli &&
          other.movedAt == this.movedAt &&
          other.totalMinor == this.totalMinor &&
          other.totalCurrency == this.totalCurrency &&
          other.note == this.note &&
          other.voidedAt == this.voidedAt &&
          other.transactionId == this.transactionId);
}

class AssetMovementsCompanion extends UpdateCompanion<AssetMovementRow> {
  final Value<String> id;
  final Value<String> assetTypeId;
  final Value<int> quantityMilli;
  final Value<DateTime> movedAt;
  final Value<int?> totalMinor;
  final Value<String?> totalCurrency;
  final Value<String> note;
  final Value<DateTime?> voidedAt;
  final Value<String?> transactionId;
  final Value<int> rowid;
  const AssetMovementsCompanion({
    this.id = const Value.absent(),
    this.assetTypeId = const Value.absent(),
    this.quantityMilli = const Value.absent(),
    this.movedAt = const Value.absent(),
    this.totalMinor = const Value.absent(),
    this.totalCurrency = const Value.absent(),
    this.note = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetMovementsCompanion.insert({
    required String id,
    required String assetTypeId,
    required int quantityMilli,
    required DateTime movedAt,
    this.totalMinor = const Value.absent(),
    this.totalCurrency = const Value.absent(),
    this.note = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assetTypeId = Value(assetTypeId),
       quantityMilli = Value(quantityMilli),
       movedAt = Value(movedAt);
  static Insertable<AssetMovementRow> custom({
    Expression<String>? id,
    Expression<String>? assetTypeId,
    Expression<int>? quantityMilli,
    Expression<DateTime>? movedAt,
    Expression<int>? totalMinor,
    Expression<String>? totalCurrency,
    Expression<String>? note,
    Expression<DateTime>? voidedAt,
    Expression<String>? transactionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetTypeId != null) 'asset_type_id': assetTypeId,
      if (quantityMilli != null) 'quantity_milli': quantityMilli,
      if (movedAt != null) 'moved_at': movedAt,
      if (totalMinor != null) 'total_minor': totalMinor,
      if (totalCurrency != null) 'total_currency': totalCurrency,
      if (note != null) 'note': note,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (transactionId != null) 'transaction_id': transactionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetMovementsCompanion copyWith({
    Value<String>? id,
    Value<String>? assetTypeId,
    Value<int>? quantityMilli,
    Value<DateTime>? movedAt,
    Value<int?>? totalMinor,
    Value<String?>? totalCurrency,
    Value<String>? note,
    Value<DateTime?>? voidedAt,
    Value<String?>? transactionId,
    Value<int>? rowid,
  }) {
    return AssetMovementsCompanion(
      id: id ?? this.id,
      assetTypeId: assetTypeId ?? this.assetTypeId,
      quantityMilli: quantityMilli ?? this.quantityMilli,
      movedAt: movedAt ?? this.movedAt,
      totalMinor: totalMinor ?? this.totalMinor,
      totalCurrency: totalCurrency ?? this.totalCurrency,
      note: note ?? this.note,
      voidedAt: voidedAt ?? this.voidedAt,
      transactionId: transactionId ?? this.transactionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetTypeId.present) {
      map['asset_type_id'] = Variable<String>(assetTypeId.value);
    }
    if (quantityMilli.present) {
      map['quantity_milli'] = Variable<int>(quantityMilli.value);
    }
    if (movedAt.present) {
      map['moved_at'] = Variable<DateTime>(movedAt.value);
    }
    if (totalMinor.present) {
      map['total_minor'] = Variable<int>(totalMinor.value);
    }
    if (totalCurrency.present) {
      map['total_currency'] = Variable<String>(totalCurrency.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<DateTime>(voidedAt.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetMovementsCompanion(')
          ..write('id: $id, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('movedAt: $movedAt, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('totalCurrency: $totalCurrency, ')
          ..write('note: $note, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('transactionId: $transactionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetPricesTable extends AssetPrices with TableInfo<$AssetPricesTable, AssetPriceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetTypeIdMeta = const VerificationMeta('assetTypeId');
  @override
  late final GeneratedColumn<String> assetTypeId = GeneratedColumn<String>(
    'asset_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES asset_types (id)'),
  );
  static const VerificationMeta _priceDateMeta = const VerificationMeta('priceDate');
  @override
  late final GeneratedColumn<DateTime> priceDate = GeneratedColumn<DateTime>(
    'price_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [id, assetTypeId, priceDate, priceMinor, currency];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_prices';
  @override
  VerificationContext validateIntegrity(Insertable<AssetPriceRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_type_id')) {
      context.handle(_assetTypeIdMeta, assetTypeId.isAcceptableOrUnknown(data['asset_type_id']!, _assetTypeIdMeta));
    } else if (isInserting) {
      context.missing(_assetTypeIdMeta);
    }
    if (data.containsKey('price_date')) {
      context.handle(_priceDateMeta, priceDate.isAcceptableOrUnknown(data['price_date']!, _priceDateMeta));
    } else if (isInserting) {
      context.missing(_priceDateMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetPriceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetPriceRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      assetTypeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}asset_type_id'])!,
      priceDate: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}price_date'])!,
      priceMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}price_minor'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
    );
  }

  @override
  $AssetPricesTable createAlias(String alias) {
    return $AssetPricesTable(attachedDatabase, alias);
  }
}

class AssetPriceRow extends DataClass implements Insertable<AssetPriceRow> {
  final String id;
  final String assetTypeId;
  final DateTime priceDate;
  final int priceMinor;
  final String currency;
  const AssetPriceRow({
    required this.id,
    required this.assetTypeId,
    required this.priceDate,
    required this.priceMinor,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_type_id'] = Variable<String>(assetTypeId);
    map['price_date'] = Variable<DateTime>(priceDate);
    map['price_minor'] = Variable<int>(priceMinor);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  AssetPricesCompanion toCompanion(bool nullToAbsent) {
    return AssetPricesCompanion(
      id: Value(id),
      assetTypeId: Value(assetTypeId),
      priceDate: Value(priceDate),
      priceMinor: Value(priceMinor),
      currency: Value(currency),
    );
  }

  factory AssetPriceRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetPriceRow(
      id: serializer.fromJson<String>(json['id']),
      assetTypeId: serializer.fromJson<String>(json['assetTypeId']),
      priceDate: serializer.fromJson<DateTime>(json['priceDate']),
      priceMinor: serializer.fromJson<int>(json['priceMinor']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetTypeId': serializer.toJson<String>(assetTypeId),
      'priceDate': serializer.toJson<DateTime>(priceDate),
      'priceMinor': serializer.toJson<int>(priceMinor),
      'currency': serializer.toJson<String>(currency),
    };
  }

  AssetPriceRow copyWith({String? id, String? assetTypeId, DateTime? priceDate, int? priceMinor, String? currency}) =>
      AssetPriceRow(
        id: id ?? this.id,
        assetTypeId: assetTypeId ?? this.assetTypeId,
        priceDate: priceDate ?? this.priceDate,
        priceMinor: priceMinor ?? this.priceMinor,
        currency: currency ?? this.currency,
      );
  AssetPriceRow copyWithCompanion(AssetPricesCompanion data) {
    return AssetPriceRow(
      id: data.id.present ? data.id.value : this.id,
      assetTypeId: data.assetTypeId.present ? data.assetTypeId.value : this.assetTypeId,
      priceDate: data.priceDate.present ? data.priceDate.value : this.priceDate,
      priceMinor: data.priceMinor.present ? data.priceMinor.value : this.priceMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetPriceRow(')
          ..write('id: $id, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('priceDate: $priceDate, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assetTypeId, priceDate, priceMinor, currency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetPriceRow &&
          other.id == this.id &&
          other.assetTypeId == this.assetTypeId &&
          other.priceDate == this.priceDate &&
          other.priceMinor == this.priceMinor &&
          other.currency == this.currency);
}

class AssetPricesCompanion extends UpdateCompanion<AssetPriceRow> {
  final Value<String> id;
  final Value<String> assetTypeId;
  final Value<DateTime> priceDate;
  final Value<int> priceMinor;
  final Value<String> currency;
  final Value<int> rowid;
  const AssetPricesCompanion({
    this.id = const Value.absent(),
    this.assetTypeId = const Value.absent(),
    this.priceDate = const Value.absent(),
    this.priceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetPricesCompanion.insert({
    required String id,
    required String assetTypeId,
    required DateTime priceDate,
    required int priceMinor,
    required String currency,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assetTypeId = Value(assetTypeId),
       priceDate = Value(priceDate),
       priceMinor = Value(priceMinor),
       currency = Value(currency);
  static Insertable<AssetPriceRow> custom({
    Expression<String>? id,
    Expression<String>? assetTypeId,
    Expression<DateTime>? priceDate,
    Expression<int>? priceMinor,
    Expression<String>? currency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetTypeId != null) 'asset_type_id': assetTypeId,
      if (priceDate != null) 'price_date': priceDate,
      if (priceMinor != null) 'price_minor': priceMinor,
      if (currency != null) 'currency': currency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetPricesCompanion copyWith({
    Value<String>? id,
    Value<String>? assetTypeId,
    Value<DateTime>? priceDate,
    Value<int>? priceMinor,
    Value<String>? currency,
    Value<int>? rowid,
  }) {
    return AssetPricesCompanion(
      id: id ?? this.id,
      assetTypeId: assetTypeId ?? this.assetTypeId,
      priceDate: priceDate ?? this.priceDate,
      priceMinor: priceMinor ?? this.priceMinor,
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
    if (assetTypeId.present) {
      map['asset_type_id'] = Variable<String>(assetTypeId.value);
    }
    if (priceDate.present) {
      map['price_date'] = Variable<DateTime>(priceDate.value);
    }
    if (priceMinor.present) {
      map['price_minor'] = Variable<int>(priceMinor.value);
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
    return (StringBuffer('AssetPricesCompanion(')
          ..write('id: $id, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('priceDate: $priceDate, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
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
  late final $AssetTypesTable assetTypes = $AssetTypesTable(this);
  late final $AssetMovementsTable assetMovements = $AssetMovementsTable(this);
  late final $AssetPricesTable assetPrices = $AssetPricesTable(this);
  late final $CustomParsersTable customParsers = $CustomParsersTable(this);
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
    assetTypes,
    assetMovements,
    assetPrices,
    customParsers,
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
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                type: type,
                currency: currency,
                isSystem: isSystem,
                archived: archived,
                createdAt: createdAt,
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
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                type: type,
                currency: currency,
                isSystem: isSystem,
                archived: archived,
                createdAt: createdAt,
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
typedef $$AssetTypesTableCreateCompanionBuilder =
    AssetTypesCompanion Function({
      required String id,
      required String nameFa,
      required String nameEn,
      required String unit,
      Value<bool> archived,
      Value<int> rowid,
    });
typedef $$AssetTypesTableUpdateCompanionBuilder =
    AssetTypesCompanion Function({
      Value<String> id,
      Value<String> nameFa,
      Value<String> nameEn,
      Value<String> unit,
      Value<bool> archived,
      Value<int> rowid,
    });

final class $$AssetTypesTableReferences extends BaseReferences<_$KakaDatabase, $AssetTypesTable, AssetTypeRow> {
  $$AssetTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AssetMovementsTable, List<AssetMovementRow>> _assetMovementsRefsTable(
    _$KakaDatabase db,
  ) => MultiTypedResultKey.fromTable(db.assetMovements, aliasName: 'asset_types__id__asset_movements__asset_type_id');

  $$AssetMovementsTableProcessedTableManager get assetMovementsRefs {
    final manager = $$AssetMovementsTableTableManager(
      $_db,
      $_db.assetMovements,
    ).filter((f) => f.assetTypeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_assetMovementsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AssetPricesTable, List<AssetPriceRow>> _assetPricesRefsTable(_$KakaDatabase db) =>
      MultiTypedResultKey.fromTable(db.assetPrices, aliasName: 'asset_types__id__asset_prices__asset_type_id');

  $$AssetPricesTableProcessedTableManager get assetPricesRefs {
    final manager = $$AssetPricesTableTableManager(
      $_db,
      $_db.assetPrices,
    ).filter((f) => f.assetTypeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_assetPricesRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AssetTypesTableFilterComposer extends Composer<_$KakaDatabase, $AssetTypesTable> {
  $$AssetTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameFa =>
      $composableBuilder(column: $table.nameFa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnFilters(column));

  Expression<bool> assetMovementsRefs(Expression<bool> Function($$AssetMovementsTableFilterComposer f) f) {
    final $$AssetMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assetMovements,
      getReferencedColumn: (t) => t.assetTypeId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AssetMovementsTableFilterComposer(
            $db: $db,
            $table: $db.assetMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> assetPricesRefs(Expression<bool> Function($$AssetPricesTableFilterComposer f) f) {
    final $$AssetPricesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assetPrices,
      getReferencedColumn: (t) => t.assetTypeId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AssetPricesTableFilterComposer(
            $db: $db,
            $table: $db.assetPrices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetTypesTableOrderingComposer extends Composer<_$KakaDatabase, $AssetTypesTable> {
  $$AssetTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameFa =>
      $composableBuilder(column: $table.nameFa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnOrderings(column));
}

class $$AssetTypesTableAnnotationComposer extends Composer<_$KakaDatabase, $AssetTypesTable> {
  $$AssetTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameFa => $composableBuilder(column: $table.nameFa, builder: (column) => column);

  GeneratedColumn<String> get nameEn => $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get unit => $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get archived => $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> assetMovementsRefs<T extends Object>(
    Expression<T> Function($$AssetMovementsTableAnnotationComposer a) f,
  ) {
    final $$AssetMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assetMovements,
      getReferencedColumn: (t) => t.assetTypeId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AssetMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.assetMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> assetPricesRefs<T extends Object>(Expression<T> Function($$AssetPricesTableAnnotationComposer a) f) {
    final $$AssetPricesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assetPrices,
      getReferencedColumn: (t) => t.assetTypeId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AssetPricesTableAnnotationComposer(
            $db: $db,
            $table: $db.assetPrices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetTypesTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $AssetTypesTable,
          AssetTypeRow,
          $$AssetTypesTableFilterComposer,
          $$AssetTypesTableOrderingComposer,
          $$AssetTypesTableAnnotationComposer,
          $$AssetTypesTableCreateCompanionBuilder,
          $$AssetTypesTableUpdateCompanionBuilder,
          (AssetTypeRow, $$AssetTypesTableReferences),
          AssetTypeRow,
          PrefetchHooks Function({bool assetMovementsRefs, bool assetPricesRefs})
        > {
  $$AssetTypesTableTableManager(_$KakaDatabase db, $AssetTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$AssetTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$AssetTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$AssetTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameFa = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetTypesCompanion(
                id: id,
                nameFa: nameFa,
                nameEn: nameEn,
                unit: unit,
                archived: archived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameFa,
                required String nameEn,
                required String unit,
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetTypesCompanion.insert(
                id: id,
                nameFa: nameFa,
                nameEn: nameEn,
                unit: unit,
                archived: archived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable<$AssetTypesTable, AssetTypeRow>(table), $$AssetTypesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({assetMovementsRefs = false, assetPricesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (assetMovementsRefs) db.assetMovements, if (assetPricesRefs) db.assetPrices],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (assetMovementsRefs)
                    await $_getPrefetchedData<AssetTypeRow, $AssetTypesTable, AssetMovementRow>(
                      currentTable: table,
                      referencedTable: $$AssetTypesTableReferences._assetMovementsRefsTable(db),
                      managerFromTypedResult: (p0) => $$AssetTypesTableReferences(db, table, p0).assetMovementsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.assetTypeId == item.id),
                      typedResults: items,
                    ),
                  if (assetPricesRefs)
                    await $_getPrefetchedData<AssetTypeRow, $AssetTypesTable, AssetPriceRow>(
                      currentTable: table,
                      referencedTable: $$AssetTypesTableReferences._assetPricesRefsTable(db),
                      managerFromTypedResult: (p0) => $$AssetTypesTableReferences(db, table, p0).assetPricesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.assetTypeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AssetTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $AssetTypesTable,
      AssetTypeRow,
      $$AssetTypesTableFilterComposer,
      $$AssetTypesTableOrderingComposer,
      $$AssetTypesTableAnnotationComposer,
      $$AssetTypesTableCreateCompanionBuilder,
      $$AssetTypesTableUpdateCompanionBuilder,
      (AssetTypeRow, $$AssetTypesTableReferences),
      AssetTypeRow,
      PrefetchHooks Function({bool assetMovementsRefs, bool assetPricesRefs})
    >;
typedef $$AssetMovementsTableCreateCompanionBuilder =
    AssetMovementsCompanion Function({
      required String id,
      required String assetTypeId,
      required int quantityMilli,
      required DateTime movedAt,
      Value<int?> totalMinor,
      Value<String?> totalCurrency,
      Value<String> note,
      Value<DateTime?> voidedAt,
      Value<String?> transactionId,
      Value<int> rowid,
    });
typedef $$AssetMovementsTableUpdateCompanionBuilder =
    AssetMovementsCompanion Function({
      Value<String> id,
      Value<String> assetTypeId,
      Value<int> quantityMilli,
      Value<DateTime> movedAt,
      Value<int?> totalMinor,
      Value<String?> totalCurrency,
      Value<String> note,
      Value<DateTime?> voidedAt,
      Value<String?> transactionId,
      Value<int> rowid,
    });

final class $$AssetMovementsTableReferences
    extends BaseReferences<_$KakaDatabase, $AssetMovementsTable, AssetMovementRow> {
  $$AssetMovementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AssetTypesTable _assetTypeIdTable(_$KakaDatabase db) =>
      db.assetTypes.createAlias('asset_movements__asset_type_id__asset_types__id');

  $$AssetTypesTableProcessedTableManager get assetTypeId {
    final $_column = $_itemColumn<String>('asset_type_id')!;

    final manager = $$AssetTypesTableTableManager($_db, $_db.assetTypes).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AssetMovementsTableFilterComposer extends Composer<_$KakaDatabase, $AssetMovementsTable> {
  $$AssetMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityMilli =>
      $composableBuilder(column: $table.quantityMilli, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get movedAt =>
      $composableBuilder(column: $table.movedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalMinor =>
      $composableBuilder(column: $table.totalMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get totalCurrency =>
      $composableBuilder(column: $table.totalCurrency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionId =>
      $composableBuilder(column: $table.transactionId, builder: (column) => ColumnFilters(column));

  $$AssetTypesTableFilterComposer get assetTypeId {
    final $$AssetTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetTypeId,
      referencedTable: $db.assetTypes,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AssetTypesTableFilterComposer(
            $db: $db,
            $table: $db.assetTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssetMovementsTableOrderingComposer extends Composer<_$KakaDatabase, $AssetMovementsTable> {
  $$AssetMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityMilli =>
      $composableBuilder(column: $table.quantityMilli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get movedAt =>
      $composableBuilder(column: $table.movedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalMinor =>
      $composableBuilder(column: $table.totalMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get totalCurrency =>
      $composableBuilder(column: $table.totalCurrency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionId =>
      $composableBuilder(column: $table.transactionId, builder: (column) => ColumnOrderings(column));

  $$AssetTypesTableOrderingComposer get assetTypeId {
    final $$AssetTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetTypeId,
      referencedTable: $db.assetTypes,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AssetTypesTableOrderingComposer(
            $db: $db,
            $table: $db.assetTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssetMovementsTableAnnotationComposer extends Composer<_$KakaDatabase, $AssetMovementsTable> {
  $$AssetMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantityMilli =>
      $composableBuilder(column: $table.quantityMilli, builder: (column) => column);

  GeneratedColumn<DateTime> get movedAt => $composableBuilder(column: $table.movedAt, builder: (column) => column);

  GeneratedColumn<int> get totalMinor => $composableBuilder(column: $table.totalMinor, builder: (column) => column);

  GeneratedColumn<String> get totalCurrency =>
      $composableBuilder(column: $table.totalCurrency, builder: (column) => column);

  GeneratedColumn<String> get note => $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get voidedAt => $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<String> get transactionId =>
      $composableBuilder(column: $table.transactionId, builder: (column) => column);

  $$AssetTypesTableAnnotationComposer get assetTypeId {
    final $$AssetTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetTypeId,
      referencedTable: $db.assetTypes,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AssetTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.assetTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssetMovementsTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $AssetMovementsTable,
          AssetMovementRow,
          $$AssetMovementsTableFilterComposer,
          $$AssetMovementsTableOrderingComposer,
          $$AssetMovementsTableAnnotationComposer,
          $$AssetMovementsTableCreateCompanionBuilder,
          $$AssetMovementsTableUpdateCompanionBuilder,
          (AssetMovementRow, $$AssetMovementsTableReferences),
          AssetMovementRow,
          PrefetchHooks Function({bool assetTypeId})
        > {
  $$AssetMovementsTableTableManager(_$KakaDatabase db, $AssetMovementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$AssetMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$AssetMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$AssetMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> assetTypeId = const Value.absent(),
                Value<int> quantityMilli = const Value.absent(),
                Value<DateTime> movedAt = const Value.absent(),
                Value<int?> totalMinor = const Value.absent(),
                Value<String?> totalCurrency = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetMovementsCompanion(
                id: id,
                assetTypeId: assetTypeId,
                quantityMilli: quantityMilli,
                movedAt: movedAt,
                totalMinor: totalMinor,
                totalCurrency: totalCurrency,
                note: note,
                voidedAt: voidedAt,
                transactionId: transactionId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String assetTypeId,
                required int quantityMilli,
                required DateTime movedAt,
                Value<int?> totalMinor = const Value.absent(),
                Value<String?> totalCurrency = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetMovementsCompanion.insert(
                id: id,
                assetTypeId: assetTypeId,
                quantityMilli: quantityMilli,
                movedAt: movedAt,
                totalMinor: totalMinor,
                totalCurrency: totalCurrency,
                note: note,
                voidedAt: voidedAt,
                transactionId: transactionId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssetMovementsTable, AssetMovementRow>(table),
                  $$AssetMovementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({assetTypeId = false}) {
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
                    if (assetTypeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.assetTypeId,
                                referencedTable: $$AssetMovementsTableReferences._assetTypeIdTable(db),
                                referencedColumn: $$AssetMovementsTableReferences._assetTypeIdTable(db).id,
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

typedef $$AssetMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $AssetMovementsTable,
      AssetMovementRow,
      $$AssetMovementsTableFilterComposer,
      $$AssetMovementsTableOrderingComposer,
      $$AssetMovementsTableAnnotationComposer,
      $$AssetMovementsTableCreateCompanionBuilder,
      $$AssetMovementsTableUpdateCompanionBuilder,
      (AssetMovementRow, $$AssetMovementsTableReferences),
      AssetMovementRow,
      PrefetchHooks Function({bool assetTypeId})
    >;
typedef $$AssetPricesTableCreateCompanionBuilder =
    AssetPricesCompanion Function({
      required String id,
      required String assetTypeId,
      required DateTime priceDate,
      required int priceMinor,
      required String currency,
      Value<int> rowid,
    });
typedef $$AssetPricesTableUpdateCompanionBuilder =
    AssetPricesCompanion Function({
      Value<String> id,
      Value<String> assetTypeId,
      Value<DateTime> priceDate,
      Value<int> priceMinor,
      Value<String> currency,
      Value<int> rowid,
    });

final class $$AssetPricesTableReferences extends BaseReferences<_$KakaDatabase, $AssetPricesTable, AssetPriceRow> {
  $$AssetPricesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AssetTypesTable _assetTypeIdTable(_$KakaDatabase db) =>
      db.assetTypes.createAlias('asset_prices__asset_type_id__asset_types__id');

  $$AssetTypesTableProcessedTableManager get assetTypeId {
    final $_column = $_itemColumn<String>('asset_type_id')!;

    final manager = $$AssetTypesTableTableManager($_db, $_db.assetTypes).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AssetPricesTableFilterComposer extends Composer<_$KakaDatabase, $AssetPricesTable> {
  $$AssetPricesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get priceDate =>
      $composableBuilder(column: $table.priceDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priceMinor =>
      $composableBuilder(column: $table.priceMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));

  $$AssetTypesTableFilterComposer get assetTypeId {
    final $$AssetTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetTypeId,
      referencedTable: $db.assetTypes,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AssetTypesTableFilterComposer(
            $db: $db,
            $table: $db.assetTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssetPricesTableOrderingComposer extends Composer<_$KakaDatabase, $AssetPricesTable> {
  $$AssetPricesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get priceDate =>
      $composableBuilder(column: $table.priceDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priceMinor =>
      $composableBuilder(column: $table.priceMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));

  $$AssetTypesTableOrderingComposer get assetTypeId {
    final $$AssetTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetTypeId,
      referencedTable: $db.assetTypes,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AssetTypesTableOrderingComposer(
            $db: $db,
            $table: $db.assetTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssetPricesTableAnnotationComposer extends Composer<_$KakaDatabase, $AssetPricesTable> {
  $$AssetPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get priceDate => $composableBuilder(column: $table.priceDate, builder: (column) => column);

  GeneratedColumn<int> get priceMinor => $composableBuilder(column: $table.priceMinor, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);

  $$AssetTypesTableAnnotationComposer get assetTypeId {
    final $$AssetTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetTypeId,
      referencedTable: $db.assetTypes,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AssetTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.assetTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssetPricesTableTableManager
    extends
        RootTableManager<
          _$KakaDatabase,
          $AssetPricesTable,
          AssetPriceRow,
          $$AssetPricesTableFilterComposer,
          $$AssetPricesTableOrderingComposer,
          $$AssetPricesTableAnnotationComposer,
          $$AssetPricesTableCreateCompanionBuilder,
          $$AssetPricesTableUpdateCompanionBuilder,
          (AssetPriceRow, $$AssetPricesTableReferences),
          AssetPriceRow,
          PrefetchHooks Function({bool assetTypeId})
        > {
  $$AssetPricesTableTableManager(_$KakaDatabase db, $AssetPricesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$AssetPricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$AssetPricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$AssetPricesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> assetTypeId = const Value.absent(),
                Value<DateTime> priceDate = const Value.absent(),
                Value<int> priceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetPricesCompanion(
                id: id,
                assetTypeId: assetTypeId,
                priceDate: priceDate,
                priceMinor: priceMinor,
                currency: currency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String assetTypeId,
                required DateTime priceDate,
                required int priceMinor,
                required String currency,
                Value<int> rowid = const Value.absent(),
              }) => AssetPricesCompanion.insert(
                id: id,
                assetTypeId: assetTypeId,
                priceDate: priceDate,
                priceMinor: priceMinor,
                currency: currency,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable<$AssetPricesTable, AssetPriceRow>(table), $$AssetPricesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({assetTypeId = false}) {
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
                    if (assetTypeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.assetTypeId,
                                referencedTable: $$AssetPricesTableReferences._assetTypeIdTable(db),
                                referencedColumn: $$AssetPricesTableReferences._assetTypeIdTable(db).id,
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

typedef $$AssetPricesTableProcessedTableManager =
    ProcessedTableManager<
      _$KakaDatabase,
      $AssetPricesTable,
      AssetPriceRow,
      $$AssetPricesTableFilterComposer,
      $$AssetPricesTableOrderingComposer,
      $$AssetPricesTableAnnotationComposer,
      $$AssetPricesTableCreateCompanionBuilder,
      $$AssetPricesTableUpdateCompanionBuilder,
      (AssetPriceRow, $$AssetPricesTableReferences),
      AssetPriceRow,
      PrefetchHooks Function({bool assetTypeId})
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
  $$AssetTypesTableTableManager get assetTypes => $$AssetTypesTableTableManager(_db, _db.assetTypes);
  $$AssetMovementsTableTableManager get assetMovements => $$AssetMovementsTableTableManager(_db, _db.assetMovements);
  $$AssetPricesTableTableManager get assetPrices => $$AssetPricesTableTableManager(_db, _db.assetPrices);
  $$CustomParsersTableTableManager get customParsers => $$CustomParsersTableTableManager(_db, _db.customParsers);
}
