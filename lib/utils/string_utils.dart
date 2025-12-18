class StringUtils {
  static String enumName(String enumToString) {
    List<String> paths = enumToString.split(".");
    return paths[paths.length - 1];
  }

  static String capitalizeFirstLetter(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  static String extractFileNameWithExtension(String url) {
    if (url.isEmpty) {
      return "";
    }

    // Find the positions of the last "/" and "_"
    final lastSlashIndex = url.lastIndexOf('/');
    final lastUnderscoreIndex = url.lastIndexOf('_');
    final lastDotIndex = url.lastIndexOf('.');

    // Validate the indices
    if (lastSlashIndex == -1 ||
        lastUnderscoreIndex == -1 ||
        lastDotIndex == -1 ||
        lastUnderscoreIndex < lastSlashIndex ||
        lastDotIndex < lastUnderscoreIndex) {
      return "";
      throw ArgumentError("Invalid URL format");
    }

    // Extract the file name and extension
    final fileName = url.substring(lastSlashIndex + 1, lastUnderscoreIndex);
    final extension = url.substring(lastDotIndex);
    String decodedString = Uri.decodeComponent(fileName);
    // Return the full name with extension
    return decodedString;
  }
}
