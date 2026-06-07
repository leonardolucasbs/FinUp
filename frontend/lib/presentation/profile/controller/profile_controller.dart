import 'package:flutter/foundation.dart';
import 'package:frontend/data/models/app_user.dart';
import 'package:frontend/data/models/content_model.dart';
import 'package:frontend/data/services/content_service.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({
    required AppUser user,
    required ContentService contentService,
  })  : _user = user,
        _contentService = contentService;

  AppUser _user;
  final ContentService _contentService;

  List<ContentModel> posts = const [];
  Set<int> deletingPostIds = const {};
  bool isLoadingPosts = false;
  String? postsError;
  String? submissionErrorMessage;

  AppUser get user => _user;

  void updateUser(AppUser user) {
    _user = user;
    notifyListeners();
  }

  bool isDeletingPost(int postId) {
    return deletingPostIds.contains(postId);
  }

  Future<void> loadPosts() async {
    isLoadingPosts = true;
    postsError = null;
    notifyListeners();

    try {
      posts = await _contentService.findContentsByUser(_user.id);
    } catch (error) {
      postsError = _messageFromError(error);
    } finally {
      isLoadingPosts = false;
      notifyListeners();
    }
  }

  Future<bool> deletePost(ContentModel post) async {
    if (post.userId != _user.id || isDeletingPost(post.id)) {
      return false;
    }

    deletingPostIds = Set<int>.from(deletingPostIds)..add(post.id);
    submissionErrorMessage = null;
    notifyListeners();

    try {
      await _contentService.deleteContent(post.id);
      posts = posts.where((item) => item.id != post.id).toList(growable: false);
      notifyListeners();
      return true;
    } catch (error) {
      submissionErrorMessage = _messageFromError(error);
      notifyListeners();
      return false;
    } finally {
      deletingPostIds = Set<int>.from(deletingPostIds)..remove(post.id);
      notifyListeners();
    }
  }

  String _messageFromError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();
    if (message.isNotEmpty) return message;
    return 'Nao foi possivel concluir a requisicao.';
  }
}
