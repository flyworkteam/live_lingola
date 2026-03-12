import '../../Models/Translation/translation_history_item_model.dart';

abstract class TranslationHistoryService {
  Future<List<TranslationHistoryItemModel>> getHistory();
  Future<List<TranslationHistoryItemModel>> getFavorites();

  Future<TranslationHistoryItemModel> saveHistoryItem({
    required TranslationHistoryItemModel item,
  });

  Future<void> deleteHistoryItem({
    required String id,
  });

  Future<void> clearHistory();

  Future<void> clearFavorites();

  Future<TranslationHistoryItemModel> updateFavoriteStatus({
    required String id,
    required bool isFavorite,
  });
}
