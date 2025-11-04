
enum ReportType {
  ventas,
  inventario,
  produccion,
}

class Report {
  final String id;
  final String title;
  final DateTime date;
  final ReportType type;

  Report({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
  });
}
