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
  static const VerificationMeta _thuBitMeta = const VerificationMeta('thuBit');
  @override
  late final GeneratedColumn<String> thuBit = GeneratedColumn<String>(
    'thu_bit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1234567'),
  );
  static const VerificationMeta _gioNhacMeta = const VerificationMeta(
    'gioNhac',
  );
  @override
  late final GeneratedColumn<int> gioNhac = GeneratedColumn<int>(
    'gio_nhac',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anMeta = const VerificationMeta('an');
  @override
  late final GeneratedColumn<bool> an = GeneratedColumn<bool>(
    'an',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("an" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _anTuMeta = const VerificationMeta('anTu');
  @override
  late final GeneratedColumn<String> anTu = GeneratedColumn<String>(
    'an_tu',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    thuBit,
    gioNhac,
    an,
    anTu,
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
    if (data.containsKey('thu_bit')) {
      context.handle(
        _thuBitMeta,
        thuBit.isAcceptableOrUnknown(data['thu_bit']!, _thuBitMeta),
      );
    }
    if (data.containsKey('gio_nhac')) {
      context.handle(
        _gioNhacMeta,
        gioNhac.isAcceptableOrUnknown(data['gio_nhac']!, _gioNhacMeta),
      );
    }
    if (data.containsKey('an')) {
      context.handle(_anMeta, an.isAcceptableOrUnknown(data['an']!, _anMeta));
    }
    if (data.containsKey('an_tu')) {
      context.handle(
        _anTuMeta,
        anTu.isAcceptableOrUnknown(data['an_tu']!, _anTuMeta),
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
      thuBit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thu_bit'],
      )!,
      gioNhac: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gio_nhac'],
      ),
      an: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}an'],
      )!,
      anTu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}an_tu'],
      ),
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
  final String thuBit;
  final int? gioNhac;
  final bool an;
  final String? anTu;
  final DateTime taoLuc;
  const Habit({
    required this.id,
    required this.ten,
    required this.mucTieuThang,
    this.met,
    this.phutMacDinh,
    required this.thuTu,
    required this.thuBit,
    this.gioNhac,
    required this.an,
    this.anTu,
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
    map['thu_bit'] = Variable<String>(thuBit);
    if (!nullToAbsent || gioNhac != null) {
      map['gio_nhac'] = Variable<int>(gioNhac);
    }
    map['an'] = Variable<bool>(an);
    if (!nullToAbsent || anTu != null) {
      map['an_tu'] = Variable<String>(anTu);
    }
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
      thuBit: Value(thuBit),
      gioNhac: gioNhac == null && nullToAbsent
          ? const Value.absent()
          : Value(gioNhac),
      an: Value(an),
      anTu: anTu == null && nullToAbsent ? const Value.absent() : Value(anTu),
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
      thuBit: serializer.fromJson<String>(json['thuBit']),
      gioNhac: serializer.fromJson<int?>(json['gioNhac']),
      an: serializer.fromJson<bool>(json['an']),
      anTu: serializer.fromJson<String?>(json['anTu']),
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
      'thuBit': serializer.toJson<String>(thuBit),
      'gioNhac': serializer.toJson<int?>(gioNhac),
      'an': serializer.toJson<bool>(an),
      'anTu': serializer.toJson<String?>(anTu),
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
    String? thuBit,
    Value<int?> gioNhac = const Value.absent(),
    bool? an,
    Value<String?> anTu = const Value.absent(),
    DateTime? taoLuc,
  }) => Habit(
    id: id ?? this.id,
    ten: ten ?? this.ten,
    mucTieuThang: mucTieuThang ?? this.mucTieuThang,
    met: met.present ? met.value : this.met,
    phutMacDinh: phutMacDinh.present ? phutMacDinh.value : this.phutMacDinh,
    thuTu: thuTu ?? this.thuTu,
    thuBit: thuBit ?? this.thuBit,
    gioNhac: gioNhac.present ? gioNhac.value : this.gioNhac,
    an: an ?? this.an,
    anTu: anTu.present ? anTu.value : this.anTu,
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
      thuBit: data.thuBit.present ? data.thuBit.value : this.thuBit,
      gioNhac: data.gioNhac.present ? data.gioNhac.value : this.gioNhac,
      an: data.an.present ? data.an.value : this.an,
      anTu: data.anTu.present ? data.anTu.value : this.anTu,
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
          ..write('thuBit: $thuBit, ')
          ..write('gioNhac: $gioNhac, ')
          ..write('an: $an, ')
          ..write('anTu: $anTu, ')
          ..write('taoLuc: $taoLuc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ten,
    mucTieuThang,
    met,
    phutMacDinh,
    thuTu,
    thuBit,
    gioNhac,
    an,
    anTu,
    taoLuc,
  );
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
          other.thuBit == this.thuBit &&
          other.gioNhac == this.gioNhac &&
          other.an == this.an &&
          other.anTu == this.anTu &&
          other.taoLuc == this.taoLuc);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<int> id;
  final Value<String> ten;
  final Value<int> mucTieuThang;
  final Value<double?> met;
  final Value<int?> phutMacDinh;
  final Value<int> thuTu;
  final Value<String> thuBit;
  final Value<int?> gioNhac;
  final Value<bool> an;
  final Value<String?> anTu;
  final Value<DateTime> taoLuc;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.ten = const Value.absent(),
    this.mucTieuThang = const Value.absent(),
    this.met = const Value.absent(),
    this.phutMacDinh = const Value.absent(),
    this.thuTu = const Value.absent(),
    this.thuBit = const Value.absent(),
    this.gioNhac = const Value.absent(),
    this.an = const Value.absent(),
    this.anTu = const Value.absent(),
    this.taoLuc = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    required String ten,
    this.mucTieuThang = const Value.absent(),
    this.met = const Value.absent(),
    this.phutMacDinh = const Value.absent(),
    this.thuTu = const Value.absent(),
    this.thuBit = const Value.absent(),
    this.gioNhac = const Value.absent(),
    this.an = const Value.absent(),
    this.anTu = const Value.absent(),
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
    Expression<String>? thuBit,
    Expression<int>? gioNhac,
    Expression<bool>? an,
    Expression<String>? anTu,
    Expression<DateTime>? taoLuc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ten != null) 'ten': ten,
      if (mucTieuThang != null) 'muc_tieu_thang': mucTieuThang,
      if (met != null) 'met': met,
      if (phutMacDinh != null) 'phut_mac_dinh': phutMacDinh,
      if (thuTu != null) 'thu_tu': thuTu,
      if (thuBit != null) 'thu_bit': thuBit,
      if (gioNhac != null) 'gio_nhac': gioNhac,
      if (an != null) 'an': an,
      if (anTu != null) 'an_tu': anTu,
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
    Value<String>? thuBit,
    Value<int?>? gioNhac,
    Value<bool>? an,
    Value<String?>? anTu,
    Value<DateTime>? taoLuc,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      ten: ten ?? this.ten,
      mucTieuThang: mucTieuThang ?? this.mucTieuThang,
      met: met ?? this.met,
      phutMacDinh: phutMacDinh ?? this.phutMacDinh,
      thuTu: thuTu ?? this.thuTu,
      thuBit: thuBit ?? this.thuBit,
      gioNhac: gioNhac ?? this.gioNhac,
      an: an ?? this.an,
      anTu: anTu ?? this.anTu,
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
    if (thuBit.present) {
      map['thu_bit'] = Variable<String>(thuBit.value);
    }
    if (gioNhac.present) {
      map['gio_nhac'] = Variable<int>(gioNhac.value);
    }
    if (an.present) {
      map['an'] = Variable<bool>(an.value);
    }
    if (anTu.present) {
      map['an_tu'] = Variable<String>(anTu.value);
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
          ..write('thuBit: $thuBit, ')
          ..write('gioNhac: $gioNhac, ')
          ..write('an: $an, ')
          ..write('anTu: $anTu, ')
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
  static const VerificationMeta _tenGoiMeta = const VerificationMeta('tenGoi');
  @override
  late final GeneratedColumn<String> tenGoi = GeneratedColumn<String>(
    'ten_goi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nhipKgMeta = const VerificationMeta('nhipKg');
  @override
  late final GeneratedColumn<double> nhipKg = GeneratedColumn<double>(
    'nhip_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.5),
  );
  static const VerificationMeta _startKgMeta = const VerificationMeta(
    'startKg',
  );
  @override
  late final GeneratedColumn<double> startKg = GeneratedColumn<double>(
    'start_kg',
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
    tenGoi,
    nhipKg,
    startKg,
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
    if (data.containsKey('ten_goi')) {
      context.handle(
        _tenGoiMeta,
        tenGoi.isAcceptableOrUnknown(data['ten_goi']!, _tenGoiMeta),
      );
    }
    if (data.containsKey('nhip_kg')) {
      context.handle(
        _nhipKgMeta,
        nhipKg.isAcceptableOrUnknown(data['nhip_kg']!, _nhipKgMeta),
      );
    }
    if (data.containsKey('start_kg')) {
      context.handle(
        _startKgMeta,
        startKg.isAcceptableOrUnknown(data['start_kg']!, _startKgMeta),
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
      tenGoi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ten_goi'],
      ),
      nhipKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}nhip_kg'],
      )!,
      startKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_kg'],
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
  final String? tenGoi;
  final double nhipKg;
  final double? startKg;
  const Profile({
    required this.id,
    this.sex,
    this.heightCm,
    this.dob,
    required this.activity,
    this.targetKg,
    this.tenGoi,
    required this.nhipKg,
    this.startKg,
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
    if (!nullToAbsent || tenGoi != null) {
      map['ten_goi'] = Variable<String>(tenGoi);
    }
    map['nhip_kg'] = Variable<double>(nhipKg);
    if (!nullToAbsent || startKg != null) {
      map['start_kg'] = Variable<double>(startKg);
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
      tenGoi: tenGoi == null && nullToAbsent
          ? const Value.absent()
          : Value(tenGoi),
      nhipKg: Value(nhipKg),
      startKg: startKg == null && nullToAbsent
          ? const Value.absent()
          : Value(startKg),
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
      tenGoi: serializer.fromJson<String?>(json['tenGoi']),
      nhipKg: serializer.fromJson<double>(json['nhipKg']),
      startKg: serializer.fromJson<double?>(json['startKg']),
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
      'tenGoi': serializer.toJson<String?>(tenGoi),
      'nhipKg': serializer.toJson<double>(nhipKg),
      'startKg': serializer.toJson<double?>(startKg),
    };
  }

  Profile copyWith({
    int? id,
    Value<String?> sex = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<String?> dob = const Value.absent(),
    double? activity,
    Value<double?> targetKg = const Value.absent(),
    Value<String?> tenGoi = const Value.absent(),
    double? nhipKg,
    Value<double?> startKg = const Value.absent(),
  }) => Profile(
    id: id ?? this.id,
    sex: sex.present ? sex.value : this.sex,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    dob: dob.present ? dob.value : this.dob,
    activity: activity ?? this.activity,
    targetKg: targetKg.present ? targetKg.value : this.targetKg,
    tenGoi: tenGoi.present ? tenGoi.value : this.tenGoi,
    nhipKg: nhipKg ?? this.nhipKg,
    startKg: startKg.present ? startKg.value : this.startKg,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      sex: data.sex.present ? data.sex.value : this.sex,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      dob: data.dob.present ? data.dob.value : this.dob,
      activity: data.activity.present ? data.activity.value : this.activity,
      targetKg: data.targetKg.present ? data.targetKg.value : this.targetKg,
      tenGoi: data.tenGoi.present ? data.tenGoi.value : this.tenGoi,
      nhipKg: data.nhipKg.present ? data.nhipKg.value : this.nhipKg,
      startKg: data.startKg.present ? data.startKg.value : this.startKg,
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
          ..write('targetKg: $targetKg, ')
          ..write('tenGoi: $tenGoi, ')
          ..write('nhipKg: $nhipKg, ')
          ..write('startKg: $startKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sex,
    heightCm,
    dob,
    activity,
    targetKg,
    tenGoi,
    nhipKg,
    startKg,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.sex == this.sex &&
          other.heightCm == this.heightCm &&
          other.dob == this.dob &&
          other.activity == this.activity &&
          other.targetKg == this.targetKg &&
          other.tenGoi == this.tenGoi &&
          other.nhipKg == this.nhipKg &&
          other.startKg == this.startKg);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String?> sex;
  final Value<double?> heightCm;
  final Value<String?> dob;
  final Value<double> activity;
  final Value<double?> targetKg;
  final Value<String?> tenGoi;
  final Value<double> nhipKg;
  final Value<double?> startKg;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.sex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.dob = const Value.absent(),
    this.activity = const Value.absent(),
    this.targetKg = const Value.absent(),
    this.tenGoi = const Value.absent(),
    this.nhipKg = const Value.absent(),
    this.startKg = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.sex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.dob = const Value.absent(),
    this.activity = const Value.absent(),
    this.targetKg = const Value.absent(),
    this.tenGoi = const Value.absent(),
    this.nhipKg = const Value.absent(),
    this.startKg = const Value.absent(),
  });
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? sex,
    Expression<double>? heightCm,
    Expression<String>? dob,
    Expression<double>? activity,
    Expression<double>? targetKg,
    Expression<String>? tenGoi,
    Expression<double>? nhipKg,
    Expression<double>? startKg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sex != null) 'sex': sex,
      if (heightCm != null) 'height_cm': heightCm,
      if (dob != null) 'dob': dob,
      if (activity != null) 'activity': activity,
      if (targetKg != null) 'target_kg': targetKg,
      if (tenGoi != null) 'ten_goi': tenGoi,
      if (nhipKg != null) 'nhip_kg': nhipKg,
      if (startKg != null) 'start_kg': startKg,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String?>? sex,
    Value<double?>? heightCm,
    Value<String?>? dob,
    Value<double>? activity,
    Value<double?>? targetKg,
    Value<String?>? tenGoi,
    Value<double>? nhipKg,
    Value<double?>? startKg,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      dob: dob ?? this.dob,
      activity: activity ?? this.activity,
      targetKg: targetKg ?? this.targetKg,
      tenGoi: tenGoi ?? this.tenGoi,
      nhipKg: nhipKg ?? this.nhipKg,
      startKg: startKg ?? this.startKg,
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
    if (tenGoi.present) {
      map['ten_goi'] = Variable<String>(tenGoi.value);
    }
    if (nhipKg.present) {
      map['nhip_kg'] = Variable<double>(nhipKg.value);
    }
    if (startKg.present) {
      map['start_kg'] = Variable<double>(startKg.value);
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
          ..write('targetKg: $targetKg, ')
          ..write('tenGoi: $tenGoi, ')
          ..write('nhipKg: $nhipKg, ')
          ..write('startKg: $startKg')
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

class $EoInsTable extends EoIns with TableInfo<$EoInsTable, EoIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EoInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ngayMeta = const VerificationMeta('ngay');
  @override
  late final GeneratedColumn<String> ngay = GeneratedColumn<String>(
    'ngay',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cmMeta = const VerificationMeta('cm');
  @override
  late final GeneratedColumn<double> cm = GeneratedColumn<double>(
    'cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [ngay, cm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'eo_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<EoIn> instance, {
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
    if (data.containsKey('cm')) {
      context.handle(_cmMeta, cm.isAcceptableOrUnknown(data['cm']!, _cmMeta));
    } else if (isInserting) {
      context.missing(_cmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ngay};
  @override
  EoIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EoIn(
      ngay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ngay'],
      )!,
      cm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cm'],
      )!,
    );
  }

  @override
  $EoInsTable createAlias(String alias) {
    return $EoInsTable(attachedDatabase, alias);
  }
}

class EoIn extends DataClass implements Insertable<EoIn> {
  final String ngay;
  final double cm;
  const EoIn({required this.ngay, required this.cm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ngay'] = Variable<String>(ngay);
    map['cm'] = Variable<double>(cm);
    return map;
  }

  EoInsCompanion toCompanion(bool nullToAbsent) {
    return EoInsCompanion(ngay: Value(ngay), cm: Value(cm));
  }

  factory EoIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EoIn(
      ngay: serializer.fromJson<String>(json['ngay']),
      cm: serializer.fromJson<double>(json['cm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ngay': serializer.toJson<String>(ngay),
      'cm': serializer.toJson<double>(cm),
    };
  }

  EoIn copyWith({String? ngay, double? cm}) =>
      EoIn(ngay: ngay ?? this.ngay, cm: cm ?? this.cm);
  EoIn copyWithCompanion(EoInsCompanion data) {
    return EoIn(
      ngay: data.ngay.present ? data.ngay.value : this.ngay,
      cm: data.cm.present ? data.cm.value : this.cm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EoIn(')
          ..write('ngay: $ngay, ')
          ..write('cm: $cm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ngay, cm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EoIn && other.ngay == this.ngay && other.cm == this.cm);
}

class EoInsCompanion extends UpdateCompanion<EoIn> {
  final Value<String> ngay;
  final Value<double> cm;
  final Value<int> rowid;
  const EoInsCompanion({
    this.ngay = const Value.absent(),
    this.cm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EoInsCompanion.insert({
    required String ngay,
    required double cm,
    this.rowid = const Value.absent(),
  }) : ngay = Value(ngay),
       cm = Value(cm);
  static Insertable<EoIn> custom({
    Expression<String>? ngay,
    Expression<double>? cm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ngay != null) 'ngay': ngay,
      if (cm != null) 'cm': cm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EoInsCompanion copyWith({
    Value<String>? ngay,
    Value<double>? cm,
    Value<int>? rowid,
  }) {
    return EoInsCompanion(
      ngay: ngay ?? this.ngay,
      cm: cm ?? this.cm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ngay.present) {
      map['ngay'] = Variable<String>(ngay.value);
    }
    if (cm.present) {
      map['cm'] = Variable<double>(cm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EoInsCompanion(')
          ..write('ngay: $ngay, ')
          ..write('cm: $cm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoInsTable extends MoIns with TableInfo<$MoInsTable, MoIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ngayMeta = const VerificationMeta('ngay');
  @override
  late final GeneratedColumn<String> ngay = GeneratedColumn<String>(
    'ngay',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pctMeta = const VerificationMeta('pct');
  @override
  late final GeneratedColumn<double> pct = GeneratedColumn<double>(
    'pct',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [ngay, pct];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mo_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoIn> instance, {
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
    if (data.containsKey('pct')) {
      context.handle(
        _pctMeta,
        pct.isAcceptableOrUnknown(data['pct']!, _pctMeta),
      );
    } else if (isInserting) {
      context.missing(_pctMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ngay};
  @override
  MoIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoIn(
      ngay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ngay'],
      )!,
      pct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pct'],
      )!,
    );
  }

  @override
  $MoInsTable createAlias(String alias) {
    return $MoInsTable(attachedDatabase, alias);
  }
}

class MoIn extends DataClass implements Insertable<MoIn> {
  final String ngay;
  final double pct;
  const MoIn({required this.ngay, required this.pct});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ngay'] = Variable<String>(ngay);
    map['pct'] = Variable<double>(pct);
    return map;
  }

  MoInsCompanion toCompanion(bool nullToAbsent) {
    return MoInsCompanion(ngay: Value(ngay), pct: Value(pct));
  }

  factory MoIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoIn(
      ngay: serializer.fromJson<String>(json['ngay']),
      pct: serializer.fromJson<double>(json['pct']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ngay': serializer.toJson<String>(ngay),
      'pct': serializer.toJson<double>(pct),
    };
  }

  MoIn copyWith({String? ngay, double? pct}) =>
      MoIn(ngay: ngay ?? this.ngay, pct: pct ?? this.pct);
  MoIn copyWithCompanion(MoInsCompanion data) {
    return MoIn(
      ngay: data.ngay.present ? data.ngay.value : this.ngay,
      pct: data.pct.present ? data.pct.value : this.pct,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoIn(')
          ..write('ngay: $ngay, ')
          ..write('pct: $pct')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ngay, pct);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoIn && other.ngay == this.ngay && other.pct == this.pct);
}

class MoInsCompanion extends UpdateCompanion<MoIn> {
  final Value<String> ngay;
  final Value<double> pct;
  final Value<int> rowid;
  const MoInsCompanion({
    this.ngay = const Value.absent(),
    this.pct = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoInsCompanion.insert({
    required String ngay,
    required double pct,
    this.rowid = const Value.absent(),
  }) : ngay = Value(ngay),
       pct = Value(pct);
  static Insertable<MoIn> custom({
    Expression<String>? ngay,
    Expression<double>? pct,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ngay != null) 'ngay': ngay,
      if (pct != null) 'pct': pct,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoInsCompanion copyWith({
    Value<String>? ngay,
    Value<double>? pct,
    Value<int>? rowid,
  }) {
    return MoInsCompanion(
      ngay: ngay ?? this.ngay,
      pct: pct ?? this.pct,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ngay.present) {
      map['ngay'] = Variable<String>(ngay.value);
    }
    if (pct.present) {
      map['pct'] = Variable<double>(pct.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoInsCompanion(')
          ..write('ngay: $ngay, ')
          ..write('pct: $pct, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TapInsTable extends TapIns with TableInfo<$TapInsTable, TapIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TapInsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _ngayMeta = const VerificationMeta('ngay');
  @override
  late final GeneratedColumn<String> ngay = GeneratedColumn<String>(
    'ngay',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loaiMeta = const VerificationMeta('loai');
  @override
  late final GeneratedColumn<String> loai = GeneratedColumn<String>(
    'loai',
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, ngay, loai, phut];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tap_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<TapIn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ngay')) {
      context.handle(
        _ngayMeta,
        ngay.isAcceptableOrUnknown(data['ngay']!, _ngayMeta),
      );
    } else if (isInserting) {
      context.missing(_ngayMeta);
    }
    if (data.containsKey('loai')) {
      context.handle(
        _loaiMeta,
        loai.isAcceptableOrUnknown(data['loai']!, _loaiMeta),
      );
    } else if (isInserting) {
      context.missing(_loaiMeta);
    }
    if (data.containsKey('phut')) {
      context.handle(
        _phutMeta,
        phut.isAcceptableOrUnknown(data['phut']!, _phutMeta),
      );
    } else if (isInserting) {
      context.missing(_phutMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TapIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TapIn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ngay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ngay'],
      )!,
      loai: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loai'],
      )!,
      phut: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phut'],
      )!,
    );
  }

  @override
  $TapInsTable createAlias(String alias) {
    return $TapInsTable(attachedDatabase, alias);
  }
}

class TapIn extends DataClass implements Insertable<TapIn> {
  final int id;
  final String ngay;
  final String loai;
  final int phut;
  const TapIn({
    required this.id,
    required this.ngay,
    required this.loai,
    required this.phut,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ngay'] = Variable<String>(ngay);
    map['loai'] = Variable<String>(loai);
    map['phut'] = Variable<int>(phut);
    return map;
  }

  TapInsCompanion toCompanion(bool nullToAbsent) {
    return TapInsCompanion(
      id: Value(id),
      ngay: Value(ngay),
      loai: Value(loai),
      phut: Value(phut),
    );
  }

  factory TapIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TapIn(
      id: serializer.fromJson<int>(json['id']),
      ngay: serializer.fromJson<String>(json['ngay']),
      loai: serializer.fromJson<String>(json['loai']),
      phut: serializer.fromJson<int>(json['phut']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ngay': serializer.toJson<String>(ngay),
      'loai': serializer.toJson<String>(loai),
      'phut': serializer.toJson<int>(phut),
    };
  }

  TapIn copyWith({int? id, String? ngay, String? loai, int? phut}) => TapIn(
    id: id ?? this.id,
    ngay: ngay ?? this.ngay,
    loai: loai ?? this.loai,
    phut: phut ?? this.phut,
  );
  TapIn copyWithCompanion(TapInsCompanion data) {
    return TapIn(
      id: data.id.present ? data.id.value : this.id,
      ngay: data.ngay.present ? data.ngay.value : this.ngay,
      loai: data.loai.present ? data.loai.value : this.loai,
      phut: data.phut.present ? data.phut.value : this.phut,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TapIn(')
          ..write('id: $id, ')
          ..write('ngay: $ngay, ')
          ..write('loai: $loai, ')
          ..write('phut: $phut')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ngay, loai, phut);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TapIn &&
          other.id == this.id &&
          other.ngay == this.ngay &&
          other.loai == this.loai &&
          other.phut == this.phut);
}

class TapInsCompanion extends UpdateCompanion<TapIn> {
  final Value<int> id;
  final Value<String> ngay;
  final Value<String> loai;
  final Value<int> phut;
  const TapInsCompanion({
    this.id = const Value.absent(),
    this.ngay = const Value.absent(),
    this.loai = const Value.absent(),
    this.phut = const Value.absent(),
  });
  TapInsCompanion.insert({
    this.id = const Value.absent(),
    required String ngay,
    required String loai,
    required int phut,
  }) : ngay = Value(ngay),
       loai = Value(loai),
       phut = Value(phut);
  static Insertable<TapIn> custom({
    Expression<int>? id,
    Expression<String>? ngay,
    Expression<String>? loai,
    Expression<int>? phut,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ngay != null) 'ngay': ngay,
      if (loai != null) 'loai': loai,
      if (phut != null) 'phut': phut,
    });
  }

  TapInsCompanion copyWith({
    Value<int>? id,
    Value<String>? ngay,
    Value<String>? loai,
    Value<int>? phut,
  }) {
    return TapInsCompanion(
      id: id ?? this.id,
      ngay: ngay ?? this.ngay,
      loai: loai ?? this.loai,
      phut: phut ?? this.phut,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ngay.present) {
      map['ngay'] = Variable<String>(ngay.value);
    }
    if (loai.present) {
      map['loai'] = Variable<String>(loai.value);
    }
    if (phut.present) {
      map['phut'] = Variable<int>(phut.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TapInsCompanion(')
          ..write('id: $id, ')
          ..write('ngay: $ngay, ')
          ..write('loai: $loai, ')
          ..write('phut: $phut')
          ..write(')'))
        .toString();
  }
}

class $ChiSoInsTable extends ChiSoIns with TableInfo<$ChiSoInsTable, ChiSoIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChiSoInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ngayMeta = const VerificationMeta('ngay');
  @override
  late final GeneratedColumn<String> ngay = GeneratedColumn<String>(
    'ngay',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eoMeta = const VerificationMeta('eo');
  @override
  late final GeneratedColumn<double> eo = GeneratedColumn<double>(
    'eo',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hongMeta = const VerificationMeta('hong');
  @override
  late final GeneratedColumn<double> hong = GeneratedColumn<double>(
    'hong',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ngucMeta = const VerificationMeta('nguc');
  @override
  late final GeneratedColumn<double> nguc = GeneratedColumn<double>(
    'nguc',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bapTayMeta = const VerificationMeta('bapTay');
  @override
  late final GeneratedColumn<double> bapTay = GeneratedColumn<double>(
    'bap_tay',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [ngay, eo, hong, nguc, bapTay];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chi_so';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChiSoIn> instance, {
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
    if (data.containsKey('eo')) {
      context.handle(_eoMeta, eo.isAcceptableOrUnknown(data['eo']!, _eoMeta));
    }
    if (data.containsKey('hong')) {
      context.handle(
        _hongMeta,
        hong.isAcceptableOrUnknown(data['hong']!, _hongMeta),
      );
    }
    if (data.containsKey('nguc')) {
      context.handle(
        _ngucMeta,
        nguc.isAcceptableOrUnknown(data['nguc']!, _ngucMeta),
      );
    }
    if (data.containsKey('bap_tay')) {
      context.handle(
        _bapTayMeta,
        bapTay.isAcceptableOrUnknown(data['bap_tay']!, _bapTayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ngay};
  @override
  ChiSoIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChiSoIn(
      ngay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ngay'],
      )!,
      eo: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}eo'],
      ),
      hong: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hong'],
      ),
      nguc: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}nguc'],
      ),
      bapTay: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bap_tay'],
      ),
    );
  }

  @override
  $ChiSoInsTable createAlias(String alias) {
    return $ChiSoInsTable(attachedDatabase, alias);
  }
}

class ChiSoIn extends DataClass implements Insertable<ChiSoIn> {
  final String ngay;
  final double? eo;
  final double? hong;
  final double? nguc;
  final double? bapTay;
  const ChiSoIn({
    required this.ngay,
    this.eo,
    this.hong,
    this.nguc,
    this.bapTay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ngay'] = Variable<String>(ngay);
    if (!nullToAbsent || eo != null) {
      map['eo'] = Variable<double>(eo);
    }
    if (!nullToAbsent || hong != null) {
      map['hong'] = Variable<double>(hong);
    }
    if (!nullToAbsent || nguc != null) {
      map['nguc'] = Variable<double>(nguc);
    }
    if (!nullToAbsent || bapTay != null) {
      map['bap_tay'] = Variable<double>(bapTay);
    }
    return map;
  }

  ChiSoInsCompanion toCompanion(bool nullToAbsent) {
    return ChiSoInsCompanion(
      ngay: Value(ngay),
      eo: eo == null && nullToAbsent ? const Value.absent() : Value(eo),
      hong: hong == null && nullToAbsent ? const Value.absent() : Value(hong),
      nguc: nguc == null && nullToAbsent ? const Value.absent() : Value(nguc),
      bapTay: bapTay == null && nullToAbsent
          ? const Value.absent()
          : Value(bapTay),
    );
  }

  factory ChiSoIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChiSoIn(
      ngay: serializer.fromJson<String>(json['ngay']),
      eo: serializer.fromJson<double?>(json['eo']),
      hong: serializer.fromJson<double?>(json['hong']),
      nguc: serializer.fromJson<double?>(json['nguc']),
      bapTay: serializer.fromJson<double?>(json['bapTay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ngay': serializer.toJson<String>(ngay),
      'eo': serializer.toJson<double?>(eo),
      'hong': serializer.toJson<double?>(hong),
      'nguc': serializer.toJson<double?>(nguc),
      'bapTay': serializer.toJson<double?>(bapTay),
    };
  }

  ChiSoIn copyWith({
    String? ngay,
    Value<double?> eo = const Value.absent(),
    Value<double?> hong = const Value.absent(),
    Value<double?> nguc = const Value.absent(),
    Value<double?> bapTay = const Value.absent(),
  }) => ChiSoIn(
    ngay: ngay ?? this.ngay,
    eo: eo.present ? eo.value : this.eo,
    hong: hong.present ? hong.value : this.hong,
    nguc: nguc.present ? nguc.value : this.nguc,
    bapTay: bapTay.present ? bapTay.value : this.bapTay,
  );
  ChiSoIn copyWithCompanion(ChiSoInsCompanion data) {
    return ChiSoIn(
      ngay: data.ngay.present ? data.ngay.value : this.ngay,
      eo: data.eo.present ? data.eo.value : this.eo,
      hong: data.hong.present ? data.hong.value : this.hong,
      nguc: data.nguc.present ? data.nguc.value : this.nguc,
      bapTay: data.bapTay.present ? data.bapTay.value : this.bapTay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChiSoIn(')
          ..write('ngay: $ngay, ')
          ..write('eo: $eo, ')
          ..write('hong: $hong, ')
          ..write('nguc: $nguc, ')
          ..write('bapTay: $bapTay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ngay, eo, hong, nguc, bapTay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChiSoIn &&
          other.ngay == this.ngay &&
          other.eo == this.eo &&
          other.hong == this.hong &&
          other.nguc == this.nguc &&
          other.bapTay == this.bapTay);
}

class ChiSoInsCompanion extends UpdateCompanion<ChiSoIn> {
  final Value<String> ngay;
  final Value<double?> eo;
  final Value<double?> hong;
  final Value<double?> nguc;
  final Value<double?> bapTay;
  final Value<int> rowid;
  const ChiSoInsCompanion({
    this.ngay = const Value.absent(),
    this.eo = const Value.absent(),
    this.hong = const Value.absent(),
    this.nguc = const Value.absent(),
    this.bapTay = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChiSoInsCompanion.insert({
    required String ngay,
    this.eo = const Value.absent(),
    this.hong = const Value.absent(),
    this.nguc = const Value.absent(),
    this.bapTay = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ngay = Value(ngay);
  static Insertable<ChiSoIn> custom({
    Expression<String>? ngay,
    Expression<double>? eo,
    Expression<double>? hong,
    Expression<double>? nguc,
    Expression<double>? bapTay,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ngay != null) 'ngay': ngay,
      if (eo != null) 'eo': eo,
      if (hong != null) 'hong': hong,
      if (nguc != null) 'nguc': nguc,
      if (bapTay != null) 'bap_tay': bapTay,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChiSoInsCompanion copyWith({
    Value<String>? ngay,
    Value<double?>? eo,
    Value<double?>? hong,
    Value<double?>? nguc,
    Value<double?>? bapTay,
    Value<int>? rowid,
  }) {
    return ChiSoInsCompanion(
      ngay: ngay ?? this.ngay,
      eo: eo ?? this.eo,
      hong: hong ?? this.hong,
      nguc: nguc ?? this.nguc,
      bapTay: bapTay ?? this.bapTay,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ngay.present) {
      map['ngay'] = Variable<String>(ngay.value);
    }
    if (eo.present) {
      map['eo'] = Variable<double>(eo.value);
    }
    if (hong.present) {
      map['hong'] = Variable<double>(hong.value);
    }
    if (nguc.present) {
      map['nguc'] = Variable<double>(nguc.value);
    }
    if (bapTay.present) {
      map['bap_tay'] = Variable<double>(bapTay.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChiSoInsCompanion(')
          ..write('ngay: $ngay, ')
          ..write('eo: $eo, ')
          ..write('hong: $hong, ')
          ..write('nguc: $nguc, ')
          ..write('bapTay: $bapTay, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LoaiTruInsTable extends LoaiTruIns
    with TableInfo<$LoaiTruInsTable, LoaiTruIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoaiTruInsTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [habitId, ngay];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loai_tru';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoaiTruIn> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {habitId, ngay};
  @override
  LoaiTruIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoaiTruIn(
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habit_id'],
      )!,
      ngay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ngay'],
      )!,
    );
  }

  @override
  $LoaiTruInsTable createAlias(String alias) {
    return $LoaiTruInsTable(attachedDatabase, alias);
  }
}

class LoaiTruIn extends DataClass implements Insertable<LoaiTruIn> {
  final int habitId;
  final String ngay;
  const LoaiTruIn({required this.habitId, required this.ngay});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['habit_id'] = Variable<int>(habitId);
    map['ngay'] = Variable<String>(ngay);
    return map;
  }

  LoaiTruInsCompanion toCompanion(bool nullToAbsent) {
    return LoaiTruInsCompanion(habitId: Value(habitId), ngay: Value(ngay));
  }

  factory LoaiTruIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoaiTruIn(
      habitId: serializer.fromJson<int>(json['habitId']),
      ngay: serializer.fromJson<String>(json['ngay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'habitId': serializer.toJson<int>(habitId),
      'ngay': serializer.toJson<String>(ngay),
    };
  }

  LoaiTruIn copyWith({int? habitId, String? ngay}) =>
      LoaiTruIn(habitId: habitId ?? this.habitId, ngay: ngay ?? this.ngay);
  LoaiTruIn copyWithCompanion(LoaiTruInsCompanion data) {
    return LoaiTruIn(
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      ngay: data.ngay.present ? data.ngay.value : this.ngay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoaiTruIn(')
          ..write('habitId: $habitId, ')
          ..write('ngay: $ngay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(habitId, ngay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoaiTruIn &&
          other.habitId == this.habitId &&
          other.ngay == this.ngay);
}

class LoaiTruInsCompanion extends UpdateCompanion<LoaiTruIn> {
  final Value<int> habitId;
  final Value<String> ngay;
  final Value<int> rowid;
  const LoaiTruInsCompanion({
    this.habitId = const Value.absent(),
    this.ngay = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LoaiTruInsCompanion.insert({
    required int habitId,
    required String ngay,
    this.rowid = const Value.absent(),
  }) : habitId = Value(habitId),
       ngay = Value(ngay);
  static Insertable<LoaiTruIn> custom({
    Expression<int>? habitId,
    Expression<String>? ngay,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (habitId != null) 'habit_id': habitId,
      if (ngay != null) 'ngay': ngay,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LoaiTruInsCompanion copyWith({
    Value<int>? habitId,
    Value<String>? ngay,
    Value<int>? rowid,
  }) {
    return LoaiTruInsCompanion(
      habitId: habitId ?? this.habitId,
      ngay: ngay ?? this.ngay,
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoaiTruInsCompanion(')
          ..write('habitId: $habitId, ')
          ..write('ngay: $ngay, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MocCansTable extends MocCans with TableInfo<$MocCansTable, MocCan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MocCansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _loaiMeta = const VerificationMeta('loai');
  @override
  late final GeneratedColumn<String> loai = GeneratedColumn<String>(
    'loai',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [id, loai, ngay, kg];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moc_can';
  @override
  VerificationContext validateIntegrity(
    Insertable<MocCan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('loai')) {
      context.handle(
        _loaiMeta,
        loai.isAcceptableOrUnknown(data['loai']!, _loaiMeta),
      );
    } else if (isInserting) {
      context.missing(_loaiMeta);
    }
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MocCan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MocCan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      loai: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loai'],
      )!,
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
  $MocCansTable createAlias(String alias) {
    return $MocCansTable(attachedDatabase, alias);
  }
}

class MocCan extends DataClass implements Insertable<MocCan> {
  final int id;
  final String loai;
  final String ngay;
  final double kg;
  const MocCan({
    required this.id,
    required this.loai,
    required this.ngay,
    required this.kg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['loai'] = Variable<String>(loai);
    map['ngay'] = Variable<String>(ngay);
    map['kg'] = Variable<double>(kg);
    return map;
  }

  MocCansCompanion toCompanion(bool nullToAbsent) {
    return MocCansCompanion(
      id: Value(id),
      loai: Value(loai),
      ngay: Value(ngay),
      kg: Value(kg),
    );
  }

  factory MocCan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MocCan(
      id: serializer.fromJson<int>(json['id']),
      loai: serializer.fromJson<String>(json['loai']),
      ngay: serializer.fromJson<String>(json['ngay']),
      kg: serializer.fromJson<double>(json['kg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loai': serializer.toJson<String>(loai),
      'ngay': serializer.toJson<String>(ngay),
      'kg': serializer.toJson<double>(kg),
    };
  }

  MocCan copyWith({int? id, String? loai, String? ngay, double? kg}) => MocCan(
    id: id ?? this.id,
    loai: loai ?? this.loai,
    ngay: ngay ?? this.ngay,
    kg: kg ?? this.kg,
  );
  MocCan copyWithCompanion(MocCansCompanion data) {
    return MocCan(
      id: data.id.present ? data.id.value : this.id,
      loai: data.loai.present ? data.loai.value : this.loai,
      ngay: data.ngay.present ? data.ngay.value : this.ngay,
      kg: data.kg.present ? data.kg.value : this.kg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MocCan(')
          ..write('id: $id, ')
          ..write('loai: $loai, ')
          ..write('ngay: $ngay, ')
          ..write('kg: $kg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, loai, ngay, kg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MocCan &&
          other.id == this.id &&
          other.loai == this.loai &&
          other.ngay == this.ngay &&
          other.kg == this.kg);
}

class MocCansCompanion extends UpdateCompanion<MocCan> {
  final Value<int> id;
  final Value<String> loai;
  final Value<String> ngay;
  final Value<double> kg;
  const MocCansCompanion({
    this.id = const Value.absent(),
    this.loai = const Value.absent(),
    this.ngay = const Value.absent(),
    this.kg = const Value.absent(),
  });
  MocCansCompanion.insert({
    this.id = const Value.absent(),
    required String loai,
    required String ngay,
    required double kg,
  }) : loai = Value(loai),
       ngay = Value(ngay),
       kg = Value(kg);
  static Insertable<MocCan> custom({
    Expression<int>? id,
    Expression<String>? loai,
    Expression<String>? ngay,
    Expression<double>? kg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loai != null) 'loai': loai,
      if (ngay != null) 'ngay': ngay,
      if (kg != null) 'kg': kg,
    });
  }

  MocCansCompanion copyWith({
    Value<int>? id,
    Value<String>? loai,
    Value<String>? ngay,
    Value<double>? kg,
  }) {
    return MocCansCompanion(
      id: id ?? this.id,
      loai: loai ?? this.loai,
      ngay: ngay ?? this.ngay,
      kg: kg ?? this.kg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loai.present) {
      map['loai'] = Variable<String>(loai.value);
    }
    if (ngay.present) {
      map['ngay'] = Variable<String>(ngay.value);
    }
    if (kg.present) {
      map['kg'] = Variable<double>(kg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MocCansCompanion(')
          ..write('id: $id, ')
          ..write('loai: $loai, ')
          ..write('ngay: $ngay, ')
          ..write('kg: $kg')
          ..write(')'))
        .toString();
  }
}

class $NapInsTable extends NapIns with TableInfo<$NapInsTable, NapIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NapInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ngayMeta = const VerificationMeta('ngay');
  @override
  late final GeneratedColumn<String> ngay = GeneratedColumn<String>(
    'ngay',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kcalMeta = const VerificationMeta('kcal');
  @override
  late final GeneratedColumn<int> kcal = GeneratedColumn<int>(
    'kcal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [ngay, kcal];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nap_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<NapIn> instance, {
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
    if (data.containsKey('kcal')) {
      context.handle(
        _kcalMeta,
        kcal.isAcceptableOrUnknown(data['kcal']!, _kcalMeta),
      );
    } else if (isInserting) {
      context.missing(_kcalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ngay};
  @override
  NapIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NapIn(
      ngay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ngay'],
      )!,
      kcal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kcal'],
      )!,
    );
  }

  @override
  $NapInsTable createAlias(String alias) {
    return $NapInsTable(attachedDatabase, alias);
  }
}

class NapIn extends DataClass implements Insertable<NapIn> {
  final String ngay;
  final int kcal;
  const NapIn({required this.ngay, required this.kcal});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ngay'] = Variable<String>(ngay);
    map['kcal'] = Variable<int>(kcal);
    return map;
  }

  NapInsCompanion toCompanion(bool nullToAbsent) {
    return NapInsCompanion(ngay: Value(ngay), kcal: Value(kcal));
  }

  factory NapIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NapIn(
      ngay: serializer.fromJson<String>(json['ngay']),
      kcal: serializer.fromJson<int>(json['kcal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ngay': serializer.toJson<String>(ngay),
      'kcal': serializer.toJson<int>(kcal),
    };
  }

  NapIn copyWith({String? ngay, int? kcal}) =>
      NapIn(ngay: ngay ?? this.ngay, kcal: kcal ?? this.kcal);
  NapIn copyWithCompanion(NapInsCompanion data) {
    return NapIn(
      ngay: data.ngay.present ? data.ngay.value : this.ngay,
      kcal: data.kcal.present ? data.kcal.value : this.kcal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NapIn(')
          ..write('ngay: $ngay, ')
          ..write('kcal: $kcal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ngay, kcal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NapIn && other.ngay == this.ngay && other.kcal == this.kcal);
}

class NapInsCompanion extends UpdateCompanion<NapIn> {
  final Value<String> ngay;
  final Value<int> kcal;
  final Value<int> rowid;
  const NapInsCompanion({
    this.ngay = const Value.absent(),
    this.kcal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NapInsCompanion.insert({
    required String ngay,
    required int kcal,
    this.rowid = const Value.absent(),
  }) : ngay = Value(ngay),
       kcal = Value(kcal);
  static Insertable<NapIn> custom({
    Expression<String>? ngay,
    Expression<int>? kcal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ngay != null) 'ngay': ngay,
      if (kcal != null) 'kcal': kcal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NapInsCompanion copyWith({
    Value<String>? ngay,
    Value<int>? kcal,
    Value<int>? rowid,
  }) {
    return NapInsCompanion(
      ngay: ngay ?? this.ngay,
      kcal: kcal ?? this.kcal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ngay.present) {
      map['ngay'] = Variable<String>(ngay.value);
    }
    if (kcal.present) {
      map['kcal'] = Variable<int>(kcal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NapInsCompanion(')
          ..write('ngay: $ngay, ')
          ..write('kcal: $kcal, ')
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
  late final $EoInsTable eoIns = $EoInsTable(this);
  late final $MoInsTable moIns = $MoInsTable(this);
  late final $TapInsTable tapIns = $TapInsTable(this);
  late final $ChiSoInsTable chiSoIns = $ChiSoInsTable(this);
  late final $LoaiTruInsTable loaiTruIns = $LoaiTruInsTable(this);
  late final $MocCansTable mocCans = $MocCansTable(this);
  late final $NapInsTable napIns = $NapInsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    habits,
    ticks,
    profiles,
    weighIns,
    eoIns,
    moIns,
    tapIns,
    chiSoIns,
    loaiTruIns,
    mocCans,
    napIns,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('loai_tru', kind: UpdateKind.delete)],
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
  Value<String> thuBit,
  Value<int?> gioNhac,
  Value<bool> an,
  Value<String?> anTu,
  required DateTime taoLuc,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<int> id,
  Value<String> ten,
  Value<int> mucTieuThang,
  Value<double?> met,
  Value<int?> phutMacDinh,
  Value<int> thuTu,
  Value<String> thuBit,
  Value<int?> gioNhac,
  Value<bool> an,
  Value<String?> anTu,
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

  static MultiTypedResultKey<$LoaiTruInsTable, List<LoaiTruIn>>
  _loaiTruInsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.loaiTruIns,
    aliasName: 'habits__id__loai_tru__habit_id',
  );

  $$LoaiTruInsTableProcessedTableManager get loaiTruInsRefs {
    final manager = $$LoaiTruInsTableTableManager(
      $_db,
      $_db.loaiTruIns,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loaiTruInsRefsTable($_db));
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

  ColumnFilters<String> get thuBit => $composableBuilder(
    column: $table.thuBit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gioNhac => $composableBuilder(
    column: $table.gioNhac,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get an => $composableBuilder(
    column: $table.an,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anTu => $composableBuilder(
    column: $table.anTu,
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

  Expression<bool> loaiTruInsRefs(
    Expression<bool> Function($$LoaiTruInsTableFilterComposer f) f,
  ) {
    final $$LoaiTruInsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loaiTruIns,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoaiTruInsTableFilterComposer(
            $db: $db,
            $table: $db.loaiTruIns,
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

  ColumnOrderings<String> get thuBit => $composableBuilder(
    column: $table.thuBit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gioNhac => $composableBuilder(
    column: $table.gioNhac,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get an => $composableBuilder(
    column: $table.an,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anTu => $composableBuilder(
    column: $table.anTu,
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

  GeneratedColumn<String> get thuBit =>
      $composableBuilder(column: $table.thuBit, builder: (column) => column);

  GeneratedColumn<int> get gioNhac =>
      $composableBuilder(column: $table.gioNhac, builder: (column) => column);

  GeneratedColumn<bool> get an =>
      $composableBuilder(column: $table.an, builder: (column) => column);

  GeneratedColumn<String> get anTu =>
      $composableBuilder(column: $table.anTu, builder: (column) => column);

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

  Expression<T> loaiTruInsRefs<T extends Object>(
    Expression<T> Function($$LoaiTruInsTableAnnotationComposer a) f,
  ) {
    final $$LoaiTruInsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loaiTruIns,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoaiTruInsTableAnnotationComposer(
            $db: $db,
            $table: $db.loaiTruIns,
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
          PrefetchHooks Function({bool ticksRefs, bool loaiTruInsRefs})
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
                Value<String> thuBit = const Value.absent(),
                Value<int?> gioNhac = const Value.absent(),
                Value<bool> an = const Value.absent(),
                Value<String?> anTu = const Value.absent(),
                Value<DateTime> taoLuc = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                ten: ten,
                mucTieuThang: mucTieuThang,
                met: met,
                phutMacDinh: phutMacDinh,
                thuTu: thuTu,
                thuBit: thuBit,
                gioNhac: gioNhac,
                an: an,
                anTu: anTu,
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
                Value<String> thuBit = const Value.absent(),
                Value<int?> gioNhac = const Value.absent(),
                Value<bool> an = const Value.absent(),
                Value<String?> anTu = const Value.absent(),
                required DateTime taoLuc,
              }) => HabitsCompanion.insert(
                id: id,
                ten: ten,
                mucTieuThang: mucTieuThang,
                met: met,
                phutMacDinh: phutMacDinh,
                thuTu: thuTu,
                thuBit: thuBit,
                gioNhac: gioNhac,
                an: an,
                anTu: anTu,
                taoLuc: taoLuc,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$HabitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({ticksRefs = false, loaiTruInsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ticksRefs) db.ticks,
                if (loaiTruInsRefs) db.loaiTruIns,
              ],
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
                  if (loaiTruInsRefs)
                    await $_getPrefetchedData<Habit, $HabitsTable, LoaiTruIn>(
                      currentTable: table,
                      referencedTable: $$HabitsTableReferences
                          ._loaiTruInsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HabitsTableReferences(db, table, p0).loaiTruInsRefs,
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
      PrefetchHooks Function({bool ticksRefs, bool loaiTruInsRefs})
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
  Value<String?> tenGoi,
  Value<double> nhipKg,
  Value<double?> startKg,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String?> sex,
  Value<double?> heightCm,
  Value<String?> dob,
  Value<double> activity,
  Value<double?> targetKg,
  Value<String?> tenGoi,
  Value<double> nhipKg,
  Value<double?> startKg,
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

  ColumnFilters<String> get tenGoi => $composableBuilder(
    column: $table.tenGoi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nhipKg => $composableBuilder(
    column: $table.nhipKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startKg => $composableBuilder(
    column: $table.startKg,
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

  ColumnOrderings<String> get tenGoi => $composableBuilder(
    column: $table.tenGoi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nhipKg => $composableBuilder(
    column: $table.nhipKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startKg => $composableBuilder(
    column: $table.startKg,
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

  GeneratedColumn<String> get tenGoi =>
      $composableBuilder(column: $table.tenGoi, builder: (column) => column);

  GeneratedColumn<double> get nhipKg =>
      $composableBuilder(column: $table.nhipKg, builder: (column) => column);

  GeneratedColumn<double> get startKg =>
      $composableBuilder(column: $table.startKg, builder: (column) => column);
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
                Value<String?> tenGoi = const Value.absent(),
                Value<double> nhipKg = const Value.absent(),
                Value<double?> startKg = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                sex: sex,
                heightCm: heightCm,
                dob: dob,
                activity: activity,
                targetKg: targetKg,
                tenGoi: tenGoi,
                nhipKg: nhipKg,
                startKg: startKg,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<String?> dob = const Value.absent(),
                Value<double> activity = const Value.absent(),
                Value<double?> targetKg = const Value.absent(),
                Value<String?> tenGoi = const Value.absent(),
                Value<double> nhipKg = const Value.absent(),
                Value<double?> startKg = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                sex: sex,
                heightCm: heightCm,
                dob: dob,
                activity: activity,
                targetKg: targetKg,
                tenGoi: tenGoi,
                nhipKg: nhipKg,
                startKg: startKg,
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
typedef $$EoInsTableCreateCompanionBuilder = EoInsCompanion Function({
  required String ngay,
  required double cm,
  Value<int> rowid,
});
typedef $$EoInsTableUpdateCompanionBuilder = EoInsCompanion Function({
  Value<String> ngay,
  Value<double> cm,
  Value<int> rowid,
});

class $$EoInsTableFilterComposer extends Composer<_$AppDatabase, $EoInsTable> {
  $$EoInsTableFilterComposer({
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

  ColumnFilters<double> get cm => $composableBuilder(
    column: $table.cm,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EoInsTableOrderingComposer
    extends Composer<_$AppDatabase, $EoInsTable> {
  $$EoInsTableOrderingComposer({
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

  ColumnOrderings<double> get cm => $composableBuilder(
    column: $table.cm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EoInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EoInsTable> {
  $$EoInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ngay =>
      $composableBuilder(column: $table.ngay, builder: (column) => column);

  GeneratedColumn<double> get cm =>
      $composableBuilder(column: $table.cm, builder: (column) => column);
}

class $$EoInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EoInsTable,
          EoIn,
          $$EoInsTableFilterComposer,
          $$EoInsTableOrderingComposer,
          $$EoInsTableAnnotationComposer,
          $$EoInsTableCreateCompanionBuilder,
          $$EoInsTableUpdateCompanionBuilder,
          (EoIn, BaseReferences<_$AppDatabase, $EoInsTable, EoIn>),
          EoIn,
          PrefetchHooks Function()
        > {
  $$EoInsTableTableManager(_$AppDatabase db, $EoInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EoInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EoInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EoInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> ngay = const Value.absent(),
            Value<double> cm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => EoInsCompanion(ngay: ngay, cm: cm, rowid: rowid),
          createCompanionCallback: ({
            required String ngay,
            required double cm,
            Value<int> rowid = const Value.absent(),
          }) => EoInsCompanion.insert(ngay: ngay, cm: cm, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EoInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EoInsTable,
      EoIn,
      $$EoInsTableFilterComposer,
      $$EoInsTableOrderingComposer,
      $$EoInsTableAnnotationComposer,
      $$EoInsTableCreateCompanionBuilder,
      $$EoInsTableUpdateCompanionBuilder,
      (EoIn, BaseReferences<_$AppDatabase, $EoInsTable, EoIn>),
      EoIn,
      PrefetchHooks Function()
    >;
typedef $$MoInsTableCreateCompanionBuilder = MoInsCompanion Function({
  required String ngay,
  required double pct,
  Value<int> rowid,
});
typedef $$MoInsTableUpdateCompanionBuilder = MoInsCompanion Function({
  Value<String> ngay,
  Value<double> pct,
  Value<int> rowid,
});

class $$MoInsTableFilterComposer extends Composer<_$AppDatabase, $MoInsTable> {
  $$MoInsTableFilterComposer({
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

  ColumnFilters<double> get pct => $composableBuilder(
    column: $table.pct,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoInsTableOrderingComposer
    extends Composer<_$AppDatabase, $MoInsTable> {
  $$MoInsTableOrderingComposer({
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

  ColumnOrderings<double> get pct => $composableBuilder(
    column: $table.pct,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoInsTable> {
  $$MoInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ngay =>
      $composableBuilder(column: $table.ngay, builder: (column) => column);

  GeneratedColumn<double> get pct =>
      $composableBuilder(column: $table.pct, builder: (column) => column);
}

class $$MoInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoInsTable,
          MoIn,
          $$MoInsTableFilterComposer,
          $$MoInsTableOrderingComposer,
          $$MoInsTableAnnotationComposer,
          $$MoInsTableCreateCompanionBuilder,
          $$MoInsTableUpdateCompanionBuilder,
          (MoIn, BaseReferences<_$AppDatabase, $MoInsTable, MoIn>),
          MoIn,
          PrefetchHooks Function()
        > {
  $$MoInsTableTableManager(_$AppDatabase db, $MoInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> ngay = const Value.absent(),
            Value<double> pct = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => MoInsCompanion(ngay: ngay, pct: pct, rowid: rowid),
          createCompanionCallback: ({
            required String ngay,
            required double pct,
            Value<int> rowid = const Value.absent(),
          }) => MoInsCompanion.insert(ngay: ngay, pct: pct, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoInsTable,
      MoIn,
      $$MoInsTableFilterComposer,
      $$MoInsTableOrderingComposer,
      $$MoInsTableAnnotationComposer,
      $$MoInsTableCreateCompanionBuilder,
      $$MoInsTableUpdateCompanionBuilder,
      (MoIn, BaseReferences<_$AppDatabase, $MoInsTable, MoIn>),
      MoIn,
      PrefetchHooks Function()
    >;
typedef $$TapInsTableCreateCompanionBuilder = TapInsCompanion Function({
  Value<int> id,
  required String ngay,
  required String loai,
  required int phut,
});
typedef $$TapInsTableUpdateCompanionBuilder = TapInsCompanion Function({
  Value<int> id,
  Value<String> ngay,
  Value<String> loai,
  Value<int> phut,
});

class $$TapInsTableFilterComposer
    extends Composer<_$AppDatabase, $TapInsTable> {
  $$TapInsTableFilterComposer({
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

  ColumnFilters<String> get ngay => $composableBuilder(
    column: $table.ngay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loai => $composableBuilder(
    column: $table.loai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phut => $composableBuilder(
    column: $table.phut,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TapInsTableOrderingComposer
    extends Composer<_$AppDatabase, $TapInsTable> {
  $$TapInsTableOrderingComposer({
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

  ColumnOrderings<String> get ngay => $composableBuilder(
    column: $table.ngay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loai => $composableBuilder(
    column: $table.loai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phut => $composableBuilder(
    column: $table.phut,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TapInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TapInsTable> {
  $$TapInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ngay =>
      $composableBuilder(column: $table.ngay, builder: (column) => column);

  GeneratedColumn<String> get loai =>
      $composableBuilder(column: $table.loai, builder: (column) => column);

  GeneratedColumn<int> get phut =>
      $composableBuilder(column: $table.phut, builder: (column) => column);
}

class $$TapInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TapInsTable,
          TapIn,
          $$TapInsTableFilterComposer,
          $$TapInsTableOrderingComposer,
          $$TapInsTableAnnotationComposer,
          $$TapInsTableCreateCompanionBuilder,
          $$TapInsTableUpdateCompanionBuilder,
          (TapIn, BaseReferences<_$AppDatabase, $TapInsTable, TapIn>),
          TapIn,
          PrefetchHooks Function()
        > {
  $$TapInsTableTableManager(_$AppDatabase db, $TapInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TapInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TapInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TapInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> ngay = const Value.absent(),
            Value<String> loai = const Value.absent(),
            Value<int> phut = const Value.absent(),
          }) => TapInsCompanion(id: id, ngay: ngay, loai: loai, phut: phut),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String ngay,
                required String loai,
                required int phut,
              }) => TapInsCompanion.insert(
                id: id,
                ngay: ngay,
                loai: loai,
                phut: phut,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TapInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TapInsTable,
      TapIn,
      $$TapInsTableFilterComposer,
      $$TapInsTableOrderingComposer,
      $$TapInsTableAnnotationComposer,
      $$TapInsTableCreateCompanionBuilder,
      $$TapInsTableUpdateCompanionBuilder,
      (TapIn, BaseReferences<_$AppDatabase, $TapInsTable, TapIn>),
      TapIn,
      PrefetchHooks Function()
    >;
typedef $$ChiSoInsTableCreateCompanionBuilder = ChiSoInsCompanion Function({
  required String ngay,
  Value<double?> eo,
  Value<double?> hong,
  Value<double?> nguc,
  Value<double?> bapTay,
  Value<int> rowid,
});
typedef $$ChiSoInsTableUpdateCompanionBuilder = ChiSoInsCompanion Function({
  Value<String> ngay,
  Value<double?> eo,
  Value<double?> hong,
  Value<double?> nguc,
  Value<double?> bapTay,
  Value<int> rowid,
});

class $$ChiSoInsTableFilterComposer
    extends Composer<_$AppDatabase, $ChiSoInsTable> {
  $$ChiSoInsTableFilterComposer({
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

  ColumnFilters<double> get eo => $composableBuilder(
    column: $table.eo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hong => $composableBuilder(
    column: $table.hong,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nguc => $composableBuilder(
    column: $table.nguc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bapTay => $composableBuilder(
    column: $table.bapTay,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChiSoInsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChiSoInsTable> {
  $$ChiSoInsTableOrderingComposer({
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

  ColumnOrderings<double> get eo => $composableBuilder(
    column: $table.eo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hong => $composableBuilder(
    column: $table.hong,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nguc => $composableBuilder(
    column: $table.nguc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bapTay => $composableBuilder(
    column: $table.bapTay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChiSoInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChiSoInsTable> {
  $$ChiSoInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ngay =>
      $composableBuilder(column: $table.ngay, builder: (column) => column);

  GeneratedColumn<double> get eo =>
      $composableBuilder(column: $table.eo, builder: (column) => column);

  GeneratedColumn<double> get hong =>
      $composableBuilder(column: $table.hong, builder: (column) => column);

  GeneratedColumn<double> get nguc =>
      $composableBuilder(column: $table.nguc, builder: (column) => column);

  GeneratedColumn<double> get bapTay =>
      $composableBuilder(column: $table.bapTay, builder: (column) => column);
}

class $$ChiSoInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChiSoInsTable,
          ChiSoIn,
          $$ChiSoInsTableFilterComposer,
          $$ChiSoInsTableOrderingComposer,
          $$ChiSoInsTableAnnotationComposer,
          $$ChiSoInsTableCreateCompanionBuilder,
          $$ChiSoInsTableUpdateCompanionBuilder,
          (ChiSoIn, BaseReferences<_$AppDatabase, $ChiSoInsTable, ChiSoIn>),
          ChiSoIn,
          PrefetchHooks Function()
        > {
  $$ChiSoInsTableTableManager(_$AppDatabase db, $ChiSoInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChiSoInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChiSoInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChiSoInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> ngay = const Value.absent(),
                Value<double?> eo = const Value.absent(),
                Value<double?> hong = const Value.absent(),
                Value<double?> nguc = const Value.absent(),
                Value<double?> bapTay = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChiSoInsCompanion(
                ngay: ngay,
                eo: eo,
                hong: hong,
                nguc: nguc,
                bapTay: bapTay,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ngay,
                Value<double?> eo = const Value.absent(),
                Value<double?> hong = const Value.absent(),
                Value<double?> nguc = const Value.absent(),
                Value<double?> bapTay = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChiSoInsCompanion.insert(
                ngay: ngay,
                eo: eo,
                hong: hong,
                nguc: nguc,
                bapTay: bapTay,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChiSoInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChiSoInsTable,
      ChiSoIn,
      $$ChiSoInsTableFilterComposer,
      $$ChiSoInsTableOrderingComposer,
      $$ChiSoInsTableAnnotationComposer,
      $$ChiSoInsTableCreateCompanionBuilder,
      $$ChiSoInsTableUpdateCompanionBuilder,
      (ChiSoIn, BaseReferences<_$AppDatabase, $ChiSoInsTable, ChiSoIn>),
      ChiSoIn,
      PrefetchHooks Function()
    >;
typedef $$LoaiTruInsTableCreateCompanionBuilder = LoaiTruInsCompanion Function({
  required int habitId,
  required String ngay,
  Value<int> rowid,
});
typedef $$LoaiTruInsTableUpdateCompanionBuilder = LoaiTruInsCompanion Function({
  Value<int> habitId,
  Value<String> ngay,
  Value<int> rowid,
});

final class $$LoaiTruInsTableReferences
    extends BaseReferences<_$AppDatabase, $LoaiTruInsTable, LoaiTruIn> {
  $$LoaiTruInsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('loai_tru__habit_id__habits__id');

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

class $$LoaiTruInsTableFilterComposer
    extends Composer<_$AppDatabase, $LoaiTruInsTable> {
  $$LoaiTruInsTableFilterComposer({
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

class $$LoaiTruInsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoaiTruInsTable> {
  $$LoaiTruInsTableOrderingComposer({
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

class $$LoaiTruInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoaiTruInsTable> {
  $$LoaiTruInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ngay =>
      $composableBuilder(column: $table.ngay, builder: (column) => column);

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

class $$LoaiTruInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoaiTruInsTable,
          LoaiTruIn,
          $$LoaiTruInsTableFilterComposer,
          $$LoaiTruInsTableOrderingComposer,
          $$LoaiTruInsTableAnnotationComposer,
          $$LoaiTruInsTableCreateCompanionBuilder,
          $$LoaiTruInsTableUpdateCompanionBuilder,
          (LoaiTruIn, $$LoaiTruInsTableReferences),
          LoaiTruIn,
          PrefetchHooks Function({bool habitId})
        > {
  $$LoaiTruInsTableTableManager(_$AppDatabase db, $LoaiTruInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoaiTruInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoaiTruInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoaiTruInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> habitId = const Value.absent(),
            Value<String> ngay = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => LoaiTruInsCompanion(habitId: habitId, ngay: ngay, rowid: rowid),
          createCompanionCallback:
              ({
                required int habitId,
                required String ngay,
                Value<int> rowid = const Value.absent(),
              }) => LoaiTruInsCompanion.insert(
                habitId: habitId,
                ngay: ngay,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LoaiTruInsTableReferences(db, table, e),
                ),
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
                        referencedTable: $$LoaiTruInsTableReferences
                            ._habitIdTable(db),
                        referencedColumn: $$LoaiTruInsTableReferences
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

typedef $$LoaiTruInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoaiTruInsTable,
      LoaiTruIn,
      $$LoaiTruInsTableFilterComposer,
      $$LoaiTruInsTableOrderingComposer,
      $$LoaiTruInsTableAnnotationComposer,
      $$LoaiTruInsTableCreateCompanionBuilder,
      $$LoaiTruInsTableUpdateCompanionBuilder,
      (LoaiTruIn, $$LoaiTruInsTableReferences),
      LoaiTruIn,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$MocCansTableCreateCompanionBuilder = MocCansCompanion Function({
  Value<int> id,
  required String loai,
  required String ngay,
  required double kg,
});
typedef $$MocCansTableUpdateCompanionBuilder = MocCansCompanion Function({
  Value<int> id,
  Value<String> loai,
  Value<String> ngay,
  Value<double> kg,
});

class $$MocCansTableFilterComposer
    extends Composer<_$AppDatabase, $MocCansTable> {
  $$MocCansTableFilterComposer({
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

  ColumnFilters<String> get loai => $composableBuilder(
    column: $table.loai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ngay => $composableBuilder(
    column: $table.ngay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kg => $composableBuilder(
    column: $table.kg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MocCansTableOrderingComposer
    extends Composer<_$AppDatabase, $MocCansTable> {
  $$MocCansTableOrderingComposer({
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

  ColumnOrderings<String> get loai => $composableBuilder(
    column: $table.loai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ngay => $composableBuilder(
    column: $table.ngay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kg => $composableBuilder(
    column: $table.kg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MocCansTableAnnotationComposer
    extends Composer<_$AppDatabase, $MocCansTable> {
  $$MocCansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get loai =>
      $composableBuilder(column: $table.loai, builder: (column) => column);

  GeneratedColumn<String> get ngay =>
      $composableBuilder(column: $table.ngay, builder: (column) => column);

  GeneratedColumn<double> get kg =>
      $composableBuilder(column: $table.kg, builder: (column) => column);
}

class $$MocCansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MocCansTable,
          MocCan,
          $$MocCansTableFilterComposer,
          $$MocCansTableOrderingComposer,
          $$MocCansTableAnnotationComposer,
          $$MocCansTableCreateCompanionBuilder,
          $$MocCansTableUpdateCompanionBuilder,
          (MocCan, BaseReferences<_$AppDatabase, $MocCansTable, MocCan>),
          MocCan,
          PrefetchHooks Function()
        > {
  $$MocCansTableTableManager(_$AppDatabase db, $MocCansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MocCansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MocCansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MocCansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> loai = const Value.absent(),
            Value<String> ngay = const Value.absent(),
            Value<double> kg = const Value.absent(),
          }) => MocCansCompanion(id: id, loai: loai, ngay: ngay, kg: kg),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String loai,
            required String ngay,
            required double kg,
          }) => MocCansCompanion.insert(id: id, loai: loai, ngay: ngay, kg: kg),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MocCansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MocCansTable,
      MocCan,
      $$MocCansTableFilterComposer,
      $$MocCansTableOrderingComposer,
      $$MocCansTableAnnotationComposer,
      $$MocCansTableCreateCompanionBuilder,
      $$MocCansTableUpdateCompanionBuilder,
      (MocCan, BaseReferences<_$AppDatabase, $MocCansTable, MocCan>),
      MocCan,
      PrefetchHooks Function()
    >;
typedef $$NapInsTableCreateCompanionBuilder = NapInsCompanion Function({
  required String ngay,
  required int kcal,
  Value<int> rowid,
});
typedef $$NapInsTableUpdateCompanionBuilder = NapInsCompanion Function({
  Value<String> ngay,
  Value<int> kcal,
  Value<int> rowid,
});

class $$NapInsTableFilterComposer
    extends Composer<_$AppDatabase, $NapInsTable> {
  $$NapInsTableFilterComposer({
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

  ColumnFilters<int> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NapInsTableOrderingComposer
    extends Composer<_$AppDatabase, $NapInsTable> {
  $$NapInsTableOrderingComposer({
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

  ColumnOrderings<int> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NapInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NapInsTable> {
  $$NapInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ngay =>
      $composableBuilder(column: $table.ngay, builder: (column) => column);

  GeneratedColumn<int> get kcal =>
      $composableBuilder(column: $table.kcal, builder: (column) => column);
}

class $$NapInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NapInsTable,
          NapIn,
          $$NapInsTableFilterComposer,
          $$NapInsTableOrderingComposer,
          $$NapInsTableAnnotationComposer,
          $$NapInsTableCreateCompanionBuilder,
          $$NapInsTableUpdateCompanionBuilder,
          (NapIn, BaseReferences<_$AppDatabase, $NapInsTable, NapIn>),
          NapIn,
          PrefetchHooks Function()
        > {
  $$NapInsTableTableManager(_$AppDatabase db, $NapInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NapInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NapInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NapInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> ngay = const Value.absent(),
            Value<int> kcal = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => NapInsCompanion(ngay: ngay, kcal: kcal, rowid: rowid),
          createCompanionCallback: ({
            required String ngay,
            required int kcal,
            Value<int> rowid = const Value.absent(),
          }) => NapInsCompanion.insert(ngay: ngay, kcal: kcal, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NapInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NapInsTable,
      NapIn,
      $$NapInsTableFilterComposer,
      $$NapInsTableOrderingComposer,
      $$NapInsTableAnnotationComposer,
      $$NapInsTableCreateCompanionBuilder,
      $$NapInsTableUpdateCompanionBuilder,
      (NapIn, BaseReferences<_$AppDatabase, $NapInsTable, NapIn>),
      NapIn,
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
  $$EoInsTableTableManager get eoIns =>
      $$EoInsTableTableManager(_db, _db.eoIns);
  $$MoInsTableTableManager get moIns =>
      $$MoInsTableTableManager(_db, _db.moIns);
  $$TapInsTableTableManager get tapIns =>
      $$TapInsTableTableManager(_db, _db.tapIns);
  $$ChiSoInsTableTableManager get chiSoIns =>
      $$ChiSoInsTableTableManager(_db, _db.chiSoIns);
  $$LoaiTruInsTableTableManager get loaiTruIns =>
      $$LoaiTruInsTableTableManager(_db, _db.loaiTruIns);
  $$MocCansTableTableManager get mocCans =>
      $$MocCansTableTableManager(_db, _db.mocCans);
  $$NapInsTableTableManager get napIns =>
      $$NapInsTableTableManager(_db, _db.napIns);
}
