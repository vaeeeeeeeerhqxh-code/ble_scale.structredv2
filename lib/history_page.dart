import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      appBar: AppBar(
        title: const Text('История измерений',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D1B3E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A2F6B), Color(0xFF0D1B3E), Color(0xFF0A0A1A)],
          ),
        ),
        child: Column(
          children: [
            // Фильтр по периоду
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: ['Неделя', 'Месяц', '3 месяца', 'Год']
                    .map((period) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _PeriodChip(label: period),
                        ))
                    .toList(),
              ),
            ),

            // Пустое состояние
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart,
                        size: 64,
                        color: Colors.white.withOpacity(0.15)),
                    const SizedBox(height: 16),
                    const Text('Нет данных измерений',
                        style:
                            TextStyle(color: Colors.white38, fontSize: 16)),
                    const SizedBox(height: 8),
                    const Text('Подключите весы и проведите измерение',
                        style:
                            TextStyle(color: Colors.white24, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodChip extends StatefulWidget {
  final String label;
  const _PeriodChip({required this.label});

  @override
  State<_PeriodChip> createState() => _PeriodChipState();
}

class _PeriodChipState extends State<_PeriodChip> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _selected = !_selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _selected
              ? const Color(0xFF4C6EF5)
              : const Color(0xFF1A2340),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: _selected
                  ? const Color(0xFF4C6EF5)
                  : Colors.white12),
        ),
        child: Text(widget.label,
            style: TextStyle(
                color: _selected ? Colors.white : Colors.white54,
                fontSize: 13)),
      ),
    );
  }
}
