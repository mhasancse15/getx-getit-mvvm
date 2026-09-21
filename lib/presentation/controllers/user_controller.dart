import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';

final class UserController extends GetxController {
  UserController(this._getUsers);

  final GetUsers _getUsers;
  final RxList<User> users = <User>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  int skip = 0;
  final int limit = AppConstants.pageSize;
  int total = 0;
  bool hasMore = true;

  List<User> get filteredUsers {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return users.toList(growable: false);

    return users
        .where(
          (user) => user.firstName.toLowerCase().contains(query) ||
              user.lastName.toLowerCase().contains(query) ||
              user.username.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    fetchUsers();
  }

  @override
  void onClose() {
    searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
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
    if (isLoading.value || isRefreshing.value || isLoadingMore.value || !hasMore) {
      return;
    }

    isLoadingMore.value = true;
    final result = await _getUsers(limit: limit, skip: skip);
    result.fold(_setError, _appendPage);
    isLoadingMore.value = false;
  }

  User? findById(int id) {
    for (final user in users) {
      if (user.id == id) return user;
    }
    return null;
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
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
