class PostDto {
  PostDto({
    this.id,
    this.width,
    this.height,
    this.md5,
    this.thumbnail,
    this.source,
    this.tag,
    this.tags,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      md5: json['md5'],
      thumbnail: json['thumbnail'],
      source: json['source'],
      tag: json['tag'],
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }
  final int? id;
  final int? width;
  final int? height;
  final String? md5;
  final String? thumbnail;
  final String? source;
  final String? tag;
  final List<String>? tags;

  @override
  String toString() => id.toString();
}

extension PostDtoX on PostDto {
  String? fileUrl() => thumbnail
      ?.replaceAll(RegExp(r'/s\d+\.zerochan'), '/static.zerochan')
      .replaceAll('.240.', '.full.')
      .replaceAll('.600.', '.full.')
      .replaceAll('/240/', '/full/')
      .replaceAll('/600/', '/full/');

  String? sampleUrl() => thumbnail
      ?.replaceAll(RegExp(r'/s\d+\.zerochan'), '/s3.zerochan')
      .replaceAll('.240.', '.600.')
      .replaceAll('/240/', '/600/');
}
