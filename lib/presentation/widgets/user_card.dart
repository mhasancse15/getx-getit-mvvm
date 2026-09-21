import 'package:flutter/material.dart';

import '../../domain/entities/user/user.dart';

class UserCard extends StatelessWidget {
  const UserCard({required this.user, required this.onTap, super.key});

  final User user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: 'user-avatar-${user.id}',
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  backgroundImage: user.image.isEmpty ? null : NetworkImage(user.image),
                  child: user.image.isEmpty
                      ? Text(user.firstName.isEmpty ? '?' : user.firstName[0])
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(user.fullName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text('@${user.username}', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 9),
                    _InfoLine(icon: Icons.email_outlined, text: user.email),
                    const SizedBox(height: 4),
                    _InfoLine(icon: Icons.phone_outlined, text: user.phone),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: <Widget>[
                        _Tag(label: '${user.age} years'),
                        _Tag(label: user.gender),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Expanded(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
