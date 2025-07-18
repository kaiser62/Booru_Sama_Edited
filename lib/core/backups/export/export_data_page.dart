// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/i18n.dart';

// Project imports:
import '../../../foundation/networking.dart';
import '../../theme/app_theme.dart';
import 'export_data_notifier.dart';

class ExportDataPage extends ConsumerStatefulWidget {
  const ExportDataPage({super.key});

  @override
  ConsumerState<ExportDataPage> createState() => _ExportDataPageState();
}

class _ExportDataPageState extends ConsumerState<ExportDataPage> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(exportDataProvider.notifier);
    final connectedToWifi = ref.watch(connectedToWifiProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          notifier.stopServer();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transfer data'.hc),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: connectedToWifi
              ? ref
                    .watch(exportDataProvider)
                    .when(
                      data: (data) => _buildBody(data),
                      error: (error, _) => Text('Error: $error'),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 8,
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.hintColor,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'WiFi connection required to transfer data. Please connect to a WiFi network and try again.'
                                    .hc,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildBody(ExportDataState state) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Builder(
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ServerInfoTile(
                        title: 'IP',
                        value: state.serverUrl,
                      ),
                      ServerInfoTile(
                        title: 'Name',
                        value: state.serverName,
                      ),
                      ServerInfoTile(
                        title: 'Version',
                        value: state.appVersion,
                      ),
                      ServerInfoTile(
                        title: 'Status',
                        value: state.status.name,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'How to transfer:',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: textTheme.bodyMedium,
                          children: [
                            const TextSpan(
                              text: '• On receiving device, go to ',
                            ),
                            TextSpan(
                              text: 'Settings > Backup and restore',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            const TextSpan(
                              text: '\n• Select ',
                            ),
                            TextSpan(
                              text: 'Receive',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            const TextSpan(
                              text: ' to start importing data from this device',
                            ),
                            const TextSpan(
                              text:
                                  '\n• Stay on this page until transfer completes',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_rounded,
                              color: colorScheme.error,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Transfer might not work on public WiFi networks (coffee shops, libraries) due to security restrictions. Please use a private network like your home WiFi.',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class ServerInfoTile extends StatelessWidget {
  const ServerInfoTile({
    required this.title,
    required this.value,
    super.key,
  });

  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SelectableText(
            value,
            style: TextStyle(
              color: theme.colorScheme.hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
