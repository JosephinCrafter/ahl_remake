import 'package:ahl/src/ahl_barrel.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../theme/theme.dart';

class WelcomingView extends StatelessWidget {
  const WelcomingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(
        Margins.mobileMargin,
      ).copyWith(bottom: 125),
      child: const _WelcomingContent(),
    );
  }
}

class _WelcomingContent extends StatelessWidget {
  const _WelcomingContent();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              constraints: const BoxConstraints(minWidth: 342, maxWidth: 420),
              padding: const EdgeInsets.all(Paddings.big)
                  .copyWith(top: Paddings.big + Sizes.nddLogoSize / 2),
              margin: const EdgeInsets.only(top: Sizes.nddLogoSize / 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AhlTheme.greenOlive.withOpacity(0.2),
                borderRadius: BorderRadius.circular(BorderSizes.medium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.welcomingTitle,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontFamily: 'Butler', fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: 'Butler',
                          ),
                      children: [
                        TextSpan(
                          text:
                              '\n${AppLocalizations.of(context)!.welcomingBody}',
                        )
                      ],
                    ),
                  ),
                  Container(
                    // constraints:
                    //     const BoxConstraints(maxHeight: 50, maxWidth: 350),
                    padding: const EdgeInsets.only(top: 45),

                    alignment: Alignment.centerLeft,
                    child: const Signature(),
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: LogoNDD(),
          ),
          //todo: change the image to Sr Michelle Image
          Positioned(
            bottom: -50,
            left: constraints.maxWidth / 2 + 15,
            child: SizedBox(
              width: 175,
              child: Image.asset(
                AhlAssets.priorAvatar,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogoNDD extends StatelessWidget {
  const LogoNDD({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: Sizes.nddLogoSize,
      child: Image.asset(
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
        AhlAssets.logoNdd,
      ),
    );
  }
}

class Signature extends StatelessWidget {
  const Signature({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: '${AppLocalizations.of(context)!.sister} Michelle Marie, o.p',
          style: AhlTheme.name,
          children: [
            TextSpan(
              text: '\n${AppLocalizations.of(context)!.prior}',
              style: AhlTheme.peopleTitle,
            ),
          ]),
    );
  }
}
