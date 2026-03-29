import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Одно измерение
class MeasurementRecord {
  final DateTime date;
  final double weight;
  final double bodyFat;
  final double muscle;
  final double water;
  final double bmi;
  final double bmr;
  final double boneMass;
  final double visceralFat;
  final double protein;
  final double bodyAge;
  final double bodyHealth;

  MeasurementRecord({
    required this.date,
    required this.weight,
    required this.bodyFat,
    required this.muscle,
    required this.water,
    required this.bmi,
    required this.bmr,
    required this.boneMass,
    required this.visceralFat,
    required this.protein,
    required this.bodyAge,
    required this.bodyHealth,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'weight': weight,
    'bodyFat': bodyFat,
    'muscle': muscle,
    'water': water,
    'bmi': bmi,
    'bmr': bmr,
    'boneMass': boneMass,
    'visceralFat': visceralFat,
    'protein': protein,
    'bodyAge': bodyAge,
    'bodyHealth': bodyHealth,
  };

  factory MeasurementRecord.fromJson(Map<String, dynamic> j) => MeasurementRecord(
    date: DateTime.parse(j['date']),
    weight: (j['weight'] ?? 0).toDouble(),
    bodyFat: (j['bodyFat'] ?? 0).toDouble(),
    muscle: (j['muscle'] ?? 0).toDouble(),
    water: (j['water'] ?? 0).toDouble(),
    bmi: (j['bmi'] ?? 0).toDouble(),
    bmr: (j['bmr'] ?? 0).toDouble(),
    boneMass: (j['boneMass'] ?? 0).toDouble(),
    visceralFat: (j['visceralFat'] ?? 0).toDouble(),
    protein: (j['protein'] ?? 0).toDouble(),
    bodyAge: (j['bodyAge'] ?? 0).toDouble(),
    bodyHealth: (j['bodyHealth'] ?? 0).toDouble(),
  );
}

/// Глобальное хранилище — используй AppState.instance везде
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._();
  AppState._();

  List<MeasurementRecord> _records = [];
  List<MeasurementRecord> get records => _records;

  MeasurementRecord? get latest => _records.isEmpty ? null : _records.last;

  /// Загрузить историю из SharedPreferences
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('measurement_history') ?? '[]';
    final list = jsonDecode(raw) as List;
    _records = list.map((e) => MeasurementRecord.fromJson(e)).toList();
    notifyListeners();
  }

  /// Сохранить новое измерение
  Future<void> addRecord(MeasurementRecord record) async {
    _records.add(record);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'measurement_history',
      jsonEncode(_records.map((r) => r.toJson()).toList()),
    );
    notifyListeners();
  }

  /// Получить значения конкретного показателя для графика
  List<double> valuesFor(String key) {
    return _records.map((r) {
      switch (key) {
        case 'weight': return r.weight;
        case 'bodyFat': return r.bodyFat;
        case 'muscle': return r.muscle;
        case 'water': return r.water;
        case 'bmi': return r.bmi;
        case 'bmr': return r.bmr;
        case 'boneMass': return r.boneMass;
        case 'visceralFat': return r.visceralFat;
        case 'protein': return r.protein;
        case 'bodyAge': return r.bodyAge;
        case 'bodyHealth': return r.bodyHealth;
        default: return 0.0;
      }
    }).toList();
  }

  /// Получить записи за период
  List<MeasurementRecord> recordsFor(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _records.where((r) => r.date.isAfter(cutoff)).toList();
  }

  /// Изменение в % относительно предыдущего
  String changePercent(String key) {
    if (_records.length < 2) return '';
    final prev = valuesFor(key)[_records.length - 2];
    final curr = valuesFor(key)[_records.length - 1];
    if (prev == 0) return '';
    final diff = ((curr - prev) / prev * 100);
    final sign = diff >= 0 ? '↑' : '↓';
    return '$sign${diff.abs().toStringAsFixed(1)}%';
  }
}
