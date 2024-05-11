import 'package:ahl/src/utils/breakpoint_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../ahl_barrel.dart';

class HeroHeaderView extends StatelessWidget {
  const HeroHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= ScreenSizes.large) {
          // HeroHeader fo mobile

          return const MobileHeroHeader();
        } else {
          return const DefaultHeroHeader();
        }
      },
    );
  }
}

class MobileHeroHeader extends StatefulWidget {
  const MobileHeroHeader({super.key});

  @override
  State<MobileHeroHeader> createState() => _MobileHeroHeaderState();
}

class _MobileHeroHeaderState extends State<MobileHeroHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints(
            maxHeight: Sizes.mobileHeroHeaderImageHeight,
          ),
          child: const HeroImageView(isWithBorder: false),
        ),
        Container(
          margin:
              const EdgeInsets.only(top: Sizes.mobileHeroHeaderImageHeight).add(
            const EdgeInsets.symmetric(
              horizontal: Paddings.big,
            ),
          ),
          child: const HeroTextView(
            needMargin: true,
            margin: 50,
          ),
        ),
      ],
    );
  }
}

class DefaultHeroHeader extends StatefulWidget {
  const DefaultHeroHeader({super.key});

  @override
  State<DefaultHeroHeader> createState() => _DefaultHeroHeaderState();
}

class _DefaultHeroHeaderState extends State<DefaultHeroHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 700,
        maxWidth: 1080,
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          const HeroImageView(),
          Container(
            margin: const EdgeInsets.only(left: Margins.small),
            alignment: Alignment.centerLeft,
            child: const HeroTextView(
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
    );
  }
}

class HeroImageView extends StatelessWidget {
  const HeroImageView({
    super.key,
    this.isWithBorder = true,
  });

  final bool isWithBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: isWithBorder
            ? BorderRadius.circular(
                BorderSizes.big,
              )
            : null,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(AhlAssets.heroBk),
        ),
      ),
    );
  }
}

class HeroTextView extends StatelessWidget {
  const HeroTextView({
    super.key,
    this.needMargin = false,
    this.alignment,
    this.margin,
  });

  /// The margin is needed when the text should
  /// go some pixel under the image
  final bool needMargin;
  final double? margin;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      TextStyle? explanationTheme = resolveForBreakPoint<TextStyle?>(
        MediaQuery.of(context
        ).size.width,
        small: Theme.of(context).textTheme.bodyMedium,
        medium: Theme.of(context).textTheme.bodyMedium,
        other: Theme.of(context).textTheme.bodyLarge,
      );

      TextStyle? titleTheme = resolveForBreakPoint<TextStyle?>(
        MediaQuery.of(context
        ).size.width,
        small: Theme.of(context).textTheme.displaySmall,
        medium: Theme.of(context).textTheme.displayMedium,
        other: Theme.of(context).textTheme.displayLarge,
      );
      return Container(
        alignment: alignment ?? Alignment.center,
        margin: EdgeInsets.only(
          top: needMargin ? margin ?? Margins.heroHeaderExtraTop : 0,
        ),
        child: Container(
          constraints: const BoxConstraints(
              maxWidth: HeroHeaderGeometry.heroHeaderExtrasWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  AppLocalizations.of(context)!.heroTitle,
                  textAlign: TextAlign.center,
                  style: titleTheme,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.heroExplanation,
                textAlign: TextAlign.center,
                style: explanationTheme,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // direction: ,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Paddings.small,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.aboutUs,
                          // overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Paddings.small,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.priesSpace,
                          // overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
