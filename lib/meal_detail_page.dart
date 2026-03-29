import 'package:flutter/material.dart';

class MealDetailPage extends StatelessWidget {
  final String mealName;
  const MealDetailPage({super.key, required this.mealName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      appBar: AppBar(
        title: Text(mealName, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D1B3E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF4C6EF5)),
            onPressed: () {
              // TODO: добавить продукт
            },
          ),
        ],
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
            // Итого калорий
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2340),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNutrient('Калории', '--', 'kcal',
                      const Color(0xFF4C6EF5)),
                  _buildNutrient('Белки', '--', 'г', const Color(0xFF51CF66)),
                  _buildNutrient('Жиры', '--', 'г', const Color(0xFFFF6B6B)),
                  _buildNutrient(
                      'Углеводы', '--', 'г', const Color(0xFFFFD43B)),
                ],
              ),
            ),

            // Пустое состояние
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant_menu,
                        size: 64,
                        color: Colors.white.withOpacity(0.15)),
                    const SizedBox(height: 16),
                    const Text('Нет добавленных продуктов',
                        style:
                            TextStyle(color: Colors.white38, fontSize: 16)),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить продукт'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C6EF5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrient(
      String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(unit,
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 2),
        Text(label,
            style:
                const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}
