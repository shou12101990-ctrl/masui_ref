import 'package:flutter/material.dart';

import '../data/columns.dart';

/// コラム本文中に埋め込む表の描画.
/// インラインでは画面幅いっぱいに折り返し表示し,
/// タップするとポップアップでピンチ拡大・ドラッグ移動できる.
class ArticleTableView extends StatelessWidget {
  final ArticleTable table;
  const ArticleTableView({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPopup(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTable(headerSize: 11, bodySize: 11.5),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.zoom_out_map, size: 12, color: Colors.black38),
              SizedBox(width: 3),
              Text('タップで拡大',
                  style: TextStyle(fontSize: 10, color: Colors.black38)),
            ],
          ),
        ],
      ),
    );
  }

  void _openPopup(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 4, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('ピンチで拡大 / ドラッグで移動',
                        style:
                            TextStyle(fontSize: 11, color: Colors.black45)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(120),
                minScale: 0.5,
                maxScale: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: SizedBox(
                    width: 640,
                    child: _buildTable(headerSize: 13, bodySize: 13.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable({required double headerSize, required double bodySize}) {
    return Table(
      border: TableBorder(
        horizontalInside:
            BorderSide(color: Colors.grey.shade300, width: 0.8),
        bottom: BorderSide(color: Colors.grey.shade300, width: 0.8),
      ),
      columnWidths: const {
        0: FlexColumnWidth(0.9),
        1: FlexColumnWidth(1.1),
        2: FlexColumnWidth(1.7),
        3: FlexColumnWidth(1.3),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(
          decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: Colors.grey.shade400, width: 1.0)),
          ),
          children: [
            for (final h in table.headers)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                child: Text(h,
                    style: TextStyle(
                        fontSize: headerSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
          ],
        ),
        for (final row in table.rows)
          TableRow(
            children: [
              for (final cell in row)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 9),
                  child: Text(cell,
                      style: TextStyle(
                          fontSize: bodySize,
                          height: 1.35,
                          color: Colors.black87)),
                ),
            ],
          ),
      ],
    );
  }
}
