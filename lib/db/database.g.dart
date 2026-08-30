// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tenMeta = const VerificationMeta('ten');
  @override
  late final GeneratedColumn<String> ten = GeneratedColumn<String>(
    'ten',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mucTieuThangMeta = const VerificationMeta(
    'mucTieuThang',
  );
  @override
  late final GeneratedColumn<int> mucTieuThang = GeneratedColumn<int>(
    'muc_tieu_thang',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _metMeta = const VerificationMeta('met');
  @override
  late final GeneratedColumn<double> met = GeneratedColumn<double>(
    'met',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phutMacDinhMeta = const VerificationMeta(
    'phutMacDinh',
  );
  @override
  late final GeneratedColumn<int> phutMacDinh = GeneratedColumn<int>(
    'phut_mac_dinh',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thuTuMeta = const VerificationMeta('thuTu');
  @override
  late final GeneratedColumn<int> thuTu = GeneratedColumn<int>(
    'thu_tu',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taoLucMeta = const VerificationMeta('taoLuc');
  @override
  late final GeneratedColumn<DateTime> taoLuc = GeneratedColumn<DateTime>(
    'tao_luc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ten,
    mucTieuThang,
    met,
    phutMacDinh,
    thuTu,
    taoLuc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ten')) {
      context.handle(
        _tenMeta,
        ten.isAcceptableOrUnknown(data['ten']!, _tenMeta),
      );
    } else if (isInserting) {
      context.missing(_tenMeta);
    }
    if (data.containsKey('muc_tieu_thang')) {
      context.handle(
        _mucTieuThangMeta,
        mucTieuThang.isAcceptableOrUnknown(
          data['muc_tieu_thang']!,
          _mucTieuThangMeta,
        ),
      );
    }
    if (data.containsKey('met')) {
      context.handle(
        _metMeta,
        met.isAcceptableOrUnknown(data['met']!, _metMeta),
      );
    }
    if (data.containsKey('phut_mac_dinh')) {
      context.handle(
        _phutMacDinhMeta,
        phutMacDinh.isAcceptableOrUnknown(
          data['phut_mac_dinh']!,
          _phutMacDinhMeta,
        ),
      );
    }
    if (data.containsKey('thu_tu')) {
      context.handle(
        _thuTuMeta,
        thuTu.isAcceptableOrUnknown(data['thu_tu']!, _thuTuMeta),
      );
    }
    if (data.containsKey('tao_luc')) {
      context.handle(
        _taoLucMeta,
        taoLuc.isAcceptableOrUnknown(data['tao_luc']!, _taoLucMeta),
      );
    } else if (isInserting) {
      context.missing(_taoLucMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ten: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ten'],
      )!,
      mucTieuThang: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}muc_tieu_thang'],
      )!,
      met: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}met'],
      ),
      phutMacDinh: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phut_mac_dinh'],
      ),
      thuTu: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}thu_tu'],
      )!,
      taoLuc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tao_luc'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final int id;
  final String ten;
  final int mucTieuThang;
  final double? met;
  final int? phutMacDinh;
  final int thuTu;
  final DateTime taoLuc;
  const Habit({
    required this.id,
    required this.ten,
    required this.mucTieuThang,
    this.met,
    this.phutMacDinh,
    required this.thuTu,
    required this.taoLuc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ten'] = Variable<String>(ten);
    map['muc_tieu_thang'] = Variable<int>(mucTieuThang);
    if (!nullToAbsent || met != null) {
      map['met'] = Variable<double>(met);
    }
    if (!nullToAbsent || phutMacDinh != null) {
      map['phut_mac_dinh'] = Variable<int>(phutMacDinh);
    }
    map['thu_tu'] = Variable<int>(thuTu);
    map['tao_luc'] = Variable<DateTime>(taoLuc);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      ten: Value(ten),
      mucTieuThang: Value(mucTieuThang),
      met: met == null && nullToAbsent ? const Value.absent() : Value(met),
      phutMacDinh: phutMacDinh == null && nullToAbsent
          ? const Value.absent()
          : Value(phutMacDinh),
      thuTu: Value(thuTu),
      taoLuc: Value(taoLuc),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<int>(json['id']),
      ten: serializer.fromJson<String>(json['ten']),
      mucTieuThang: serializer.fromJson<int>(json['mucTieuThang']),
      met: serializer.fromJson<double?>(json['met']),
      phutMacDinh: serializer.fromJson<int?>(json['phutMacDinh']),
      thuTu: serializer.fromJson<int>(json['thuTu']),
      taoLuc: serializer.fromJson<DateTime>(json['taoLuc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ten': serializer.toJson<String>(ten),
      'mucTieuThang': serializer.toJson<int>(mucTieuThang),
      'met': serializer.toJson<double?>(met),
      'phutMacDinh': serializer.toJson<int?>(phutMacDinh),
      'thuTu': serializer.toJson<int>(thuTu),
      'taoLuc': serializer.toJson<DateTime>(taoLuc),
    };
  }

  Habit copyWith({
    int? id,
    String? ten,
    int? mucTieuThang,
    Value<double?> met = const Value.absent(),
    Value<int?> phutMacDinh = const Value.absent(),
    int? thuTu,
    DateTime? taoLuc,
  }) => Habit(
    id: id ?? this.id,
    ten: ten ?? this.ten,
    mucTieuThang: mucTieuThang ?? this.mucTieuThang,
    met: met.present ? met.value : this.met,
    phutMacDinh: phutMacDinh.present ? phutMacDinh.value : this.phutMacDinh,
    thuTu: thuTu ?? this.thuTu,
    taoLuc: taoLuc ?? this.taoLuc,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      ten: data.ten.present ? data.ten.value : this.ten,
      mucTieuThang: data.mucTieuThang.present
          ? data.mucTieuThang.value
          : this.mucTieuThang,
      met: data.met.present ? data.met.value : this.met,
      phutMacDinh: data.phutMacDinh.present
          ? data.phutMacDinh.value
          : this.phutMacDinh,
      thuTu: data.thuTu.present ? data.thuTu.value : this.thuTu,
      taoLuc: data.taoLuc.present ? data.taoLuc.value : this.taoLuc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('ten: $ten, ')
          ..write('mucTieuThang: $mucTieuThang, ')
          ..write('met: $met, ')
          ..write('phutMacDinh: $phutMacDinh, ')
          ..write('thuTu: $thuTu, ')
          ..write('taoLuc: $taoLuc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ten, mucTieuThang, met, phutMacDinh, thuTu, taoLuc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.ten == this.ten &&
          other.mucTieuThang == this.mucTieuThang &&
          other.met == this.met &&
          other.phutMacDinh == this.phutMacDinh &&
          other.thuTu == this.thuTu &&
          other.taoLuc == this.taoLuc);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<int> id;
  final Value<String> ten;
  final Value<int> mucTieuThang;
  final Value<double?> met;
  final Value<int?> phutMacDinh;
  final Value<int> thuTu;
  final Value<DateTime> taoLuc;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.ten = const Value.absent(),
    this.mucTieuThang = const Value.absent(),
    this.met = const Value.absent(),
    this.phutMacDinh = const Value.absent(),
    this.thuTu = const Value.absent(),
    this.taoLuc = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    required String ten,
    this.mucTieuThang = const Value.absent(),
    this.met = const Value.absent(),
    this.phutMacDinh = const Value.absent(),
    this.thuTu = const Value.absent(),
    required DateTime taoLuc,
  }) : ten = Value(ten),
       taoLuc = Value(taoLuc);
  static Insertable<Habit> custom({
    Expression<int>? id,
    Expression<String>? ten,
    Expression<int>? mucTieuThang,
    Expression<double>? met,
    Expression<int>? phutMacDinh,
    Expression<int>? thuTu,
    Expression<DateTime>? taoLuc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ten != null) 'ten': ten,
      if (mucTieuThang != null) 'muc_tieu_thang': mucTieuThang,
      if (met != null) 'met': met,
      if (phutMacDinh != null) 'phut_mac_dinh': phutMacDinh,
      if (thuTu != null) 'thu_tu': thuTu,
      if (taoLuc != null) 'tao_luc': taoLuc,
    });
  }

  HabitsCompanion copyWith({
    Value<int>? id,
    Value<String>? ten,
    Value<int>? mucTieuThang,
    Value<double?>? met,
    Value<int?>? phutMacDinh,
    Value<int>? thuTu,
    Value<DateTime>? taoLuc,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      ten: ten ?? this.ten,
      mucTieuThang: mucTieuThang ?? this.mucTieuThang,
      met: met ?? this.met,
      phutMacDinh: phutMacDinh ?? this.phutMacDinh,
      thuTu: thuTu ?? this.thuTu,
      taoLuc: taoLuc ?? this.taoLuc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ten.present) {
      map['ten'] = Variable<String>(ten.value);
    }
    if (mucTieuThang.present) {
      map['muc_tieu_thang'] = Variable<int>(mucTieuThang.value);
    }
    if (met.present) {
      map['met'] = Variable<double>(met.value);
    }
    if (phutMacDinh.present) {
      map['phut_mac_dinh'] = Variable<int>(phutMacDinh.value);
    }
    if (thuTu.present) {
      map['thu_tu'] = Variable<int>(thuTu.value);
    }
    if (taoLuc.present) {
      map['tao_luc'] = Variable<DateTime>(taoLuc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('ten: $ten, ')
          ..write('mucTieuThang: $mucTieuThang, ')
          ..write('met: $met, ')
          ..write('phutMacDinh: $phutMacDinh, ')
          ..write('thuTu: $thuTu, ')
          ..write('taoLuc: $taoLuc')
          ..write(')'))
        .toString();
  }
}

