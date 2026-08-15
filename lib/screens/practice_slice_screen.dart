import 'package:flutter/material.dart';

import '../data/ion_species.dart';
import '../data/reaction.dart';
import '../data/reagent.dart';
import '../l10n/app_strings.dart';
import '../modes/practice_mode_controller.dart';
import '../theme/terminal_theme.dart';

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
  // Keys into AppStrings, not raw strings, so a language toggle at any point
  // re-renders correctly instead of leaving stale-language text on screen
  // from whenever it was first set.
  String _instructionKey = 'slice.instruction';
  String? _feedbackKey;
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
          _instructionKey = 'slice.recordPrompt';
        });
      };
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

  void _toggleLanguage(AppLanguage language) {
    if (AppStrings.current == language) return;
    setState(() => AppStrings.current = language);
  }

  void _openObservationPanel() {
    final optionsEn = _reaction.distractorDescriptionsEn;
    final optionsAr = _reaction.distractorDescriptionsAr;
    final correctIndex = optionsEn.indexOf(_reaction.resultDescriptionEn);
    final rtl = AppStrings.current == AppLanguage.arabic;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            title: Text(AppStrings.get('slice.recordPrompt')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < optionsEn.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TerminalButton(
                      label: '${i + 1}. ${rtl ? optionsAr[i] : optionsEn[i]}',
                      onPressed: () => _chooseObservation(dialogContext, i, correctIndex),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _chooseObservation(BuildContext dialogContext, int chosenIndex, int correctIndex) {
    final correct = chosenIndex == correctIndex;
    _controller.recordObservation(correct);
    setState(() {
      _feedbackKey = correct ? 'slice.correct' : 'slice.incorrect';
    });
    Navigator.of(dialogContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    final rtl = AppStrings.current == AppLanguage.arabic;
    final feedbackKey = _feedbackKey;

    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('C:\\KEMIKA>_'),
          actions: [
            TerminalToggleChip(
              label: 'EN',
              active: !rtl,
              onTap: () => _toggleLanguage(AppLanguage.english),
            ),
            TerminalToggleChip(
              label: 'AR',
              active: rtl,
              onTap: () => _toggleLanguage(AppLanguage.arabic),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(AppStrings.get(_instructionKey), textAlign: TextAlign.center),
                if (feedbackKey != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    feedbackKey == 'slice.correct'
                        ? '${AppStrings.get(feedbackKey)} ${_reaction.equationText}'
                        : AppStrings.get(feedbackKey),
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
                        border: Border.all(color: TerminalColors.green, width: 2),
                      ),
                      child: Text(
                        '> ${AppStrings.get('slice.beakerLabel')}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black87),
                      ),
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
                TerminalButton(
                  label: AppStrings.get('slice.recordButton'),
                  onPressed: _readyToRecord ? _openObservationPanel : null,
                ),
                const SizedBox(height: 16),
              ],
            ),
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
        border: Border.all(color: TerminalColors.green, width: 2),
      ),
    );
  }
}
