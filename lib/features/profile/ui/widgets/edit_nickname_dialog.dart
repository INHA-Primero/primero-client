// lib/features/profile/presentation/widgets/edit_nickname_dialog.dart
// (이전 답변의 EditNicknameDialog 코드와 동일 - 변경 없음)
import 'package:flutter/material.dart';
import 'package:primero/core/theme/app_text_style.dart';

class EditNicknameDialog extends StatefulWidget {
  final String initialNickname;
  final Function(String newNickname) onSave;

  const EditNicknameDialog({
    super.key,
    required this.initialNickname,
    required this.onSave,
  });

  @override
  State<EditNicknameDialog> createState() => _EditNicknameDialogState();
}

class _EditNicknameDialogState extends State<EditNicknameDialog> {
  late TextEditingController _nicknameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.initialNickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_nicknameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('나무 이름 수정', style: AppTextStyle.bold.copyWith(fontSize: 18)),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nicknameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '새 나무 이름을 입력하세요',
            border: OutlineInputBorder(),
          ),
          style: AppTextStyle.regular,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '나무 이름은 비워둘 수 없습니다.';
            }
            if (value.trim().length > 20) {
              // 예시: 최대 길이 제한
              return '나무 이름은 20자 이내로 입력해주세요.';
            }
            return null;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            '취소',
            style: AppTextStyle.medium.copyWith(color: Colors.grey),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: Text(
            '저장',
            style: AppTextStyle.medium.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
