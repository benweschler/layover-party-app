import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/widgets/buttons/responsive_buttons.dart';

import 'celebration_particles.dart';

class TripConfirmationDialog extends StatelessWidget {
  final Trip trip;

  const TripConfirmationDialog(this.trip, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CelebrationParticles(
      fadeDuration: const Duration(seconds: 2),
      child: FractionallySizedBox(
        widthFactor: 0.75,
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Insets.offset,
            vertical: Insets.lg,
          ),
          decoration: const BoxDecoration(
            borderRadius: Corners.medBorderRadius,
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text('Party Time!', style: TextStyles.h2),
              ),
              const SizedBox(height: Insets.med),
              for (final city in trip.layovers
                  .map((layover) => layover.airport.city))
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (rect) => LinearGradient(
                    colors: [
                      AppColors.of(context).primary,
                      AppColors.of(context).secondary,
                    ],
                  ).createShader(rect),
                  child: Text(city, style: TextStyles.title),
                ),
              const Expanded(child: Center(child: Text('{Placeholder}'))),
              ResponsiveButton.large(
                onTap: context.pop,
                builder: (_) => Container(
                  padding: const EdgeInsets.symmetric(vertical: Insets.sm),
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: Colors.black,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Lets Go',
                      style: TextStyles.body2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
