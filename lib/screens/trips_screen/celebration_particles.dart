import 'dart:math';

import 'package:flutter/material.dart';
import 'package:particle_field/particle_field.dart';
import 'package:rnd/rnd.dart';

class CelebrationParticles extends StatelessWidget {
  final Widget child;
  final Duration fadeDuration;

  const CelebrationParticles({
    Key? key,
    required this.fadeDuration,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color particleColor = Colors.amberAccent;
    int particleCount = 1200;

    // Celebration particles must underlay another widget in a Stack.
    return RepaintBoundary(
      child: ParticleField(
        blendMode: BlendMode.dstIn,
        spriteSheet: SpriteSheet(
          image: const AssetImage('assets/particle_sprite_sheet.png'),
          frameWidth: 21,
          scale: 0.75,
        ),
        onTick: (controller, elapsed, size) {
          List<Particle> particles = controller.particles;

          // calculate base distance from center & velocity based on width/height:
          final double d = min(size.width, size.height) * 0.3;
          final double v = d * 0.08;

          // calculate an opacity multiplier based on time elapsed (ie. fade out):
          controller.opacity = Curves.easeOutExpo.transform(
            max(0, 1 - elapsed.inMilliseconds / fadeDuration.inMilliseconds),
          );
          if (controller.opacity == 0) return;

          // add new particles, reducing the number added each tick:
          int addCount = particleCount ~/ 30;
          particleCount -= addCount;
          while (--addCount > 0) {
            final double angle = rnd.getRad();
            particles.add(Particle(
              // adding random variation makes it more visually interesting:
              x: cos(angle) * d * rnd(0.8, 1),
              y: sin(angle) * d * rnd(0.8, 1),
              vx: cos(angle) * v * rnd(0.5, 1.5),
              vy: sin(angle) * v * rnd(0.5, 1.5),
              color: particleColor.withOpacity(rnd(0.5, 1)),
            ));
          }

          // update existing particles & remove old ones:
          for (int i = particles.length - 1; i >= 0; i--) {
            final Particle o = particles[i];
            o.update(frame: o.age ~/ 3);
            if (o.age > 40) particles.removeAt(i);
          }
        },
      ).stackBelow(child: child),
    );
  }
}
