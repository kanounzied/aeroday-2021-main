class UsualFunctions {
  static String getInitials(name) {
    List<String> names = name.split(" ");
    print(names);
    String initials = "";
    int numWords = 2;
    if (numWords > names.length) {
      numWords = names.length;
    }

    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }
}