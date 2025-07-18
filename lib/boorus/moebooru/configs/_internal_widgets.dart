// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i18n/i18n.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../../../core/configs/auth/widgets.dart';
import '../../../core/configs/create/providers.dart';
import '../moebooru.dart';
import 'types.dart';

class MoebooruPasswordField extends ConsumerStatefulWidget {
  const MoebooruPasswordField({
    super.key,
    this.hintText,
    this.controller,
  });

  final String? hintText;
  final TextEditingController? controller;

  @override
  ConsumerState<MoebooruPasswordField> createState() =>
      _MoebooruPasswordFieldState();
}

class _MoebooruPasswordFieldState extends ConsumerState<MoebooruPasswordField> {
  var password = '';

  late final passwordController = widget.controller ?? TextEditingController();

  @override
  void dispose() {
    super.dispose();
    if (widget.controller == null) {
      passwordController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(initialBooruConfigProvider);
    final moebooru = ref.watch(moebooruProvider);

    return CreateBooruApiKeyField(
      controller: passwordController,
      labelText: context.t.booru.password_label,
      onChanged: (value) => setState(() {
        if (value.isEmpty) {
          ref.editNotifier.updateApiKey(value);
          return;
        }

        password = value;
        final hashed = hashBooruPasswordSHA1(
          url: config.url,
          booru: moebooru,
          password: value,
        );
        ref.editNotifier.updateApiKey(hashed);
      }),
    );
  }
}

class MoebooruHashedPasswordField extends ConsumerWidget {
  const MoebooruHashedPasswordField({
    required this.passwordController,
    super.key,
  });

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hashedPassword = ref.watch(
      editBooruConfigProvider(
        ref.watch(editBooruConfigIdProvider),
      ).select((value) => value.apiKey),
    );

    return hashedPassword.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.hashtag,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    hashedPassword,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  splashRadius: 12,
                  onPressed: () {
                    ref.editNotifier.updateApiKey('');
                    passwordController.clear();
                  },
                  icon: const Icon(Symbols.close),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
