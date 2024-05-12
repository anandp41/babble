import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/message_reply_provider.dart';
import '../../core/colors.dart';

class AppBarBackButton extends ConsumerWidget {
  const AppBarBackButton({
    super.key,
  });
  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () {
          Get.back();
          cancelReply(ref);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: appbarBackButtonColor,
        ));
  }
}
