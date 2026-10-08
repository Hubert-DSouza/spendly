import 'package:flutter/material.dart';


// class HomepageTile extends StatelessWidget {
//   final String label;
//   final double amount;
//   final Color color;

//   const HomepageTile({
//     super.key,
//     required this.label,
//     required this.amount,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(AppSpacing.lg),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(AppRadius.md),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.poppins(
//               fontSize: 12,
//               color: AppColors.primary,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: AppSpacing.xs),
//           Text(
//             '₹${amount.toStringAsFixed(0)}',
//             style: GoogleFonts.poppins(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class HomepageTile extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const HomepageTile({super.key, required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(label),
          Text('₹$amount'),         
        ],
      ),
    );
  }
}
