// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../../../users/creator/creator.dart';

class DanbooruFavoriteGroup extends Equatable {
  const DanbooruFavoriteGroup({
    required this.id,
    required this.name,
    required this.creator,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublic,
    required this.postIds,
  });

  final int id;
  final String name;
  final Creator creator;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublic;
  final List<int> postIds;

  @override
  List<Object?> get props => [id, name, updatedAt, isPublic, postIds];
}

extension FavoriteGroupX on DanbooruFavoriteGroup {
  DanbooruFavoriteGroup copyWith({
    String? name,
    bool? isPublic,
    List<int>? postIds,
  }) => DanbooruFavoriteGroup(
    id: id,
    name: name ?? this.name,
    creator: creator,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isPublic: isPublic ?? this.isPublic,
    postIds: postIds ?? this.postIds,
  );

  int get totalCount => postIds.length;
  String getQueryString() => 'favgroup:$id';
}
