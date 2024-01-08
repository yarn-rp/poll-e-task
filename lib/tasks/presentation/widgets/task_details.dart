import 'package:app_ui/app_ui.dart';
import 'package:blueprint/core/l10n/l10n.dart';
import 'package:blueprint/tasks/presentation/widgets/priority_chip.dart';
import 'package:blueprint/tasks/presentation/widgets/user_tile.dart';
import 'package:blueprint/tasks/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:task_repository/task_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({
    required this.task,
    required this.onClose,
    super.key,
  });

  final Task task;
  final VoidCallback onClose;

  Widget _buildDivider() {
    return const Column(
      children: [
        SizedBox(
          height: AppSpacing.lg,
        ),
        Divider(),
        SizedBox(
          height: AppSpacing.lg,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const padding = EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
    );

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.dividerTheme.color ?? theme.dividerColor,
        ),
      ),
      margin: EdgeInsets.zero,
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: _TaskDetailsAppBar(
          onClose: onClose,
          platformTaskUrl: task.taskURL,
          platformName: task.project.platformName,
          taskTitle: task.title,
        ),
        body: ListView(
          children: [
            _buildDivider(),
            Padding(
              padding: padding,
              child: _TaskDescriptionSection(
                task: task,
              ),
            ),
            _buildDivider(),
            Padding(
              padding: padding,
              child: _TaskDetailsSection(
                task: task,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskDescriptionSection extends StatelessWidget {
  const _TaskDescriptionSection({
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Section(
      title: l10n.description,
      child: RichTextCard(
        text: task.description,
      ),
    );
  }
}

class _TaskDetailsSection extends StatelessWidget {
  const _TaskDetailsSection({
    required this.task,
    super.key,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Section(
      title: l10n.details,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TaskLabels(task: task),
                const SizedBox(
                  height: AppSpacing.xlg,
                ),
                _StartAndDueDates(task: task),
                const SizedBox(
                  height: AppSpacing.xlg,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _TaskCreatedBy(
                        task: task,
                      ),
                    ),
                    Expanded(
                      child: _TaskAssignees(
                        task: task,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSpacing.xlg,
                ),
                _CreatedAndUpdatedDates(task: task),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreatedAndUpdatedDates extends StatelessWidget {
  const _CreatedAndUpdatedDates({
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final createdAtFromNow = Jiffy(task.createdAt).fromNow();
    final updatedAtFromNow = Jiffy(task.updatedAt).fromNow();

    return Column(
      children: [
        Text(
          '${l10n.created} $createdAtFromNow',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          '${l10n.updated} $updatedAtFromNow',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _TaskCreatedBy extends StatelessWidget {
  const _TaskCreatedBy({
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final creator = task.creator;

    return Section.mini(
      title: l10n.createdBy,
      child: UserTile(
        platformUrl: creator.platformURL,
        avatarUrl: creator.avatarUrl,
        displayName: creator.displayName,
        // TODO: add email
        email: null,
      ),
    );
  }
}

class _TaskAssignees extends StatelessWidget {
  const _TaskAssignees({
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Section.mini(
      title: l10n.assignees,
      child: Wrap(
        children: task.assigned
            .map(
              (e) => UserTile(
                platformUrl: e.platformURL,
                avatarUrl: e.avatarUrl,
                displayName: e.displayName,
                email: null,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _StartAndDueDates extends StatelessWidget {
  const _StartAndDueDates({
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TaskStartDate(
            task: task,
          ),
        ),
        Expanded(
          child: _TaskDueDate(
            task: task,
          ),
        ),
      ],
    );
  }
}

class _TaskStartDate extends StatelessWidget {
  const _TaskStartDate({
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Section.mini(
      title: l10n.startDate,
      child: SizedBox(
        width: double.infinity,
        child: TimeTile(
          time: task.startDate,
        ),
      ),
    );
  }
}

class _TaskDueDate extends StatelessWidget {
  const _TaskDueDate({
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Section.mini(
      title: l10n.dueDate,
      child: SizedBox(
        width: double.infinity,
        child: TimeTile(
          time: task.dueDate,
        ),
      ),
    );
  }
}

class _TaskLabels extends StatelessWidget {
  const _TaskLabels({
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ProjectPlatformChip(task: task),
        PriorityChip(task: task),
        ...task.labels.map((e) => LabelChip(text: e.name)),
      ],
    );
  }
}

class _TaskDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _TaskDetailsAppBar({
    required this.onClose,
    required this.platformTaskUrl,
    required this.platformName,
    required this.taskTitle,
  });

  final Uri platformTaskUrl;
  final String platformName;
  final String taskTitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight + kMinInteractiveDimension,
      backgroundColor: Colors.transparent,
      centerTitle: false,
      leadingWidth: double.infinity,
      actions: [
        FilledButton.tonalIcon(
          onPressed: () => launchUrl(platformTaskUrl),
          icon: const Icon(Icons.link),
          label: Text(
            'View in $platformName',
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close),
        ),
      ],
      title: Text(
        taskTitle,
        style: Theme.of(context).textTheme.headlineMedium,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
        kToolbarHeight + kMinInteractiveDimension,
      );
}