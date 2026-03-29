import 'package:flutter/material.dart';
import 'diet_page.dart';
import 'health_tools_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.title});
  final String title;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String _userName = '';
  String? _activeBodyPart;
  Offset? _tooltipOffset;

  final Map<String, Map<String, String>> _bodyPartData = {
    'Голова': {'Гидратация': '--', 'Состояние': '--'},
    'Грудь': {'Мышцы': '--', 'Жир': '--'},
    'Живот': {'Висцеральный жир': '--', 'Обмен веществ': '--'},
    'Правая рука': {'Мышцы': '--', 'Жир': '--'},
    'Левая рука': {'Мышцы': '--', 'Жир': '--'},
    'Правая нога': {'Мышцы': '--', 'Жир': '--'},
    'Левая нога': {'Мышцы': '--', 'Жир': '--'},
  };

  final List<Map<String, dynamic>> _metrics = [
    {'label': 'Вес', 'value': '--', 'unit': 'kg', 'icon': Icons.monitor_weight_outlined, 'color': const Color(0xFF4C6EF5)},
    {'label': 'Жир', 'value': '--', 'unit': '%', 'icon': Icons.water_drop_outlined, 'color': const Color(0xFFFF6B6B)},
    {'label': 'Мышцы', 'value': '--', 'unit': '%', 'icon': Icons.fitness_center, 'color': const Color(0xFF51CF66)},
    {'label': 'Кости', 'value': '--', 'unit': '%', 'icon': Icons.architecture, 'color': const Color(0xFFFFD43B)},
    {'label': 'Вода', 'value': '--', 'unit': '%', 'icon': Icons.opacity, 'color': const Color(0xFF339AF0)},
    {'label': 'BMI', 'value': '--', 'unit': '', 'icon': Icons.analytics_outlined, 'color': const Color(0xFFCC5DE8)},
    {'label': 'Обмен веществ', 'value': '--', 'unit': 'ккал', 'icon': Icons.local_fire_department_outlined, 'color': const Color(0xFFFF922B)},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Пользователь';
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _onBodyPartTap(String part, Offset offset) {
    setState(() {
      if (_activeBodyPart == part) {
        _activeBodyPart = null;
        _tooltipOffset = null;
      } else {
        _activeBodyPart = part;
        _tooltipOffset = offset;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A2F6B), Color(0xFF0D1B3E), Color(0xFF0A0A1A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBodyDataTab(),
                    _buildDietTab(),
                    _buildHealthToolsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  _userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController!,
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white38,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: Color(0xFF4C6EF5), width: 2.5),
        ),
        tabs: const [
          Tab(text: 'Данные тела'),
          Tab(text: 'Диетические данные'),
          Tab(text: 'Инструменты'),
        ],
      ),
    );
  }

  Widget _buildBodyDataTab() {
    return GestureDetector(
      onTap: () => setState(() {
        _activeBodyPart = null;
        _tooltipOffset = null;
      }),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildBodyFigure(),
            const SizedBox(height: 16),
            _buildMetricsGrid(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyFigure() {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Фоновое свечение
          Container(
            width: 160,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF4C6EF5).withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // SVG-подобный человечек через CustomPaint
          CustomPaint(
            size: const Size(140, 280),
            painter: _BodyPainter(activePart: _activeBodyPart),
          ),

          // Кликабельные зоны
          ..._buildBodyTapZones(),

          // Тултип
          if (_activeBodyPart != null && _tooltipOffset != null)
            Positioned(
              left: _tooltipOffset!.dx,
              top: _tooltipOffset!.dy,
              child: _buildTooltip(_activeBodyPart!),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildBodyTapZones() {
    return [
      // Голова
      _bodyZone('Голова', left: 55, top: 8, width: 34, height: 34, tooltipDx: 100, tooltipDy: 10),
      // Грудь
      _bodyZone('Грудь', left: 45, top: 52, width: 54, height: 50, tooltipDx: 100, tooltipDy: 55),
      // Живот
      _bodyZone('Живот', left: 48, top: 102, width: 48, height: 40, tooltipDx: 100, tooltipDy: 105),
      // Правая рука
      _bodyZone('Правая рука', left: 18, top: 55, width: 26, height: 80, tooltipDx: -90, tooltipDy: 60),
      // Левая рука
      _bodyZone('Левая рука', left: 100, top: 55, width: 26, height: 80, tooltipDx: 20, tooltipDy: 60),
      // Правая нога
      _bodyZone('Правая нога', left: 42, top: 158, width: 28, height: 100, tooltipDx: -80, tooltipDy: 160),
      // Левая нога
      _bodyZone('Левая нога', left: 74, top: 158, width: 28, height: 100, tooltipDx: 20, tooltipDy: 160),
    ];
  }

  Widget _bodyZone(String part, {
    required double left, required double top,
    required double width, required double height,
    required double tooltipDx, required double tooltipDy,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTapUp: (details) {
          _onBodyPartTap(part, Offset(tooltipDx, tooltipDy));
        },
        child: Container(
          width: width,
          height: height,
          color: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildTooltip(String part) {
    final data = _bodyPartData[part] ?? {};
    return Container(
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxWidth: 130),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2340),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4C6EF5), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C6EF5).withOpacity(0.3),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(part,
              style: const TextStyle(
                  color: Color(0xFF4C6EF5), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...data.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.key, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                const SizedBox(width: 8),
                Text(e.value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
        ),
        itemCount: _metrics.length,
        itemBuilder: (context, index) {
          final m = _metrics[index];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2340),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: (m['color'] as Color).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(m['icon'] as IconData, color: m['color'] as Color, size: 18),
                    const SizedBox(width: 6),
                    Text(m['label'] as String,
                        style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(m['value'] as String,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(m['unit'] as String,
                          style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDietTab() => const DietPage();

  Widget _buildHealthToolsTab() => const HealthToolsPage();
}

// Рисуем медицинский силуэт человека
class _BodyPainter extends CustomPainter {
  final String? activePart;

  _BodyPainter({this.activePart});

  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF2A3A6B);

    final activePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF4C6EF5).withOpacity(0.5);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF4C6EF5)
      ..strokeWidth = 1.5;

    final cx = size.width / 2;

    // Голова
    final headRect = Rect.fromCenter(center: Offset(cx, 22), width: 34, height: 34);
    final headPaint = activePart == 'Голова' ? activePaint : bodyPaint;
    canvas.drawOval(headRect, headPaint);
    canvas.drawOval(headRect, strokePaint);

    // Шея
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, 43), width: 12, height: 10), bodyPaint);

    // Грудь / торс верх
    final chestPath = Path()
      ..moveTo(cx - 28, 50)
      ..lineTo(cx + 28, 50)
      ..lineTo(cx + 22, 100)
      ..lineTo(cx - 22, 100)
      ..close();
    final chestPaint = activePart == 'Грудь' ? activePaint : bodyPaint;
    canvas.drawPath(chestPath, chestPaint);
    canvas.drawPath(chestPath, strokePaint);

    // Живот
    final bellyPath = Path()
      ..moveTo(cx - 22, 100)
      ..lineTo(cx + 22, 100)
      ..lineTo(cx + 18, 148)
      ..lineTo(cx - 18, 148)
      ..close();
    final bellyPaint = activePart == 'Живот' ? activePaint : bodyPaint;
    canvas.drawPath(bellyPath, bellyPaint);
    canvas.drawPath(bellyPath, strokePaint);

    // Правая рука (слева на экране)
    final rightArmPath = Path()
      ..moveTo(cx - 28, 52)
      ..lineTo(cx - 40, 58)
      ..lineTo(cx - 38, 130)
      ..lineTo(cx - 26, 128)
      ..close();
    final rightArmPaint = activePart == 'Правая рука' ? activePaint : bodyPaint;
    canvas.drawPath(rightArmPath, rightArmPaint);
    canvas.drawPath(rightArmPath, strokePaint);

    // Левая рука (справа на экране)
    final leftArmPath = Path()
      ..moveTo(cx + 28, 52)
      ..lineTo(cx + 40, 58)
      ..lineTo(cx + 38, 130)
      ..lineTo(cx + 26, 128)
      ..close();
    final leftArmPaint = activePart == 'Левая рука' ? activePaint : bodyPaint;
    canvas.drawPath(leftArmPath, leftArmPaint);
    canvas.drawPath(leftArmPath, strokePaint);

    // Правая нога (слева на экране)
    final rightLegPath = Path()
      ..moveTo(cx - 18, 148)
      ..lineTo(cx - 4, 148)
      ..lineTo(cx - 6, 260)
      ..lineTo(cx - 22, 260)
      ..close();
    final rightLegPaint = activePart == 'Правая нога' ? activePaint : bodyPaint;
    canvas.drawPath(rightLegPath, rightLegPaint);
    canvas.drawPath(rightLegPath, strokePaint);

    // Левая нога (справа на экране)
    final leftLegPath = Path()
      ..moveTo(cx + 4, 148)
      ..lineTo(cx + 18, 148)
      ..lineTo(cx + 22, 260)
      ..lineTo(cx + 6, 260)
      ..close();
    final leftLegPaint = activePart == 'Левая нога' ? activePaint : bodyPaint;
    canvas.drawPath(leftLegPath, leftLegPaint);
    canvas.drawPath(leftLegPath, strokePaint);
  }

  @override
  bool shouldRepaint(_BodyPainter old) => old.activePart != activePart;
}