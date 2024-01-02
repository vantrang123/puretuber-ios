  extension DateTimeExtension on String {
  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    try {
      final difference = date2.difference(DateTime.parse(this));
      final value;

      if ((difference.inDays / 7).floor() >= 1) {
        value = (numericDates) ? '1 week' : 'a week ago';
      } else if (difference.inDays >= 2) {
        value = '${difference.inDays} days';
      } else if (difference.inDays >= 1) {
        value = (numericDates) ? '1 day' : 'yesterday';
      } else if (difference.inHours >= 2) {
        value = '${difference.inHours} hours';
      } else if (difference.inHours >= 1) {
        value = (numericDates) ? '1 hour' : 'a few hours ago';
      } else if (difference.inMinutes >= 2) {
        value = '${difference.inMinutes} minutes';
      } else if (difference.inMinutes >= 1) {
        value = (numericDates) ? '1 minute' : 'a few minutes ago';
      } else if (difference.inSeconds >= 3) {
        value = '${difference.inSeconds} seconds';
      } else {
        return '';
      }

      return value.toString().isEmpty ? 'Just now' : '$value ago';
    } catch(e) {
      return 'Just now';
    }
  }
}
