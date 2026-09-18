import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Écran de création du commerce (Étape 2 sur 2).
/// Design fidèle à la maquette avec header bleu nuit.
class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final _businessNameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _locationController = TextEditingController();

  // Secteurs disponibles
  final List<Map<String, dynamic>> _sectors = [
    {'name': 'Alimentation & Épicerie', 'icon': Icons.local_grocery_store_outlined},
    {'name': 'Prêt-à-porter & Mode', 'icon': Icons.checkroom_outlined},
    {'name': 'Téléphonie & Tech', 'icon': Icons.devices_outlined},
    {'name': 'Beauté & Cosmétiques', 'icon': Icons.spa_outlined},
    {'name': 'Quincaillerie & BTP', 'icon': Icons.handyman_outlined},
    {'name': 'Restaurant & Maquis', 'icon': Icons.restaurant_outlined},
  ];

  // Secteurs sélectionnés
  final Set<int> _selectedSectors = {};

  bool _isLoading = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _whatsappController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_businessNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer le nom du commerce.')),
      );
      return;
    }
    if (_selectedSectors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner au moins un secteur.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Commerce créé ! (Simulation)')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // === HEADER BLEU NUIT ===
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 32,
              left: 24,
              right: 24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.bleuNuit,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.orangePrincipal,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'ÉTAPE 2 SUR 2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Nouveau point de vente',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Parlons de votre commerce ✨',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Donnez une identité à votre boutique pour vos reçus clients,\ninventaires et catalogues.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // === CONTENU PRINCIPAL ===
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === CARTE BLANCHE AVEC LES CHAMPS ===
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // === NOM DU COMMERCE ===
                        _buildLabel('Nom du commerce', required: true),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _businessNameController,
                          hintText: 'ex: Boutique Awa & Frères',
                          icon: Icons.storefront_outlined,
                          suffixIcon: const Icon(
                            Icons.verified,
                            color: AppColors.succes,
                            size: 20,
                          ),
                          helperText: 'Ce nom apparaîtra en en-tête de chaque ticket de caisse et reçu WhatsApp.',
                        ),
                        const SizedBox(height: 24),

                        // === SECTEUR D'ACTIVITÉ ===
                        Row(
                          children: [
                            _buildLabel('Secteur d\'activité', required: true),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.orangePrincipal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${_selectedSectors.length} sélectionné${_selectedSectors.length > 1 ? "s" : ""}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.orangePrincipal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(_sectors.length, (index) {
                            final sector = _sectors[index];
                            final isSelected = _selectedSectors.contains(index);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedSectors.remove(index);
                                  } else {
                                    _selectedSectors.add(index);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.orangePrincipal.withOpacity(0.1)
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.orangePrincipal
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      sector['icon'] as IconData,
                                      size: 18,
                                      color: isSelected
                                          ? AppColors.orangePrincipal
                                          : AppColors.texteSecondaire,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      sector['name'] as String,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? AppColors.orangePrincipal
                                            : AppColors.textePrincipal,
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: AppColors.orangePrincipal,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),

                        // === NUMÉRO WHATSAPP PRO ===
                        _buildLabel('Numéro WhatsApp Pro', required: true),
                        const SizedBox(height: 10),
                        _buildWhatsAppField(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.mark_chat_read_outlined,
                              size: 14,
                              color: AppColors.texteSecondaire,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Reçus directs',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.texteSecondaire,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // === LOCALISATION ===
                        _buildLabel('Localisation du magasin', required: true),
                        const SizedBox(height: 10),
                        _buildLocationField(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // === APERÇU DU REÇU ===
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Aperçu sur vos reçus',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.texteSecondaire,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.orangePrincipal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: AppColors.orangePrincipal,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _businessNameController.text.trim().isEmpty
                                    ? 'Boutique Awa & Frères • Abidjan'
                                    : '${_businessNameController.text.trim()} • ${_locationController.text.trim().isEmpty ? "Abidjan" : _locationController.text.trim()}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textePrincipal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // === NOTE INFO ===
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bleuNuit.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_reset,
                          size: 18,
                          color: AppColors.bleuNuit,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Modifiable à tout moment dans les paramètres de l\'application.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.bleuNuit.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // === BOUTON CONTINUER ===
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orangePrincipal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.orangePrincipal.withOpacity(0.4),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continuer vers la personnalisation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 20),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textePrincipal,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              color: AppColors.orangePrincipal,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: AppColors.textePrincipal,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.texteSecondaire.withOpacity(0.5),
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.texteSecondaire,
                size: 22,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.texteSecondaire,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWhatsAppField() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🇧', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '+226',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textePrincipal,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: AppColors.texteSecondaire,
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _whatsappController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                color: AppColors.textePrincipal,
              ),
              decoration: InputDecoration(
                hintText: '70 00 00 00',
                hintStyle: TextStyle(
                  color: AppColors.texteSecondaire.withOpacity(0.5),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _locationController,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                color: AppColors.textePrincipal,
              ),
              decoration: InputDecoration(
                hintText: 'ex: Abidjan, Cocody',
                hintStyle: TextStyle(
                  color: AppColors.texteSecondaire.withOpacity(0.5),
                ),
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.texteSecondaire,
                  size: 22,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Géolocalisation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Géolocalisation (à implémenter)')),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.my_location,
                color: AppColors.orangePrincipal,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}