class UrlImages {
  static const _urlBegin =
      'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2F';
  static const _imagesLinks = <String, String>{
    'appreciation':
        '${_urlBegin}appreciation_project.png?alt=media&token=5719ce96-13fd-4d31-b4a4-6f40f4b15ff4',
    'astronaut':
        '${_urlBegin}astronaut_project.png?alt=media&token=9fc1ab9f-6258-4852-a726-244296672fa2',
    'building':
        '${_urlBegin}building_project.png?alt=media&token=f46f6729-a571-4acf-8d05-3bfc00de01c5',
    'calendar':
        '${_urlBegin}calendar_project.png?alt=media&token=c97aa8ad-df13-4efc-b994-2518ee875585',
    'depilation':
        '${_urlBegin}depilation_project.png?alt=media&token=98110288-43b7-4f90-8a51-0563c0122ca0',
    'destination':
        '${_urlBegin}destination_project.png?alt=media&token=06b0ad56-6ee2-4ada-b32c-d5a79ad74fb2',
    'experts':
        '${_urlBegin}experts_project.png?alt=media&token=cbeb4627-1002-4543-b4d0-d5f2d34a1490',
    'home-run':
        '${_urlBegin}home-run_project.png?alt=media&token=1f6d6ce9-75e5-4146-98a2-0acacc67a345',
    'internet':
        '${_urlBegin}internet_project.png?alt=media&token=4977175b-149c-4ed3-84c4-007403941c3c',
    'javascript-frameworks':
        '${_urlBegin}javascript-frameworks_project.png?alt=media&token=7f843e2d-bac9-4cac-9cde-f644e1b21411',
    'maintenance':
        '${_urlBegin}maintenance_project.png?alt=media&token=cdddffd2-d6fc-4e12-84f4-6dd2f67c7bc7',
    'palette':
        '${_urlBegin}palette_project.png?alt=media&token=c16dd278-4538-4cfb-b26a-a4cbb5f910a8',
    'photos':
        '${_urlBegin}photos_project.png?alt=media&token=6d4ab1d5-3392-49b4-b761-436a15b513ed',
    'plain-credit-card':
        '${_urlBegin}plain-credit-card_project.png?alt=media&token=54919214-0713-451e-a8fa-4ad7ade3b56f',
    'resume':
        '${_urlBegin}resume_project.png?alt=media&token=e73cd111-945e-4c0c-ae50-b29827ca42ad',
    'snowman':
        '${_urlBegin}snowman_project.png?alt=media&token=7b3dd5c6-82fe-4f26-baf2-fe07abaa72c2',
    'superhero':
        '${_urlBegin}superhero_project.png?alt=media&token=eebddacd-a441-4c0e-b6f1-9deeebd6d93a',
    'yacht':
        '${_urlBegin}yacht_project.png?alt=media&token=1df6fa39-7539-45a2-83d6-a6c1802023c8'
  };

  Map<String, String> get images => _imagesLinks;

  String selectedCoverKey(String value) =>
      _imagesLinks.entries.singleWhere((element) => element.value == value).key;

  String selectedCoverValue(String key) =>
      _imagesLinks.entries.singleWhere((element) => element.key == key).value;
}
