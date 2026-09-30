import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import 'add_product_screen.dart';

String _toLowerCaseTr(String s) {
  const from = 'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ';
  const to = 'abcçdefgğhıijklmnoöprsştuüvyz';
  return s.split('').map((c) {
    final i = from.indexOf(c);
    return i != -1 ? to[i] : c.toLowerCase();
  }).join();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ProductService _service = ProductService();
  final TextEditingController _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _loadProducts();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await _service.getProducts();
    PaintingBinding.instance.imageCache.clear();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
      _isLoading = false;
    });
    _animController.forward(from: 0);
  }

  void _onSearch() {
    final query = _toLowerCaseTr(_searchController.text.trim());
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((p) {
          return _toLowerCaseTr(p.code).contains(query) ||
              _toLowerCaseTr(p.name).contains(query);
        }).toList();
      }
    });
  }

  Future<void> _addProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );
    if (result == true) _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildResultInfo(),
            Expanded(child: _buildProductList()),
          ],
        ),
      ),
      bottomNavigationBar: _buildLicenseBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProduct,
        backgroundColor: const Color(0xFF00C9A7),
        foregroundColor: const Color(0xFF0D1B2A),
        elevation: 8,
        icon: const Icon(Icons.add),
        label: Text('Ürün Ekle', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/logo.png',
              width: 46,
              height: 46,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Makbul Ürün Kodları',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              Text(
                'Ürün Yönetim Sistemi',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF7B9FCF),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00C9A7).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF00C9A7).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '${_allProducts.length} Ürün',
              style: TextStyle(
                color: const Color(0xFF00C9A7),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A3A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF00C9A7).withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00C9A7).withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Ürün kodu veya adı ile ara...',
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF00C9A7),
              size: 22,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFF7B9FCF),
                      size: 18,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _onSearch();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultInfo() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return const SizedBox(height: 4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: Color(0xFF7B9FCF), size: 16),
          const SizedBox(width: 6),
          Text(
            '"$query" için ${_filteredProducts.length} sonuç',
            style: TextStyle(color: const Color(0xFF7B9FCF), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00C9A7)),
      );
    }

    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchController.text.isNotEmpty
                  ? Icons.search_off
                  : Icons.inventory_2_outlined,
              color: const Color(0xFF00C9A7).withValues(alpha: 0.3),
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Ürün bulunamadı'
                  : 'Henüz ürün yok',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Farklı bir kod veya isim deneyin'
                  : 'Sağ alttaki + butonuna tıklayın',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnim,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 90),
        itemCount: _filteredProducts.length,
        itemBuilder: (ctx, index) {
          final product = _filteredProducts[index];
          return AnimatedSlide(
            duration: Duration(milliseconds: 300 + (index * 50)),
            offset: Offset.zero,
            child: ProductCard(product: product),
          );
        },
      ),
    );
  }

  Widget _buildLicenseBar() {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFF00C9A7).withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified,
            color: const Color(0xFF00C9A7).withValues(alpha: 0.5),
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            'Bu uygulama Yuşa Emin Mert\'e aittir.',
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF7B9FCF).withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
