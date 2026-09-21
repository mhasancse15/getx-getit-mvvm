import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../widgets/empty_widget.dart';

class UserDetailsPage extends GetView<UserController> {
  const UserDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(Get.parameters['id'] ?? '');
    final user = id == null ? null : controller.findById(id);

    if (user == null) {
      return const Scaffold(body: EmptyWidget(message: 'User details are unavailable.'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('User details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          children: <Widget>[
            Hero(
              tag: 'user-avatar-${user.id}',
              child: CircleAvatar(
                radius: 56,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundImage: user.image.isEmpty ? null : NetworkImage(user.image),
                child: user.image.isEmpty ? Text(user.firstName[0], style: const TextStyle(fontSize: 32)) : null,
              ),
            ),
            const SizedBox(height: 14),
            Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('@${user.username}', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 24),
            _DetailsSection(
              title: 'Contact',
              icon: Icons.contact_page_outlined,
              rows: <MapEntry<String, String>>[
                MapEntry<String, String>('Email', user.email),
                MapEntry<String, String>('Phone', user.phone),
              ],
            ),
            _DetailsSection(
              title: 'Personal information',
              icon: Icons.person_outline_rounded,
              rows: <MapEntry<String, String>>[
                MapEntry<String, String>('Age', '${user.age}'),
                MapEntry<String, String>('Gender', user.gender),
                MapEntry<String, String>('Birth date', user.birthDate),
                MapEntry<String, String>('Height', '${user.height} m'),
                MapEntry<String, String>('Weight', '${user.weight} kg'),
                MapEntry<String, String>('Blood group', user.bloodGroup),
                MapEntry<String, String>('Eye color', user.eyeColor),
              ],
            ),
            _DetailsSection(
              title: 'Address',
              icon: Icons.location_on_outlined,
              rows: <MapEntry<String, String>>[
                MapEntry<String, String>('Address', user.address.displayValue),
              ],
            ),
            _DetailsSection(
              title: 'Company',
              icon: Icons.business_outlined,
              rows: <MapEntry<String, String>>[
                MapEntry<String, String>('Company', user.company.name),
                MapEntry<String, String>('Title', user.company.title),
                MapEntry<String, String>('Department', user.company.department),
                MapEntry<String, String>('Role', user.role),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.title, required this.icon, required this.rows});

  final String title;
  final IconData icon;
  final List<MapEntry<String, String>> rows;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 100, child: Text(row.key, style: TextStyle(color: Colors.grey.shade600))),
                    Expanded(child: Text(row.value.isEmpty ? '—' : row.value)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
