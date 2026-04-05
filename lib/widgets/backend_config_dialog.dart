import 'package:flutter/material.dart';
import '../services/app_config.dart';
import '../theme/app_colors.dart';

class BackendConfigDialog extends StatefulWidget {
  const BackendConfigDialog({super.key});

  @override
  State<BackendConfigDialog> createState() => _BackendConfigDialogState();
}

class _BackendConfigDialogState extends State<BackendConfigDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlController;
  bool _saving = false;
  final _urlFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(
      text: AppConfig.hasCustomApiBaseUrl ? AppConfig.apiBaseUrl : '',
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocus.dispose();
    super.dispose();
  }

  bool _looksLikePrivateHost(String value) {
    final v = value.trim();
    if (v.isEmpty) return false;
    final host = v
        .replaceFirst('http://', '')
        .replaceFirst('https://', '')
        .replaceFirst('/api', '')
        .split(':')
        .first;
    if (host.startsWith('192.168.')) return true;
    if (host.startsWith('10.')) return true;
    if (host.startsWith('172.')) {
      final parts = host.split('.');
      if (parts.length > 1) {
        final second = int.tryParse(parts[1]) ?? 0;
        return second >= 16 && second <= 31;
      }
    }
    return false;
  }

  void _setQuickUrl(String value) {
    _urlController.text = value;
    _urlFocus.requestFocus();
    _urlController.selection = TextSelection.fromPosition(
      TextPosition(offset: _urlController.text.length),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final value = _urlController.text.trim();
      if (value.isEmpty) {
        await AppConfig.resetCustomApiBaseUrl();
      } else {
        await AppConfig.setCustomApiBaseUrl(value);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultHostPort = AppConfig.defaultApiBaseUrl
        .replaceFirst('http://', '')
        .replaceFirst('https://', '')
        .replaceFirst('/api', '');

    return AlertDialog(
      title: const Text('Conexión de la app'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Predeterminado: ${AppConfig.defaultApiBaseUrl}',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              focusNode: _urlFocus,
              decoration: InputDecoration(
                labelText: 'IP o dirección de conexión',
                hintText: defaultHostPort,
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return null;
                if (!text.contains('.') && !text.contains('localhost')) {
                  return 'Ingresa una IP o URL válida';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: _saving ? null : () => _setQuickUrl('127.0.0.1:5001'),
                  child: const Text('USB (ADB)'),
                ),
                OutlinedButton(
                  onPressed: _saving ? null : () => _setQuickUrl('10.0.2.2:5001'),
                  child: const Text('Emulador'),
                ),
                OutlinedButton(
                  onPressed: _saving
                      ? null
                      : () {
                          final current = _urlController.text.trim();
                          if (_looksLikePrivateHost(current)) {
                            _setQuickUrl(current);
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Wi-Fi: escribe la IP de tu PC (ej. 192.168.18.21:5001)',
                              ),
                            ),
                          );
                          _urlFocus.requestFocus();
                        },
                  child: const Text('Wi-Fi'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Puedes escribir solo la IP y puerto. La app agregará /api automáticamente.',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _saving
              ? null
              : () async {
                  setState(() => _saving = true);
                  await AppConfig.resetCustomApiBaseUrl();
                  if (!mounted) return;
                  Navigator.pop(context, true);
                },
          child: const Text('Usar predeterminado'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
