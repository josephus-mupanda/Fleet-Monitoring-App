import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/images.dart';
import '../core/config/constants.dart';

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold (
      body: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Stack(
                      fit: StackFit.loose,
                      children: [
                        Center(
                          child: SingleChildScrollView(
                            child: Container(
                              height: size.height,
                              width: size.width,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(Constants.kDefaultPadding),
                                        child: Card(
                                          color: Theme.of(context).cardColor,
                                          child: Column(
                                            children: <Widget>[
                                              const SizedBox(height: Constants.kDefaultPadding / 2),
                                              Flexible(
                                                  child: Container(
                                                    padding: const EdgeInsets.only(left: 50, right: 50, bottom: 80),
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            height: 300,
                                                            child:  SvgPicture.asset(
                                                              ImagePath.notFoundSvg,
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            "404",
                                                            textAlign: TextAlign.center,
                                                            style: Theme.of(context).textTheme.bodyLarge,
                                                          ),
                                                          Text(
                                                            "Page not Found",
                                                            textAlign: TextAlign.center,
                                                            style: Theme.of(context).textTheme.bodyMedium,
                                                          ),
                                                          const SizedBox(
                                                            height: Constants.kDefaultPadding,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
