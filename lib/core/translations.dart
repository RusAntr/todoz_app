import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'title': 'Todos',
          'hello': 'Hey, %s!',
          'today': 'Today ',
          'yesterday': 'Yesterday ',
          'tomorrow': 'Tomorrow ',
          'numberOfTasks': '%s out of %s tasks',
          'noTasks': 'No tasks',
          'toDo': 'To do',
          'taskDone': 'done',
          'taskUndone': 'undone',
          'inProgress': 'In progress',
          'newTask': 'New task',
          'addToProject': 'Add to a project',
          'titleHint': 'Title',
          'noProjects': 'Click to create\nnew project :)',
          'profilePage': 'Profile',
          'projectsPage': 'Projects',
          'homePage': 'Tasks',
          'newProject': 'New Project',
          'chooseColor': 'Choose color',
          'create': 'Create',
          'chooseCover': 'Choose cover',
          'all': 'all',
          'changeProject': 'Change Project',
          'change': 'Change',
          'delete': 'Delete',
          'days': 'd ',
          'hours': 'h ',
          'minutes': 'm ',
          'seconds': 's',
          'till': 'till ',
          'less': 'less',
          'allTasks': 'All Tasks',
          'loading': 'loading...',
          'noTasksToDo': 'There are no tasks :)',
          'noTasksDone': 'No tasks done yet ;)',
          'done': 'Done',
          'signOut': 'Sign out',
          'achievements': 'Achievements',
          'productivityPage': 'Productivity',
          'amazing': 'Amazing!',
          'good': 'Good!',
          'fantastic': 'Fantastic!',
          'notBad': 'Not Bad!',
          'nothing': ':(',
          'tasksPlural234': 'task(s)',
          'tasksPlural': 'task(s)',
          'tasksPlural1': 'task(s)',
          'projectsPlural': 'project(s)',
          'projectsPlural1': 'project(s)',
          'projectsPlural234': 'project(s)',
          'add': 'add',
          'duration': 'Duration',
          'date': 'Date',
          'timeSpent': ' spent doing tasks',
          'archive': 'Archive',
          'aboutApp': 'About',
          'changeLanguage': 'Change language',
          'currentLanguage': 'Current language: ',
          'nameSignUp': 'your name',
          'passwordSignUp': 'your password',
          'emailSignUp': 'your email',
          'nameTitle': 'Name',
          'emailTitle': 'Email',
          'passwordTitle': 'Password',
          'signUp': 'Sign up',
          'signUpGoogle': 'Sign up with Google',
          'existingAccount': 'Already have an account?',
          'logIn': 'Log in',
          'monday': 'Monday',
          'tuesday': 'Tuesday',
          'wednesday': 'Wednesday',
          'thursday': 'Thursday',
          'friday': 'Friday',
          'saturday': 'Saturday',
          'sunday': 'Sunday',
          'emptyErrorTitle': 'Empty :(',
          'emptyErrorMessage': 'Please add task\'s title',
          'deletedSuccessfully': 'Deleted Successfully',
          'clickUndo': 'Click to undo',
          'undo': 'undo',
          'sort': 'sort',
          'sortDateCreated': 'Creation date',
          'sortDateUntil': 'Deadline',
          'sortTimePassed': 'Time spent',
          'sortDuration': 'Duration',
          'sortName': 'Name',
        },
        'ru': {
          'title': 'Список дел',
          'hello': 'Привет, %s!',
          'today': 'Сегодня ',
          'yesterday': 'Вчера ',
          'tomorrow': 'Завтра ',
          'numberOfTasks': '%s из %s дел',
          'noTasks': 'Нет задач',
          'toDo': 'Задачи',
          'taskDone': 'сделано',
          'taskUndone': 'не сделано',
          'inProgress': 'В процессе',
          'newTask': 'Новая задача',
          'addToProject': 'Добавить в проект',
          'titleHint': 'Название',
          'noProjects': 'Кликните, чтобы\nсоздать проект :)',
          'profilePage': 'Профиль',
          'projectsPage': 'Проекты',
          'homePage': 'Задачи',
          'newProject': 'Новый проект',
          'chooseColor': 'Выберете цвет',
          'create': 'Создать',
          'chooseCover': 'Выберете обложку',
          'all': 'все',
          'changeProject': 'Изменить проект',
          'change': 'Изменить',
          'delete': 'Удалить',
          'days': 'д ',
          'hours': 'ч ',
          'minutes': 'м ',
          'seconds': 'с',
          'till': 'до ',
          'less': 'скрыть',
          'allTasks': 'Все Задачи',
          'loading': 'загрузка...',
          'noTasksToDo': 'Тут нет задач :)',
          'noTasksDone': 'Пока ничего не сделано ;)',
          'done': 'Выполнено',
          'signOut': 'Выйти',
          'achievements': 'Достижения',
          'productivityPage': 'Продуктивность',
          'amazing': 'Замечательно!',
          'good': 'Отлично!',
          'fantastic': 'Великолепно!',
          'notBad': 'Неплохо!',
          'nothing': ':(',
          'tasksPlural234': 'задачи',
          'tasksPlural': 'задач',
          'tasksPlural1': 'задача',
          'projectsPlural': 'проектов',
          'projectsPlural1': 'проект',
          'projectsPlural234': 'проекта',
          'add': 'создать',
          'duration': 'Длительн.',
          'date': 'Дата',
          'timeSpent': ' потрачено на выполнение задач',
          'archive': 'Архив',
          'aboutApp': 'О приложении',
          'changeLanguage': 'Сменить язык',
          'currentLanguage': 'Язык: ',
          'nameSignUp': 'Ваше имя',
          'passwordSignUp': 'Ваш пароль',
          'emailSignUp': 'Ваша почта',
          'nameTitle': 'Имя',
          'emailTitle': 'Email',
          'passwordTitle': 'Пароль',
          'signUp': 'Регистрация',
          'signUpGoogle': 'Войти с Google',
          'existingAccount': 'Уже есть аккаунт?',
          'logIn': 'Войти',
          'monday': 'Понедельник',
          'tuesday': 'Вторник',
          'wednesday': 'Среда',
          'thursday': 'Четверг',
          'friday': 'Пятница',
          'saturday': 'Суббота',
          'sunday': 'Воскресенье',
          'emptyErrorTitle': 'Пусто :(',
          'emptyErrorMessage': 'Пожалуйста добавьте название задачи',
          'deletedSuccessfully': 'Успешно удалено',
          'clickUndo': 'Нажмите, чтобы отменить',
          'undo': 'отмена',
          'sort': 'сортировать',
          'sortDateCreated': 'Дата создания',
          'sortDateUntil': 'Дэдлайн',
          'sortTimePassed': 'Потрачено времени',
          'sortDuration': 'Продолжительность',
          'sortName': 'Название',
        },
        'zh': {
          'title': '标题',
          'hello': '你好, %s!',
          'today': '今天 ',
          'yesterday': '昨天 ',
          'tomorrow': '明天 ',
          'numberOfTasks': '%s 个任务中的 %s 个',
          'noTasks': '没有任务',
          'toDo': '任务',
          'taskDone': '完成',
          'taskUndone': '没完成的任务',
          'inProgress': '进行中',
          'newTask': '创建新任务',
          'addToProject': '添加到项目',
          'titleHint': '标题名称',
          'noProjects': '没有项目 :)',
          'profilePage': '资料',
          'projectsPage': '项目',
          'homePage': '主页',
          'newProject': '新项目',
          'chooseColor': '选择颜色',
          'create': '创建',
          'chooseCover': '选择封面',
          'all': '全部',
          'changeProject': '改变项目',
          'change': '改变',
          'delete': '删除',
          'days': '天 ',
          'hours': '小时 ',
          'minutes': '分钟 ',
          'seconds': '秒',
          'till': '直到 ',
          'less': '较少',
          'allTasks': '所有任务',
          'loading': '加载...',
          'noTasksToDo': '这里没有任务 :)',
          'noTasksDone': '尚未完成任何任务 ;)',
          'done': '完成的',
          'signOut': '退出',
          'achievements': '成就',
          'productivityPage': '生产率',
          'amazing': '惊人!',
          'good': '好!',
          'fantastic': '极好!',
          'notBad': '不错!',
          'nothing': '空 :(',
          'tasksPlural234': '个任务',
          'tasksPlural': '个任务',
          'tasksPlural1': '个任务',
          'projectsPlural': '个项目',
          'projectsPlural1': '个项目',
          'projectsPlural234': '个项目',
          'add': '添加',
          'duration': '持续时间',
          'date': '日期和时间',
          'timeSpent': ' 花在做任务上',
          'archive': '档案',
          'aboutApp': '关于应用',
          'changeLanguage': '改变语言',
          'currentLanguage': '当前语言: ',
          'nameSignUp': '名',
          'passwordSignUp': '密码',
          'emailSignUp': '电邮',
          'nameTitle': '名字',
          'emailTitle': '电邮',
          'passwordTitle': '密码',
          'signUp': '注册',
          'signUpGoogle': '用谷歌注册',
          'existingAccount': '已经有账户了？',
          'logIn': '登录',
          'monday': '星期一',
          'tuesday': '星期二',
          'wednesday': '星期三',
          'thursday': '星期四',
          'friday': '星期五',
          'saturday': '星期六',
          'sunday': '星期天',
          'emptyErrorTitle': '空的错误标题 :(',
          'emptyErrorMessage': '空的错误信息',
          'deletedSuccessfully': '删除成功',
          'clickUndo': '点击撤销',
          'undo': '撤消',
          'sort': '排序',
          'sortDateCreated': '创建日期',
          'sortDateUntil': '最后期限',
          'sortTimePassed': '所花费的时间',
          'sortDuration': '持续时间',
          'sortName': '按名字',
        }
      };
}
