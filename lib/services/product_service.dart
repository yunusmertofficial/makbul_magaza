import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductService {
  static const String _key = 'makbul_products';

  static const String _base = 'https://www.makbul.com/Content/global/images/products';

  static final List<Product> _defaultProducts = [
    // Çok Satanlar
    Product(id: '1', code: '2071', name: 'Çiğ Kaju', imageUrl: '$_base/1/171/big-cig-kaju-kg888.jpg'),
    Product(id: '2', code: '2072', name: 'Kavrulmuş Kaju', imageUrl: '$_base/1/172/big-kaju-kg833.jpg'),
    Product(id: '3', code: '2063', name: 'Kavrulmuş Badem', imageUrl: '$_base/1/168/big-kavrulmus-badem-kg862.jpg'),
    Product(id: '4', code: '2103', name: 'Özel Ceviz İçi', imageUrl: '$_base/2/215/big-ozel-ceviz-ici-kg449.jpg'),
    Product(id: '5', code: '2021', name: 'Kavrulmuş Fındık', imageUrl: '$_base/1/133/big-kavrulmus-findik-kg974.jpg'),
    Product(id: '6', code: '2111', name: 'Soslu Mısır', imageUrl: '$_base/2/221/big-soslu-misir-kg178.jpg'),
    Product(id: '7', code: '2027', name: 'Makademya Fındık Kavrulmuş', imageUrl: '$_base/1/1041/big-makademya-findik-kavrulmus689.jpg'),
    Product(id: '8', code: '2151', name: 'Kokteyl Lüks', imageUrl: '$_base/2/227/big-kokteyl-luks-kg372.jpg'),
    Product(id: '9', code: '6031', name: 'Türk Kahvesi', imageUrl: '$_base/2/228/big-turk-kahvesi-kg961.jpg'),
    Product(id: '10', code: '2012', name: 'Antep Fıstığı', imageUrl: '$_base/1/131/big-antep-fistigi-kg886.jpg'),
    Product(id: '11', code: '2081', name: 'Kokteyl Atıştır', imageUrl: '$_base/1/1035/big-kokteyl-atistir339.jpg'),
    // Yeni Gelenler
    Product(id: '12', code: '3114', name: 'Lokum Cennet Fitil Fındıklı Narlı', imageUrl: '$_base/1/1140/big-lokum-cennet-fitil-findikli-narli-kg508.jpg'),
    Product(id: '16', code: '3114', name: 'Lokum Cennet Fitil Fındıklı Sade', imageUrl: '$_base/1/1141/big-lokum-cennet-fitil-findikli-sade-kg615.jpg'),
    Product(id: '17', code: '3114', name: 'Lokum Cennet Fitil Fındıklı Portakallı', imageUrl: '$_base/1/1142/big-lokum-cennet-fitil-findikli-portakalli-kg414.jpg'),
    Product(id: '18', code: '3114', name: 'Lokum Cennet Fitil Fındıklı Karadutlu', imageUrl: '$_base/1/1143/big-lokum-cennet-fitil-findikli-karadutlu-kg694.jpg'),
    // Atıştırmalıklar
    Product(id: '21', code: '7068', name: 'Karamelli Çikolata', imageUrl: '$_base/9/973/big-karamelli-cikolata-kg52.jpg'),
    Product(id: '22', code: '7216', name: 'Slimfoods Bar', imageUrl: '$_base/9/972/big-slimfoods-bar-kg686.jpg'),
    Product(id: '23', code: '3023', name: 'Lokum Narlı Zengin Duble', imageUrl: '$_base/1/1050/big-lokum-narli-zengin-duble336.jpg'),
    Product(id: '24', code: '7054', name: 'Cocony Hindistan Cevizli Bar', imageUrl: '$_base/7/794/big-cocony-hindistan-cevizli-bar-kg591.jpg'),
    Product(id: '25', code: '1203', name: 'Jölelop', imageUrl: '$_base/8/842/big-jolelop255.jpg'),
    Product(id: '26', code: '1121', name: 'Jelly Yumuşak Şeker', imageUrl: '$_base/2/264/big-jelly-yumusak-seker-kg186.jpg'),
    Product(id: '27', code: '3128', name: 'Çikolata Kaplı Lokum', imageUrl: '$_base/3/304/big-cikolatali-lokum-kg703.jpg'),
    Product(id: '28', code: '3120', name: 'Duble Fıstıklı Sütlü Lokum', imageUrl: '$_base/9/99/big-duble-fistikli-sutlu-lokum-kg380.jpg'),
    Product(id: '29', code: '3112', name: 'Duble Fındıklı Lokum', imageUrl: '$_base/2/246/big-duble-findikli-lokum-kg834.jpg'),
    // Öne Çıkanlar
    Product(id: '31', code: '1491', name: 'Cezerye', imageUrl: '$_base/1/175/big-cezerye-kg47.jpg'),
    Product(id: '32', code: '7012', name: 'Sütlü Çikolatalı Fındık Draje', imageUrl: '$_base/2/235/big-sutlu-cikolatali-findik-draje-kg387.jpg'),
    // Bir Yudum Mutluluk
    Product(id: '38', code: '6032', name: 'Gold Kahve', imageUrl: '$_base/2/230/big-gold-kahve-kg668.jpg'),
    // Düğün Paketleri
    Product(id: '40', code: '7051', name: 'Badem Şekeri', imageUrl: '$_base/2/253/big-badem-sekeri-kg946.jpg'),
    Product(id: '41', code: '7042', name: 'Yöresel Badem Şekeri', imageUrl: '$_base/7/792/big-yoresel-badem-sekeri.jpg'),
    Product(id: '42', code: '3100', name: 'Güllü Lokum', imageUrl: '$_base/2/244/big-gullu-lokum-kg394.jpg'),
    Product(id: '43', code: '3100', name: 'Kuş Lokumu', imageUrl: '$_base/2/249/big-kus-lokumu-kg635.jpg'),
    Product(id: '44', code: '3100', name: 'Sade Lokum', imageUrl: '$_base/2/242/big-sade-lokum-kg449.jpg'),
    Product(id: '45', code: '2078', name: 'Kokteyl Maksimum', imageUrl: '$_base/7/729/big-kokteyl-maksimum830.jpg'),
    Product(id: '46', code: '2153', name: 'Kokteyl Gurme', imageUrl: '$_base/4/416/big-kokteyl-gurme-kg446.jpg'),
    // Sağlıklı Kal
    Product(id: '50', code: '5111', name: 'Yulaf Ezmesi', imageUrl: '$_base/4/417/big-yulaf-ezmesi-kg467.jpg'),
    Product(id: '52', code: '2061', name: 'Çiğ Badem İçi', imageUrl: '$_base/1/165/big-cig-badem-ici-kg9.jpg'),
    // Kuruyemiş
    Product(id: '53', code: '2044', name: 'Ayçekirdek Siyah Tuzsuz', imageUrl: '$_base/3/394/big-tuzsuz-siyah-aycekirdek-kg75.jpg'),
    Product(id: '54', code: '2043', name: 'Ayçekirdek Siyah Uzun', imageUrl: '$_base/3/306/big-tuzlu-siyah-aycekirdek-kg296.jpg'),
    Product(id: '57', code: '2101', name: 'Ceviz Kabuklu', imageUrl: '$_base/4/416/big-kokteyl-gurme-kg446.jpg'),
    Product(id: '58', code: '2132', name: 'Cips Ballı Susam', imageUrl: '$_base/3/395/big-balli-susamli-cips-kg861.jpg'),
    Product(id: '59', code: '2057', name: 'Cips Fıstık', imageUrl: '$_base/1/164/big-cips-fistik-kg543.jpg'),
    Product(id: '60', code: '2131', name: 'Cips Şapkalı', imageUrl: '$_base/2/224/big-sapkali-cips-kg642.jpg'),
    Product(id: '61', code: '2133', name: 'Cips Tırtıl', imageUrl: '$_base/3/397/big-tirtil-cips-kg464.jpg'),
    Product(id: '62', code: '2022', name: 'Fındık İçi Çiğ', imageUrl: '$_base/1/133/big-kavrulmus-findik-kg974.jpg'),
    Product(id: '63', code: '2023', name: 'Fındık Kabuklu', imageUrl: '$_base/1/133/big-kavrulmus-findik-kg974.jpg'),
    Product(id: '64', code: '2026', name: 'Fındık tuzlu kavrulmuş', imageUrl: '$_base/1/133/big-kavrulmus-findik-kg974.jpg'),
    Product(id: '65', code: '2051', name: 'Fıstık Kabuklu', imageUrl: '$_base/1/131/big-antep-fistigi-kg886.jpg'),
    Product(id: '66', code: '2054', name: 'Fıstık Kendy', imageUrl: '$_base/1/164/big-cips-fistik-kg543.jpg'),
    Product(id: '67', code: '2011', name: 'Fıstık Siirt', imageUrl: '$_base/1/131/big-antep-fistigi-kg886.jpg'),
    Product(id: '68', code: '2056', name: 'Fıstık Soslu', imageUrl: '$_base/1/164/big-cips-fistik-kg543.jpg'),
    Product(id: '69', code: '2059', name: 'Fıstık Tango', imageUrl: '$_base/1/131/big-antep-fistigi-kg886.jpg'),
    Product(id: '70', code: '2055', name: 'Fıstık Toppy', imageUrl: '$_base/1/164/big-cips-fistik-kg543.jpg'),
    Product(id: '71', code: '2053', name: 'Fıstık Tuzlu Lüks', imageUrl: '$_base/1/131/big-antep-fistigi-kg886.jpg'),
    Product(id: '72', code: '2052', name: 'Fıstık Tuzsuz Lüks', imageUrl: '$_base/1/131/big-antep-fistigi-kg886.jpg'),
    Product(id: '73', code: '2031', name: 'kabak Çitte Nevşehir', imageUrl: '$_base/2/222/big-kavrulmus-karpuz-cekirdegi-kg818.jpg'),
    Product(id: '74', code: '2035', name: 'kabak İçi Çiğ', imageUrl: '$_base/2/222/big-kavrulmus-karpuz-cekirdegi-kg818.jpg'),
    Product(id: '75', code: '2032', name: 'kabak Nevşehir', imageUrl: '$_base/2/222/big-kavrulmus-karpuz-cekirdegi-kg818.jpg'),
    Product(id: '76', code: '2033', name: 'kabak Edirne', imageUrl: '$_base/2/222/big-kavrulmus-karpuz-cekirdegi-kg818.jpg'),
    Product(id: '77', code: '2034', name: 'kabak Tuzsuz', imageUrl: '$_base/2/222/big-kavrulmus-karpuz-cekirdegi-kg818.jpg'),
    Product(id: '78', code: '2084', name: 'Kokteyl eko Enerji', imageUrl: '$_base/1/1035/big-kokteyl-atistir339.jpg'),
    Product(id: '79', code: '2094', name: 'Leblebi Beyaz Duble', imageUrl: '$_base/1/199/big-duble-beyaz-leblebi-kg608.jpg'),
    Product(id: '81', code: '2091', name: 'Leblebi Çıtır Sarı', imageUrl: '$_base/1/185/big-duble-sari-leblebi-kg527.jpg'),
    Product(id: '82', code: '2098', name: 'Leblebi Natural Köy', imageUrl: '$_base/1/185/big-duble-sari-leblebi-kg527.jpg'),
    Product(id: '83', code: '2092', name: 'Leblebi Sarı Duble', imageUrl: '$_base/1/185/big-duble-sari-leblebi-kg527.jpg'),
    Product(id: '84', code: '2097', name: 'Leblebi Şeker Beyaz', imageUrl: '$_base/2/206/big-leblebi-sekeri-beyaz-kg899.jpg'),
    Product(id: '85', code: '2096', name: 'Leblebi Şeker Renkli', imageUrl: '$_base/2/204/big-leblebi-sekeri-renkli-kg428.jpg'),
    Product(id: '86', code: '2093', name: 'Leblebi Tuzlu Duble', imageUrl: '$_base/1/195/big-duble-tuzlu-leblebi-kg895.jpg'),
    Product(id: '87', code: '2121', name: 'karpuz çekirdeği', imageUrl: '$_base/2/222/big-kavrulmus-karpuz-cekirdegi-kg818.jpg'),
    // Bakliyat
    Product(id: '89', code: '1081', name: 'Bakla İç', imageUrl: '$_base/4/417/big-yulaf-ezmesi-kg467.jpg'),
    Product(id: '90', code: '1082', name: 'Bakla Kabuklu', imageUrl: '$_base/4/417/big-yulaf-ezmesi-kg467.jpg'),
    Product(id: '91', code: '1071', name: 'Barbunya Kiraz', imageUrl: '$_base/4/417/big-yulaf-ezmesi-kg467.jpg'),
    Product(id: '92', code: '1101', name: 'Börlüce', imageUrl: '$_base/4/417/big-yulaf-ezmesi-kg467.jpg'),
    Product(id: '93', code: '1061', name: 'Buğday Aşurelik', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '94', code: '1038', name: 'Bulgur Başbaşı', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '95', code: '1035', name: 'Bulgur Esmer Köftelik', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '96', code: '1034', name: 'Bulgur Esmer Pilavlık', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '97', code: '1031', name: 'Bulgur Köftelik', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '98', code: '1033', name: 'Bulgur Midyat', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '99', code: '1032', name: 'Bulgur Pilavlık', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '100', code: '1037', name: 'Bulgur Seferkeleti', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '101', code: '1036', name: 'Bulgur Şehriyeli', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '102', code: '1044', name: 'Fasulye Bombay', imageUrl: '$_base/4/417/big-yulaf-ezmesi-kg467.jpg'),
    Product(id: '103', code: '1045', name: 'Fasulye Dermason', imageUrl: '$_base/4/417/big-yulaf-ezmesi-kg467.jpg'),
    Product(id: '104', code: '1046', name: 'Fasulye Horaz', imageUrl: '$_base/4/417/big-yulaf-ezmesi-kg467.jpg'),
    Product(id: '105', code: '1042', name: 'Fasulye Maş', imageUrl: '$_base/4/417/big-yulaf-ezmesi-kg467.jpg'),
    Product(id: '106', code: '1043', name: 'Fasulye Şeker', imageUrl: '$_base/4/417/big-yulaf-ezmesi-kg467.jpg'),
    Product(id: '107', code: '1021', name: 'Mercimek Kırmızı Futbol', imageUrl: '$_base/1/185/big-duble-sari-leblebi-kg527.jpg'),
    Product(id: '108', code: '1023', name: 'Mercimek Sarı', imageUrl: '$_base/1/185/big-duble-sari-leblebi-kg527.jpg'),
    Product(id: '109', code: '1022', name: 'Mercimek Yeşil', imageUrl: '$_base/1/185/big-duble-sari-leblebi-kg527.jpg'),
    Product(id: '110', code: '1111', name: 'Mısır Popcorn', imageUrl: '$_base/2/221/big-soslu-misir-kg178.jpg'),
    Product(id: '111', code: '1112', name: 'Mısır Yarması', imageUrl: '$_base/2/221/big-soslu-misir-kg178.jpg'),
    Product(id: '112', code: '1051', name: 'Nohut İri Beyaz', imageUrl: '$_base/1/199/big-duble-beyaz-leblebi-kg608.jpg'),
    Product(id: '113', code: '1052', name: 'Nohut Sarı', imageUrl: '$_base/1/185/big-duble-sari-leblebi-kg527.jpg'),
    Product(id: '114', code: '1011', name: 'Pirinç Baldo', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '115', code: '1016', name: 'Pirinç Basmati Cella', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '116', code: '1013', name: 'Pirinç Kırık', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '117', code: '1012', name: 'Pirinç Osmancık', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '118', code: '1015', name: 'Pirinç Yeri Pilavlık', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '119', code: '1161', name: 'Tel Şehriye Kavrulmuş', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    // Kuru Meyve
    Product(id: '120', code: '4121', name: 'Cennet Meyvesi', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '121', code: '4081', name: 'Cranberry Kıyılmış', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '122', code: '4072', name: 'Erik Kurusu Çekirdeksiz', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '123', code: '4051', name: 'Dut Kurusu', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '124', code: '4072', name: 'Erik Sarı', imageUrl: '$_base/1/139/big-sari-kayisi-kg716.jpg'),
    Product(id: '125', code: '4049', name: 'Hurma Bağdat', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '126', code: '4041', name: 'Hurma Medine Mebrum', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '127', code: '4042', name: 'Hurma Medjoul', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '128', code: '4101', name: 'İğde', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '129', code: '4031', name: 'İncir Naturel', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '130', code: '4030', name: 'İncir Kıyılmış', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '131', code: '4021', name: 'Kayısı Gün Kurusu', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '133', code: '4022', name: 'Kayısı Sarı', imageUrl: '$_base/1/139/big-sari-kayisi-kg716.jpg'),
    Product(id: '134', code: '4025', name: 'Kayısı Kıyılmış', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '135', code: '4091', name: 'Keçiboynuzu', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '136', code: '4011', name: 'Kuş Üzümü', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '137', code: '4012', name: 'Üzüm Besni Sarı', imageUrl: '$_base/1/139/big-sari-kayisi-kg716.jpg'),
    Product(id: '138', code: '4014', name: 'Üzüm İzmir Çekirdeksiz', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    Product(id: '139', code: '4013', name: 'Üzüm Siyah Çekirdekli', imageUrl: '$_base/1/137/big-gun-kurusu-kayisi-kg375.jpg'),
    // Sofralık
    Product(id: '140', code: '1211', name: 'Ev Mantısı', imageUrl: '$_base/1/119/big-un-kg623.jpg'),
    Product(id: '141', code: '1212', name: 'Tarhana', imageUrl: '$_base/1/119/big-un-kg623.jpg'),
    // Baharat
    Product(id: '142', code: '8153', name: 'Biber Acı Toz', imageUrl: ''),
    Product(id: '143', code: '8151', name: 'Biber İpek', imageUrl: ''),
    Product(id: '144', code: '8155', name: 'Biber İsot', imageUrl: ''),
    Product(id: '145', code: '8154', name: 'Biber Tatlı Toz', imageUrl: ''),
    Product(id: '146', code: '8152', name: 'Biber Yağlı Pul', imageUrl: ''),
    Product(id: '147', code: '8091', name: 'Çörekotu', imageUrl: ''),
    Product(id: '148', code: '8042', name: 'Karabiber Tane', imageUrl: ''),
    Product(id: '149', code: '8041', name: 'Karabiber Toz', imageUrl: ''),
    Product(id: '150', code: '8131', name: 'Karbonat', imageUrl: ''),
    Product(id: '151', code: '8051', name: 'Kekik', imageUrl: ''),
    Product(id: '152', code: '8101', name: 'Kimyon', imageUrl: ''),
    Product(id: '153', code: '8161', name: 'Köfte Baharatı', imageUrl: ''),
    Product(id: '154', code: '8112', name: 'tavuk Harcı', imageUrl: ''),
    Product(id: '155', code: '8031', name: 'Köri', imageUrl: ''),
    Product(id: '156', code: '8012', name: 'Limon Tuzu Tane', imageUrl: ''),
    Product(id: '157', code: '8011', name: 'Limon Tuzu Toz', imageUrl: ''),
    Product(id: '158', code: '8061', name: 'Nane', imageUrl: ''),
    Product(id: '159', code: '8022', name: 'Sumak Tane', imageUrl: ''),
    Product(id: '160', code: '8021', name: 'Sumak Toz', imageUrl: ''),
    Product(id: '161', code: '8081', name: 'Susam', imageUrl: ''),
    Product(id: '162', code: '8121', name: 'Tarçın Toz', imageUrl: ''),
    Product(id: '163', code: '8111', name: 'YeniBahar', imageUrl: ''),
    Product(id: '164', code: '8211', name: 'Zencefil Toz', imageUrl: ''),
    Product(id: '165', code: '8221', name: 'Zerdeçal Toz', imageUrl: ''),
    // Lokum
    Product(id: '166', code: '3112', name: 'Lokum Fındıklı Duble', imageUrl: '$_base/2/246/big-duble-findikli-lokum-kg834.jpg'),
    Product(id: '167', code: '3121', name: 'Lokum Osmanlı Vali', imageUrl: '$_base/5/501/big-vali-file-findikli-osmanli-lokum-kg737.jpg'),
    Product(id: '168', code: '3111', name: 'Lokum Fıstıklı Duble', imageUrl: '$_base/2/245/big-duble-fistikli-lokum-kg513.jpg'),
    Product(id: '169', code: '3021', name: 'Lokum Padişah Narlı', imageUrl: '$_base/5/552/big-narli-padisah-lokumu-kg-306.jpg'),
    Product(id: '170', code: '3020', name: 'Lokum Padişah Sade', imageUrl: '$_base/5/551/big-padisah-lokumu-kg257.jpg'),
    // Un, Şeker ve Pastacılık
    Product(id: '174', code: '1134', name: 'Galeta Unu', imageUrl: '$_base/1/121/big-galeta-unu-kg563.jpg'),
    Product(id: '175', code: '1381', name: 'Haşhaş Mavi', imageUrl: '$_base/2/214/big-mavi-hashas-kg619.jpg'),
    Product(id: '176', code: '1371', name: 'Hindistan Cevizi', imageUrl: '$_base/2/217/big-hindistan-cevizi-kg646.jpg'),
    Product(id: '177', code: '1313', name: 'İrmik', imageUrl: '$_base/2/219/big-irmik-kg118.jpg'),
    Product(id: '178', code: '1312', name: 'Mısır Nişastası', imageUrl: '$_base/2/220/big-misir-nisastasi-kg383.jpg'),
    Product(id: '179', code: '1135', name: 'Mısır Unu', imageUrl: '$_base/1/122/big-misir-unu-kg452.jpg'),
    Product(id: '181', code: '1311', name: 'Pudra Şekeri', imageUrl: '$_base/2/223/big-pudra-sekeri-kg349.jpg'),
    Product(id: '182', code: '1113', name: 'Toz Şeker', imageUrl: '$_base/1/117/big-toz-seker-kg223.jpg'),
    Product(id: '183', code: '1141', name: 'Un', imageUrl: '$_base/1/119/big-un-kg623.jpg'),
    // Pestil ve Sucuk
    Product(id: '184', code: '1461', name: 'Atom Fındıklı', imageUrl: '$_base/1/181/big-atom-findikli-kg919.jpg'),
    Product(id: '185', code: '1451', name: 'Cevizli Sucuk Acılı', imageUrl: '$_base/1/184/big-cevizli-sucuk-kg495.jpg'),
    Product(id: '186', code: '1452', name: 'Cevizli Sucuk Vezir', imageUrl: '$_base/1/184/big-cevizli-sucuk-kg495.jpg'),
    Product(id: '187', code: '1492', name: 'Cezerye Narlı', imageUrl: '$_base/1/169/big-narli-cezerye-kg732.jpg'),
    Product(id: '188', code: '1471', name: 'Köme Cevizli', imageUrl: '$_base/1/184/big-cevizli-sucuk-kg495.jpg'),
    Product(id: '189', code: '1441', name: 'Köme Pikolalı', imageUrl: '$_base/1/184/big-cevizli-sucuk-kg495.jpg'),
    Product(id: '190', code: '1422', name: 'Muska Fındıklı', imageUrl: '$_base/2/205/big-findikli-muska-kg334.jpg'),
    Product(id: '191', code: '1421', name: 'Muska Sade', imageUrl: '$_base/2/205/big-findikli-muska-kg334.jpg'),
    Product(id: '192', code: '1432', name: 'Pestil Fındıklı', imageUrl: '$_base/1/175/big-cezerye-kg47.jpg'),
    Product(id: '193', code: '1431', name: 'Pestil Sade', imageUrl: '$_base/1/175/big-cezerye-kg47.jpg'),
    Product(id: '194', code: '3118', name: 'Pestil Sarma Fıstık', imageUrl: '$_base/1/175/big-cezerye-kg47.jpg'),
    Product(id: '195', code: '1434', name: 'Pestil Tatlısı Fındıklı', imageUrl: '$_base/1/175/big-cezerye-kg47.jpg'),
    Product(id: '196', code: '1436', name: 'Pestil Tatlısı Parmak', imageUrl: '$_base/1/175/big-cezerye-kg47.jpg'),
    // Sakız ve Şekerlemeler
    Product(id: '197', code: '1121', name: 'Jelly yumuşak şeker', imageUrl: '$_base/2/264/big-jelly-yumusak-seker-kg186.jpg'),
    Product(id: '199', code: '1123', name: 'Jöle Şeker', imageUrl: '$_base/2/248/big-jole-seker-kg710.jpg'),
    Product(id: '200', code: '8225', name: 'Jellybig', imageUrl: '$_base/5/528/big-jellybig-super-kola-kg370.jpg'),
    Product(id: '202', code: '1128', name: 'Jöleberry', imageUrl: '$_base/7/760/big-joleberry948.jpg'),
    Product(id: '203', code: '1125', name: 'Jelirop', imageUrl: '$_base/8/842/big-jolelop255.jpg'),
    // Kahve
    Product(id: '204', code: '6033', name: 'Kahve Kreması', imageUrl: '$_base/2/230/big-gold-kahve-kg668.jpg'),
    // Çikolata ve Kaplamalı Ürünler
    Product(id: '205', code: '7081', name: 'Draje Badem renkli', imageUrl: '$_base/1/1094/big-draje-badem-gokkusagi-kg659.jpg'),
    Product(id: '206', code: '7071', name: 'Draje çakıltaşı', imageUrl: '$_base/2/260/big-draje-cakiltasi-kg818.jpg'),
    Product(id: '207', code: '7041', name: 'Draje Bonibon', imageUrl: '$_base/2/235/big-sutlu-cikolatali-findik-draje-kg387.jpg'),
    Product(id: '208', code: '7071', name: 'Draje Çikolatalı', imageUrl: '$_base/8/880/big-draje-cikolata-rengarenk205.jpg'),
    // Bayramlık Şeker
    Product(id: '210', code: '1196', name: 'bayramlık Şeker', imageUrl: '$_base/2/264/big-jelly-yumusak-seker-kg186.jpg'),
  ];

  Future<List<Product>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      await saveProducts(_defaultProducts);
      return List.from(_defaultProducts);
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Product.fromMap(Map<String, dynamic>.from(e))).toList();
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
