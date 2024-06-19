import 'package:ahl/src/pages/prayers/prayers_page.dart';
import 'package:ahl/src/pages/who_we_are/who_we_are.dart';
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

          return MobileHeroHeader();
        } else {
          return DefaultHeroHeader();
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
    Navigator.pushNamed(context, PrayersPage.routeName);
  }

  void secondaryAction() {
    Navigator.pushNamed(context, WhoWeArePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
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
            margin: const EdgeInsets.only(left: Margins.extraLarge),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Text(
                  AppLocalizations.of(context)!.heroTitle,
                  textAlign: TextAlign.center,
                  style: titleTheme,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: Paddings.huge),
                child: Text(
                  AppLocalizations.of(context)!.heroHeaderSubtitle,
                  textAlign: TextAlign.center,
                  style: subtitleTheme,
                ),
              ),
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
