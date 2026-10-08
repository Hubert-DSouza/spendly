import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(title: const Text("How to Use Spendly")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How Spendly works",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 15, height: 1.6, color: muted),
                children: [
                  TextSpan(
                    text: "Set your ",
                    style: TextStyle(color: muted),
                  ),
                  TextSpan(
                    text: "Monthly Budget",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        " to tell Spendly how much you have available to spend this month.\n\n",
                  ),

                  TextSpan(text: "Log your "),
                  TextSpan(
                    text: "Expenses",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        " whenever you spend money. Your spending automatically affects your budget.\n\n",
                  ),

                  TextSpan(text: "Check your "),
                  TextSpan(
                    text: "Today's Limit",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        " to see how much you can still spend today while staying within your monthly budget.\n\n",
                  ),

                  TextSpan(text: "Use "),
                  TextSpan(
                    text: "Projected Daily",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        " to see how much you could spend per day for the remaining days of the month.\n\n",
                  ),

                  TextSpan(text: "Create "),
                  TextSpan(
                    text: "Savings Goals",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        " with a target and deadline to see how much you need to set aside each day.\n\n",
                  ),

                  TextSpan(text: "Finally, use "),
                  TextSpan(
                    text: "Expenses",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: " and "),
                  TextSpan(
                    text: "Analytics",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        " to understand where your money is going and identify your spending patterns.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
