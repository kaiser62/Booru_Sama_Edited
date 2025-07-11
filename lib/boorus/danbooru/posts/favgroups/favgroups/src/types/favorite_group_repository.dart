// Project imports:
import 'danbooru_favorite_group.dart';

abstract class FavoriteGroupRepository {
  Future<List<DanbooruFavoriteGroup>> getFavoriteGroupsByCreatorName({
    required String name,
    int? page,
  });

  Future<bool> createFavoriteGroup({
    required String name,
    List<int>? initialItems,
    bool isPrivate = false,
  });

  Future<bool> editFavoriteGroup({
    required int id,
    String? name,
    List<int>? itemIds,
    bool isPrivate = false,
  });

  Future<bool> deleteFavoriteGroup({
    required int id,
  });

  Future<bool> addItemsToFavoriteGroup({
    required int id,
    required List<int> itemIds,
  });

  Future<bool> removeItemsFromFavoriteGroup({
    required int id,
    required List<int> itemIds,
  });
}
