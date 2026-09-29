const optionsOne = ['Not bothered', 'Bothered a little', 'Bothered a lot'];
const optionsTwo = [
  'Not at all',
  'Several days',
  'More than half the days',
  'Nearly every day',
];
const optionsThree = ['0', '1', '2', '3'];
const depression = [3, 5, 10, 13, 16, 17, 21, 24, 26, 31, 34, 37, 38, 42];
const anxiety = [2, 4, 7, 9, 15, 19, 20, 23, 25, 28, 30, 36, 40, 41];
const stress = [1, 6, 8, 11, 12, 14, 18, 22, 27, 29, 32, 33, 35, 39];

class TestResults {
  String _phqFifteen;
  int _phqFifteenScore;
  String _phqNine;
  int _phqNineScore;
  String _gadSeven;
  int _gadSevenScore;
  String _dass;
  int _depressionDass;
  int _anxietyDass;
  int _stressDass;

  TestResults(
    this._phqFifteen,
    this._phqFifteenScore,
    this._phqNine,
    this._phqNineScore,
    this._gadSeven,
    this._gadSevenScore,
    this._dass,
    this._depressionDass,
    this._anxietyDass,
    this._stressDass,
  );

  String get phqFifteen => _phqFifteen;
  int get phqFifteenScore => _phqFifteenScore;
  String get phqNine => _phqNine;
  int get phqNineScore => _phqNineScore;
  String get gadSeven => _gadSeven;
  int get gadSevenScore => _gadSevenScore;
  String get dass => _dass;
  int get depressionDass => _depressionDass;
  int get anxietyDass => _anxietyDass;
  int get stressDass => _stressDass;

  set phqFifteen(newPhqFifteen) => _phqFifteen = newPhqFifteen;
  set phqFifteenScore(newPhqFifteenScore) =>
      _phqFifteenScore = newPhqFifteenScore;
  set phqNine(newPhqNine) => _phqNine = newPhqNine;
  set phqNineScore(newPhqNineScore) => _phqNineScore = newPhqNineScore;
  set gadSeven(newGadSeven) => _gadSeven = newGadSeven;
  set gadSevenScore(newGadSevenScore) => _gadSevenScore = newGadSevenScore;
  set dass(newDass) => _dass = newDass;
  set depressionDass(newDepressionDass) => _depressionDass = newDepressionDass;
  set anxietyDass(newAnxietyDass) => _anxietyDass = newAnxietyDass;
  set stressDass(newStressDass) => _stressDass = newStressDass;
}

TestResults studentTestResults = TestResults("", 0, "", 0, "", 0, "", 0, 0, 0);

void resetTestResults() =>
    studentTestResults = TestResults("", 0, "", 0, "", 0, "", 0, 0, 0);
