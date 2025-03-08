abstract class FolderType {
  final String name;

  FolderType(this.name);
}

class BuiltinFolder extends FolderType {
  BuiltinFolder(String name) : super(name);

  static final FolderType defaultFolder = BuiltinFolder("");
}

class CustomFolder extends FolderType {
  CustomFolder(super.name);
}