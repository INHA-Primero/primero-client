// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:primero/core/theme/app_colors.dart';
// import 'package:primero/core/theme/app_text_style.dart';
// import 'package:primero/features/profile/providers/recycle_history_provider.dart';

// class RecycleDetailScreen extends ConsumerWidget {
//   final int recycleId;
//   const RecycleDetailScreen({super.key, required this.recycleId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // family provider에 id를 전달하여 특정 상세 정보를 watch
//     final detailState = ref.watch(recycleDetailProvider(recycleId));

//     return Scaffold(
//       appBar: AppBar(title: const Text('상세 정보')),
//       body: detailState.when(
//         // 데이터가 있을 때
//         data: (detail) => Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(detail.location, style: AppTextStyle.headline2),
//               const SizedBox(height: 16),
//               if (detail.imagePath.isNotEmpty)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8.0),
//                   child: Image.network(
//                     detail.imagePath,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     height: 250,
//                     // 로딩 중, 에러 발생 시 UI 처리
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Container(
//                         height: 250,
//                         color: Colors.grey.shade300,
//                         child: const Center(
//                           child: CircularProgressIndicator(color: AppColors.primary),
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       height: 250,
//                       color: Colors.grey.shade300,
//                       child: const Icon(Icons.error),
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 24),
//               _buildDetailRow('날짜', DateFormat('yyyy.MM.dd').format(detail.takenAt)),
//               _buildDetailRow('시각', DateFormat('HH:mm:ss').format(detail.takenAt)),
//               _buildDetailRow('포인트', '${detail.point} P'),
//               _buildDetailRow('인증 결과', detail.result ? '성공' : '실패'),
//             ],
//           ),
//         ),
//         // 로딩 중일 때
//         loading: () => const Center(child: CircularProgressIndicator()),
//         // 에러 발생 시
//         error: (err, stack) => Center(child: Text('상세 정보를 불러올 수 없습니다: $err')),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: AppTextStyle.regular.copyWith(color: Colors.grey[700])),
//           Text(value, style: AppTextStyle.medium),
//         ],
//       ),
//     );
//   }
// }
