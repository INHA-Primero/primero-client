// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:primero/core/theme/app_colors.dart';
// import 'package:primero/core/theme/app_text_style.dart';
// import 'package:primero/features/profile/providers/recycle_history_provider.dart';
// import 'package:primero/features/profile/ui/screens/recycle_detail_screen.dart';

// class RecycleHistoryScreen extends ConsumerStatefulWidget {
//   const RecycleHistoryScreen({super.key});

//   @override
//   ConsumerState<RecycleHistoryScreen> createState() =>
//       _RecycleHistoryScreenState();
// }

// class _RecycleHistoryScreenState extends ConsumerState<RecycleHistoryScreen> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     // 스크롤 리스너 추가
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     // 스크롤이 끝에 도달했는지 확인
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       // 다음 페이지 로드
//       ref.read(recycleHistoryProvider.notifier).fetchNextPage();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final historyState = ref.watch(recycleHistoryProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text('전체 분리수거 기록')),
//       body: historyState.when(
//         // 데이터가 성공적으로 로드되었을 때
//         data: (histories) {
//           if (histories.isEmpty) {
//             return const Center(child: Text('기록이 없습니다.'));
//           }
//           return RefreshIndicator(
//             onRefresh: () => ref.refresh(recycleHistoryProvider.future),
//             child: ListView.separated(
//               controller: _scrollController,
//               itemCount: histories.length,
//               itemBuilder: (context, index) {
//                 final history = histories[index];
//                 final date = DateFormat('yyyy.MM.dd').format(history.takenAt);
//                 return ListTile(
//                   title: Text(history.location),
//                   subtitle: Text(date),
//                   trailing: Text(
//                     "${history.point} P",
//                     style: AppTextStyle.headline4.copyWith(
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder:
//                             (context) =>
//                                 RecycleDetailScreen(recycleId: history.id),
//                       ),
//                     );
//                   },
//                 );
//               },
//               separatorBuilder: (_, __) => const Divider(height: 1),
//             ),
//           );
//         },
//         // 로딩 중일 때
//         loading: () => const Center(child: CircularProgressIndicator()),
//         // 에러 발생 시
//         error: (err, stack) => Center(child: Text('데이터를 불러올 수 없습니다: $err')),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
