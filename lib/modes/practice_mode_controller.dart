import '../data/reaction.dart';

class AttemptRecord {
  const AttemptRecord({
    required this.attemptNumber,
    required this.correct,
    required this.dropsUsed,
  });

  final int attemptNumber;
  final bool correct;
  final int dropsUsed;
}

/// Owns the manual interaction loop for one [Reaction]: drip -> gradual reveal ->
/// record. No chemical result is ever exposed to the player except as the direct
/// output of [addDrop] or [recordObservation] below -- both only ever fire in
/// response to a manual player action (see CONSTITUTION.md, law 1: "no result
/// without action").
class PracticeModeController {
  PracticeModeController(this.reaction);

  final Reaction reaction;

  final List<AttemptRecord> _attempts = [];
  List<AttemptRecord> get attempts => List.unmodifiable(_attempts);

  int _dropCount = 0;
  bool _readyToRecord = false;
  bool get readyToRecord => _readyToRecord;

  /// Fires with progress in 0..1, driving the gradual color reveal.
  void Function(double progress)? onProgressChanged;
  void Function()? onReadyToRecord;
  void Function(AttemptRecord record)? onAttemptRecorded;

  void addDrop() {
    if (_readyToRecord) return;

    _dropCount++;
    final progress = (_dropCount / reaction.requiredDripCount).clamp(0.0, 1.0);
    onProgressChanged?.call(progress);

    if (_dropCount >= reaction.requiredDripCount) {
      _readyToRecord = true;
      onReadyToRecord?.call();
    }
  }

  bool recordObservation(bool isCorrectChoice) {
    if (!_readyToRecord) return false;

    final record = AttemptRecord(
      attemptNumber: _attempts.length + 1,
      correct: isCorrectChoice,
      dropsUsed: _dropCount,
    );
    _attempts.add(record);
    onAttemptRecorded?.call(record);
    return isCorrectChoice;
  }
}
