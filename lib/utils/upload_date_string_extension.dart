extension DateTimeExtension on String {
  String timeAgoString() {
    final number = this.split(' ').first;
    final unit;

    if (this.contains('years') || this.contains('year')) {
      unit = 'year';
    } else if (this.contains('months') || this.contains('month')) {
      unit = 'month';
    } else if (this.contains('weeks') || this.contains('week')) {
      unit = 'week';
    } else if (this.contains('days') || this.contains('day')) {
      unit = 'day';
    } else if (this.contains('hours') || this.contains('hour')) {
      unit = 'hour';
    } else if (this.contains('minutes') || this.contains('minute')) {
      unit = 'minute';
    } else if (this.contains('seconds') || this.contains('second')) {
      unit = 'second';
    } else {
      return '';
    }

    return unit.toString().isEmpty ? this : '$number $unit ago';
  }
}
