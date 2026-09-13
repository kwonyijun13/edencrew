// Chart period tabs on the stock detail screen.
enum ChartPeriod {
  oneMonth('1개월', 2),
  threeMonths('3개월', 6),
  sixMonths('6개월', 12),
  oneYear('1년', 25);
  const ChartPeriod(this.label, this.pageCount);

  // Tab label shown in the UI.
  final String label;

  // How many Naver HTML pages to fetch (~10 trading days each).
  final int pageCount;
}
