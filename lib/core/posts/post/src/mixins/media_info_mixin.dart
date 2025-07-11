// Project imports:
import 'video_info_mixin.dart';

mixin MediaInfoMixin {
  String get format;
  String get md5;
  int get fileSize;

  bool get isVideo => isFormatVideo(format);

  bool get isAnimated => isAnimatedFormat(format);
}

bool isAnimatedFormat(String? format) {
  return isFormatVideo(format) || format == 'gif' || format == '.gif';
}
