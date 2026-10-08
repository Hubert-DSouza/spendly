// import 'package:expense_tracker/pages/analytics_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../pages/expense_history.dart';
// import '../theme/app_theme.dart';

// class BottomNavBar extends StatelessWidget {
//   final int selectedIndex;

//   const BottomNavBar({super.key, required this.selectedIndex});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: AppColors.surface,
//         border: Border(top: BorderSide(color: AppColors.border)),
//       ),
//       child: SafeArea(
//         child: SizedBox(
//           height: 64,
//           child: Row(
//             children: [
//               NavBarItem(
//                 icon: Icons.home_outlined,
//                 label: 'Home',
//                 selected: selectedIndex == 0,
//                 onTap: () {
//                   if (selectedIndex != 0) {
//                     Navigator.popUntil(context, (route) => route.isFirst);
//                   }
//                 },
//               ),
//               NavBarItem(
//                 icon: Icons.receipt_long_outlined,
//                 label: 'Expenses',
//                 selected: selectedIndex == 1,
//                 onTap: () {
//                   if (selectedIndex != 1) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const ExpenseHistory(),
//                       ),
//                     );
//                   }
//                 },
//               ),
//               NavBarItem(
//                 icon: Icons.account_balance_wallet_outlined,
//                 label: 'Budget',
//                 selected: selectedIndex == 2,
//                 onTap: () {},
//               ),
//               NavBarItem(
//                 icon: Icons.bar_chart_outlined,
//                 label: 'Analytics',
//                 selected: selectedIndex == 3,
//                 onTap: () {
//                   if (selectedIndex != 3) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const AnalyticsPage(),
//                       ),
//                     );
//                   }
//                 },
//               ),
//               NavBarItem(
//                 icon: Icons.event_note_outlined,
//                 label: 'Schedule',
//                 selected: selectedIndex == 4,
//                 onTap: () {},
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NavBarItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   const NavBarItem({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = selected ? AppColors.primary : AppColors.muted;

//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         behavior: HitTestBehavior.opaque,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 21, color: color),
//             const SizedBox(height: 3),
//             Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: 10,
//                 fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
