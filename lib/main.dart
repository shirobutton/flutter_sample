import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sample/api_service.dart';

import 'task.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

final counterProvider = StateProvider<int>((ref) => 0);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          AddTask(),
          const Expanded(child: TaskList()),
        ],
      ),
    );
  }
}

final taskListProvider = StateProvider<List<Task>>((ref) => []);
final indexProvider = Provider<int>((_) {
  throw UnimplementedError();
});

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListLength = ref.watch(taskListProvider.select((value) {
      return value.length;
    }));
    return ListView.builder(
      itemCount: taskListLength,
      itemBuilder: (context, index) {
        return ProviderScope(
          overrides: [indexProvider.overrideWith((_) => index)],
          child: const TaskItem(),
        );
      },
    );
  }
}

extension KotlinLikeList<T> on Iterable<T> {
  T? getOrNull(int index) {
    if (index >= 0 && index < length) return elementAt(index);
    return null;
  }
}

class TaskItem extends ConsumerWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);
    final task = ref.watch(taskListProvider.select((list) {
      if (index >= 0 && index < list.length) return list[index];
      return null;
    }));
    if (task == null) return const SizedBox.shrink();
    return ListTile(
      title: Text(task.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) {
              final newTask = task.copyWith(isCompleted: !task.isCompleted);
              ref.read(taskListProvider.notifier).update((state) {
                state[index] = newTask;
                return List.from(state);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(taskListProvider.notifier).update((state) {
                state.removeAt(index);
                return List.from(state);
              });
            },
          ),
        ],
      ),
    );
  }
}

class AddTask extends ConsumerWidget {
  final TextEditingController controller = TextEditingController();

  AddTask({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: TextField(controller: controller),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            ref
                .read(taskListProvider.notifier)
                .update((state) => [...state, Task(name: controller.text)]);
            controller.clear();
          },
        ),
      ],
    );
  }
}

class PostsList extends ConsumerWidget {
  const PostsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(postsProvider).when(
          data: (posts) {
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(posts[index].title),
                  subtitle: Text(posts[index].body),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Text('Error: $err'),
        );
  }
}
