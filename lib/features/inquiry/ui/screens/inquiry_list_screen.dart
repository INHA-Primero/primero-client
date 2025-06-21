import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/features/inquiry/providers/inquiry_di.dart';
import 'inquiry_datail_screen.dart'; // 상세 화면 import
import 'inquiry_write_screen.dart';

class InquiryListScreen extends ConsumerWidget {
  const InquiryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inquiryListAsync = ref.watch(myInquiriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('문의 내역'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: inquiryListAsync.when(
        data: (pagedData) {
          final inquiries = pagedData.content;
          if (inquiries.isEmpty) {
            return const Center(child: Text('아직 작성한 문의가 없습니다.'));
          }
          return RefreshIndicator(
            onRefresh:
                () =>
                    ref.refresh(myInquiriesProvider.notifier).fetchInquiries(),
            child: ListView.builder(
              itemCount: inquiries.length,
              itemBuilder: (context, index) {
                final inquiry = inquiries[index];
                return ListTile(
                  title: Text(
                    inquiry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '작성일: ${inquiry.createdAt.split('T')[0]}',
                  ), // 날짜만 표시
                  trailing: Chip(
                    label: Text(
                      inquiry.status == 'OPEN' ? '대기중' : '답변완료',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor:
                        inquiry.status == 'OPEN'
                            ? Colors.orange
                            : AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                  onTap: () {
                    // ✨ 상세 보기 화면으로 inquiry.id를 넘겨주며 이동
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                InquiryDetailScreen(inquiryId: inquiry.id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('오류가 발생했습니다: $err'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:
                        () =>
                            ref
                                .refresh(myInquiriesProvider.notifier)
                                .fetchInquiries(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const InquiryWriteScreen()),
          );
          if (result == true) {
            ref.refresh(myInquiriesProvider.notifier).fetchInquiries();
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