class $TicksTable extends Ticks with TableInfo<$TicksTable, Tick> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TicksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ngayMeta = const VerificationMeta('ngay');
  @override
  late final GeneratedColumn<String> ngay = GeneratedColumn<String>(
    'ngay',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phutMeta = const VerificationMeta('phut');
  @override
  late final GeneratedColumn<int> phut = GeneratedColumn<int>(
    'phut',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [habitId, ngay, phut];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ticks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tick> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('ngay')) {
      context.handle(
        _ngayMeta,
        ngay.isAcceptableOrUnknown(data['ngay']!, _ngayMeta),
      );
    } else if (isInserting) {
      context.missing(_ngayMeta);
    }
    if (data.containsKey('phut')) {
      context.handle(
        _phutMeta,
        phut.isAcceptableOrUnknown(data['phut']!, _phutMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {habitId, ngay};
  @override
  Tick map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tick(
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habit_id'],
      )!,
      ngay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ngay'],
      )!,
      phut: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phut'],
      ),
    );
  }

  @override
  $TicksTable createAlias(String alias) {
    return $TicksTable(attachedDatabase, alias);
  }
}

class Tick extends DataClass implements Insertable<Tick> {
  final int habitId;
  final String ngay;
  final int? phut;
  const Tick({required this.habitId, required this.ngay, this.phut});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['habit_id'] = Variable<int>(habitId);
    map['ngay'] = Variable<String>(ngay);
    if (!nullToAbsent || phut != null) {
      map['phut'] = Variable<int>(phut);
    }
    return map;
  }

  TicksCompanion toCompanion(bool nullToAbsent) {
    return TicksCompanion(
      habitId: Value(habitId),
      ngay: Value(ngay),
      phut: phut == null && nullToAbsent ? const Value.absent() : Value(phut),
    );
  }

  factory Tick.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tick(
      habitId: serializer.fromJson<int>(json['habitId']),
      ngay: serializer.fromJson<String>(json['ngay']),
      phut: serializer.fromJson<int?>(json['phut']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'habitId': serializer.toJson<int>(habitId),
      'ngay': serializer.toJson<String>(ngay),
      'phut': serializer.toJson<int?>(phut),
    };
  }

  Tick copyWith({
    int? habitId,
    String? ngay,
    Value<int?> phut = const Value.absent(),
  }) => Tick(
    habitId: habitId ?? this.habitId,
    ngay: ngay ?? this.ngay,
    phut: phut.present ? phut.value : this.phut,
  );
  Tick copyWithCompanion(TicksCompanion data) {
    return Tick(
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      ngay: data.ngay.present ? data.ngay.value : this.ngay,
      phut: data.phut.present ? data.phut.value : this.phut,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tick(')
          ..write('habitId: $habitId, ')
          ..write('ngay: $ngay, ')
          ..write('phut: $phut')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(habitId, ngay, phut);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tick &&
          other.habitId == this.habitId &&
          other.ngay == this.ngay &&
          other.phut == this.phut);
}

class TicksCompanion extends UpdateCompanion<Tick> {
  final Value<int> habitId;
  final Value<String> ngay;
  final Value<int?> phut;
  final Value<int> rowid;
  const TicksCompanion({
    this.habitId = const Value.absent(),
    this.ngay = const Value.absent(),
    this.phut = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TicksCompanion.insert({
    required int habitId,
    required String ngay,
    this.phut = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : habitId = Value(habitId),
       ngay = Value(ngay);
  static Insertable<Tick> custom({
    Expression<int>? habitId,
    Expression<String>? ngay,
    Expression<int>? phut,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (habitId != null) 'habit_id': habitId,
      if (ngay != null) 'ngay': ngay,
      if (phut != null) 'phut': phut,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TicksCompanion copyWith({
    Value<int>? habitId,
    Value<String>? ngay,
    Value<int?>? phut,
    Value<int>? rowid,
  }) {
    return TicksCompanion(
      habitId: habitId ?? this.habitId,
      ngay: ngay ?? this.ngay,
      phut: phut ?? this.phut,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    if (ngay.present) {
      map['ngay'] = Variable<String>(ngay.value);
    }
    if (phut.present) {
      map['phut'] = Variable<int>(phut.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicksCompanion(')
          ..write('habitId: $habitId, ')
          ..write('ngay: $ngay, ')
          ..write('phut: $phut, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<String> dob = GeneratedColumn<String>(
    'dob',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityMeta = const VerificationMeta(
    'activity',
  );
  @override
  late final GeneratedColumn<double> activity = GeneratedColumn<double>(
    'activity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.2),
  );
  static const VerificationMeta _targetKgMeta = const VerificationMeta(
    'targetKg',
  );
  @override
  late final GeneratedColumn<double> targetKg = GeneratedColumn<double>(
    'target_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sex,
    heightCm,
    dob,
    activity,
    targetKg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('dob')) {
      context.handle(
        _dobMeta,
        dob.isAcceptableOrUnknown(data['dob']!, _dobMeta),
      );
    }
    if (data.containsKey('activity')) {
      context.handle(
        _activityMeta,
        activity.isAcceptableOrUnknown(data['activity']!, _activityMeta),
      );
    }
    if (data.containsKey('target_kg')) {
      context.handle(
        _targetKgMeta,
        targetKg.isAcceptableOrUnknown(data['target_kg']!, _targetKgMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      dob: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dob'],
      ),
      activity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}activity'],
      )!,
      targetKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_kg'],
      ),
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String? sex;
  final double? heightCm;
  final String? dob;
  final double activity;
  final double? targetKg;
  const Profile({
    required this.id,
    this.sex,
    this.heightCm,
    this.dob,
    required this.activity,
    this.targetKg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>(sex);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || dob != null) {
      map['dob'] = Variable<String>(dob);
    }
    map['activity'] = Variable<double>(activity);
    if (!nullToAbsent || targetKg != null) {
      map['target_kg'] = Variable<double>(targetKg);
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      dob: dob == null && nullToAbsent ? const Value.absent() : Value(dob),
      activity: Value(activity),
      targetKg: targetKg == null && nullToAbsent
          ? const Value.absent()
          : Value(targetKg),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      sex: serializer.fromJson<String?>(json['sex']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      dob: serializer.fromJson<String?>(json['dob']),
      activity: serializer.fromJson<double>(json['activity']),
      targetKg: serializer.fromJson<double?>(json['targetKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sex': serializer.toJson<String?>(sex),
      'heightCm': serializer.toJson<double?>(heightCm),
      'dob': serializer.toJson<String?>(dob),
      'activity': serializer.toJson<double>(activity),
      'targetKg': serializer.toJson<double?>(targetKg),
    };
  }

  Profile copyWith({
    int? id,
    Value<String?> sex = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<String?> dob = const Value.absent(),
    double? activity,
    Value<double?> targetKg = const Value.absent(),
  }) => Profile(
    id: id ?? this.id,
    sex: sex.present ? sex.value : this.sex,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    dob: dob.present ? dob.value : this.dob,
    activity: activity ?? this.activity,
    targetKg: targetKg.present ? targetKg.value : this.targetKg,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      sex: data.sex.present ? data.sex.value : this.sex,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      dob: data.dob.present ? data.dob.value : this.dob,
      activity: data.activity.present ? data.activity.value : this.activity,
      targetKg: data.targetKg.present ? data.targetKg.value : this.targetKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('sex: $sex, ')
          ..write('heightCm: $heightCm, ')
          ..write('dob: $dob, ')
          ..write('activity: $activity, ')
          ..write('targetKg: $targetKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sex, heightCm, dob, activity, targetKg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.sex == this.sex &&
          other.heightCm == this.heightCm &&
          other.dob == this.dob &&
          other.activity == this.activity &&
          other.targetKg == this.targetKg);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String?> sex;
  final Value<double?> heightCm;
  final Value<String?> dob;
  final Value<double> activity;
  final Value<double?> targetKg;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.sex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.dob = const Value.absent(),
    this.activity = const Value.absent(),
    this.targetKg = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.sex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.dob = const Value.absent(),
    this.activity = const Value.absent(),
    this.targetKg = const Value.absent(),
  });
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? sex,
    Expression<double>? heightCm,
    Expression<String>? dob,
    Expression<double>? activity,
    Expression<double>? targetKg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sex != null) 'sex': sex,
      if (heightCm != null) 'height_cm': heightCm,
      if (dob != null) 'dob': dob,
      if (activity != null) 'activity': activity,
      if (targetKg != null) 'target_kg': targetKg,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String?>? sex,
    Value<double?>? heightCm,
    Value<String?>? dob,
    Value<double>? activity,
    Value<double?>? targetKg,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      dob: dob ?? this.dob,
      activity: activity ?? this.activity,
      targetKg: targetKg ?? this.targetKg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (dob.present) {
      map['dob'] = Variable<String>(dob.value);
    }
    if (activity.present) {
      map['activity'] = Variable<double>(activity.value);
    }
    if (targetKg.present) {
      map['target_kg'] = Variable<double>(targetKg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('sex: $sex, ')
          ..write('heightCm: $heightCm, ')
          ..write('dob: $dob, ')
          ..write('activity: $activity, ')
          ..write('targetKg: $targetKg')
          ..write(')'))
        .toString();
  }
}

class $WeighInsTable extends WeighIns with TableInfo<$WeighInsTable, WeighIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeighInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ngayMeta = const VerificationMeta('ngay');
  @override
  late final GeneratedColumn<String> ngay = GeneratedColumn<String>(
    'ngay',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kgMeta = const VerificationMeta('kg');
  @override
  late final GeneratedColumn<double> kg = GeneratedColumn<double>(
    'kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [ngay, kg];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weigh_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeighIn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ngay')) {
      context.handle(
        _ngayMeta,
        ngay.isAcceptableOrUnknown(data['ngay']!, _ngayMeta),
      );
    } else if (isInserting) {
      context.missing(_ngayMeta);
    }
    if (data.containsKey('kg')) {
      context.handle(_kgMeta, kg.isAcceptableOrUnknown(data['kg']!, _kgMeta));
    } else if (isInserting) {
      context.missing(_kgMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ngay};
  @override
  WeighIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeighIn(
      ngay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ngay'],
      )!,
      kg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kg'],
      )!,
    );
  }

  @override
  $WeighInsTable createAlias(String alias) {
    return $WeighInsTable(attachedDatabase, alias);
  }
}

class WeighIn extends DataClass implements Insertable<WeighIn> {
  final String ngay;
  final double kg;
  const WeighIn({required this.ngay, required this.kg});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ngay'] = Variable<String>(ngay);
    map['kg'] = Variable<double>(kg);
    return map;
  }

  WeighInsCompanion toCompanion(bool nullToAbsent) {
    return WeighInsCompanion(ngay: Value(ngay), kg: Value(kg));
  }

  factory WeighIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeighIn(
      ngay: serializer.fromJson<String>(json['ngay']),
      kg: serializer.fromJson<double>(json['kg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ngay': serializer.toJson<String>(ngay),
      'kg': serializer.toJson<double>(kg),
    };
  }

  WeighIn copyWith({String? ngay, double? kg}) =>
      WeighIn(ngay: ngay ?? this.ngay, kg: kg ?? this.kg);
  WeighIn copyWithCompanion(WeighInsCompanion data) {
    return WeighIn(
      ngay: data.ngay.present ? data.ngay.value : this.ngay,
      kg: data.kg.present ? data.kg.value : this.kg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeighIn(')
          ..write('ngay: $ngay, ')
          ..write('kg: $kg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ngay, kg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeighIn && other.ngay == this.ngay && other.kg == this.kg);
}

class WeighInsCompanion extends UpdateCompanion<WeighIn> {
  final Value<String> ngay;
  final Value<double> kg;
  final Value<int> rowid;
  const WeighInsCompanion({
    this.ngay = const Value.absent(),
    this.kg = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeighInsCompanion.insert({
    required String ngay,
    required double kg,
    this.rowid = const Value.absent(),
  }) : ngay = Value(ngay),
       kg = Value(kg);
  static Insertable<WeighIn> custom({
    Expression<String>? ngay,
    Expression<double>? kg,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ngay != null) 'ngay': ngay,
      if (kg != null) 'kg': kg,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeighInsCompanion copyWith({
    Value<String>? ngay,
    Value<double>? kg,
    Value<int>? rowid,
  }) {
    return WeighInsCompanion(
      ngay: ngay ?? this.ngay,
      kg: kg ?? this.kg,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ngay.present) {
      map['ngay'] = Variable<String>(ngay.value);
    }
    if (kg.present) {
      map['kg'] = Variable<double>(kg.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeighInsCompanion(')
          ..write('ngay: $ngay, ')
          ..write('kg: $kg, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $TicksTable ticks = $TicksTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $WeighInsTable weighIns = $WeighInsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    habits,
    ticks,
    profiles,
    weighIns,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ticks', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({
  Value<int> id,
  required String ten,
  Value<int> mucTieuThang,
  Value<double?> met,
  Value<int?> phutMacDinh,
  Value<int> thuTu,
  required DateTime taoLuc,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<int> id,
  Value<String> ten,
  Value<int> mucTieuThang,
  Value<double?> met,
  Value<int?> phutMacDinh,
  Value<int> thuTu,
  Value<DateTime> taoLuc,
});

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, Habit> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TicksTable, List<Tick>> _ticksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ticks,
    aliasName: 'habits__id__ticks__habit_id',
  );

  $$TicksTableProcessedTableManager get ticksRefs {
    final manager = $$TicksTableTableManager(
      $_db,
      $_db.ticks,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ticksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ten => $composableBuilder(
    column: $table.ten,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mucTieuThang => $composableBuilder(
    column: $table.mucTieuThang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get met => $composableBuilder(
    column: $table.met,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phutMacDinh => $composableBuilder(
    column: $table.phutMacDinh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get thuTu => $composableBuilder(
    column: $table.thuTu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get taoLuc => $composableBuilder(
    column: $table.taoLuc,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ticksRefs(
    Expression<bool> Function($$TicksTableFilterComposer f) f,
  ) {
    final $$TicksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticks,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicksTableFilterComposer(
            $db: $db,
            $table: $db.ticks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ten => $composableBuilder(
    column: $table.ten,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mucTieuThang => $composableBuilder(
    column: $table.mucTieuThang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get met => $composableBuilder(
    column: $table.met,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phutMacDinh => $composableBuilder(
    column: $table.phutMacDinh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get thuTu => $composableBuilder(
    column: $table.thuTu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get taoLuc => $composableBuilder(
    column: $table.taoLuc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ten =>
      $composableBuilder(column: $table.ten, builder: (column) => column);

  GeneratedColumn<int> get mucTieuThang => $composableBuilder(
    column: $table.mucTieuThang,
    builder: (column) => column,
  );

  GeneratedColumn<double> get met =>
      $composableBuilder(column: $table.met, builder: (column) => column);

  GeneratedColumn<int> get phutMacDinh => $composableBuilder(
    column: $table.phutMacDinh,
    builder: (column) => column,
  );

  GeneratedColumn<int> get thuTu =>
      $composableBuilder(column: $table.thuTu, builder: (column) => column);

  GeneratedColumn<DateTime> get taoLuc =>
      $composableBuilder(column: $table.taoLuc, builder: (column) => column);

  Expression<T> ticksRefs<T extends Object>(
    Expression<T> Function($$TicksTableAnnotationComposer a) f,
  ) {
    final $$TicksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticks,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicksTableAnnotationComposer(
            $db: $db,
            $table: $db.ticks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, $$HabitsTableReferences),
          Habit,
          PrefetchHooks Function({bool ticksRefs})
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> ten = const Value.absent(),
                Value<int> mucTieuThang = const Value.absent(),
                Value<double?> met = const Value.absent(),
                Value<int?> phutMacDinh = const Value.absent(),
                Value<int> thuTu = const Value.absent(),
                Value<DateTime> taoLuc = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                ten: ten,
                mucTieuThang: mucTieuThang,
                met: met,
                phutMacDinh: phutMacDinh,
                thuTu: thuTu,
                taoLuc: taoLuc,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String ten,
                Value<int> mucTieuThang = const Value.absent(),
                Value<double?> met = const Value.absent(),
                Value<int?> phutMacDinh = const Value.absent(),
                Value<int> thuTu = const Value.absent(),
                required DateTime taoLuc,
              }) => HabitsCompanion.insert(
                id: id,
                ten: ten,
                mucTieuThang: mucTieuThang,
                met: met,
                phutMacDinh: phutMacDinh,
                thuTu: thuTu,
                taoLuc: taoLuc,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$HabitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({ticksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ticksRefs) db.ticks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ticksRefs)
                    await $_getPrefetchedData<Habit, $HabitsTable, Tick>(
                      currentTable: table,
                      referencedTable: $$HabitsTableReferences._ticksRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$HabitsTableReferences(db, table, p0).ticksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.habitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, $$HabitsTableReferences),
      Habit,
      PrefetchHooks Function({bool ticksRefs})
    >;
typedef $$TicksTableCreateCompanionBuilder = TicksCompanion Function({
  required int habitId,
  required String ngay,
  Value<int?> phut,
  Value<int> rowid,
});
typedef $$TicksTableUpdateCompanionBuilder = TicksCompanion Function({
  Value<int> habitId,
  Value<String> ngay,
  Value<int?> phut,
  Value<int> rowid,
});

final class $$TicksTableReferences
    extends BaseReferences<_$AppDatabase, $TicksTable, Tick> {
  $$TicksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('ticks__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<int>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TicksTableFilterComposer extends Composer<_$AppDatabase, $TicksTable> {
  $$TicksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ngay => $composableBuilder(
    column: $table.ngay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phut => $composableBuilder(
    column: $table.phut,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicksTableOrderingComposer
    extends Composer<_$AppDatabase, $TicksTable> {
  $$TicksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ngay => $composableBuilder(
    column: $table.ngay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phut => $composableBuilder(
    column: $table.phut,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TicksTable> {
  $$TicksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ngay =>
      $composableBuilder(column: $table.ngay, builder: (column) => column);

  GeneratedColumn<int> get phut =>
      $composableBuilder(column: $table.phut, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TicksTable,
          Tick,
          $$TicksTableFilterComposer,
          $$TicksTableOrderingComposer,
          $$TicksTableAnnotationComposer,
          $$TicksTableCreateCompanionBuilder,
          $$TicksTableUpdateCompanionBuilder,
          (Tick, $$TicksTableReferences),
          Tick,
          PrefetchHooks Function({bool habitId})
        > {
  $$TicksTableTableManager(_$AppDatabase db, $TicksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TicksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TicksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TicksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> habitId = const Value.absent(),
                Value<String> ngay = const Value.absent(),
                Value<int?> phut = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicksCompanion(
                habitId: habitId,
                ngay: ngay,
                phut: phut,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int habitId,
                required String ngay,
                Value<int?> phut = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicksCompanion.insert(
                habitId: habitId,
                ngay: ngay,
                phut: phut,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TicksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
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
                    if (habitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.habitId,
                        referencedTable: $$TicksTableReferences._habitIdTable(
                          db,
                        ),
                        referencedColumn: $$TicksTableReferences
                            ._habitIdTable(db)
                            .id,
                      ) as T;
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

typedef $$TicksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TicksTable,
      Tick,
      $$TicksTableFilterComposer,
      $$TicksTableOrderingComposer,
      $$TicksTableAnnotationComposer,
      $$TicksTableCreateCompanionBuilder,
      $$TicksTableUpdateCompanionBuilder,
      (Tick, $$TicksTableReferences),
      Tick,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String?> sex,
  Value<double?> heightCm,
  Value<String?> dob,
  Value<double> activity,
  Value<double?> targetKg,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String?> sex,
  Value<double?> heightCm,
  Value<String?> dob,
  Value<double> activity,
  Value<double?> targetKg,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetKg => $composableBuilder(
    column: $table.targetKg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetKg => $composableBuilder(
    column: $table.targetKg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<String> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<double> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => column);

  GeneratedColumn<double> get targetKg =>
      $composableBuilder(column: $table.targetKg, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<String?> dob = const Value.absent(),
                Value<double> activity = const Value.absent(),
                Value<double?> targetKg = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                sex: sex,
                heightCm: heightCm,
                dob: dob,
                activity: activity,
                targetKg: targetKg,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<String?> dob = const Value.absent(),
                Value<double> activity = const Value.absent(),
                Value<double?> targetKg = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                sex: sex,
                heightCm: heightCm,
                dob: dob,
                activity: activity,
                targetKg: targetKg,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$WeighInsTableCreateCompanionBuilder = WeighInsCompanion Function({
  required String ngay,
  required double kg,
  Value<int> rowid,
});
typedef $$WeighInsTableUpdateCompanionBuilder = WeighInsCompanion Function({
  Value<String> ngay,
  Value<double> kg,
  Value<int> rowid,
});

class $$WeighInsTableFilterComposer
    extends Composer<_$AppDatabase, $WeighInsTable> {
  $$WeighInsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ngay => $composableBuilder(
    column: $table.ngay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kg => $composableBuilder(
    column: $table.kg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeighInsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeighInsTable> {
  $$WeighInsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ngay => $composableBuilder(
    column: $table.ngay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kg => $composableBuilder(
    column: $table.kg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeighInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeighInsTable> {
  $$WeighInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ngay =>
      $composableBuilder(column: $table.ngay, builder: (column) => column);

  GeneratedColumn<double> get kg =>
      $composableBuilder(column: $table.kg, builder: (column) => column);
}

class $$WeighInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeighInsTable,
          WeighIn,
          $$WeighInsTableFilterComposer,
          $$WeighInsTableOrderingComposer,
          $$WeighInsTableAnnotationComposer,
          $$WeighInsTableCreateCompanionBuilder,
          $$WeighInsTableUpdateCompanionBuilder,
          (WeighIn, BaseReferences<_$AppDatabase, $WeighInsTable, WeighIn>),
          WeighIn,
          PrefetchHooks Function()
        > {
  $$WeighInsTableTableManager(_$AppDatabase db, $WeighInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeighInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeighInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeighInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> ngay = const Value.absent(),
            Value<double> kg = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => WeighInsCompanion(ngay: ngay, kg: kg, rowid: rowid),
          createCompanionCallback: ({
            required String ngay,
            required double kg,
            Value<int> rowid = const Value.absent(),
          }) => WeighInsCompanion.insert(ngay: ngay, kg: kg, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeighInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeighInsTable,
      WeighIn,
      $$WeighInsTableFilterComposer,
      $$WeighInsTableOrderingComposer,
      $$WeighInsTableAnnotationComposer,
      $$WeighInsTableCreateCompanionBuilder,
      $$WeighInsTableUpdateCompanionBuilder,
      (WeighIn, BaseReferences<_$AppDatabase, $WeighInsTable, WeighIn>),
      WeighIn,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$TicksTableTableManager get ticks =>
      $$TicksTableTableManager(_db, _db.ticks);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$WeighInsTableTableManager get weighIns =>
      $$WeighInsTableTableManager(_db, _db.weighIns);
}
