import 'package:flutter/material.dart';
import 'package:afara_project/core/theme/app_theme.dart';

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  bool isIndividual = true; // State for the toggle

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.responsivePadding(
        context,
      ).copyWith(top: AppTheme.spacingXXL * 2, bottom: AppTheme.spacingXXL * 2),
      child: Column(
        children: [
          // Header
          Text(
            'Frequently Asked Questions',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Text(
            'Quick answers to common questions',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: AppTheme.spacingXXL),

          // User Type Toggle
          ToggleSelector(
            isIndividual: isIndividual,
            onChanged: (val) => setState(() => isIndividual = val),
          ),
          const SizedBox(height: AppTheme.spacingXXL),

          // FAQ List
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppTheme.responsiveMaxWidth(context),
            ),
            child: Column(
              children: const [
                FaqItem(
                  question: 'How do I set up my personal Afara account?',
                  answer:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi nec nulla non metus pretium ullamcorper.',
                ),
                FaqItem(
                  question: 'How do I set up my personal Afara account?',
                  answer:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi nec nulla non metus pretium ullamcorper.',
                ),
                FaqItem(
                  question: 'How do I set up my personal Afara account?',
                  answer:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi nec nulla non metus pretium ullamcorper.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXXL * 1.5),
          const SupportCtaSection(),
        ],
      ),
    );
  }
}

/// Reusable FAQ Item
class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const FaqItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  question,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.add, color: Color(0xFF737373)),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Text(
            answer,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.black87, height: 1.5),
          ),
          const Divider(height: AppTheme.spacingXXL, color: Colors.black12),
        ],
      ),
    );
  }
}

/// Toggle Selector Widget
class ToggleSelector extends StatelessWidget {
  final bool isIndividual;
  final Function(bool) onChanged;

  const ToggleSelector({
    super.key,
    required this.isIndividual,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.responsiveToggleSelectorWidth(context),
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFB4B4B4).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSM),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingXS),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isIndividual ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSM),
                ),
                child: Text(
                  'Individual Users',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isIndividual
                        ? const Color(0xFF3873AF)
                        : const Color(0xFF737373),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isIndividual ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSM),
                ),
                child: Text(
                  'Business Users',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: !isIndividual
                        ? const Color(0xFF3873AF)
                        : const Color(0xFF737373),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The "Need Personalized Support?" Blue Card
class SupportCtaSection extends StatelessWidget {
  const SupportCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppTheme.responsivePadding(context),
      padding: AppTheme.responsivePadding(context),
      decoration: BoxDecoration(
        color: const Color(0xFF3873AF),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMD),
      ),
      child: Column(
        children: [
          Text(
            'Need Personalized Support?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Text(
            'Our expert team is ready to help you implement the \nperfect identity solution',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppTheme.spacingMD),
          // Contact Support Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: const Size(228, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSM),
              ),
              elevation: 0,
              side: const BorderSide(color: Colors.black12),
            ),
            child: Text(
              'Contact Support',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
