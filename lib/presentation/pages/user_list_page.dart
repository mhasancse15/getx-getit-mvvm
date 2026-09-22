import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/user_controller.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/user_card.dart';

class UserListPage extends GetView<UserController> {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.products);
            },
            icon: const Icon(Icons.propane_tank_outlined),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: controller.searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => controller.submitSearch(),
              decoration: InputDecoration(
                hintText: 'Search by name, username, or email',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: Obx(
                      () => controller.searchQuery.value.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                        onPressed: controller.clearSearch,
                    icon: const Icon(Icons.clear_rounded),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.users.isEmpty) {
                return const LoadingWidget();
              }
              if (controller.users.isEmpty &&
                  controller.errorMessage.value.isNotEmpty) {
                return AppErrorWidget(onRetry: controller.fetchUsers);
              }
              if (controller.filteredUsers.isEmpty) {
                return const EmptyWidget();
              }

              final displayedUsers = controller.filteredUsers;
              return RefreshIndicator(
                onRefresh: controller.refreshUsers,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 300) {
                      controller.loadMoreUsers();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    itemCount: displayedUsers.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= displayedUsers.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final user = displayedUsers[index];
                      return UserCard(
                        user: user,
                        onTap: () =>
                            Get.toNamed('${AppRoutes.users}/${user.id}'),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
