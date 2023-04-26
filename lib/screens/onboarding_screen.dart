import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layover_party/models/app_model.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/utils/iterable_utils.dart';
import 'package:layover_party/widgets/buttons/responsive_buttons.dart';
import 'package:layover_party/widgets/gooey_carousel/gooey_carousel_plus.dart';
import 'package:provider/provider.dart';

class OnboardingScreenCarousel extends StatelessWidget {
  const OnboardingScreenCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GooeyCarousel(
      children: [
        OnboardingScreen(
          rightBlobPath: 'assets/onboarding/right_orange.png',
          leftBlobPath: 'assets/onboarding/left_orange.png',
          illustrationPath: 'assets/onboarding/airport.png',
          buttonGradientColors: [
            Color(0xFFED7303),
            Color(0xFFF9544A),
          ],
          title: 'Welcome to Layover Party!',
          description:
              'Turn your layovers into adventures with other travelers!',
          index: 0,
        ),
        OnboardingScreen(
          rightBlobPath: 'assets/onboarding/right_purple.png',
          leftBlobPath: 'assets/onboarding/left_purple.png',
          illustrationPath: 'assets/onboarding/city.png',
          buttonGradientColors: [
            Color(0xFFA5AEFF),
            Color(0xFFA5AEFF),
          ],
          title: 'Exotic Destinations',
          description: 'Make use of your extra time by exploring new areas',
          index: 1,
        ),
        OnboardingScreen(
          rightBlobPath: 'assets/onboarding/right_blue.png',
          leftBlobPath: 'assets/onboarding/left_blue.png',
          illustrationPath: 'assets/onboarding/mountains.png',
          buttonGradientColors: [
            Color(0xFF3075FA),
            Color(0xFF66C0E0),
          ],
          title: 'Make new friends',
          description:
              'Meet like-minded folks also looking for new connections and adventures',
          index: 2,
        ),
      ],
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  final String rightBlobPath;
  final String leftBlobPath;
  final String illustrationPath;
  final List<Color> buttonGradientColors;
  final String title;
  final String description;
  final int index;

  const OnboardingScreen({
    Key? key,
    required this.rightBlobPath,
    required this.leftBlobPath,
    required this.illustrationPath,
    required this.buttonGradientColors,
    required this.title,
    required this.description,
    required this.index,
  }) : super(key: key);

  Widget _buildGradientBlobs() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Image.asset(leftBlobPath),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Image.asset(rightBlobPath),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(child: DotPageIndicator(numPages: 3, index: index)),
                const SizedBox(height: Insets.med),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyles.h1.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: Insets.med),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyles.h2.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Insets.xl * 1.5),
          Expanded(
            child: index == 2
                ? UnconstrainedBox(
                    constrainedAxis: Axis.horizontal,
                    child: ContinueButton(buttonGradientColors),
                  )
                : ContinueArrow(buttonGradientColors),
          ),
          const SizedBox(height: Insets.xl),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: _buildGradientBlobs()),
                  Expanded(child: _buildContent()),
                ],
              ),
              Align(
                alignment: const Alignment(0, -0.3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
                  child: Image.asset(illustrationPath),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContinueButton extends StatelessWidget {
  final List<Color> gradientColors;

  const ContinueButton(this.gradientColors, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton.large(
      onTap: () => context.read<AppModel>().isOnboarded = true,
      builder: (_) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Insets.med),
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          gradient: LinearGradient(colors: gradientColors),
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Continue',
            style: TextStyles.title.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ContinueArrow extends StatelessWidget {
  final List<Color> gradientColors;

  const ContinueArrow(this.gradientColors, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) =>
          LinearGradient(colors: gradientColors).createShader(rect),
      blendMode: BlendMode.srcIn,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Swipe to Continue',
            style: TextStyles.title.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: Insets.med),
          const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}

class DotPageIndicator extends StatelessWidget {
  final int numPages;
  final int index;

  const DotPageIndicator({
    Key? key,
    required this.numPages,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < numPages; i++)
          Container(
            width: Insets.sm,
            height: Insets.sm,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == i
                  ? Colors.black.withOpacity(0.75)
                  : Colors.black.withOpacity(0.25),
            ),
          )
      ].separate(const SizedBox(width: Insets.med)).toList(),
    );
  }
}
