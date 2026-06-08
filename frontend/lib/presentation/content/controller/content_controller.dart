import 'package:flutter/foundation.dart';

import 'package:frontend/data/models/app_user.dart';
import 'package:frontend/data/models/content_model.dart';
import 'package:frontend/data/services/content_service.dart';
import 'package:frontend/data/services/saved_content_service.dart';

class ContentController extends ChangeNotifier {
  ContentController({
    required this.user,
    required ContentService contentService,
    required SavedContentService savedContentService,
  })  : _contentService = contentService,
        _savedContentService = savedContentService;

  final AppUser user;
  final ContentService _contentService;
  final SavedContentService _savedContentService;

  List<ContentModel> contents = const [];
  Map<int, int> saveCounts = const {};
  Map<int, bool> savedByCurrentUser = const {};
  Map<int, int> savedContentIds = const {};
  Set<int> savingContentIds = const {};
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;
  String? submissionErrorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      contents = await _contentService.findAllContents();
      await Future.wait([
        loadSaveCounts(force: true),
        loadSavedStatuses(force: true),
      ]);
    } catch (error) {
      errorMessage = _messageFromError(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSaveCounts({bool force = false}) async {
    final contentIds = contents.map((content) => content.id).toSet();
    final nextSaveCounts = Map<int, int>.from(saveCounts)
      ..removeWhere((contentId, _) => !contentIds.contains(contentId));

    final idsToLoad = contentIds.where(
      (contentId) => force || !nextSaveCounts.containsKey(contentId),
    );

    if (idsToLoad.isEmpty) {
      saveCounts = nextSaveCounts;
      return;
    }

    final entries = await Future.wait(
      idsToLoad.map((contentId) async {
        try {
          final count = await _savedContentService.findSaveCountByContentId(
            contentId,
          );
          return MapEntry(contentId, count);
        } catch (_) {
          return MapEntry(contentId, nextSaveCounts[contentId] ?? 0);
        }
      }),
    );

    for (final entry in entries) {
      nextSaveCounts[entry.key] = entry.value;
    }
    saveCounts = nextSaveCounts;
  }

  int saveCountFor(int contentId) {
    return saveCounts[contentId] ?? 0;
  }

  Future<void> loadSavedStatuses({bool force = false}) async {
    final contentIds = contents.map((content) => content.id).toSet();
    final nextSavedStatuses = Map<int, bool>.from(savedByCurrentUser)
      ..removeWhere((contentId, _) => !contentIds.contains(contentId));
    final nextSavedContentIds = Map<int, int>.from(savedContentIds)
      ..removeWhere((contentId, _) => !contentIds.contains(contentId));

    final idsToLoad = contentIds.where(
      (contentId) => force || !nextSavedStatuses.containsKey(contentId),
    );

    if (idsToLoad.isEmpty) {
      savedByCurrentUser = nextSavedStatuses;
      savedContentIds = nextSavedContentIds;
      return;
    }

    final entries = await Future.wait(
      idsToLoad.map((contentId) async {
        try {
          final hasSaved = await _savedContentService.hasUserSavedContent(
            contentId,
            user.id,
          );
          int? savedContentId = nextSavedContentIds[contentId];
          if (hasSaved && savedContentId == null) {
            final savedContent = await _savedContentService
                .findSavedContentByUserAndContent(
                  userId: user.id,
                  contentId: contentId,
                );
            savedContentId = savedContent?.id;
          }
          return _SavedStatusLoadResult(
            contentId: contentId,
            isSaved: hasSaved,
            savedContentId: savedContentId,
          );
        } catch (_) {
          return _SavedStatusLoadResult(
            contentId: contentId,
            isSaved: nextSavedStatuses[contentId] ?? false,
            savedContentId: nextSavedContentIds[contentId],
          );
        }
      }),
    );

    for (final entry in entries) {
      nextSavedStatuses[entry.contentId] = entry.isSaved;
      if (entry.savedContentId == null) {
        nextSavedContentIds.remove(entry.contentId);
      } else {
        nextSavedContentIds[entry.contentId] = entry.savedContentId!;
      }
    }
    savedByCurrentUser = nextSavedStatuses;
    savedContentIds = nextSavedContentIds;
  }

  bool hasUserSaved(int contentId) {
    return savedByCurrentUser[contentId] ?? false;
  }

  bool isSavingContent(int contentId) {
    return savingContentIds.contains(contentId);
  }

  bool isOwner(ContentModel content) {
    return content.userId == user.id;
  }

  Future<bool> createContent({
    required String title,
    required String description,
    required String type,
    String? imageUrl,
  }) async {
    isSubmitting = true;
    submissionErrorMessage = null;
    notifyListeners();

    try {
      await _contentService.createContent(
        CreateContentRequest(
          title: title,
          description: description,
          type: type,
          userId: user.id,
          imageUrl: imageUrl == null || imageUrl.trim().isEmpty
              ? null
              : imageUrl.trim(),
        ),
      );
      await load();
      return true;
    } catch (error) {
      submissionErrorMessage = _messageFromError(error);
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> updateContent({
    required ContentModel content,
    required String title,
    required String description,
    required String type,
    String? imageUrl,
  }) async {
    if (!isOwner(content)) {
      submissionErrorMessage = 'Apenas o autor pode editar este conteudo.';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    submissionErrorMessage = null;
    notifyListeners();

    try {
      await _contentService.updateContent(
        content.id,
        UpdateContentRequest(
          title: title,
          description: description,
          type: type,
          imageUrl: imageUrl == null || imageUrl.trim().isEmpty
              ? null
              : imageUrl.trim(),
        ),
      );
      await load();
      return true;
    } catch (error) {
      submissionErrorMessage = _messageFromError(error);
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deleteContent(ContentModel content) async {
    if (!isOwner(content)) {
      submissionErrorMessage = 'Apenas o autor pode excluir este conteudo.';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    submissionErrorMessage = null;
    notifyListeners();

    try {
      await _contentService.deleteContent(content.id);
      contents = contents
          .where((item) => item.id != content.id)
          .toList(growable: false);
      saveCounts = Map<int, int>.from(saveCounts)..remove(content.id);
      savedByCurrentUser = Map<int, bool>.from(savedByCurrentUser)
        ..remove(content.id);
      savedContentIds = Map<int, int>.from(savedContentIds)..remove(content.id);
      savingContentIds = Set<int>.from(savingContentIds)..remove(content.id);
      notifyListeners();
      await load();
      return true;
    } catch (error) {
      submissionErrorMessage = _messageFromError(error);
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> saveContent(ContentModel content) async {
    if (isOwner(content)) {
      submissionErrorMessage = 'Voce nao pode salvar seu proprio conteudo.';
      notifyListeners();
      return false;
    }
    if (hasUserSaved(content.id) || isSavingContent(content.id)) {
      return false;
    }

    savingContentIds = Set<int>.from(savingContentIds)..add(content.id);
    submissionErrorMessage = null;
    notifyListeners();

    try {
      final savedContent = await _savedContentService.createSavedContent(
        CreateSavedContentRequest(
          userId: user.id,
          contentId: content.id,
        ),
      );
      savedByCurrentUser = Map<int, bool>.from(savedByCurrentUser)
        ..[content.id] = true;
      savedContentIds = Map<int, int>.from(savedContentIds)
        ..[content.id] = savedContent.id;
      saveCounts = Map<int, int>.from(saveCounts)
        ..[content.id] = saveCountFor(content.id) + 1;
      notifyListeners();
      await refreshSaveCount(content.id);
      notifyListeners();
      return true;
    } catch (error) {
      submissionErrorMessage = _messageFromError(error);
      notifyListeners();
      return false;
    } finally {
      savingContentIds = Set<int>.from(savingContentIds)..remove(content.id);
      notifyListeners();
    }
  }

  Future<bool> unsaveContent(ContentModel content) async {
    if (isOwner(content)) {
      submissionErrorMessage = 'Voce nao pode desmarcar seu proprio conteudo.';
      notifyListeners();
      return false;
    }
    if (!hasUserSaved(content.id) || isSavingContent(content.id)) {
      return false;
    }

    savingContentIds = Set<int>.from(savingContentIds)..add(content.id);
    submissionErrorMessage = null;
    notifyListeners();

    try {
      final savedContentId = await _savedContentIdFor(content.id);
      if (savedContentId == null) {
        submissionErrorMessage = 'Nao foi possivel localizar o conteudo salvo.';
        notifyListeners();
        return false;
      }

      await _savedContentService.deleteSavedContent(savedContentId);
      savedByCurrentUser = Map<int, bool>.from(savedByCurrentUser)
        ..[content.id] = false;
      savedContentIds = Map<int, int>.from(savedContentIds)..remove(content.id);
      saveCounts = Map<int, int>.from(saveCounts)
        ..[content.id] = saveCountFor(content.id) > 0
            ? saveCountFor(content.id) - 1
            : 0;
      notifyListeners();
      await refreshSaveCount(content.id);
      notifyListeners();
      return true;
    } catch (error) {
      submissionErrorMessage = _messageFromError(error);
      notifyListeners();
      return false;
    } finally {
      savingContentIds = Set<int>.from(savingContentIds)..remove(content.id);
      notifyListeners();
    }
  }

  Future<bool> toggleSaved(ContentModel content) {
    return hasUserSaved(content.id)
        ? unsaveContent(content)
        : saveContent(content);
  }

  Future<void> refreshSaveCount(int contentId) async {
    try {
      final count = await _savedContentService.findSaveCountByContentId(
        contentId,
      );
      saveCounts = Map<int, int>.from(saveCounts)..[contentId] = count;
    } catch (_) {
      return;
    }
  }

  Future<int?> _savedContentIdFor(int contentId) async {
    final existingId = savedContentIds[contentId];
    if (existingId != null) return existingId;

    final savedContent = await _savedContentService
        .findSavedContentByUserAndContent(
          userId: user.id,
          contentId: contentId,
        );
    if (savedContent == null) return null;

    savedContentIds = Map<int, int>.from(savedContentIds)
      ..[contentId] = savedContent.id;
    return savedContent.id;
  }

  String _messageFromError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();
    if (message.isNotEmpty) return message;
    return 'Nao foi possivel concluir a requisicao.';
  }
}

class _SavedStatusLoadResult {
  const _SavedStatusLoadResult({
    required this.contentId,
    required this.isSaved,
    required this.savedContentId,
  });

  final int contentId;
  final bool isSaved;
  final int? savedContentId;
}
