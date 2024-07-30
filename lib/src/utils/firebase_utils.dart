String? getCollection(String path) {
  List entry = path.split('/').where((element) => element != "").toList();
  String? collection;
  try {
    collection = entry.getRange(0, entry.length - 1).join('/');
  } on RangeError catch (_) {
    return null;
  }

  if (collection.isEmpty) {
    return null;
  }
  return collection;
}
