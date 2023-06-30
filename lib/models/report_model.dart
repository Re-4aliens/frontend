class Report {
  late int memberId;
  late String reportCategory;
  late String reportContent;

  Report({required this.memberId, required this.reportCategory, required this.reportContent});
}

List<String> _reportList = ["", "", "SPAM", "", ""];