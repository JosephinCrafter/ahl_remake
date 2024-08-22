import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../prayers/prayers_page.dart';
import '../..//who_we_are/who_we_are.dart';
import '../../../theme/theme.dart';
import '../../../utils/breakpoint_resolver.dart';
import '../../../../ahl_barrel.dart';

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
  const MobileHeroHeader({
    super.key,
  });

  @override
  State<MobileHeroHeader> createState() => _MobileHeroHeaderState();
}

class _MobileHeroHeaderState extends State<MobileHeroHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Durations.short1,
          curve: Curves.easeOut,
          color: AhlTheme.yellowLight,
          constraints: const BoxConstraints(
            minHeight: Sizes.mobileHeroHeaderImageHeight,
          ),
          child: Image.asset(
            AhlAssets.heroBk,
          ),
        ),
        Container(
          color: AhlTheme.yellowLight, //.withAlpha(0xB6),
          // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.72),
          padding: const EdgeInsets.symmetric(
            horizontal: Paddings.big,
          ),
          child: const HeroTextView(
            needMargin: true,
            margin: 0,
          ),
        ),
      ],
    );
  }
}

class HeroActions extends StatefulWidget {
  const HeroActions({
    super.key,
    this.primaryCallback,
    this.secondaryCallback,
  });

  final VoidCallback? primaryCallback;
  final VoidCallback? secondaryCallback;

  @override
  State<HeroActions> createState() => _HeroActionsState();
}

class _HeroActionsState extends State<HeroActions> {
  void primaryAction() {
    context.goNamed(PrayersPage.routeName);
  }

  void secondaryAction() {
    context.goNamed(WhoWeArePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // direction: ,
        spacing: 20,
        runSpacing: 20,
        children: [
          OutlinedButton(
            onPressed: widget.secondaryCallback ?? secondaryAction,
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
            onPressed: widget.primaryCallback ?? primaryAction,
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
    );
  }
}

class DefaultHeroHeader extends StatefulWidget {
  const DefaultHeroHeader({
    super.key,
  });

  @override
  State<DefaultHeroHeader> createState() => _DefaultHeroHeaderState();
}

class _DefaultHeroHeaderState extends State<DefaultHeroHeader> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      key: const Key("HeroHeader_Container"),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 1.2,
        maxWidth: ContentSize.maxWidth(
          MediaQuery.of(context).size.width,
        ),
      ),
      alignment: Alignment.center,
      child: 
           Stack(
              children: [
                // const HeroImageView(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 470),
                    color: AhlTheme.yellowLight.withAlpha(0xB2),
                    padding: const EdgeInsets.symmetric(
                            horizontal: Margins.extraLarge)
                        .add(
                      const EdgeInsets.only(top: 45),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: const HeroTextView(
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            )
          ,
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
      color: AhlTheme.yellowLight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: isWithBorder
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(BorderSizes.big),
                  bottomRight: Radius.circular(BorderSizes.big),
                )
              : null,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(AhlAssets.heroBk),
          ),
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
        MediaQuery.of(context).size.width,
        small: Theme.of(context).textTheme.bodyMedium,
        medium: Theme.of(context).textTheme.bodyMedium,
        other: Theme.of(context).textTheme.bodyLarge,
      );

      TextStyle? titleTheme = resolveForBreakPoint<TextStyle?>(
        MediaQuery.of(context).size.width,
        small: Theme.of(context).textTheme.displaySmall,
        medium: Theme.of(context).textTheme.displayMedium,
        other: Theme.of(context).textTheme.displayLarge,
      );
      TextStyle? subtitleTheme = resolveForBreakPoint<TextStyle?>(
        MediaQuery.of(context).size.width,
        small: Theme.of(context).textTheme.titleSmall,
        medium: Theme.of(context).textTheme.titleMedium,
        other: Theme.of(context).textTheme.titleLarge,
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
              const Gap(30),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Text(
                  AppLocalizations.of(context)!.heroTitle,
                  textAlign: TextAlign.center,
                  style: titleTheme,
                ),
              ),

              const Gap(20),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: Paddings.huge),
              //   child:
              Text(
                AppLocalizations.of(context)!.heroHeaderSubtitle,
                textAlign: TextAlign.center,
                style: subtitleTheme,
              ),
              // ),
              const Gap(20),
              Text(
                AppLocalizations.of(context)!.heroExplanation,
                textAlign: TextAlign.center,
                style: explanationTheme,
              ),
              const HeroActions(),
            ],
          ),
        ),
      );
    });
  }
}

class ScrollIncitation extends StatefulWidget {
  const ScrollIncitation({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScrollIncitation();
  }
}

class _ScrollIncitation extends State<ScrollIncitation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Durations.medium1,
    )..repeat();

    // controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 500,
        width: 10,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
