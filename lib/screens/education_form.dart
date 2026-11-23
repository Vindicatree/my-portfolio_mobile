import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _degreeController = TextEditingController();
  final _fieldController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isOngoing = false;

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldController.dispose();
    super.dispose();
  }

  String? _requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi.';
    }
    if (value.trim().length > 80) {
      return '$label maksimal 80 karakter.';
    }
    return null;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final currentDate = isStart ? _startDate : _endDate;
    final initialDate =
        currentDate ??
        (isStart ? DateTime(today.year - 1, today.month, today.day) : today);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(today) ? today : initialDate,
      firstDate: DateTime(1950),
      lastDate: today,
      helpText: isStart ? 'Pilih tanggal mulai' : 'Pilih tanggal selesai',
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      if (isStart) {
        _startDate = pickedDate;
      } else {
        _endDate = pickedDate;
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showEducationSummary() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pendidikan berhasil disimpan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Institusi: ${_institutionController.text.trim()}'),
              Text('Gelar: ${_degreeController.text.trim()}'),
              Text('Program studi: ${_fieldController.text.trim()}'),
              Text('Tanggal mulai: ${_formatDate(_startDate)}'),
              Text(
                'Tanggal selesai: ${_isOngoing ? 'Sedang berlangsung' : _formatDate(_endDate)}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _showEducationSummary();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Pendidikan'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _institutionController,
                  maxLength: 80,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama institusi',
                    hintText: 'Contoh: Universitas Indonesia',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _requiredText(value, 'Nama institusi'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _degreeController,
                  maxLength: 80,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Gelar atau jenjang',
                    hintText: 'Contoh: Sarjana Komputer',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _requiredText(value, 'Gelar atau jenjang'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _fieldController,
                  maxLength: 80,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Program studi',
                    hintText: 'Contoh: Ilmu Komputer',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _requiredText(value, 'Program studi'),
                ),
                const SizedBox(height: 12),
                FormField<DateTime>(
                  initialValue: _startDate,
                  validator: (value) {
                    if (value == null) return 'Tanggal mulai wajib dipilih.';
                    if (!_isOngoing &&
                        _endDate != null &&
                        value.isAfter(_endDate!)) {
                      return 'Tanggal mulai harus sebelum tanggal selesai.';
                    }
                    return null;
                  },
                  builder: (field) => InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Tanggal mulai',
                      border: const OutlineInputBorder(),
                      errorText: field.errorText,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(_formatDate(_startDate))),
                        TextButton.icon(
                          onPressed: () async {
                            await _pickDate(isStart: true);
                            field.didChange(_startDate);
                          },
                          icon: const Icon(Icons.calendar_month),
                          label: const Text('Pilih'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Pendidikan masih berlangsung'),
                  value: _isOngoing,
                  onChanged: (value) {
                    setState(() {
                      _isOngoing = value ?? false;
                      if (_isOngoing) _endDate = null;
                    });
                  },
                ),
                if (!_isOngoing) ...[
                  const SizedBox(height: 8),
                  FormField<DateTime>(
                    initialValue: _endDate,
                    validator: (value) {
                      if (value == null) {
                        return 'Tanggal selesai wajib dipilih atau tandai masih berlangsung.';
                      }
                      if (_startDate != null && value.isBefore(_startDate!)) {
                        return 'Tanggal selesai harus setelah tanggal mulai.';
                      }
                      return null;
                    },
                    builder: (field) => InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Tanggal selesai',
                        border: const OutlineInputBorder(),
                        errorText: field.errorText,
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(_formatDate(_endDate))),
                          TextButton.icon(
                            onPressed: () async {
                              await _pickDate(isStart: false);
                              field.didChange(_endDate);
                            },
                            icon: const Icon(Icons.calendar_month),
                            label: const Text('Pilih'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
