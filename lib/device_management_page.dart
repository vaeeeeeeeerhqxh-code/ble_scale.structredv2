import 'package:flutter/material.dart';

class DeviceManagementPage extends StatelessWidget {
  const DeviceManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      appBar: AppBar(
        title: const Text('Управление устройством',
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Подключённое устройство
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2340),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF4C6EF5).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFF4C6EF5).withOpacity(0.15),
                    ),
                    child: const Icon(Icons.scale,
                        color: Color(0xFF4C6EF5), size: 30),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Нет подключённых весов',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Нажмите + чтобы добавить',
                            style:
                                TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Не подкл.',
                        style:
                            TextStyle(color: Colors.white38, fontSize: 12)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text('Настройки устройства',
                style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            _buildMenuCard([
              _buildTile(Icons.sync, 'Синхронизировать время', () {}),
              _buildTile(Icons.straighten, 'Единицы измерения', () {}),
              _buildTile(Icons.tune, 'Калибровка', () {}),
              _buildTile(Icons.history, 'Получить историю', () {}),
              _buildTile(Icons.battery_full, 'Уровень заряда', () {}),
            ]),

            const SizedBox(height: 24),
            const Text('Дополнительно',
                style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            _buildMenuCard([
              _buildTile(Icons.wifi, 'Настройка Wi-Fi', () {}),
              _buildTile(Icons.info_outline, 'Информация об устройстве', () {}),
              _buildTile(Icons.restore, 'Сброс до заводских настроек', () {},
                  isDestructive: true),
            ]),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2340),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              e.value,
              if (!isLast)
                const Divider(
                    height: 1, color: Colors.white10, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTile(IconData icon, String label, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon,
          color: isDestructive ? Colors.redAccent : Colors.white54, size: 22),
      title: Text(label,
          style: TextStyle(
              color: isDestructive ? Colors.redAccent : Colors.white,
              fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
      onTap: onTap,
    );
  }
}
