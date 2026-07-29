import 'package:elchemist_app/constants.dart';

double Function(
  double volume,
  double targetNicStr,
) nicVol = ((volume, targetNicStr) => volume * targetNicStr);

double Function(
  double nicVol,
) nicGrams = ((nicVol) => nicVol * nicDensity);

double Function(
  double volume,
  double targetNicStr,
  double nicBaseNicStr,
  double nicBasePerc,
) nicBaseCompVol = ((volume, targetNicStr, nicBaseNicStr, nicBasePerc) =>
    ((volume * (targetNicStr / nicBaseNicStr)) - (volume * targetNicStr)) *
    nicBasePerc);

double Function(
  double volume,
  double targetNicStr,
  double targetPerc,
) targetCompVol = ((volume, targetNicStr, targetPerc) =>
    (volume - (volume * targetNicStr)) * targetPerc);

double Function(double pgVol) pgGrams = ((pgVol) => pgVol * pgDensity);

double Function(double vgVol) vgGrams = ((vgVol) => vgVol * vgDensity);

double Function(double volume, double flavPerc) flavVol =
    ((volume, flavPerc) => volume * flavPerc);

double Function(double pgVol) pgFlavGrams = ((pgVol) => pgVol * pgFlavDensity);

double Function(double vgVol) vgFlavGrams = ((vgVol) => vgVol * vgFlavDensity);

double Function(double flavVol, double targetCompVol, double nicBaseCompVol)
    mixRecipeComp = ((flavVol, targetCompVol, nicBaseCompVol) =>
        targetCompVol - (flavVol + nicBaseCompVol));
