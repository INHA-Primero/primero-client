// lib/features/inquiry/ui/screens/inquiry_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/features/inquiry/providers/inquiry_di.dart';

class InquiryDetailScreen extends ConsumerWidget {
  final int inquiryId;

  const InquiryDetailScreen({super.key, required this.inquiryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inquiryDetailAsync = ref.watch(inquiryDetailProvider(inquiryId));

    return Scaffold(
      appBar: AppBar(title: const Text('문의 상세')),
      body: inquiryDetailAsync.when(
        data: (inquiry) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 문의 제목 및 상태
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        inquiry.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(
                        inquiry.status == 'OPEN' ? '대기중' : '답변완료',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor:
                          inquiry.status == 'OPEN'
                              ? Colors.orange
                              : AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '작성자: ${inquiry.writer} | 작성일: ${inquiry.createdAt.split('T')[0]}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const Divider(height: 32),
                // 문의 내용
                Text(
                  inquiry.content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 32),
                // 답변 섹션
                if (inquiry.answers.isNotEmpty)
                  ...inquiry.answers.map(
                    (answer) => Card(
                      margin: const EdgeInsets.only(top: 16),
                      color: Colors.grey[100],
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.support_agent,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '관리자 답변',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Text(
                              answer.content,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('오류가 발생했습니다: $err')),
      ),
    );
  }
}
