import '../models/drug.dart';

import 'drugs/sedative.dart';
import 'drugs/inhalational.dart';
import 'drugs/muscle_relaxant.dart';
import 'drugs/analgesic.dart';
import 'drugs/vasopressor.dart';
import 'drugs/vasodilator.dart';
import 'drugs/circulatory_other.dart';
import 'drugs/antiarrhythmic.dart';
import 'drugs/local_anesthetic.dart';
import 'drugs/anticoagulant.dart';
import 'drugs/steroid.dart';
import 'drugs/antiemetic.dart';
import 'drugs/psychotropic.dart';
import 'drugs/psychotropic_ext.dart';
import 'drugs/antimicrobial.dart';
import 'drugs/antihistamine.dart';
import 'drugs/transfusion.dart';
import 'drugs/diuretic.dart';
import 'drugs/gastrointestinal.dart';
import 'drugs/other.dart';

/// 麻酔薬リファレンス データ (Excel「ますい.xlsx」より抜粋・整形).
/// 研修医向けの参考情報であり, 実際の投与は最新の添付文書・成書を確認すること.
/// (カテゴリごとの実データは lib/data/drugs/ 以下に分割)
final List<Drug> kDrugs = [
  ...kSedativeDrugs,
  ...kInhalationalDrugs,
  ...kMuscleRelaxantDrugs,
  ...kAnalgesicDrugs,
  ...kVasopressorDrugs,
  ...kVasodilatorDrugs,
  ...kCirculatoryOtherDrugs,
  ...kAntiarrhythmicDrugs,
  ...kLocalAnestheticDrugs,
  ...kAnticoagulantDrugs,
  ...kSteroidDrugs,
  ...kAntiemeticDrugs,
  ...kPsychotropicDrugs,
  ...kPsychotropicExtDrugs,
  ...kAntimicrobialDrugs,
  ...kAntihistamineDrugs,
  ...kTransfusionDrugs,
  ...kDiureticDrugs,
  ...kGastrointestinalDrugs,
  ...kOtherDrugs,
];
