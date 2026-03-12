import '../../Models/Translation/translation_history_item_model.dart';
import 'translation_history_service.dart';

class MockTranslationHistoryService implements TranslationHistoryService {
  final List<TranslationHistoryItemModel> _items = [];

  @override
  Future<List<TranslationHistoryItemModel>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List<TranslationHistoryItemModel>.from(_items)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<TranslationHistoryItemModel>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _items.where((e) => e.isFavorite).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<TranslationHistoryItemModel> saveHistoryItem({
    required TranslationHistoryItemModel item,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _items.insert(0, item);
    return item;
  }

  @override
  Future<void> deleteHistoryItem({required String id}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _items.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> clearHistory() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _items.clear();
  }

  @override
  Future<void> clearFavorites() async {
    await Future.delayed(const Duration(milliseconds: 100));
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isFavorite: false);
    }
  }

  @override
  Future<TranslationHistoryItemModel> updateFavoriteStatus({
    required String id,
    required bool isFavorite,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) {
      throw Exception('History item not found');
    }

    final updated = _items[index].copyWith(isFavorite: isFavorite);
    _items[index] = updated;
    return updated;
  }
}
