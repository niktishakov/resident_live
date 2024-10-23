import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/shared/shared.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'No server-side data storage. Everything works ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextSpan(
                text: 'offline',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.blue,
                    ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: "Get Started",
          textColor: Colors.white,
          onPressed: () => context.goNamed(ScreenNames.home),
        ),
      ],
    );
  }
}
