import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../services/product_service.dart';

String _toUpperCaseTr(String s) {
  const from = 'abcçdefgğhıijklmnoöprsştuüvyz';
  const to   = 'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ';
  return s.split('').map((c) {
    final i = from.indexOf(c);
    return i != -1 ? to[i] : c.toUpperCase();
  }).join();
}

String _toLowerCaseTr(String s) {
  const from = 'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ';
  const to   = 'abcçdefgğhıijklmnoöprsştuüvyz';
  return s.split('').map((c) {
    final i = from.indexOf(c);
    return i != -1 ? to[i] : c.toLowerCase();
  }).join();
}

class AddProductScreen extends StatefulWidget {
  final Product? existingProduct;

  const AddProductScreen({super.key, this.existingProduct});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final ProductService _service = ProductService();
  bool _isSaving = false;
  bool _previewError = false;

  bool get isEditing => widget.existingProduct != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _codeController.text = widget.existingProduct!.code;
      _nameController.text = widget.existingProduct!.name;
      _imageUrlController.text = widget.existingProduct!.imageUrl;
    }
    _imageUrlController.addListener(() {
      if (_previewError) setState(() => _previewError = false);
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final product = Product(
      id: isEditing
          ? widget.existingProduct!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      code: _toUpperCaseTr(_codeController.text.trim()),
      name: _nameController.text.trim(),
      imageUrl: _imageUrlController.text.trim().replaceAll(' ', ''),
    );

    if (isEditing) {
      await _service.updateProduct(product);
    } else {
      await _service.addProduct(product);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? 'Ürün Düzenle' : 'Yeni Ürün Ekle',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(),
              const SizedBox(height: 28),
              _buildField(
                controller: _imageUrlController,
                label: 'Resim URL\'si',
                hint: 'https://example.com/urun.jpg',
                icon: Icons.image_outlined,
                onChanged: (_) => setState(() => _previewError = false),
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _codeController,
                label: 'Ürün Kodu',
                hint: 'Örn: MK001',
                icon: Icons.qr_code_2,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ürün kodu gerekli' : null,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _nameController,
                label: 'Ürün Adı',
                hint: 'Örn: Elma',
                icon: Icons.inventory_2_outlined,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ürün adı gerekli' : null,
                onChanged: (v) => debugPrint('ÜRÜN ADI INPUT: "$v"'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C9A7),
                    foregroundColor: const Color(0xFF0D1B2A),
                    disabledBackgroundColor:
                        const Color(0xFF00C9A7).withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFF00C9A7).withValues(alpha: 0.4),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(
                          color: Color(0xFF0D1B2A), strokeWidth: 2)
                      : Text(
                          isEditing ? 'Güncelle' : 'Kaydet',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    final url = _imageUrlController.text.trim();
    return Center(
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A3A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF00C9A7).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: url.isNotEmpty && !_previewError
            ? Image.network(
                key: ValueKey(url),
                url,
                fit: BoxFit.cover,
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00C9A7)),
                  );
                },
                errorBuilder: (ctx, err, stack) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => setState(() => _previewError = true),
                  );
                  return const Icon(
                    Icons.broken_image_outlined,
                    color: Color(0xFF00C9A7),
                    size: 48,
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: const Color(0xFF00C9A7).withValues(alpha: 0.5),
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Resim Önizleme',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF00C9A7).withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF00C9A7), size: 20),
        labelStyle: GoogleFonts.outfit(color: const Color(0xFF7B9FCF)),
        hintStyle: GoogleFonts.outfit(
            color: Colors.white.withValues(alpha: 0.25), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF1E2A3A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: const Color(0xFF00C9A7).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF00C9A7), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
        ),
      ),
    );
  }
}
