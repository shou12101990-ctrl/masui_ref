import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/emergency_neuro.dart';

void main() {
  group('脳出血・くも膜下出血記事の安全性境界', () {
    test('輸液は等張晶質液とeuvolemiaを基本にする', () {
      expect(neuroEmergencyFluids, contains('等張晶質液'));
      expect(neuroEmergencyFluids, contains('euvolemia'));
      expect(neuroEmergencyFluids, contains('低張液'));
      expect(neuroEmergencyFluids, contains('HES'));
      expect(neuroEmergencyFluids, contains('絶対禁忌」ではない'));
      expect(neuroEmergencyFluids, contains('維持液ではない'));
    });

    test('赤血球輸血は7だけを固定cutoffにしない', () {
      expect(neuroEmergencyTransfusion, contains('Hb <7 g/dL'));
      expect(neuroEmergencyTransfusion, contains('Hb <9 g/dL'));
      expect(neuroEmergencyTransfusion, contains('SAHARA'));
      expect(neuroEmergencyTransfusion, contains('単一の「脳外科cutoff」はない'));
      expect(neuroEmergencyTransfusion, contains('Hb 8-9 g/dL'));
    });

    test('主要抗凝固薬の緊急拮抗を網羅する', () {
      expect(neuroEmergencyReversal, contains('4因子PCC'));
      expect(neuroEmergencyReversal, contains('IVビタミンK'));
      expect(neuroEmergencyReversal, contains('イダルシズマブ'));
      expect(neuroEmergencyReversal, contains('アンデキサネット'));
      expect(neuroEmergencyReversal, contains('プロタミン'));
    });

    test('アスピリン関連ICHは緊急手術の有無を分ける', () {
      expect(neuroEmergencyReversal, contains('緊急開頭術'));
      expect(neuroEmergencyReversal, contains('考慮し得る'));
      expect(neuroEmergencyReversal, contains('緊急手術を行わない'));
      expect(neuroEmergencyReversal, contains('一律血小板輸血は有害'));
    });

    test('CPP式とSAHの固定血圧目標なしを明記する', () {
      expect(neuroEmergencyPhysiology, contains('MAP - ICP'));
      expect(neuroEmergencyIchVsSah, contains('130-150'));
      expect(neuroEmergencyIchVsSah, contains('固定SBP目標を定めていない'));
      expect(neuroEmergencyIchVsSah, contains('予防的昇圧・hypervolemiaは行わない'));
    });

    test('根拠と更新日を保持する', () {
      expect(neuroEmergencyLastReviewed, '2026-07-18');
      expect(neuroEmergencyEvidence, contains('AHA/ASA 2022'));
      expect(neuroEmergencyEvidence, contains('AHA/ASA 2023'));
      expect(neuroEmergencyEvidence, contains('AABB 2023'));
      expect(neuroEmergencyEvidence, contains('TRAIN trial'));
      expect(neuroEmergencyEvidence, contains('SAHARA trial'));
    });
  });
}
