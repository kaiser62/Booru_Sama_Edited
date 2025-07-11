// Project imports:
import 'types.dart';

class AutocompleteDto {
  const AutocompleteDto({
    this.t,
    this.t2,
    this.c,
    this.id,
  });

  factory AutocompleteDto.fromJson(Map<String, dynamic> json) {
    final tag = json['t'] as String?;
    final tag2 = json['t2'] as String?;
    final cleanTag = stripBoldHtmlTags(tag);
    final cleanTag2 = stripBoldHtmlTags(tag2);

    return AutocompleteDto(
      t: cleanTag,
      t2: cleanTag2,
      c: tagTypeFromInt(json['c']),
      id: json['id'],
    );
  }

  final String? t;
  final String? t2;
  final AnimePicturesTagType? c;
  final int? id;
}

String? stripBoldHtmlTags(String? input) {
  if (input == null) return null;

  final decoded = input.replaceAll(r'\u003C', '<').replaceAll(r'\u003E', '>');

  final stripped = decoded.replaceAll(RegExp(r'<\/?b>'), '');

  return stripped;
}
