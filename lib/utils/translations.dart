import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'title': 'Todos',
          'hello': 'Hey, %s!',
          'today': 'Today ',
          'numberOfTasks': '%s out of %s tasks',
          'noTasks': 'No tasks',
          'toDo': 'To do',
          'taskDone': 'done',
          'taskUndone': 'undone',
          'inProgress': 'In progress',
        },
        'ru': {
          'title': 'Список дел',
          'hello': 'Привет, %s!',
          'today': 'Сегодня ',
          'numberOfTasks': '%s из %s дел',
          'noTasks': 'Нет задач',
          'toDo': 'Задачи',
          'taskDone': 'сделано',
          'taskUndone': 'не сделано',
          'inProgress': 'В процессе'
        },
      };
}
