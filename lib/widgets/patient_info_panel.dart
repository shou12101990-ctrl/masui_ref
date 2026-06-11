import 'package:flutter/material.dart';

import '../state/patient_store.dart';

/// 計算機タブTOPの患者情報入力パネル.
/// 展開/折りたたみでき, 年齢・身長・体重・性別を入力すると PatientStore に反映され,
/// 各計算機が自動参照する.
class PatientInfoPanel extends StatefulWidget {
  const PatientInfoPanel({super.key});

  @override
  State<PatientInfoPanel> createState() => _PatientInfoPanelState();
}

class _PatientInfoPanelState extends State<PatientInfoPanel> {
  static const _accent = Color(0xFF00796B);

  final _store = PatientStore.instance;
  bool _expanded = false;

  late final TextEditingController _ageCtrl;
  late final TextEditingController _hCtrl;
  late final TextEditingController _wCtrl;

  @override
  void initState() {
    super.initState();
    _ageCtrl = TextEditingController(text: _store.age?.toString() ?? '');
    _hCtrl = TextEditingController(text: _store.heightCm?.toString() ?? '');
    _wCtrl = TextEditingController(
        text: _store.weightKg == null ? '' : _fmtNum(_store.weightKg!));
  }

  @override
  void dispose() {
    _ageCtrl.dispose();
    _hCtrl.dispose();
    _wCtrl.dispose();
    super.dispose();
  }

  static String _fmtNum(double v) =>
      v % 1 == 0 ? v.toStringAsFixed(0) : v.toString();

  String get _summary {
    if (!_store.hasAny) return '未入力 (各計算機にデフォルト値を使用)';
    final parts = <String>[
      if (_store.age != null) '${_store.age}歳',
      if (_store.heightCm != null) '${_store.heightCm}cm',
      if (_store.weightKg != null) '${_fmtNum(_store.weightKg!)}kg',
      if (_store.sex != null) _store.sex!.label,
    ];
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, _) {
        return Card(
          margin: EdgeInsets.zero,
          color: _accent.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: _accent.withValues(alpha: 0.25)),
          ),
          child: Column(
            children: [
              // ── ヘッダ (タップで開閉) ──
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(14, 10, 8, 10),
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: _accent, size: 20),
                      const SizedBox(width: 8),
                      const Text('患者情報',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      if (!_expanded)
                        Expanded(
                          child: Text(_summary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 11.5,
                                  color: _store.hasAny
                                      ? Colors.black87
                                      : Colors.black38)),
                        )
                      else
                        const Spacer(),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),
              // ── 入力欄 (2x2) ──
              if (_expanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _numField(
                              label: '年齢',
                              unit: '歳',
                              ctrl: _ageCtrl,
                              onChanged: (s) =>
                                  _store.setAge(int.tryParse(s.trim())),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _numField(
                              label: '身長',
                              unit: 'cm',
                              ctrl: _hCtrl,
                              onChanged: (s) =>
                                  _store.setHeight(int.tryParse(s.trim())),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _numField(
                              label: '体重',
                              unit: 'kg',
                              ctrl: _wCtrl,
                              onChanged: (s) =>
                                  _store.setWeight(double.tryParse(s.trim())),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: _sexField()),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: _store.hasAny ? _clearAll : null,
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('クリア',
                              style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black54,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              minimumSize: Size.zero,
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _clearAll() {
    _ageCtrl.clear();
    _hCtrl.clear();
    _wCtrl.clear();
    _store.clear();
  }

  Widget _numField({
    required String label,
    required String unit,
    required TextEditingController ctrl,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: '—',
            suffixText: unit,
            suffixStyle:
                const TextStyle(fontSize: 11, color: Colors.black45),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sexField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('性別',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 4),
        Row(
          children: [
            for (final s in Sex.values) ...[
              Expanded(
                child: GestureDetector(
                  onTap: () => _store.setSex(_store.sex == s ? null : s),
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _store.sex == s
                          ? _accent.withValues(alpha: 0.14)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _store.sex == s
                              ? _accent
                              : Colors.black12,
                          width: 1.4),
                    ),
                    child: Text(s.label,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: _store.sex == s
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: _store.sex == s
                                ? Colors.black87
                                : Colors.black54)),
                  ),
                ),
              ),
              if (s != Sex.values.last) const SizedBox(width: 6),
            ],
          ],
        ),
      ],
    );
  }
}
