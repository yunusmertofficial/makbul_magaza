import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E2A3A), Color(0xFF243447)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C9A7).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF00C9A7).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Ürün Resmi
            Hero(
              tag: 'product_${product.id}',
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFF0D1B2A),
                ),
                clipBehavior: Clip.antiAlias,
                child: product.imageUrl.isEmpty
                    ? const Icon(
                        Icons.inventory_2_outlined,
                        color: Color(0xFF00C9A7),
                        size: 36,
                      )
                    : product.imageUrl.startsWith('assets/')
                    ? Image.asset(
                        product.imageUrl,
                        key: ValueKey(product.imageUrl),
                        fit: BoxFit.cover,
                        errorBuilder: _imageErrorBuilder,
                      )
                    : Image.network(
                        product.imageUrl,
                        key: ValueKey(product.imageUrl),
                        fit: BoxFit.cover,
                        loadingBuilder: (ctx, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF00C9A7),
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: _imageErrorBuilder,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            // Ürün Bilgileri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C9A7).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF00C9A7).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.qr_code_2,
                          color: Color(0xFF00C9A7),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.code,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00C9A7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    debugPrint('Resim yüklenemedi: ${product.imageUrl} — Hata: $error');
    return const Icon(
      Icons.image_not_supported_outlined,
      color: Color(0xFF00C9A7),
      size: 36,
    );
  }
}
