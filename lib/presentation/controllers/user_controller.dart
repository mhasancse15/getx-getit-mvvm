import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/user/user.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/search_user.dart';

final class UserController extends GetxController {
  UserController(this._getUsers, this._searchUsersUseCase);

  final GetUsers _getUsers;
  final SearchUsers _searchUsersUseCase;

  final RxList<User> users = <User>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  Worker? _searchDebounceWorker;

  int skip = 0;
  final int limit = AppConstants.pageSize;
  int total = 0;
  bool hasMore = true;
  String _lastExecutedQuery = '';

  bool get _isSearchMode => searchQuery.value.trim().isNotEmpty;

  List<User> get filteredUsers {
    return users.toList(growable: false);
  }

  @override
  void onInit() {
    super.onInit();
    _searchDebounceWorker = debounce<String>(
      searchQuery,
      (_) => _searchUsers(searchQuery.value),
      time: const Duration(milliseconds: 600),
    );
    fetchUsers();
  }

  @override
  void onClose() {
    _searchDebounceWorker?.dispose();
    super.onClose();
  }

  Future<void> fetchUsers() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';
    skip = 0;
    total = 0;
    hasMore = true;
    users.clear();

    final result = await _getUsers(limit: limit, skip: skip);
    result.fold(_setError, _appendPage);
    isLoading.value = false;
  }

  Future<void> refreshUsers() async {
    if (isRefreshing.value) return;

    isRefreshing.value = true;
    errorMessage.value = '';
    skip = 0;
    total = 0;
    hasMore = true;

    final result = await _getUsers(limit: limit, skip: skip);
    result.fold(_setError, (page) {
      users
        ..clear()
        ..addAll(page.users);
      total = page.total;
      skip = page.users.length;
      hasMore = users.length < total;
    });
    isRefreshing.value = false;
  }

  Future<void> loadMoreUsers() async {
    if (isLoading.value ||
        isRefreshing.value ||
        isLoadingMore.value ||
        !hasMore) {
      return;
    }

    isLoadingMore.value = true;
    final result = _isSearchMode
        ? await _searchUsersUseCase(
            query: searchQuery.value.trim(),
            limit: limit,
            skip: skip,
          )
        : await _getUsers(limit: limit, skip: skip);
    result.fold(_setError, _appendPage);
    isLoadingMore.value = false;
  }

  User? findById(int id) {
    for (final user in users) {
      if (user.id == id) return user;
    }
    return null;
  }

  Future<void> submitSearch() async {
    if (isLoading.value || isRefreshing.value || isLoadingMore.value) return;
    final query = searchController.text.trim();
    if (query == searchQuery.value &&
        query == _lastExecutedQuery) {
      return;
    }

    searchQuery.value = query;
    await _searchUsers(query);
  }

  void onSearchChanged(String value) {
    searchQuery.value = value.trim();
  }

  Future<void> clearSearch() async {
    searchController.clear();
    searchQuery.value = '';
  }

  Future<void> _searchUsers(String query) async {
    if (isLoading.value || isRefreshing.value) return;
    if (query == _lastExecutedQuery) return;
    isLoading.value = true;
    errorMessage.value = '';
    skip = 0;
    total = 0;
    hasMore = true;
    users.clear();

    final result = query.isEmpty
        ? await _getUsers(limit: limit, skip: skip)
        : await _getUsers.search(query: query, limit: limit, skip: skip);

    result.fold(_setError, _appendPage);
    _lastExecutedQuery = query;
    isLoading.value = false;
  }

  void _appendPage(UsersPage page) {
    final existingIds = users.map((user) => user.id).toSet();
    users.addAll(page.users.where((user) => !existingIds.contains(user.id)));
    total = page.total;
    skip += page.users.length;
    hasMore = users.length < total && page.users.isNotEmpty;
    errorMessage.value = '';
  }

  void _setError(failure) {
    errorMessage.value = failure.message;
    AppLogger.error('Unable to load users', failure);
  }
}
