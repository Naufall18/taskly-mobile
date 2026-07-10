import 'package:flutter/material.dart';
import '../models/item.dart';
import '../data/repo.dart';
import '../config.dart';
import 'item_form.dart';

class ItemList extends StatefulWidget {
  final ItemRepo repo;
  final List<Item> Function() selector;
  const ItemList({super.key, required this.repo, required this.selector});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  bool _hideDone = false;

  void _openForm(BuildContext context, {Item? existing}) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => ItemForm(repo: widget.repo, existing: existing)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repo,
      builder: (context, _) {
        if (!widget.repo.loaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = widget.selector();
        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Nothing here yet — tap + to add.'),
            ),
          );
        }
        final visible =
            _hideDone ? items.where((e) => !e.flag).toList() : items;
        return Column(
          children: [
            if (AppConfig.usesFlag) _progress(context, items),
            Expanded(child: _buildList(context, visible)),
          ],
        );
      },
    );
  }

  Widget _progress(BuildContext context, List<Item> items) {
    final total = items.length;
    final done = items.where((e) => e.flag).length;
    final ratio = total == 0 ? 0.0 : done / total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('$done of $total done',
                  style: Theme.of(context).textTheme.labelLarge),
              const Spacer(),
              Text('${(ratio * 100).round()}%',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary)),
              const SizedBox(width: 4),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: _hideDone ? 'Show completed' : 'Hide completed',
                isSelected: _hideDone,
                icon: Icon(
                    _hideDone ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _hideDone = !_hideDone),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: ratio, minHeight: 6),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Item> items) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('All done — nothing to show.'),
        ),
      );
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final it = items[i];
        final sub = [
          if (it.detail.isNotEmpty) it.detail,
          if (it.category.isNotEmpty) it.category,
        ].join('  ·  ');
        return Dismissible(
          key: ValueKey(it.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            widget.repo.remove(it.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${it.title} deleted'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () => widget.repo.add(
                      it.title, it.detail, it.value, it.flag, it.category),
                ),
              ),
            );
          },
          child: ListTile(
            leading: AppConfig.usesFlag
                ? Checkbox(
                    value: it.flag,
                    onChanged: (_) => widget.repo.toggle(it.id))
                : CircleAvatar(child: Text(it.title.characters.first)),
            title: Text(it.title),
            subtitle: sub.isEmpty ? null : Text(sub),
            trailing: AppConfig.usesValue
                ? Text(
                    it.value.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                : const Icon(Icons.chevron_right),
            onTap: () => _openForm(context, existing: it),
          ),
        );
      },
    );
  }
}
