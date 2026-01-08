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

  /// Calculate lock label text based on lock status and offerData
  /// Returns "Lifetime" if permanent, or "X days left" / "X hours left" if timed
  static String? getLockLabelText(bool? isLocked, dynamic offerData) {
    if (isLocked != true) return null;

    // If offerData is null, cannot determine lock type
    if (offerData == null) return null;

    // Extract offerType and endDate from offerData
    String? offerType;
    String? endDate;
    // Handle PropertyOfferData object or Map
    if (offerData is Map<String, dynamic>) {
      offerType = offerData['offerType'];
      endDate = offerData['endDate'];
    } else {
      // Try to access as object properties using dynamic access
      try {
        // Access properties using noSuchMethod/dynamic calls
        final dynamic data = offerData;
        offerType = data.offerType;
        endDate = data.endDate;
      } catch (e) {
        return null;
      }
    }

    // If offerType is "lifetime" or endDate is null/empty, it's a permanent lock
    if (offerType == "lifetime" || endDate == null || endDate.isEmpty) {
      return "Lifetime Booked";
    }

    // For timed offers, calculate remaining time (endDate is guaranteed to be non-null here due to check above)
    if (offerType == "timed") {
      try {
        // Parse the expiration date
        final expiresDate = DateTime.parse(endDate);
        final now = DateTime.now();
        final difference = expiresDate.difference(now);

        if (difference.isNegative) {
          // Lock has expired
          return null;
        }

        final daysLeft = difference.inDays;
        if (daysLeft == 0) {
          final hoursLeft = difference.inHours;
          if (hoursLeft <= 0) {
            return null; // Lock expired
          }
          return "Booked — free in $hoursLeft ${hoursLeft == 1 ? 'hour' : 'hours'}";
        }

        return "Booked — free in $daysLeft ${daysLeft == 1 ? 'day' : 'days'}";
      } catch (e) {
        // If parsing fails, treat as permanent
        return "Lifetime Booked";
      }
    }

    return null;
  }

  /// Get lock tooltip text
  /// Returns "Locked by you" if current user owns the lock, otherwise "Locked by another vendor"
  static String getLockTooltipText(bool? isLockedByMe) {
    if (isLockedByMe == true) {
      return "Locked by you";
    }
    return "Locked by another vendor";
  }
}
