import 'package:flutter/material.dart';
import 'package:kavesys_app/models/report.dart';

const MOCK_REPORTS = [
  // Report(id: 'R001', title: 'Reporte de Ventas Mensual - Feb 2025', date: '2025-03-01', type: 'Ventas'),
  // Report(id: 'R002', title: 'Reporte de Inventario - Feb 2025', date: '2025-03-01', type: 'Inventario'),
  // Report(id: 'R003', title: 'Reporte de Producción - Feb 2025', date: '2025-03-01', type: 'Producción' ),
  // Report(id: 'R004', title: 'Reporte de Ventas Mensual - Ene 2025', date: '2025-02-01', type: 'Ventas' ),
];

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Generar Nuevo Reporte',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  items: const [
                    DropdownMenuItem(value: 'Ventas', child: Text('Reporte de Ventas')),
                    DropdownMenuItem(value: 'Inventario', child: Text('Reporte de Inventario')),
                    DropdownMenuItem(value: 'Producción', child: Text('Reporte de Producción')),
                  ],
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: 'Ventas',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Generar y Descargar PDF'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reportes Recientes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (MOCK_REPORTS.isNotEmpty)
                  ...MOCK_REPORTS.map((report) => ReportItem(report: report))
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'No hay reportes recientes.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReportItem extends StatelessWidget {
  final Report report;

  const ReportItem({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typeColors = {
      ReportType.ventas: Colors.green,
      ReportType.inventario: Colors.blue,
      ReportType.produccion: Colors.purple,
    };

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: const Icon(Icons.bar_chart, size: 32),
        title: Text(report.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Generado: ${report.date.toLocal().toString().split(' ')[0]}'),
        trailing: Chip(
          label: Text(report.type.toString().split('.').last),
          backgroundColor: typeColors[report.type]!.withOpacity(0.2),
          labelStyle: TextStyle(color: typeColors[report.type]),
        ),
      ),
    );
  }
}