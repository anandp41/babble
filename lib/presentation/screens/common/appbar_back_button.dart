import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../common/providers/message_reply_provider.dart';
import '../../../core/colors.dart';
import '../../../core/strings.dart';

class AppBarBackButton extends ConsumerWidget {
  const AppBarBackButton({
    super.key,
  });
  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
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
