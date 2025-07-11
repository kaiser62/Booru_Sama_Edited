// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../rating/rating.dart';
import '../../../sources/source.dart';
import '../mixins/image_info_mixin.dart';
import '../mixins/media_info_mixin.dart';
import '../mixins/video_info_mixin.dart';

class PostMetadata extends Equatable {
  const PostMetadata({
    this.page,
    this.search,
    this.limit,
  });
  final int? page;
  final String? search;
  final int? limit;

  @override
  List<Object?> get props => [page, search, limit];
}

abstract class Post
    with MediaInfoMixin, ImageInfoMixin, VideoInfoMixin
    implements TagDetails {
  int get id;
  DateTime? get createdAt;
  String get thumbnailImageUrl;
  String get sampleImageUrl;
  String get originalImageUrl;
  Set<String> get tags;
  Rating get rating;
  bool get hasComment;
  bool get isTranslated;
  bool get hasParentOrChildren;
  int? get parentId;
  PostSource get source;
  int get score;
  int? get downvotes;
  int? get uploaderId;
  String? get uploaderName;

  PostMetadata? get metadata;
}

abstract interface class TagDetails {
  Set<String>? get artistTags;
  Set<String>? get characterTags;
  Set<String>? get copyrightTags;
}

extension PostImageX on Post {
  bool get hasFullView => originalImageUrl.isNotEmpty && !isVideo;

  bool get hasNoImage =>
      thumbnailImageUrl.isEmpty &&
      sampleImageUrl.isEmpty &&
      originalImageUrl.isEmpty;

  bool get hasParent => parentId != null && parentId! > 0;
}

extension PostX on Post {
  String get relationshipQuery => hasParent ? 'parent:$parentId' : 'parent:$id';
}

// We should use start using the PostId class instead of int
sealed class PostId {
  const PostId();

  static PostId from(String value) {
    if (int.tryParse(value) != null) {
      return NumericPostId(int.parse(value));
    } else {
      return StringPostId(value);
    }
  }
}

class NumericPostId extends PostId with EquatableMixin {
  const NumericPostId(this.value);

  final int value;

  @override
  String toString() => value.toString();

  @override
  List<Object?> get props => [value];
}

class StringPostId extends PostId with EquatableMixin {
  const StringPostId(this.value);

  final String value;

  @override
  String toString() => value;

  @override
  List<Object?> get props => [value];
}
