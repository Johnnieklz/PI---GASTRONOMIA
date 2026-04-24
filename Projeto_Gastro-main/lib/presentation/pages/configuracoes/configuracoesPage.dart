import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  bool _notificacoes = true;
  bool _temaEscuro = false;
  String _idioma = 'Português';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(
            color: Color(0xFF6C2998),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6C2998)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Preferências'),
          _buildSwitchTile(
            title: 'Notificações',
            subtitle: 'Receber alertas de novas receitas',
            icon: Icons.notifications_none,
            value: _notificacoes,
            onChanged: (val) => setState(() => _notificacoes = val),
          ),
          _buildSwitchTile(
            title: 'Tema Escuro',
            subtitle: 'Alternar entre tema claro e escuro',
            icon: Icons.dark_mode_outlined,
            value: _temaEscuro,
            onChanged: (val) => setState(() => _temaEscuro = val),
          ),
          _buildListTile(
            title: 'Idioma',
            subtitle: _idioma,
            icon: Icons.language,
            onTap: () {
              // Implementar seleção de idioma
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Aplicativo'),
          _buildListTile(
            title: 'Sobre o App',
            subtitle: 'Versão 1.0.0',
            icon: Icons.info_outline,
            onTap: () {},
          ),
          _buildListTile(
            title: 'Termos de Uso',
            icon: Icons.description_outlined,
            onTap: () {},
          ),
          _buildListTile(
            title: 'Privacidade',
            icon: Icons.security,
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Conta'),
          _buildListTile(
            title: 'Limpar Cache',
            icon: Icons.delete_outline,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache limpo com sucesso!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF6C2998),
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        secondary: Icon(icon, color: const Color(0xFF6C2998)),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF6C2998),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(fontSize: 12))
            : null,
        leading: Icon(icon, color: const Color(0xFF6C2998)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }
}
