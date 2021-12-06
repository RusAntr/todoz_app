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
          'newTask': 'New task',
          'addToProject': 'Add to a project',
          'titleHint': 'Title',
          'noProjects': 'No Projects',
          'addTodo': 'Add',
          'profilePage': 'Profile',
          'projectsPage': 'Projects',
          'homePage': 'Tasks',
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
          'inProgress': 'В процессе',
          'newTask': 'Новая задача',
          'addToProject': 'Добавить в проект',
          'titleHint': 'Название',
          'noProjects': 'Нет проектов',
          'addTodo': 'Добавить',
          'profilePage': 'Профиль',
          'projectsPage': 'Проекты',
          'homePage': 'Задачи',
        },
      };
}
