import 'package:flutter/material.dart';

class HealthToolsPage extends StatelessWidget {
  const HealthToolsPage({super.key});

  final List<Map<String, dynamic>> _tools = const [
    {
      'title': 'Калькулятор BMI',
      'subtitle': 'Индекс массы тела',
      'icon': Icons.monitor_weight_outlined,
      'color': Color(0xFF4C6EF5),
    },
    {
      'title': 'Норма воды',
      'subtitle': 'Суточная потребность в воде',
      'icon': Icons.water_drop_outlined,
      'color': Color(0xFF339AF0),
    },
    {
      'title': 'Калории',
      'subtitle': 'Дневная норма калорий',
      'icon': Icons.local_fire_department_outlined,
      'color': Color(0xFFFF922B),
    },
    {
      'title': 'Процент жира',
      'subtitle': 'Анализ состава тела',
      'icon': Icons.analytics_outlined,
      'color': Color(0xFFFF6B6B),
    },
    {
      'title': 'Мышечная масса',
      'subtitle': 'Расчёт мышечной массы',
      'icon': Icons.fitness_center,
      'color': Color(0xFF51CF66),
    },
    {
      'title': 'Базальный метаболизм',
      'subtitle': 'BMR — расход калорий в покое',
      'icon': Icons.speed_outlined,
      'color': Color(0xFFCC5DE8),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('Инструменты',
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: _tools.length,
            itemBuilder: (context, index) {
              final tool = _tools[index];
              return GestureDetector(
                onTap: () {
                  // TODO: открыть калькулятор
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2340),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: (tool['color'] as Color).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (tool['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(tool['icon'] as IconData,
                            color: tool['color'] as Color, size: 22),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tool['title'] as String,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(tool['subtitle'] as String,
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
