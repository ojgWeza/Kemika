import 'package:flutter/material.dart';

import '../data/ion_species.dart';
import '../data/reaction.dart';
import '../data/reagent.dart';
import '../l10n/app_strings.dart';
import '../modes/practice_mode_controller.dart';

/// The chloride + AgNO3 vertical slice: one full lesson end-to-end (drag reagent ->
/// drip -> observe -> record), built to validate the "no result without action" loop
/// before anything else (Kemidex, Challenge Mode, protagonist, other ions) is built.
class PracticeSliceScreen extends StatefulWidget {
  const PracticeSliceScreen({super.key});

  @override
  State<PracticeSliceScreen> createState() => _PracticeSliceScreenState();
}

class _PracticeSliceScreenState extends State<PracticeSliceScreen> {
  // A clear aqueous solution, not white -- so the gradual reveal toward the
  // (also white) AgCl precipitate is actually visible. Using plain white for
  // both ends of the lerp made the "gradual reveal" invisible on screen even
  // though the underlying drip-count state was advancing correctly --
  // caught by actually driving the app, not just reading the code.
  static const _emptySolutionColor = Color(0xFFDCE8ED);

  late final Reaction _reaction;
  late final PracticeModeController _controller;

  Color _beakerColor = _emptySolutionColor;
  String _instruction = '';
  String _feedback = '';
  bool _readyToRecord = false;

  @override
  void initState() {
    super.initState();
    _reaction = _buildChlorideVsSilverNitrateReaction();
    _controller = PracticeModeController(_reaction)
      ..onProgressChanged = (progress) {
        setState(() {
          _beakerColor = Color.lerp(_emptySolutionColor, _reaction.resultColor, progress)!;
        });
      }
      ..onReadyToRecord = () {
        setState(() {
          _readyToRecord = true;
          _instruction = AppStrings.get('slice.recordPrompt');
        });
      };
    _instruction = AppStrings.get('slice.instruction');
  }

  Reaction _buildChlorideVsSilverNitrateReaction() {
    const chloride = IonSpecies(
      id: 'cl-',
      displayNameEn: 'Chloride (Cl⁻)',
      displayNameAr: 'كلوريد (Cl⁻)',
      category: IonCategory.anion,
    );
    const silverNitrate = Reagent(
      id: 'agno3',
      displayNameEn: 'Silver Nitrate (AgNO3)',
      displayNameAr: 'نترات الفضة (AgNO3)',
      dropperTint: Color(0xFFD9D9E6),
    );

    return const Reaction(
      targetIon: chloride,
      reagent: silverNitrate,
      requiredDripCount: 5,
      resultColor: Colors.white,
      resultDescriptionEn: 'White curdy precipitate',
      resultDescriptionAr: 'راسب أبيض متجبن',
      equationText: 'Ag⁺ + Cl⁻ → AgCl↓ (white)',
      distractorDescriptionsEn: [
        'White curdy precipitate',
        'Yellow precipitate',
        'No visible change',
        'Pale blue precipitate',
      ],
      distractorDescriptionsAr: [
        'راسب أبيض متجبن',
        'راسب أصفر',
        'لا تغيير ملحوظ',
        'راسب أزرق فاتح',
      ],
    );
  }

  void _openObservationPanel() {
    final optionsEn = _reaction.distractorDescriptionsEn;
    final optionsAr = _reaction.distractorDescriptionsAr;
    final correctIndex = optionsEn.indexOf(_reaction.resultDescriptionEn);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppStrings.get('slice.recordPrompt')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < optionsEn.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _chooseObservation(dialogContext, i, correctIndex),
                      child: Text(
                        AppStrings.current == AppLanguage.arabic ? optionsAr[i] : optionsEn[i],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _chooseObservation(BuildContext dialogContext, int chosenIndex, int correctIndex) {
    final correct = chosenIndex == correctIndex;
    _controller.recordObservation(correct);
    setState(() {
      _feedback = correct
          ? '${AppStrings.get('slice.correct')} ${_reaction.equationText}'
          : AppStrings.get('slice.incorrect');
    });
    Navigator.of(dialogContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kemika')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(_instruction, textAlign: TextAlign.center),
              if (_feedback.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  _feedback,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              const Spacer(),
              DragTarget<String>(
                onAcceptWithDetails: (_) => _controller.addDrop(),
                builder: (context, candidateData, rejectedData) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 220,
                    height: 260,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: _beakerColor,
                      border: Border.all(color: Colors.black87, width: 3),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: Text(AppStrings.get('slice.beakerLabel'), textAlign: TextAlign.center),
                  );
                },
              ),
              const Spacer(),
              Draggable<String>(
                data: 'drop',
                feedback: _dropperVisual(),
                childWhenDragging: Opacity(opacity: 0.3, child: _dropperVisual()),
                child: _dropperVisual(),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _readyToRecord ? _openObservationPanel : null,
                child: Text(AppStrings.get('slice.recordButton')),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropperVisual() {
    return Container(
      width: 60,
      height: 90,
      decoration: BoxDecoration(
        color: _reaction.reagent.dropperTint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black54, width: 2),
      ),
    );
  }
}
