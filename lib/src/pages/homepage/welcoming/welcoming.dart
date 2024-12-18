import 'dart:math';

import 'package:ahl/ahl_barrel.dart';
import 'package:ahl/src/utils/breakpoint_resolver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_seo/flutter_seo.dart';

import '../../../theme/theme.dart';

class WelcomingView extends StatelessWidget {
  const WelcomingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Margins.medium,
      ).copyWith(bottom: 85),
      child: const _WelcomingContent(),
    );
  }
}

class _WelcomingContent extends StatelessWidget {
  const _WelcomingContent();
  @override
  Widget build(BuildContext context) {
    // Build html tree
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      CreateHtml.makeWidgetTree(context);
    });

    String welcomingBody = AppLocalizations.of(context)!.welcomingBody;
    String welcomingTitle = AppLocalizations.of(context)!.welcomingTitle;

    double avatarWidth = 174;
    double avatarHeight = 155;
    // GlobalKey containerKey = GlobalKey(debugLabel: 'welcoming_container');
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                // key: containerKey,
                constraints: BoxConstraints(
                  minWidth: 342,
                  maxWidth:
                      ContentSize.maxWidth(MediaQuery.of(context).size.width),
                ),
                padding: const EdgeInsets.all(Paddings.big)
                    .copyWith(top: Paddings.big + Sizes.nddLogoSize / 2),
                margin: const EdgeInsets.only(top: Sizes.nddLogoSize / 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AhlTheme.affiche,
                  borderRadius: BorderRadius.circular(BorderSizes.medium),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcomingTitle,
                      style: resolveHeadlineTextThemeForBreakPoints(
                        MediaQuery.of(context).size.width,
                        context,
                      ),
                      key: SeoKey(
                        TagType.h2,
                        text: welcomingTitle,
                        alt: "Welcoming",
                      ),
                    ),
                    SelectableText(
                      '\n$welcomingBody',
                      key: SeoKey(TagType.p, text: welcomingBody),
                      style: resolveBodyTextThemeForBreakPoints(
                        MediaQuery.of(context).size.width,
                        context,
                      ),
                    ),
                    Container(
                      // constraints: BoxConstraints(
                      //   // minWidth: 480,
                      //   maxWidth: constraints.maxWidth - 135,
                      // ),
                      padding: EdgeInsets.only(
                        top: 45,
                        right: resolveForBreakPoint<double>(
                          MediaQuery.of(context).size.width,
                          small: 0,
                          other: avatarWidth / 2 + 140,
                          medium: avatarWidth / 2 + 80,
                        ),
                      ),
                      alignment: resolveForBreakPoint<AlignmentGeometry>(
                        MediaQuery.of(context).size.width,
                        small: Alignment.center,
                        other: Alignment.centerRight,
                      ),
                      child: const Signature(),
                    ),
                    Visibility(
                      visible: resolveForBreakPoint<bool>(
                        MediaQuery.of(context).size.width,
                        small: true,
                        other: false,
                      ),
                      child: const SizedBox(
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: LogoNDD(),
            ),
            Positioned(
              bottom:
                  (-avatarHeight / 2) - 10, // avatarHeight is the image height
              left: resolveForBreakPoint<double>(
                MediaQuery.of(context).size.width,
                small: constraints.maxWidth / 2 - avatarWidth / 2,
                medium: constraints.maxWidth / 2 +
                    min(
                          MediaQuery.of(context).size.width,
                          ContentSize.maxWidth(
                              MediaQuery.of(context).size.width),
                        ) /
                        2 -
                    50 -
                    avatarWidth,
                other: constraints.maxWidth / 2 +
                    min(
                          MediaQuery.of(context).size.width,
                          ContentSize.maxWidth(
                              MediaQuery.of(context).size.width),
                        ) /
                        2 -
                    100 -
                    avatarWidth,
              ),
              child: SizedBox(
                width: avatarWidth,
                child: Image.asset(
                  AhlAssets.priorAvatar,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class LogoNDD extends StatelessWidget {
  const LogoNDD({super.key});

  @override
  Widget build(BuildContext context) {
    // seo: Html element creation
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      CreateHtml.makeWidgetTree(context);
    });

    return SizedBox.square(
      dimension: Sizes.nddLogoSize,
      child: Image.asset(
        key: SeoKey(TagType.img,
            alt:
                "Logo des Soeurs Dominicaines Missionnaires de Notre Dame de la Delivrande",src: AhlAssets.logoNdd,),
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
    //seo: create html tag
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      CreateHtml.makeWidgetTree(context);
    });

    String title = '${AppLocalizations.of(context)!.sister} Michèle Marie, o.p';

    return RichText(
        key:SeoKey(TagType.p),
      text: TextSpan(
        text: title,
        style: AhlTheme.name,
        children: [
          TextSpan(
            text: '\n${AppLocalizations.of(context)!.prior}',
            style: AhlTheme.peopleTitle,
          ),
        ],
      ),
    );
  }
}
