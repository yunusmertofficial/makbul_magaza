import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductService {
  static const String _key = 'makbul_products';
  static const String _catalogVersionKey = 'makbul_catalog_version';
  static const int _catalogVersion = 3;
  static const Set<String> _removedCatalogProductIds = {'120', '124', '125', '191', '194'};

  static final List<Product> _defaultProducts = [
    // Çok Satanlar
    Product(id: '1', code: '2071', name: 'Kaju Çiğ', imageUrl: 'assets/products/big-cig-kaju-kg888.webp'),
    Product(id: '2', code: '2072', name: 'Kaju Kavrulmuş', imageUrl: 'assets/products/big-kaju-kg833.webp'),
    Product(id: '3', code: '2063', name: 'Badem Kavrulmuş', imageUrl: 'assets/products/big-kavrulmus-badem-kg862.webp'),
    Product(id: '4', code: '2103', name: 'Ceviz İçi Özel', imageUrl: 'assets/products/big-ozel-ceviz-ici-kg449.webp'),
    Product(id: '5', code: '2021', name: 'Fındık Kavrulmuş', imageUrl: 'assets/products/big-kavrulmus-findik-kg974.webp'),
    Product(id: '6', code: '2111', name: 'Soslu Mısır', imageUrl: 'assets/products/big-soslu-misir-kg178.webp'),
    Product(id: '7', code: '2027', name: 'Makademya Fındık Kavrulmuş', imageUrl: 'assets/products/big-makademya-findik-kavrulmus689.webp'),
    Product(id: '8', code: '2151', name: 'Kokteyl Lüks', imageUrl: 'assets/products/big-kokteyl-luks-kg372.webp'),
    Product(id: '9', code: '6031', name: 'Türk Kahvesi', imageUrl: 'assets/products/big-turk-kahvesi-kg961.webp'),
    Product(id: '10', code: '2012', name: 'Fıstık Antep', imageUrl: 'assets/products/big-antep-fistigi-kg886.webp'),
    Product(id: '11', code: '2081', name: 'Kokteyl Atıştır', imageUrl: 'assets/products/big-kokteyl-atistir339.webp'),
    // Yeni Gelenler
    Product(id: '12', code: '3114', name: 'Lokum Cennet Fitil Fındıklı Narlı', imageUrl: 'assets/products/big-lokum-cennet-fitil-findikli-sade-kg615.webp'),
    Product(id: '16', code: '3114', name: 'Lokum Cennet Fitil Fındıklı Sade', imageUrl: 'assets/products/big-lokum-cennet-fitil-findikli-sade-kg615.webp'),
    Product(id: '17', code: '3114', name: 'Lokum Cennet Fitil Fındıklı Portakallı', imageUrl: 'assets/products/big-lokum-cennet-fitil-findikli-portakalli-kg414.webp'),
    Product(id: '18', code: '3114', name: 'Lokum Cennet Fitil Fındıklı Karadutlu', imageUrl: 'assets/products/big-lokum-cennet-fitil-findikli-karadutlu-kg694.webp'),
    // Atıştırmalıklar
    Product(id: '21', code: '7068', name: 'Karamelli Çikolata', imageUrl: 'assets/products/big-karamelli-cikolata-kg52.webp'),
    Product(id: '22', code: '7216', name: 'Slimfoods Bar', imageUrl: 'assets/products/big-slimfoods-bar-kg686.webp'),
    Product(id: '23', code: '3023', name: 'Lokum Narlı Zengin Duble', imageUrl: 'assets/products/big-lokum-narli-zengin-duble336.webp'),
    Product(id: '24', code: '7054', name: 'Cocony Hindistan Cevizli Bar', imageUrl: 'assets/products/big-cocony-hindistan-cevizli-bar-kg591.webp'),
    Product(id: '25', code: '1203', name: 'Jölelop', imageUrl: 'assets/products/big-jolelop255.webp'),
    Product(id: '26', code: '1121', name: 'Jelly Yumuşak Şeker', imageUrl: 'assets/products/big-jelly-yumusak-seker-kg186.webp'),
    Product(id: '27', code: '3128', name: 'Çikolata Kaplı Lokum', imageUrl: 'assets/products/big-cikolatali-lokum-kg703.webp'),
    Product(id: '28', code: '3120', name: 'Fıstıklı Sütlü Lokum Duble', imageUrl: 'assets/products/big-duble-fistikli-sutlu-lokum-kg380.webp'),
    Product(id: '29', code: '3112', name: 'Fındıklı Lokum Duble', imageUrl: 'assets/products/big-duble-findikli-lokum-kg834.webp'),
    // Öne Çıkanlar
    Product(id: '31', code: '1491', name: 'Cezerye', imageUrl: 'assets/products/big-cezerye-kg47.jpg'),
    Product(id: '32', code: '7012', name: 'Sütlü Çikolatalı Fındık Draje', imageUrl: 'assets/products/big-sutlu-cikolatali-findik-draje-kg387.webp'),
    // Bir Yudum Mutluluk
    Product(id: '38', code: '6032', name: 'Gold Kahve', imageUrl: 'assets/products/big-gold-kahve-kg668.webp'),
    // Düğün Paketleri
    Product(id: '40', code: '7051', name: 'Badem Şekeri', imageUrl: 'assets/products/big-badem-sekeri-kg946.webp'),
    Product(id: '41', code: '7042', name: 'Yöresel Badem Şekeri', imageUrl: 'assets/products/big-yoresel-badem-sekeri.webp'),
    Product(id: '42', code: '3100', name: 'Lokum Güllü', imageUrl: 'assets/products/big-gullu-lokum-kg394.webp'),
    Product(id: '43', code: '3100', name: 'Kuş Lokumu', imageUrl: 'assets/products/big-kus-lokumu-kg635.webp'),
    Product(id: '44', code: '3100', name: 'Lokum Sade', imageUrl: 'assets/products/big-sade-lokum-kg449.webp'),
    Product(id: '45', code: '2078', name: 'Kokteyl Maksimum', imageUrl: 'assets/products/big-kokteyl-maksimum830.webp'),
    Product(id: '46', code: '2153', name: 'Kokteyl Gurme', imageUrl: 'assets/products/big-kokteyl-gurme-kg446.webp'),
    // Sağlıklı Kal
    Product(id: '50', code: '5111', name: 'Yulaf Ezmesi', imageUrl: 'assets/products/big-yulaf-ezmesi-kg467.webp'),
    Product(id: '52', code: '2061', name: 'Badem İçi Çiğ', imageUrl: 'assets/products/big-cig-badem-ici-kg9.webp'),
    // Kuruyemiş
    Product(id: '53', code: '2044', name: 'Ayçekirdek Siyah Tuzsuz', imageUrl: 'assets/products/big-tuzsuz-siyah-aycekirdek-kg75.webp'),
    Product(id: '54', code: '2043', name: 'Ayçekirdek Siyah Uzun', imageUrl: 'assets/products/big-tuzlu-siyah-aycekirdek-kg296.webp'),
    Product(id: '57', code: '2101', name: 'Ceviz Kabuklu', imageUrl: 'assets/products/big-california-kabuklu-ceviz-kg708.webp'),
    Product(id: '58', code: '2132', name: 'Cips Ballı Susam', imageUrl: 'assets/products/big-balli-susamli-cips-kg861.webp'),
    Product(id: '59', code: '2057', name: 'Cips Fıstık', imageUrl: 'assets/products/big-cips-fistik-kg543.webp'),
    Product(id: '60', code: '2131', name: 'Cips Şapkalı', imageUrl: 'assets/products/big-sapkali-cips-kg642.webp'),
    Product(id: '61', code: '2133', name: 'Cips Tırtıl', imageUrl: 'assets/products/big-tirtil-cips-kg464.webp'),
    Product(id: '62', code: '2022', name: 'Fındık İçi Çiğ', imageUrl: 'assets/products/big-cig-findik-kg545.webp'),
    Product(id: '63', code: '2023', name: 'Fındık Kabuklu', imageUrl: 'assets/products/big-kabuklu-findik-kg425.webp'),
    Product(id: '64', code: '2026', name: 'Fındık tuzlu kavrulmuş', imageUrl: 'assets/products/big-tuzlu-kavrulmus-findik-kg847.webp'),
    Product(id: '65', code: '2051', name: 'Fıstık Kabuklu', imageUrl: 'assets/products/big-kabuklu-fistik-kg237.webp'),
    Product(id: '66', code: '2054', name: 'Fıstık Kendy', imageUrl: 'assets/products/fistik-kendy-2150-fistik-halktan-8669-21-B.jpg'),
    Product(id: '67', code: '2011', name: 'Fıstık Siirt', imageUrl: 'assets/products/big-siirt-fistigi-kg238.webp'),
    Product(id: '68', code: '2056', name: 'Fıstık Soslu', imageUrl: 'assets/products/big-soslu-fistik-kg849.webp'),
    Product(id: '69', code: '2059', name: 'Fıstık Tango', imageUrl: 'assets/products/big-tango-fistik-kg544.webp'),
    Product(id: '70', code: '2055', name: 'Fıstık Toppy', imageUrl: 'assets/products/big-toppy-fistik-kg657.webp'),
    Product(id: '71', code: '2053', name: 'Fıstık Tuzlu Lüks', imageUrl: 'assets/products/big-tuzlu-fistik-kg368.webp'),
    Product(id: '72', code: '2052', name: 'Fıstık Tuzsuz Lüks', imageUrl: 'assets/products/big-tuzsuz-fistik-kg144.webp'),
    Product(id: '73', code: '2031', name: 'Kabak Çifte Nevşehir', imageUrl: 'assets/products/big-cifte-kavrulmus-kabak-cekirdegi-kg892.webp'),
    Product(id: '74', code: '2035', name: 'Kabak İçi Çiğ', imageUrl: 'assets/products/big-kabak-cekirdegi-ici-kg935.webp'),
    Product(id: '75', code: '2032', name: 'Kabak Nevşehir', imageUrl: 'assets/products/big-kabak-cekirdegi-kg363.webp'),
    Product(id: '76', code: '2033', name: 'Kabak Edirne', imageUrl: 'assets/products/big-cifte-kavrulmus-sivri-kabak-cekirdegi-kg257.webp'),
    Product(id: '77', code: '2034', name: 'Kabak Tuzsuz', imageUrl: 'assets/products/big-tuzsuz-kabak-cekirdegi-kg977.webp'),
    Product(id: '78', code: '2084', name: 'Kokteyl eko Enerji', imageUrl: 'assets/products/big-kokteyl-enerji-kg301.webp'),
    Product(id: '79', code: '2094', name: 'Leblebi Beyaz Duble', imageUrl: 'assets/products/big-duble-beyaz-leblebi-kg608.webp'),
    Product(id: '81', code: '2091', name: 'Çıtır Çerez', imageUrl: 'assets/products/big-citir-leblebi-sari-kg248.jpg'),
    Product(id: '82', code: '2098', name: 'Leblebi Natural Köy', imageUrl: 'assets/products/big-koy-leblebisi-kg231.webp'),
    Product(id: '83', code: '2092', name: 'Leblebi Sarı Duble', imageUrl: 'assets/products/big-duble-sari-leblebi-kg527.webp'),
    Product(id: '84', code: '2097', name: 'Leblebi Şeker Beyaz', imageUrl: 'assets/products/big-leblebi-sekeri-beyaz-kg899.webp'),
    Product(id: '85', code: '2096', name: 'Leblebi Şeker Renkli', imageUrl: 'assets/products/big-leblebi-sekeri-renkli-kg428.webp'),
    Product(id: '86', code: '2093', name: 'Leblebi Tuzlu Duble', imageUrl: 'assets/products/big-duble-tuzlu-leblebi-kg895.webp'),
    Product(id: '87', code: '2121', name: 'Karpuz Çekirdeği', imageUrl: 'assets/products/big-kavrulmus-karpuz-cekirdegi-kg818.webp'),
    // Bakliyat
    Product(id: '89', code: '1081', name: 'Bakla İç', imageUrl: 'assets/products/big-bakla-ici-kg543.webp'),
    Product(id: '90', code: '1082', name: 'Bakla Kabuklu', imageUrl: 'assets/products/big-kabuklu-bakla-kg843.webp'),
    Product(id: '91', code: '1071', name: 'Barbunya Kiraz', imageUrl: 'assets/products/big-barbunya-kg264.webp'),
    Product(id: '92', code: '1101', name: 'Börülce', imageUrl: 'assets/products/big-borulce-kg426.webp'),
    Product(id: '93', code: '1061', name: 'Aşurelik Buğday', imageUrl: 'assets/products/big-asurelik-bugday-kg466.webp'),
    Product(id: '94', code: '1038', name: 'Bulgur Başbaşı', imageUrl: 'assets/products/big-basbasi-bulgur-kg21.webp'),
    Product(id: '95', code: '1035', name: 'Bulgur Esmer Köftelik', imageUrl: 'assets/products/big-esmer-koftelik-bulgur-kg271.webp'),
    Product(id: '96', code: '1034', name: 'Bulgur Esmer Pilavlık', imageUrl: 'assets/products/big-pilavlik-bulgur-kg947.webp'),
    Product(id: '97', code: '1031', name: 'Bulgur Köftelik', imageUrl: 'assets/products/big-koftelik-bulgur-kg644.webp'),
    Product(id: '98', code: '1033', name: 'Bulgur Midyat', imageUrl: 'assets/products/big-midyat-bulgur-kg279.webp'),
    Product(id: '99', code: '1032', name: 'Bulgur Pilavlık', imageUrl: 'assets/products/big-pilavlik-bulgur-kg947.webp'),
    Product(id: '100', code: '1037', name: 'Bulgur Seferkitel', imageUrl: 'assets/products/big-seferkitel-bulgur-kg358.webp'),
    Product(id: '101', code: '1036', name: 'Bulgur Şehriyeli', imageUrl: 'assets/products/big-sehriyeli-bulgur-kg169.webp'),
    Product(id: '102', code: '1044', name: 'Fasulye Bombay', imageUrl: 'assets/products/big-bombay-fasulye-kg95.webp'),
    Product(id: '103', code: '1045', name: 'Fasulye Dermason', imageUrl: 'assets/products/big-dermason-fasulye-kg983.webp'),
    Product(id: '104', code: '1046', name: 'Fasulye Horoz', imageUrl: 'assets/products/big-horoz-fasulye579.webp'),
    Product(id: '105', code: '1042', name: 'Fasulye Maş', imageUrl: 'assets/products/big-mas-fasulye-kg370.webp'),
    Product(id: '106', code: '1043', name: 'Fasulye Şeker', imageUrl: 'assets/products/big-seker-fasulye-kg582.webp'),
    Product(id: '107', code: '1021', name: 'Mercimek Kırmızı Futbol', imageUrl: 'assets/products/big-kirmizi-mercimek-kg427.webp'),
    Product(id: '108', code: '1023', name: 'Mercimek Sarı', imageUrl: 'assets/products/big-sari-mercimek-kg170.webp'),
    Product(id: '109', code: '1022', name: 'Mercimek Yeşil', imageUrl: 'assets/products/big-yesil-mercimek-kg163.webp'),
    Product(id: '110', code: '1111', name: 'Mısır Popcorn', imageUrl: 'assets/products/big-patlayan-misir-kg475.webp'),
    Product(id: '111', code: '1112', name: 'Mısır Yarması', imageUrl: 'assets/products/big-misir-yarmasi-kg307.webp'),
    Product(id: '112', code: '1051', name: 'Nohut İri Beyaz', imageUrl: 'assets/products/big-beyaz-nohut-kg417.webp'),
    Product(id: '113', code: '1052', name: 'Nohut Sarı', imageUrl: 'assets/products/big-nohut-kg326.webp'),
    Product(id: '114', code: '1011', name: 'Pirinç Baldo', imageUrl: 'assets/products/big-baldo-pirinc-kg489.webp'),
    Product(id: '115', code: '1016', name: 'Pirinç Basmati Cella', imageUrl: 'assets/products/big-basmati-pirinc-kg958.webp'),
    Product(id: '116', code: '1013', name: 'Pirinç Kırık', imageUrl: 'assets/products/big-kirik-pirinc-kg155.webp'),
    Product(id: '117', code: '1012', name: 'Pirinç Osmancık', imageUrl: 'assets/products/big-osmancik-pirinc-kg711.webp'),
    Product(id: '118', code: '1015', name: 'Pirinç Yerli Pilavlık', imageUrl: 'assets/products/big-yerli-pilavlik-pirinc-kg848.webp'),
    Product(id: '119', code: '1161', name: 'Tel Şehriye Kavrulmuş', imageUrl: 'assets/products/big-tel-sehriye-kg592.webp'),
    // Kuru Meyve
    Product(id: '121', code: '4081', name: 'Crawberry Kıyılmış', imageUrl: 'assets/products/big-cranbery-dilimli-kg395.webp'),
    Product(id: '122', code: '4072', name: 'Erik Kurusu Çekirdeksiz', imageUrl: 'assets/products/big-erik-kurusu-kg15.webp'),
    Product(id: '123', code: '4051', name: 'Dut Kurusu', imageUrl: 'assets/products/big-dut-kurusu-kg824.webp'),
    Product(id: '126', code: '4041', name: 'Hurma Medine Mebrum', imageUrl: 'assets/products/big-mebrum-hurma-kg39.webp'),
    Product(id: '127', code: '4042', name: 'Hurma Medjoul', imageUrl: 'assets/products/big-kudus-medjoul-hurma-kg319.webp'),
    Product(id: '128', code: '4101', name: 'İğde', imageUrl: 'assets/products/igde.jpg'),
    Product(id: '129', code: '4031', name: 'İncir Naturel', imageUrl: 'assets/products/incir-naturel.webp'),
    Product(id: '130', code: '4030', name: 'İncir Kıyılmış', imageUrl: 'assets/products/incir-kiyilmis.jpg'),
    Product(id: '131', code: '4021', name: 'Kayısı Gün Kurusu', imageUrl: 'assets/products/big-gun-kurusu-kayisi-kg375.webp'),
    Product(id: '133', code: '4022', name: 'Kayısı Sarı', imageUrl: 'assets/products/big-sari-kayisi-kg716.webp'),
    Product(id: '134', code: '4025', name: 'Kayısı Kıyılmış', imageUrl: 'assets/products/kayisi-kiyilmis.webp'),
    Product(id: '135', code: '4091', name: 'Keçiboynuzu', imageUrl: 'assets/products/keciboynuzu.jpg'),
    Product(id: '136', code: '4011', name: 'Kuş Üzümü', imageUrl: 'assets/products/big-kus-uzumu-kg542.webp'),
    Product(id: '137', code: '4012', name: 'Üzüm Besni Sarı', imageUrl: 'assets/products/big-besni-uzum-kg139.webp'),
    Product(id: '138', code: '4014', name: 'Üzüm İzmir Çekirdeksiz', imageUrl: 'assets/products/big-cekirdeksiz-izmir-uzum-kg74.webp'),
    Product(id: '139', code: '4013', name: 'Üzüm Siyah Çekirdekli', imageUrl: 'assets/products/big-cekirdekli-siyah-uzum-kg986.webp'),
    // Sofralık
    Product(id: '140', code: '1211', name: 'Ev Mantısı', imageUrl: 'assets/products/ev-mantisi.jpg'),
    Product(id: '141', code: '1212', name: 'Tarhana', imageUrl: 'assets/products/big-tarhana-kg592.webp'),
    // Baharat
    Product(id: '142', code: '8153', name: 'Biber Acı Toz', imageUrl: 'assets/products/big-aci-toz-biber-kg906.webp'),
    Product(id: '143', code: '8151', name: 'Biber İpek', imageUrl: 'assets/products/big-ipek-biber-kg59.webp'),
    Product(id: '144', code: '8155', name: 'Biber İsot', imageUrl: 'assets/products/biber-isot.webp'),
    Product(id: '145', code: '8154', name: 'Biber Tatlı Toz', imageUrl: 'assets/products/big-tatli-toz-biber-kg882.webp'),
    Product(id: '146', code: '8152', name: 'Biber Yağlı Pul', imageUrl: 'assets/products/big-yagli-pul-biber-kg78.webp'),
    Product(id: '147', code: '8091', name: 'Çörekotu', imageUrl: 'assets/products/big-corekotu-kg315.webp'),
    Product(id: '148', code: '8042', name: 'Karabiber Tane', imageUrl: 'assets/products/big-tane-karabiber-kg320.webp'),
    Product(id: '149', code: '8041', name: 'Karabiber Toz', imageUrl: 'assets/products/big-karabiber-kg879.webp'),
    Product(id: '150', code: '8131', name: 'Karbonat', imageUrl: 'assets/products/big-karbonat-kg943.webp'),
    Product(id: '151', code: '8051', name: 'Kekik', imageUrl: 'assets/products/big-kekik-kg792.webp'),
    Product(id: '152', code: '8101', name: 'Kimyon', imageUrl: 'assets/products/big-kimyon-kg402.webp'),
    Product(id: '153', code: '8161', name: 'Köfte Baharatı', imageUrl: 'assets/products/big-kofte-baharati-kg304.webp'),
    Product(id: '154', code: '8112', name: 'Tavuk Harcı', imageUrl: 'assets/products/big-tavuk-cesnisi-kg781.webp'),
    Product(id: '155', code: '8031', name: 'Köri', imageUrl: 'assets/products/big-kori-kg403.webp'),
    Product(id: '156', code: '8012', name: 'Limon Tuzu Tane', imageUrl: 'assets/products/big-tane-limon-tuzu-kg738.webp'),
    Product(id: '157', code: '8011', name: 'Limon Tuzu Toz', imageUrl: 'assets/products/big-toz-limon-tuzu-kg408.webp'),
    Product(id: '158', code: '8061', name: 'Nane', imageUrl: 'assets/products/big-nane-kg558.webp'),
    Product(id: '159', code: '8022', name: 'Sumak Tane', imageUrl: 'assets/products/big-tane-sumak-kg37.webp'),
    Product(id: '160', code: '8021', name: 'Sumak Toz', imageUrl: 'assets/products/big-sumak-kg822.webp'),
    Product(id: '161', code: '8081', name: 'Susam', imageUrl: 'assets/products/big-susam-kg175.webp'),
    Product(id: '162', code: '8121', name: 'Tarçın Toz', imageUrl: 'assets/products/big-tarcin-kg608.webp'),
    Product(id: '163', code: '8111', name: 'YeniBahar', imageUrl: 'assets/products/big-yenibahar-kg771.webp'),
    Product(id: '164', code: '8211', name: 'Zencefil Toz', imageUrl: 'assets/products/big-toz-zencefil-kg812.webp'),
    Product(id: '165', code: '8221', name: 'Zerdeçal Toz', imageUrl: 'assets/products/big-toz-zerdecal-kg352.webp'),
    // Lokum
    Product(id: '166', code: '3112', name: 'Fındıklı Lokum Duble', imageUrl: 'assets/products/big-duble-findikli-lokum-kg834.webp'),
    Product(id: '167', code: '3121', name: 'Lokum Osmanlı Vali', imageUrl: 'assets/products/big-vali-file-findikli-osmanli-lokum-kg737.webp'),
    Product(id: '168', code: '3111', name: 'Lokum Fıstıklı Duble', imageUrl: 'assets/products/big-duble-fistikli-lokum-kg513.webp'),
    Product(id: '169', code: '3021', name: 'Lokum Padişah Narlı', imageUrl: 'assets/products/big-narli-padisah-lokumu-kg-306.webp'),
    Product(id: '170', code: '3020', name: 'Lokum Padişah Sade', imageUrl: 'assets/products/big-padisah-lokumu-kg257.webp'),
    // Un, Şeker ve Pastacılık
    Product(id: '174', code: '1134', name: 'Galeta Unu', imageUrl: 'assets/products/big-galeta-unu-kg563.webp'),
    Product(id: '175', code: '1381', name: 'Haşhaş Mavi', imageUrl: 'assets/products/big-mavi-hashas-kg619.webp'),
    Product(id: '176', code: '1371', name: 'Hindistan Cevizi', imageUrl: 'assets/products/big-hindistan-cevizi-kg646.webp'),
    Product(id: '177', code: '1313', name: 'İrmik', imageUrl: 'assets/products/big-irmik-kg118.webp'),
    Product(id: '178', code: '1312', name: 'Mısır Nişastası', imageUrl: 'assets/products/big-misir-nisastasi-kg383.webp'),
    Product(id: '179', code: '1135', name: 'Mısır Unu', imageUrl: 'assets/products/big-misir-unu-kg452.webp'),
    Product(id: '181', code: '1311', name: 'Pudra Şekeri', imageUrl: 'assets/products/big-pudra-sekeri-kg349.webp'),
    Product(id: '182', code: '1113', name: 'Toz Şeker', imageUrl: 'assets/products/big-toz-seker-kg223.webp'),
    Product(id: '183', code: '1141', name: 'Un', imageUrl: 'assets/products/big-un-kg623.webp'),
    // Pestil ve Sucuk
    Product(id: '184', code: '1461', name: 'Atom Fındıklı', imageUrl: 'assets/products/big-atom-findikli-kg919.webp'),
    Product(id: '185', code: '1451', name: 'Cevizli Sucuk Açık', imageUrl: 'assets/products/big-cevizli-sucuk-kg495.webp'),
    Product(id: '186', code: '1452', name: 'Cevizli Sucuk Vezir', imageUrl: 'assets/products/big-cevizli-vezir-sucuk-kg569.webp'),
    Product(id: '187', code: '1492', name: 'Cezerye Narlı', imageUrl: 'assets/products/big-narli-cezerye-kg732.webp'),
    Product(id: '188', code: '1471', name: 'Köme Cevizli', imageUrl: 'assets/products/big-cevizli-kome-kg661.webp'),
    Product(id: '189', code: '1441', name: 'Köme Pikolalı', imageUrl: 'assets/products/big-pikolali-kome-kg406.webp'),
    Product(id: '190', code: '1422', name: 'Muska Fındıklı', imageUrl: 'assets/products/big-findikli-muska-kg334.webp'),
    Product(id: '192', code: '1432', name: 'Pestil Fındıklı', imageUrl: 'assets/products/big-findikli-pestil-kg803.webp'),
    Product(id: '193', code: '1431', name: 'Pestil Sade', imageUrl: 'assets/products/big-sade-pestil-kg781.webp'),
    Product(id: '195', code: '1434', name: 'Pestil Tatlısı Fındıklı', imageUrl: 'assets/products/big-findikli-pestil-tatlisi-kg846.webp'),
    Product(id: '196', code: '1436', name: 'Pestil Tatlısı Parmak', imageUrl: 'assets/products/big-rulo-pestil-tatlisi-kg289.webp'),
    // Sakız ve Şekerlemeler
    Product(id: '197', code: '1121', name: 'Jelly yumuşak şeker', imageUrl: 'assets/products/big-jelly-yumusak-seker-kg186.webp'),
    Product(id: '199', code: '1123', name: 'Jöle Şeker', imageUrl: 'assets/products/big-jole-seker-kg710.webp'),
    Product(id: '200', code: '8225', name: 'Jellybig', imageUrl: 'assets/products/big-jellybig-super-kola-kg370.webp'),
    Product(id: '202', code: '1128', name: 'Jöleberry', imageUrl: 'assets/products/big-joleberry948.webp'),
    Product(id: '203', code: '1125', name: 'Jelirop', imageUrl: 'assets/products/big-jelirop-kg591.webp'),
    // Kahve
    Product(id: '204', code: '6033', name: 'Kahve Kreması', imageUrl: 'assets/products/big-kahve-kremasi-kg712.webp'),
    // Çikolata ve Kaplamalı Ürünler
    Product(id: '205', code: '7081', name: 'Draje Badem renkli', imageUrl: 'assets/products/big-cikolatali-badem-draje-kg343.webp'),
    Product(id: '206', code: '7071', name: 'Draje çakıltaşı', imageUrl: 'assets/products/big-draje-cakiltasi-kg818.webp'),
    Product(id: '207', code: '7041', name: 'Draje Bonibon', imageUrl: 'assets/products/big-draje-bonibon-kg564.webp'),
    Product(id: '208', code: '7214', name: 'Draje Çikolata Rengarenk', imageUrl: 'assets/products/big-draje-cikolata-rengarenk205.webp'),
    // Bayramlık Şeker
    Product(id: '210', code: '3061', name: 'Lokum Kat Kat Böğürtlenli', imageUrl: 'assets/products/middle-lokum-kat-kat-bogurtlenli397.jpg'),
    Product(id: '213', code: '2134', name: 'Cips Piramit Süt Mısır', imageUrl: 'assets/products/piramit.webp'),
    Product(id: '214', code: '2135', name: 'Cips Makarna Ketçap', imageUrl: 'assets/products/big-ketcap-aromali-makarna-cipsi.jpg'),
    Product(id: '209', code: '2029', name: 'Kabuklu Kavrulmuş Makademya Fındığı', imageUrl: 'assets/products/big-kabuklu-kavrulmus-makademya-findigi394.jpg'),
    Product(id: '216', code: '4015', name: 'Üzüm Dalından Çekirdeksiz', imageUrl: 'assets/products/big-uzum-dalindan-cekirdeksiz-kg851.jpg'),
    Product(id: '211', code: '3061', name: 'Lokum Kat Kat Çilekli', imageUrl: 'assets/products/middle-lokum-kat-kat-cilekli.jpg'),
    Product(id: '212', code: '3061', name: 'Lokum Kat Kat Karamelize', imageUrl: 'assets/products/big-lokum-kat-kat-karamelize207.jpg'),
    Product(id: '215', code: '7056', name: 'Hurma Ezmesi Fıstıklı', imageUrl: 'assets/products/big-hurma-ezmesi-fistikli-kg453.jpg'),
    Product(id: '217', code: '4004', name: 'Cevizli Sucuk Kelebek', imageUrl: 'assets/products/kelebek-cevizli-sucuk-f8a715.jpg'),
    Product(id: '218', code: '2136', name: 'Kabak Karbeyaz', imageUrl: 'assets/products/kabak-karbeyaz.webp'),
    Product(id: '219', code: '8223', name: 'Kaju Fırından', imageUrl: 'assets/products/big-kaju-firindan-kg555-1.jpg'),
    Product(id: '220', code: '2082', name: 'Kokteyl Naturel', imageUrl: 'assets/products/kokteyl-naturel-2162-karisik-cerez-halktan-8657-21-B.jpg'),
    Product(id: '221', code: '7013', name: 'Draje Çikolata Fildişi', imageUrl: 'assets/products/big-fildisi-cikolatali-findik-draje-kg528.jpg'),
    Product(id: '222', code: '7017', name: 'Draje Çikolata Bitter', imageUrl: 'assets/products/big-bitter-cikolatali-findik-draje-kg701.jpg'),
    Product(id: '223', code: '1002', name: 'Tropi Frutti Yumuşak Şeker', imageUrl: 'assets/products/big-tropifrutti-karisik-yumusak-sekerleme464-1.jpg'),
    Product(id: '224', code: '1025', name: 'Jelly Ekşi Mix', imageUrl: 'assets/products/big-jelly-eksi-mix-1.jpg'),
    Product(id: '225', code: '7121', name: 'Toptop Sakız', imageUrl: 'assets/products/toptop-sakiz-2270-toptop-seker-halktan-8588-22-B.jpg'),
    Product(id: '226', code: '1001', name: 'Softbons Yumuşak Şeker', imageUrl: 'assets/products/big-softbons-yumusak-seker-kg456.jpg'),
    Product(id: '227', code: '7083', name: 'Draje Kaju', imageUrl: 'assets/products/big-spesiyal-kajulu-draje-kg618.jpg'),
    Product(id: '228', code: '7014', name: 'Draje Portakal Bitter', imageUrl: 'assets/products/portakal-draje.jpg'),
    Product(id: '229', code: '7033', name: 'Roll in Love Mix', imageUrl: 'assets/products/roll-in-love-mix.jpg'),
    Product(id: '230', code: '7088', name: 'Draje Biskrem', imageUrl: 'assets/products/small-draje-biskrem906.jpg'),
    Product(id: '231', code: '7215', name: 'Mini Kornet', imageUrl: 'assets/products/mini-kornet.webp'),
    Product(id: '232', code: '7026', name: 'Fındıklı Top Gofret', imageUrl: 'assets/products/findikli-top-gofret.avif'),
    Product(id: '233', code: '7057', name: 'Altın Para', imageUrl: 'assets/products/big-altin-para-kg20.jpg'),
    Product(id: '234', code: '7025', name: 'Choco Wafer', imageUrl: 'assets/products/chocowafer.jpg'),
    Product(id: '235', code: '1122', name: 'Jellycik', imageUrl: 'assets/products/big-jellycik-kg284.jpg'),
    Product(id: '236', code: '3002', name: 'Lokum Sultan Çilekli Duble', imageUrl: 'assets/products/toz-fistikli-cilekli-sultan-lokumu.webp'),
    Product(id: '237', code: '4061', name: 'Kuru Meyve Tropik Mix', imageUrl: 'assets/products/big-kurumeyve-tropik-mix-574-1.jpg'),
    Product(id: '238', code: '7084', name: 'Draje Bisküvit', imageUrl: 'assets/products/big-biskuvi-draje-kg650.jpg'),
    Product(id: '239', code: '2020', name: 'Şehzade Yer Fıstıklı', imageUrl: 'assets/products/big-lokum-sehzade-kg539.jpg'),
    Product(id: '240', code: '2086', name: 'Kokteyl Premium', imageUrl: 'assets/products/kokteyl-ekstra-luks-2184-karisik-cerez-halktan-8790-21-B.jpg'),
  ];

  Future<List<Product>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      await saveProducts(_defaultProducts);
      await prefs.setInt(_catalogVersionKey, _catalogVersion);
      return List.from(_defaultProducts);
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    var products = jsonList.map((e) => Product.fromMap(Map<String, dynamic>.from(e))).toList();

    if ((prefs.getInt(_catalogVersionKey) ?? 0) < _catalogVersion) {
      final defaultsById = {for (final product in _defaultProducts) product.id: product};
      products.removeWhere((product) => _removedCatalogProductIds.contains(product.id));
      final existingIds = products.map((product) => product.id).toSet();

      products = products.map((product) => defaultsById[product.id] ?? product).toList();
      products.addAll(_defaultProducts.where((product) => !existingIds.contains(product.id)));

      await saveProducts(products);
      await prefs.setInt(_catalogVersionKey, _catalogVersion);
    }

    return products;
  }

  Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(products.map((p) => p.toMap()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<void> addProduct(Product product) async {
    final products = await getProducts();
    products.add(product);
    await saveProducts(products);
  }

  Future<void> deleteProduct(String id) async {
    final products = await getProducts();
    products.removeWhere((p) => p.id == id);
    await saveProducts(products);
  }

  Future<void> updateProduct(Product updated) async {
    final products = await getProducts();
    final index = products.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      products[index] = updated;
      await saveProducts(products);
    }
  }
}
