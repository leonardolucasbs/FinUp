import 'package:flutter/foundation.dart';
import 'package:frontend/data/models/app_user.dart';
import 'package:frontend/data/models/course_model.dart';
import 'package:frontend/data/models/subscription_model.dart';
import 'package:frontend/data/services/course_service.dart';
import 'package:frontend/data/services/subscription_service.dart';

class CourseController extends ChangeNotifier {
  CourseController({
    required this.user,
    required CourseService courseService,
    required SubscriptionService subscriptionService,
    bool initialShowOnlyMyCourses = false,
  })  : _courseService = courseService,
        _subscriptionService = subscriptionService,
        showOnlyMyCourses = initialShowOnlyMyCourses;

  final AppUser user;
  final CourseService _courseService;
  final SubscriptionService _subscriptionService;

  List<CourseModel> courses = const [];
  List<SubscriptionModel> subscriptions = const [];
  Map<int, int> subscriptionIdsByCourse = const {};
  Set<int> updatingCourseIds = const {};
  bool isLoading = false;
  bool showOnlyMyCourses;
  String searchTerm = '';
  String? errorMessage;
  String? submissionErrorMessage;

  List<CourseModel> get filteredCourses {
    final term = searchTerm.trim().toLowerCase();
    Iterable<CourseModel> result = courses;

    if (showOnlyMyCourses) {
      result = result.where((course) => isSubscribed(course.id));
    }

    if (term.isNotEmpty) {
      result = result.where((course) {
        return course.title.toLowerCase().contains(term) ||
            course.description.toLowerCase().contains(term) ||
            course.teacher.toLowerCase().contains(term);
      });
    }

    return result.toList(growable: false);
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _courseService.findAllCourses(),
        _subscriptionService.findAllSubscriptions(),
      ]);

      courses = results[0] as List<CourseModel>;
      subscriptions = results[1] as List<SubscriptionModel>;
      _syncSubscriptionMap();
    } catch (error) {
      errorMessage = _messageFromError(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSearchTerm(String value) {
    searchTerm = value;
    notifyListeners();
  }

  void setShowOnlyMyCourses(bool value) {
    showOnlyMyCourses = value;
    notifyListeners();
  }

  bool isSubscribed(int courseId) {
    return subscriptionIdsByCourse.containsKey(courseId);
  }

  bool isUpdatingCourse(int courseId) {
    return updatingCourseIds.contains(courseId);
  }

  Future<bool> toggleSubscription(CourseModel course) {
    return isSubscribed(course.id)
        ? unsubscribeFromCourse(course)
        : subscribeToCourse(course);
  }

  Future<bool> subscribeToCourse(CourseModel course) async {
    if (isSubscribed(course.id) || isUpdatingCourse(course.id)) {
      return false;
    }

    updatingCourseIds = Set<int>.from(updatingCourseIds)..add(course.id);
    submissionErrorMessage = null;
    notifyListeners();

    try {
      final subscription = await _subscriptionService.createSubscription(
        CreateSubscriptionRequest(userId: user.id, courseId: course.id),
      );
      subscriptions = [
        ...subscriptions.where((item) {
          return item.userId != user.id || item.courseId != course.id;
        }),
        subscription,
      ];
      subscriptionIdsByCourse = Map<int, int>.from(subscriptionIdsByCourse)
        ..[course.id] = subscription.id;
      notifyListeners();
      return true;
    } catch (error) {
      submissionErrorMessage = _messageFromError(error);
      notifyListeners();
      return false;
    } finally {
      updatingCourseIds = Set<int>.from(updatingCourseIds)..remove(course.id);
      notifyListeners();
    }
  }

  Future<bool> unsubscribeFromCourse(CourseModel course) async {
    if (!isSubscribed(course.id) || isUpdatingCourse(course.id)) {
      return false;
    }

    updatingCourseIds = Set<int>.from(updatingCourseIds)..add(course.id);
    submissionErrorMessage = null;
    notifyListeners();

    try {
      final subscriptionId = await _subscriptionIdFor(course.id);
      if (subscriptionId == null) {
        submissionErrorMessage = 'Nao foi possivel localizar a inscricao.';
        notifyListeners();
        return false;
      }

      await _subscriptionService.deleteSubscription(subscriptionId);
      subscriptions = subscriptions
          .where((subscription) => subscription.id != subscriptionId)
          .toList(growable: false);
      subscriptionIdsByCourse = Map<int, int>.from(subscriptionIdsByCourse)
        ..remove(course.id);
      notifyListeners();
      return true;
    } catch (error) {
      submissionErrorMessage = _messageFromError(error);
      notifyListeners();
      return false;
    } finally {
      updatingCourseIds = Set<int>.from(updatingCourseIds)..remove(course.id);
      notifyListeners();
    }
  }

  Future<int?> _subscriptionIdFor(int courseId) async {
    final existingId = subscriptionIdsByCourse[courseId];
    if (existingId != null) return existingId;

    final loaded = await _subscriptionService.findAllSubscriptions();
    subscriptions = loaded;
    _syncSubscriptionMap();
    return subscriptionIdsByCourse[courseId];
  }

  void _syncSubscriptionMap() {
    final nextMap = <int, int>{};
    for (final subscription in subscriptions) {
      if (subscription.userId == user.id && subscription.isActive) {
        nextMap[subscription.courseId] = subscription.id;
      }
    }
    subscriptionIdsByCourse = nextMap;
  }

  String _messageFromError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();
    if (message.isNotEmpty) return message;
    return 'Nao foi possivel concluir a requisicao.';
  }
}
