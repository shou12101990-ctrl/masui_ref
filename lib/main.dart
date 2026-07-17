import 'package:flutter/material.dart';

import 'screens/column_screen.dart';
import 'screens/calculator_hub_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/medication_master_screen.dart';

void main() {
  runApp(const MasuiApp());
}

class MasuiApp extends StatelessWidget {
  const MasuiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00796B),
      brightness: Brightness.light,
    );
    return MaterialApp(
      title: 'やさしい麻酔科ローテ β',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F7),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          color: Colors.white,
          margin: EdgeInsets.zero,
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _pages = [
    MedicationMasterScreen(),
    CalculatorHubScreen(),
    ColumnScreen(),
    EmergencyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      // IndexedStack: タブ切替時も各ページの状態(検索条件・スクロール位置等)を保持
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: _BottomNav(
        index: _index,
        scheme: scheme,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool emphasis; // 緊急対応など強調（常に赤・太字）
  const _NavItem(
    this.icon,
    this.selectedIcon,
    this.label, {
    this.emphasis = false,
  });
}

class _BottomNav extends StatelessWidget {
  final int index;
  final ColorScheme scheme;
  final ValueChanged<int> onTap;
  const _BottomNav({
    required this.index,
    required this.scheme,
    required this.onTap,
  });

  static const _items = [
    _NavItem(Icons.medication_outlined, Icons.medication, '薬剤'),
    _NavItem(Icons.calculate_outlined, Icons.calculate, '機能'),
    _NavItem(Icons.menu_book_outlined, Icons.menu_book, '解説'),
    _NavItem(Icons.emergency_outlined, Icons.emergency, '緊急対応', emphasis: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (int i = 0; i < _items.length; i++)
                Expanded(child: _tile(_items[i], i)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(_NavItem it, int i) {
    final selected = index == i;
    final color = it.emphasis
        ? Colors.red
        : (selected ? scheme.primary : Colors.black54);
    final bold = it.emphasis || selected;
    return InkWell(
      onTap: () => onTap(i),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 強調タブ(緊急対応)は常に塗りつぶしアイコン
          Icon(
            (it.emphasis || selected) ? it.selectedIcon : it.icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            it.label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
