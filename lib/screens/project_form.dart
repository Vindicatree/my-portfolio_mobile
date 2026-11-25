import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});
  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _category = 'full-time';
  String _thumbnail = '';
  bool _submitting = false;
  final _categories = const [
    'internship',
    'research',
    'volunteer',
    'part-time',
    'full-time',
    'freelance',
  ];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context) || !mounted) return;
    final token = context.read<AuthState>().token;
    if (token == null) return;
    setState(() => _submitting = true);
    try {
      await context.read<ApiClient>().createExperience(
        Experience(
          title: _title.trim(),
          description: _description.trim(),
          category: _category,
          thumbnail: _thumbnail.trim(),
        ),
        token: token,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Data berhasil disimpan'),
          content: const Text(
            'Pengalaman baru sudah ditambahkan ke portofolio.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.pop(context);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        await context.read<AuthState>().logout();
        if (mounted) await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan (${error.statusCode}).')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tambah Pengalaman')),
    drawer: const LeftDrawer(),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Title'),
            onChanged: (value) => _title = value,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Title wajib diisi.'
                : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            minLines: 3,
            maxLines: 5,
            onChanged: (value) => _description = value,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Description wajib diisi.'
                : null,
          ),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: _categories
                .map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _category = value);
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Thumbnail URL (opsional)',
            ),
            keyboardType: TextInputType.url,
            onChanged: (value) => _thumbnail = value,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              final uri = Uri.tryParse(value.trim());
              return uri != null &&
                      (uri.scheme == 'http' || uri.scheme == 'https') &&
                      uri.host.isNotEmpty
                  ? null
                  : 'Masukkan URL yang valid.';
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const CircularProgressIndicator()
                : const Text('Simpan'),
          ),
        ],
      ),
    ),
  );
}
