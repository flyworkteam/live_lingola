import '../../Models/Translation/translation_history_item_model.dart';
import '../../Services/Translation/translation_history_service.dart';
import 'translation_history_repository.dart';

class MockTranslationHistoryRepository implements TranslationHistoryRepository {
  final TranslationHistoryService service;

  MockTranslationHistoryRepository({
    required this.service,
  });

  @override
  Future<List<TranslationHistoryItemModel>> getHistory() {
    return service.getHistory();
  }

  @override
  Future<List<TranslationHistoryItemModel>> getFavorites() {
    return service.getFavorites();
  }

  @override
  Future<TranslationHistoryItemModel> saveHistoryItem({
    required TranslationHistoryItemModel item,
  }) {
    return service.saveHistoryItem(item: item);
  }

  @override
  Future<void> deleteHistoryItem({required String id}) {
    return service.deleteHistoryItem(id: id);
  }

  @override
  Future<void> clearHistory() {
    return service.clearHistory();
  }

  @override
  Future<void> clearFavorites() {
    return service.clearFavorites();
  }

  @override
  Future<TranslationHistoryItemModel> updateFavoriteStatus({
    required String id,
    required bool isFavorite,
  }) {
    return service.updateFavoriteStatus(id: id, isFavorite: isFavorite);
  }
}
