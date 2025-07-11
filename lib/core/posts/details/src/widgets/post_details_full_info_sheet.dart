// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foundation/widgets.dart';

// Project imports:
import '../../../../boorus/engine/engine.dart';
import '../../../../boorus/engine/providers.dart';
import '../../../../configs/ref.dart';
import '../../../details_manager/types.dart';
import '../../../details_manager/widgets.dart';
import '../../../details_pageview/widgets.dart';

class PostDetailsFullInfoSheet extends ConsumerWidget {
  const PostDetailsFullInfoSheet({
    required this.sheetState,
    required this.uiBuilder,
    required this.preferredParts,
    super.key,
    this.scrollController,
    this.canCustomize = true,
  });

  final ScrollController? scrollController;
  final SheetState sheetState;
  final PostDetailsUIBuilder? uiBuilder;
  final Set<DetailsPart>? preferredParts;
  final bool canCustomize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parts = preferredParts;
    final booruBuilder = ref.watch(booruBuilderProvider(ref.watchConfigAuth));
    final builder = uiBuilder ?? booruBuilder?.postDetailsUIBuilder;

    if (builder == null || parts == null) {
      return RawPostDetailsInfoSheet(
        scrollController: scrollController,
        preview: DefaultPostDetailsInfoPreview(
          scrollController: scrollController,
        ),
        slivers: [
          const SliverSizedBox(height: 12),
          SliverOffstage(
            offstage: sheetState == SheetState.hidden,
            sliver: const SliverToBoxAdapter(
              child: Center(
                child: Text('No widgets to display'),
              ),
            ),
          ),
          SliverSizedBox(
            height: MediaQuery.paddingOf(context).bottom + 72,
          ),
        ],
        sheetState: sheetState,
      );
    }

    return RawPostDetailsInfoSheet(
      scrollController: scrollController,
      preview: DefaultPostDetailsInfoPreview(
        scrollController: scrollController,
      ),
      slivers: [
        ...parts
            .map(
              (p) => builder.buildPart(context, p),
            )
            .nonNulls,
        const SliverSizedBox(height: 12),
        if (canCustomize)
          const SliverToBoxAdapter(
            child: AddCustomDetailsButton(),
          ),
      ],
      sheetState: sheetState,
    );
  }
}

class RawPostDetailsInfoSheet extends StatelessWidget {
  const RawPostDetailsInfoSheet({
    required this.scrollController,
    required this.preview,
    required this.slivers,
    required this.sheetState,
    super.key,
  });

  final ScrollController? scrollController;
  final Widget preview;
  final List<Widget> slivers;

  final SheetState sheetState;

  @override
  Widget build(BuildContext context) {
    if (sheetState == SheetState.collapsed) {
      return preview;
    }

    return ScrollConfiguration(
      // We need the overscroll notifications for closing/collapsing the sheet
      behavior: const MaterialScrollBehavior(),
      child: LayoutBuilder(
        builder: (context, constraints) => PostDetailsSheetConstraints(
          maxWidth: constraints.maxWidth,
          child: CustomScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            slivers: [
              const SliverSizedBox(height: 16),
              ...slivers,
              SliverSizedBox(
                height: MediaQuery.paddingOf(context).bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostDetailsSheetConstraints extends InheritedWidget {
  const PostDetailsSheetConstraints({
    required this.maxWidth,
    required super.child,
    super.key,
  });

  static PostDetailsSheetConstraints? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PostDetailsSheetConstraints>();
  }

  final double maxWidth;

  @override
  bool updateShouldNotify(covariant PostDetailsSheetConstraints oldWidget) {
    return maxWidth != oldWidget.maxWidth;
  }
}

class DefaultPostDetailsInfoPreview extends StatelessWidget {
  const DefaultPostDetailsInfoPreview({
    super.key,
    this.scrollController,
  });

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          const SliverSizedBox(height: 12),
          SliverSizedBox(
            height: MediaQuery.paddingOf(context).bottom + 72,
          ),
        ],
      ),
    );
  }
}
