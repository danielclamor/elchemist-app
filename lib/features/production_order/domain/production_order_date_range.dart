typedef DateRange = ({DateTime? from, DateTime? to});

enum DatePreset {
  allTime('All Time', null),
  today('Today', 0),
  last7Days('Last 7 days', 6),
  last30Days('Last 30 days', 29);

  const DatePreset(this.label, this._daysBack);

  final String label;
  final int? _daysBack;

  DateRange toRange(DateTime now) => (
        from: _daysBack != null
            ? DateTime(now.year, now.month, now.day - _daysBack)
            : null,
        to: null,
      );
}
