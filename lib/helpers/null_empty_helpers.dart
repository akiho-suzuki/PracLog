extension ListNullEmptyCheck on List? {
  bool get isNotNullOrEmpty => this?.isNotEmpty ?? false;
}

extension StringNullEmptyCheck on String? {
  bool get isNotNullOrEmpty => this?.isNotEmpty ?? false;
}
