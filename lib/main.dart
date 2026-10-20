import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BatixApp());
}

// ============================================================================
// 1. DESIGN TOKENS OFFICIELS (design_tokens_batix.json) & COMPOSANTS UI BATIX
// ============================================================================
class C {
  static const Color bgDark = Color(0xFF06141D);
  static const Color bgNavy = Color(0xFF0A2232);
  static const Color bgCard = Color(0xFF0D2334);
  static const Color bgInput = Color(0xFF091B29);
  static const Color bgLight = Color(0xFFF4F7FA);
  static const Color bgLightInput = Color(0xFFEEF2F6);
  static const Color greenLight = Color(0xFF4ADE80);
  static const Color green = Color(0xFF10B981);
  static const Color greenVivid = Color(0xFF1DB954);
  static const Color greenDark = Color(0xFF059669);
  static const Color greenDeep = Color(0xFF064E3B);
  static const Color greenRole = Color(0xFF16A34A);
  static const Color orangeGold = Color(0xFFFBBF24);
  static const Color orange = Color(0xFFF59E0B);
  static const Color orangeVivid = Color(0xFFFF8C00);
  static const Color orangeRole = Color(0xFFEA580C);
  static const Color blueRole = Color(0xFF0284C7);
  static const Color purpleRole = Color(0xFF7C3AED);
  static const Color whatsapp = Color(0xFF1D4ED8);
  static const Color red = Color(0xFFEF4444);
  static const Color border = Color(0x4534D399);
  static const Color borderSubtle = Color(0x3394A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textDarkPrimary = Color(0xFF082032);
  static const Color textDarkSecondary = Color(0xFF64748B);
  static const LinearGradient gradOrange = LinearGradient(
    colors: [orangeGold, orange, orangeRole],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient gradGreen = LinearGradient(
    colors: [greenLight, greenRole, greenDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient gradHeroBanner = LinearGradient(
    colors: [greenDeep, Color(0xFF047857), Color(0xFF065F46)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const RadialGradient gradBg = RadialGradient(
    center: Alignment(0, -0.5),
    radius: 1.35,
    colors: [Color(0x3810B981), bgNavy, bgDark],
  );
}
/// Widget utilitaire chargeant une image du pack `assets/batix/` avec fallback visuel propre
class BatixAsset extends StatelessWidget {
  final String file;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? radius;
  final Widget? fallback;
  const BatixAsset(
    this.file, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
    this.fallback,
  });
  @override
  Widget build(BuildContext context) {
    final Widget img = Image.asset(
      'assets/batix/$file',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          fallback ??
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: C.bgCard,
              borderRadius: radius ?? BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, color: C.greenLight, size: 28),
            ),
          ),
    );
    if (radius != null) {
      return ClipRRect(borderRadius: radius!, child: img);
    }
    return img;
  }
}
/// Fond d'écran avec image issue du pack `03_Arriere_Plans_&_Fonds_Ecrans` + dégradé de secours
class BatixScreenBg extends StatelessWidget {
  final String bgFile;
  final Widget child;
  final bool isLight;
  const BatixScreenBg({
    super.key,
    this.bgFile = 'bg_01_sombre_principal_navy_teal_1080x2400.png',
    this.isLight = false,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isLight ? C.bgLight : C.bgDark,
        gradient: isLight ? null : C.gradBg,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: isLight ? 0.55 : 0.42,
            child: Image.asset(
              'assets/batix/$bgFile',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

Widget batixCard({
  required Widget child,
  Color? color,
  Color? borderColor,
  EdgeInsets? padding,
  EdgeInsets? margin,
  double radius = 18,
  List<BoxShadow>? boxShadow,
}) {
  return Container(
    margin: margin ?? const EdgeInsets.only(bottom: 12),
    padding: padding ?? const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color ?? C.bgCard,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? C.border),
      boxShadow: boxShadow,
    ),
    child: child,
  );
}

Widget batixBadge(String text, Color bg, {Color textColor = Colors.white}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
    ),
  );
}

class BatixBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isOrange;
  final bool outlined;
  final VoidCallback onTap;
  final double height;
  const BatixBtn({
    super.key,
    required this.label,
    this.icon,
    this.isOrange = false,
    this.outlined = false,
    this.height = 52,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: C.bgCard.withOpacity(0.75),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: C.greenLight, width: 1.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: C.greenLight, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: isOrange ? C.gradOrange : C.gradGreen,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: (isOrange ? C.orange : C.green).withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/// Logo BATIX : par défaut showWordmark = false affiche UNIQUEMENT l'emblème sans texte BATIX en bas
class BatixLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  final String? subtitle;
  final bool showSlogan;
  final bool darkText;
  const BatixLogo({
    super.key,
    this.size = 68,
    this.showWordmark = false,
    this.subtitle,
    this.showSlogan = false,
    this.darkText = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [C.greenLight, C.greenDark, C.bgNavy]),
            border: Border.all(color: C.orange, width: 2.2),
            boxShadow: [
              BoxShadow(color: C.green.withOpacity(0.35), blurRadius: 12),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/batix/apk_icon_only_logo.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: size * 0.14,
                    child: Icon(Icons.location_city_rounded, size: size * 0.42, color: Colors.white),
                  ),
                  Positioned(
                    bottom: size * 0.14,
                    child: Icon(Icons.local_shipping_rounded, size: size * 0.42, color: C.orangeGold),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showWordmark) ...[
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: size * 0.36,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
              children: [
                TextSpan(
                  text: 'BATI',
                  style: TextStyle(color: darkText ? C.textDarkPrimary : Colors.white),
                ),
                const TextSpan(text: 'X', style: TextStyle(color: C.orange)),
              ],
            ),
          ),
        ],
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subtitle!,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: darkText ? Colors.black54 : Colors.white70,
              ),
            ),
          ),
        if (showSlogan)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "L'approvisionnement intelligent\nde vos chantiers.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: darkText ? C.textDarkPrimary : Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
/// Carte GPS utilisant les vraies cartes extraites du pack `Cartes_GPS_&_Avatars/`
class GpsMapCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String mapAsset;
  final double height;
  const GpsMapCard({
    super.key,
    required this.title,
    this.subtitle = 'Itinéraire GPS en direct',
    this.mapAsset = 'carte_gps_01_itineraire_sombre_3_points.png',
    this.height = 165,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2D3F), Color(0xFF081B26)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: C.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/batix/$mapAsset',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                        itemBuilder: (_, __) => Container(
                          decoration: BoxDecoration(border: Border.all(color: C.greenLight, width: 0.3)),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.location_on_rounded, color: C.greenLight, size: 32),
                        Container(width: 90, height: 4, color: C.greenLight),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: C.orange, shape: BoxShape.circle),
                          child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 22),
                        ),
                        Container(width: 60, height: 4, color: C.orangeGold),
                        const Icon(Icons.flag_circle_rounded, color: C.red, size: 34),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xCC06141D),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: C.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.local_shipping_rounded, color: C.greenLight, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: C.greenLight,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Stepper4Bar extends StatelessWidget {
  final int step;
  final List<String> labels;
  final List<String>? times;
  const Stepper4Bar({
    super.key,
    required this.step,
    required this.labels,
    this.times,
  });
  @override
  Widget build(BuildContext context) {
    return batixCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(labels.length, (i) {
          final done = i <= step;
          final current = i == step;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2.5,
                        color: i == 0
                            ? Colors.transparent
                            : (i <= step ? C.greenLight : Colors.white24),
                      ),
                    ),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: done
                          ? (current ? C.orange : C.greenRole)
                          : Colors.white12,
                      child: Icon(
                        done
                            ? (current && i == 2
                                ? Icons.local_shipping_rounded
                                : Icons.check_rounded)
                            : Icons.lock_outline_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2.5,
                        color: i == labels.length - 1
                            ? Colors.transparent
                            : (i < step ? C.greenLight : Colors.white24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: done ? FontWeight.bold : FontWeight.normal,
                    color: done ? C.greenLight : Colors.white54,
                  ),
                ),
                if (times != null && i < times!.length) ...[
                  const SizedBox(height: 2),
                  Text(
                    times![i],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 9.5, color: Colors.white60),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================================
// 2. DONNÉES PARTAGÉES (Produits BTP avec photos du pack, Commandes, Livreurs)
// ============================================================================
class Product {
  String id, name, sub, cat, unit, badge, asset, desc;
  int priceDark, priceLight, stock, threshold;
  double rating;
  int reviews;
  IconData icon;
  Color color;
  bool active;
  Product(
    this.id,
    this.name,
    this.sub,
    this.cat,
    this.unit,
    this.priceDark,
    this.priceLight,
    this.stock,
    this.asset,
    this.icon,
    this.color, {
    this.badge = 'En stock',
    this.threshold = 50,
    this.rating = 4.8,
    this.reviews = 320,
    this.active = true,
    this.desc = 'Matériau BTP de haute qualité, certifié pour tous types de construction.',
  });
}

class Order {
  String id, delivId, client, product, unit, supplier, driver, phone, plate, dest, origin, time, eta, distance, pin, status, asset;
  int qty, total;
  bool isUrgent;
  String? p1, p2, p3;
  bool signed;
  Order({
    required this.id,
    required this.delivId,
    required this.client,
    required this.product,
    required this.qty,
    required this.unit,
    required this.total,
    required this.supplier,
    required this.driver,
    required this.phone,
    required this.plate,
    required this.dest,
    this.origin = "Cimenterie d'Abidjan / Dépôt Central",
    required this.time,
    this.eta = 'À livrer avant 11:30 (Dans 45 min)',
    this.distance = '8,4 km',
    required this.pin,
    required this.status,
    this.asset = 'produit_01_sac_ciment_50kg_cpj42_5.png',
    this.isUrgent = false,
    this.p1,
    this.p2,
    this.p3,
    this.signed = false,
  });
}

class DriverInfo {
  String name, phone, status, vehicle, rating, distance, duration, nextStop;
  int deliveriesCount;
  bool active;
  DriverInfo({
    required this.name,
    required this.phone,
    required this.status,
    required this.vehicle,
    this.rating = '4.8',
    this.deliveriesCount = 124,
    this.distance = '4,2 km',
    this.duration = '12 min',
    this.nextStop = 'Quartier Bastos, Yaoundé',
    this.active = true,
  });
}

class Store {
  static final List<Product> products = [
    Product(
      'P1',
      'Ciment CPJ 42.5',
      'Haute qualité • Sac 50kg',
      'Ciment',
      'sac',
      4700,
      8500,
      500,
      'produit_01_sac_ciment_50kg_cpj42_5.png',
      Icons.inventory_2_rounded,
      const Color(0xFFD97706),
      desc: 'Ciment de haute qualité, idéal pour tous types de construction.',
    ),
    Product(
      'P2',
      'Fer à béton 8mm',
      'Acier haute résistance',
      'Fer à béton',
      'barre',
      3500,
      4800,
      250,
      'produit_04_fer_a_beton_8mm_barres.png',
      Icons.linear_scale_rounded,
      const Color(0xFF64748B),
    ),
    Product(
      'P3',
      'Fer à béton 12mm',
      'Acier haute résistance • FeE500',
      'Fer à béton',
      'barre',
      5800,
      6800,
      180,
      'produit_03_fer_a_beton_12mm.png',
      Icons.reorder_rounded,
      const Color(0xFF475569),
    ),
    Product(
      'P4',
      'Gravier 5/15 & 15/25',
      'Granulats de qualité concassés',
      'Gravier',
      'm³',
      4200,
      4200,
      140,
      'produit_05_gravier_5_15_granulats.png',
      Icons.landscape_rounded,
      const Color(0xFF94A3B8),
    ),
    Product(
      'P5',
      'Bois de coffrage',
      'Épaisseur 25mm • Traité',
      'Bois',
      'm²',
      12000,
      12000,
      90,
      'produit_06_bois_de_coffrage_25mm.png',
      Icons.forest_rounded,
      const Color(0xFFB45309),
    ),
    Product(
      'P6',
      'Briques creuses',
      'Briques haute densité',
      'Brique',
      'unité',
      250,
      300,
      1200,
      'produit_07_briques_creuses.png',
      Icons.grid_view_rounded,
      const Color(0xFFEA580C),
    ),
    Product(
      'P7',
      'Sable de construction',
      'Sable lavé de carrière',
      'Sable',
      'm³',
      12000,
      12000,
      50,
      'produit_08_sable_de_construction.png',
      Icons.terrain_rounded,
      const Color(0xFFD97706),
      badge: 'Stock faible',
    ),
  ];
  static final List<Order> orders = [
    Order(
      id: 'CMD-2025-0089',
      delivId: 'LIV-2025-0048',
      client: 'Bâtiment Horizon',
      product: 'Ciment CPJ 42.5',
      qty: 100,
      unit: 'sacs',
      total: 470000,
      supplier: 'Fournisseur A (Ciment Horizon)',
      driver: 'Moussa',
      phone: '(+237) 6 57 81 70 43',
      plate: 'BA-5847-AC',
      dest: 'Odza (Derrière Tradex) • Quartier Bastos, Yaoundé',
      time: '12:34 - 17/10/2026',
      eta: 'À livrer avant 11:30 (Dans 45 min)',
      distance: '8,4 km',
      pin: '8419',
      status: 'En préparation',
      asset: 'produit_02_palette_sacs_ciment_cpj42_5.png',
    ),
    Order(
      id: 'CMD-2025-00124',
      delivId: 'LIV-2025-0062',
      client: 'Chantier Riviera',
      product: 'Ciment (50kg)',
      qty: 200,
      unit: 'sacs',
      total: 245000,
      supplier: 'BATIX Logistics',
      driver: 'Yannick M.',
      phone: '+237 6 72 45 12 98',
      plate: 'LT-8821-AB',
      dest: 'Chantier Riviera • Plateau - Abidjan',
      time: "Aujourd'hui, 14:30",
      eta: 'À livrer avant 11:30 (Dans 45 min)',
      distance: '8,4 km',
      pin: '8419',
      status: 'En livraison',
      asset: 'produit_01_sac_ciment_50kg_cpj42_5.png',
    ),
    Order(
      id: 'CMD-2025-0088',
      delivId: 'LIV-2025-0063',
      client: 'Entrepôt Akwa',
      product: 'Fer à béton 8mm',
      qty: 20,
      unit: 'barres',
      total: 280000,
      supplier: 'Ciment Horizon',
      driver: 'Mbarga T.',
      phone: '+237 6 98 21 45 67',
      plate: 'CE-4012-BC',
      dest: 'Entrepôt Akwa',
      time: '11:20 - 17/10/2026',
      eta: 'À livrer avant 12:45 (Dans 2h)',
      distance: '12,1 km',
      pin: '5521',
      status: 'En livraison',
      asset: 'produit_04_fer_a_beton_8mm_barres.png',
    ),
    Order(
      id: 'CMD-2025-0087',
      delivId: 'LIV-2025-0064',
      client: 'Résidence Bonapriso',
      product: 'Briques creuses',
      qty: 200,
      unit: 'unités',
      total: 50000,
      supplier: 'Ciment Horizon',
      driver: 'Salifou D.',
      phone: '+237 6 70 12 34 56',
      plate: 'LT-3910-DL',
      dest: 'Résidence Bonapriso',
      time: '10:15 - 17/10/2026',
      eta: 'URGENT - Avant 10:45 (Dans 15 min)',
      distance: '5,2 km',
      pin: '9042',
      status: 'En attente de confirmation',
      asset: 'produit_07_briques_creuses.png',
      isUrgent: true,
    ),
    Order(
      id: 'CMD-2025-0086',
      delivId: 'LIV-2025-0065',
      client: 'Chantier Bastos',
      product: 'Sable de construction',
      qty: 10,
      unit: 'm³',
      total: 120000,
      supplier: 'Ciment Horizon',
      driver: 'Moussa',
      phone: '(+237) 6 57 81 70 43',
      plate: 'BA-5847-AC',
      dest: 'Quartier Bastos, Yaoundé',
      time: '09:40 - 17/10/2026',
      eta: 'Livré à 10:45',
      distance: '3,8 km',
      pin: '3318',
      status: 'En préparation',
      asset: 'produit_08_sable_de_construction.png',
    ),
  ];
  static final List<DriverInfo> drivers = [
    DriverInfo(
      name: 'Yannick M.',
      phone: '+237 6 72 45 12 98',
      status: 'En livraison',
      vehicle: 'Camion Benne 15T • LT-8821-AB',
      rating: '4.8',
      deliveriesCount: 124,
      distance: '4,2 km',
      duration: '12 min',
      nextStop: 'Quartier Bastos, Yaoundé',
    ),
    DriverInfo(
      name: 'Mbarga T.',
      phone: '+237 6 98 21 45 67',
      status: 'En livraison',
      vehicle: 'Camion Plateau • CE-4012-BC',
      rating: '4.7',
      deliveriesCount: 98,
      distance: '7,5 km',
      duration: '22 min',
      nextStop: 'Entrepôt Akwa, Douala',
    ),
    DriverInfo(
      name: 'Salifou D.',
      phone: '+237 6 70 12 34 56',
      status: 'En route',
      vehicle: 'Camion Grue • LT-3910-DL',
      rating: '4.9',
      deliveriesCount: 156,
      distance: '5,2 km',
      duration: '15 min',
      nextStop: 'Résidence Bonapriso',
    ),
    DriverInfo(
      name: 'Moussa',
      phone: '(+237) 6 57 81 70 43',
      status: 'En livraison',
      vehicle: 'Semi-Remorque • BA-5847-AC',
      rating: '4.9',
      deliveriesCount: 210,
      distance: '1,8 km',
      duration: '8 min',
      nextStop: 'Odza (Derrière Tradex), Yaoundé',
    ),
  ];
}

// ============================================================================
// 3. APPLICATION PRINCIPALE & PARTIE 1 : ONBOARDING, AUTH, DRAWER & 4 PROFILS
// ============================================================================
class BatixApp extends StatelessWidget {
  const BatixApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BATIX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: C.bgDark,
        primaryColor: C.green,
        useMaterial3: true,
      ),
      home: const SplashScreenBatix(),
    );
  }
}
/// Écran 1 : Splash Screen officiel (`01_Splash_Screen_Partenaire_Logistique.png`)
class SplashScreenBatix extends StatefulWidget {
  const SplashScreenBatix({super.key});
  @override
  State<SplashScreenBatix> createState() => _SplashScreenBatixState();
}

class _SplashScreenBatixState extends State<SplashScreenBatix> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        ),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD9ECFA), Color(0xFFFCE2C4), C.bgNavy, C.bgDark],
              stops: [0.0, 0.35, 0.72, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: 0.45,
                child: Image.asset(
                  'assets/batix/bg_03_splash_aurore_rubans_1080x2400.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const BatixLogo(
                        size: 98,
                        showWordmark: false,
                        showSlogan: true,
                        darkText: true,
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BatixAsset(
                            'hero_01_camion_chantier_coucher_soleil.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            fallback: Container(
                              decoration: BoxDecoration(
                                color: C.bgCard,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.local_shipping_rounded,
                                  size: 110,
                                  color: C.orangeGold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 65,
                            height: 7,
                            decoration: BoxDecoration(
                              color: C.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 65,
                            height: 7,
                            decoration: BoxDecoration(
                              color: C.orangeGold,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Votre partenaire logistique\nde confiance',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/// Écran 2 : Page d'accueil BATIX (`02_Page_Accueil_BATIX_Commencer.png`)
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD9ECFA), Color(0xFFFCE2C4), C.bgNavy, C.bgDark],
            stops: [0.0, 0.30, 0.65, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const BatixLogo(
                  size: 88,
                  showWordmark: false,
                  showSlogan: true,
                  darkText: true,
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const BatixAsset(
                          'hero_01_camion_chantier_coucher_soleil.png',
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, Color(0xEE06141D)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: const Text(
                              'Ensemble pour des chantiers plus performants !',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: C.bgCard.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: C.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _onboardPillar(Icons.layers_rounded, 'Matériaux\nBTP'),
                      Container(width: 1, height: 36, color: Colors.white24),
                      _onboardPillar(Icons.local_shipping_rounded, 'Livraison\nrapide'),
                      Container(width: 1, height: 36, color: Colors.white24),
                      _onboardPillar(Icons.verified_rounded, 'Partenaires\nfiables'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                BatixBtn(
                  label: 'Commencer  →',
                  isOrange: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WelcomeAuthScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _onboardPillar(IconData icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: C.greenLight, size: 26),
        const SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
/// Écran 3 : Bienvenue sur BATIX (`03_Bienvenue_Inscription_Connexion_Demo.png`)
class WelcomeAuthScreen extends StatelessWidget {
  const WelcomeAuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BatixScreenBg(
        bgFile: 'bg_02_sombre_rubans_vert_orange_1080x2400.png',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackButton(
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const BatixLogo(size: 84, showWordmark: false),
                const SizedBox(height: 16),
                const Text(
                  'Bienvenue sur BATIX',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Connectez-vous ou créez votre compte\npour accéder à tous les services.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                ),
                const SizedBox(height: 24),
                _authActionTile(
                  label: "S'inscrire",
                  icon: Icons.person_rounded,
                  gradient: C.gradOrange,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                ),
                const SizedBox(height: 14),
                _authActionTile(
                  label: 'Se connecter',
                  icon: Icons.login_rounded,
                  bgColor: C.bgCard,
                  borderColor: C.greenLight,
                  textColor: Colors.white,
                  iconColor: C.greenLight,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                ),
                const SizedBox(height: 14),
                _authActionTile(
                  label: 'Mode démo',
                  icon: Icons.play_circle_outline_rounded,
                  bgColor: Colors.white,
                  textColor: C.textDarkPrimary,
                  iconColor: C.textDarkPrimary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileChoiceScreen()),
                  ),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      const BatixAsset(
                        'banniere_03_silhouette_chantier_grues_bas.png',
                        height: 105,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.black45,
                        child: const Text(
                          'Ensemble pour des chantiers\nplus performants !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _authActionTile({
    required String label,
    required IconData icon,
    LinearGradient? gradient,
    Color? bgColor,
    Color? borderColor,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          gradient: gradient,
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: borderColor != null ? Border.all(color: borderColor, width: 1.5) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const Expanded(child: SizedBox()),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Expanded(child: SizedBox()),
            Icon(Icons.chevron_right_rounded, color: textColor),
          ],
        ),
      ),
    );
  }
}
/// Écran 4 : Se connecter (`04_Se_Connecter_Login_Sombre.png`)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController(text: 'client@batix.com');
  final TextEditingController _passCtrl = TextEditingController(text: '••••••••');
  bool _obscure = true;
  bool _rememberMe = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BatixScreenBg(
        bgFile: 'bg_02_sombre_rubans_vert_orange_1080x2400.png',
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(22),
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: BackButton(color: Colors.white),
              ),
              const BatixLogo(size: 82, showWordmark: false, showSlogan: true),
              const SizedBox(height: 22),
              batixCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Se connecter',
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Accédez à votre espace en toute sécurité',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
                        suffixIcon: const Icon(Icons.mail_outline_rounded, color: Colors.white38, size: 18),
                        hintText: 'Adresse e-mail',
                        filled: true,
                        fillColor: C.bgInput,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: C.borderSubtle),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Colors.white60,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                        hintText: 'Mot de passe',
                        filled: true,
                        fillColor: C.bgInput,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: C.borderSubtle),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _rememberMe = !_rememberMe),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                activeColor: C.green,
                                onChanged: (v) => setState(() => _rememberMe = v ?? true),
                              ),
                              const Text('Se souvenir de moi', style: TextStyle(fontSize: 12.5)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Lien de réinitialisation envoyé par e-mail.')),
                            );
                          },
                          child: const Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(color: C.orangeGold, fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    BatixBtn(
                      label: 'Se connecter',
                      icon: Icons.arrow_forward_rounded,
                      isOrange: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileChoiceScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: C.greenLight, width: 1.3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileChoiceScreen()),
                      ),
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 30, color: C.orangeGold),
                      label: const Text(
                        'Se connecter avec Google',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Pas encore de compte ? ', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          ),
                          child: const Text(
                            "S'inscrire",
                            style: TextStyle(color: C.greenLight, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/// Écran d'inscription complet
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _selectedRole = 'Client';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BatixScreenBg(
        bgFile: 'bg_02_sombre_rubans_vert_orange_1080x2400.png',
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(22),
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: BackButton(color: Colors.white),
              ),
              const BatixLogo(size: 72, showWordmark: false),
              const SizedBox(height: 14),
              batixCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Créer un compte BATIX',
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Rejoignez la plateforme BTP & Logistique',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        hintText: 'Nom complet ou Entreprise',
                        filled: true,
                        fillColor: C.bgInput,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone_outlined),
                        hintText: 'Téléphone (+237 6...)',
                        filled: true,
                        fillColor: C.bgInput,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        hintText: 'Adresse e-mail',
                        filled: true,
                        fillColor: C.bgInput,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      dropdownColor: C.bgCard,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.badge_outlined),
                        filled: true,
                        fillColor: C.bgInput,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      items: ['Client', 'Fournisseur', 'Transporteur / Livreur', 'Agent BATIX']
                          .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedRole = v ?? 'Client'),
                    ),
                    const SizedBox(height: 16),
                    BatixBtn(
                      label: 'Continuer vers les profils →',
                      isOrange: true,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileChoiceScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/// Écran 5 : Choisissez votre profil - 4 rôles (`05_Choix_Du_Profil_4_Roles.png`)
class ProfileChoiceScreen extends StatelessWidget {
  const ProfileChoiceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final roles = [
      {
        'title': 'Client',
        'desc': 'Trouvez et commandez vos matériaux.',
        'icon': Icons.person_rounded,
        'color': C.greenRole,
        'page': const ClientWorkspace(),
      },
      {
        'title': 'Fournisseur',
        'desc': 'Vendez vos matériaux aux professionnels.',
        'icon': Icons.factory_rounded,
        'color': C.orangeRole,
        'page': const SupplierWorkspace(),
      },
      {
        'title': 'Transporteur / Livreur',
        'desc': 'Livrez en toute sécurité vos commandes.',
        'icon': Icons.local_shipping_rounded,
        'color': C.blueRole,
        'page': const DriverWorkspace(),
      },
      {
        'title': 'Agent BATIX',
        'desc': 'Gérez les inscriptions et le suivi.',
        'icon': Icons.verified_user_rounded,
        'color': C.purpleRole,
        'page': const AgentWorkspace(),
      },
    ];
    return Scaffold(
      body: BatixScreenBg(
        bgFile: 'bg_02_sombre_rubans_vert_orange_1080x2400.png',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 30),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const WelcomeAuthScreen()),
                          );
                        }
                      },
                    ),
                    const Expanded(
                      child: Center(child: BatixLogo(size: 60, showWordmark: false)),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Choisissez votre profil',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sélectionnez le profil qui correspond à votre activité.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.84,
                    children: roles.map((r) {
                      return GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => r['page'] as Widget),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.22),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: r['color'] as Color,
                                child: Icon(r['icon'] as IconData, color: Colors.white, size: 28),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                r['title'] as String,
                                style: const TextStyle(
                                  color: C.textDarkPrimary,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Text(
                                  r['desc'] as String,
                                  style: const TextStyle(
                                    color: C.textDarkSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(Icons.chevron_right_rounded, color: C.textDarkPrimary),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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
/// Écran 6 : Menu Latéral Drawer (`06_Menu_Lateral_Drawer_Navigation.png`)
class BatixDrawerMenu extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String roleBadge;
  final Color roleColor;
  final ValueChanged<int>? onSelectTab;
  const BatixDrawerMenu({
    super.key,
    this.userName = 'Utilisateur',
    this.userEmail = 'client@batix.com',
    this.roleBadge = 'Client',
    this.roleColor = C.greenRole,
    this.onSelectTab,
  });
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: C.bgDark,
      child: BatixScreenBg(
        bgFile: 'bg_02_sombre_rubans_vert_orange_1080x2400.png',
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person_rounded, size: 34, color: C.textDarkPrimary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            userEmail,
                            style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                          ),
                          const SizedBox(height: 4),
                          batixBadge(roleBadge, roleColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  children: [
                    _drawerItem(
                      context,
                      icon: Icons.home_rounded,
                      label: 'Accueil',
                      selected: true,
                      onTap: () {
                        Navigator.pop(context);
                        onSelectTab?.call(0);
                      },
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.inventory_2_outlined,
                      label: 'Mes commandes',
                      onTap: () {
                        Navigator.pop(context);
                        onSelectTab?.call(1);
                      },
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.local_shipping_outlined,
                      label: 'Suivi des livraisons',
                      onTap: () {
                        Navigator.pop(context);
                        onSelectTab?.call(2);
                      },
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.construction_rounded,
                      label: 'Mes chantiers',
                      onTap: () {
                        Navigator.pop(context);
                        onSelectTab?.call(2);
                      },
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.grid_view_rounded,
                      label: 'Catalogue',
                      onTap: () {
                        Navigator.pop(context);
                        onSelectTab?.call(1);
                      },
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.receipt_long_outlined,
                      label: 'Factures',
                      onTap: () => Navigator.pop(context),
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.headset_mic_outlined,
                      label: 'Support',
                      onTap: () => Navigator.pop(context),
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.settings_outlined,
                      label: 'Paramètres',
                      onTap: () {
                        Navigator.pop(context);
                        onSelectTab?.call(3);
                      },
                    ),
                    const Divider(color: Colors.white12),
                    _drawerItem(
                      context,
                      icon: Icons.swap_horiz_rounded,
                      label: 'Changer de profil (4 Rôles)',
                      color: C.orangeGold,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileChoiceScreen()),
                        );
                      },
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.logout_rounded,
                      label: 'Déconnexion',
                      color: C.red,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const WelcomeAuthScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 14),
                child: BatixLogo(size: 52, showWordmark: false, showSlogan: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool selected = false,
    Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected ? C.gradGreen : null,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.white, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.white,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PARTIE 2 & PARTIE 3 : ESPACE CLIENT (Mode Clair + Mode Sombre "Marché Intelligent")
// ============================================================================
class ClientWorkspace extends StatefulWidget {
  const ClientWorkspace({super.key});
  @override
  State<ClientWorkspace> createState() => _ClientWorkspaceState();
}

class _ClientWorkspaceState extends State<ClientWorkspace> {
  bool _darkMarket = false; // false = Mode Clair (Partie 2), true = Mode Sombre Marché Intelligent (Partie 3)
  int _tab = 0; // 0: Accueil, 1: Catalogue/Commandes, 2: Livraison, 3: Profil
  String _cat = 'Tous';
  String _search = '';
  bool _notifEnabled = true;
  final Map<String, int> _qty = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkMarket ? C.bgDark : C.bgLight,
      drawer: BatixDrawerMenu(
        onSelectTab: (i) => setState(() => _tab = i),
      ),
      appBar: AppBar(
        backgroundColor: _darkMarket ? C.bgDark : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: _darkMarket ? Colors.white : C.textDarkPrimary),
        title: BatixLogo(
          size: 36,
          showWordmark: false,
          subtitle: _darkMarket ? 'LE MARCHÉ INTELLIGENT' : 'ESPACE CLIENT',
          darkText: !_darkMarket,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: _darkMarket ? 'Passer en Mode Clair' : 'Passer au Marché Intelligent (Sombre)',
            icon: Icon(
              _darkMarket ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: C.orange,
            ),
            onPressed: () => setState(() => _darkMarket = !_darkMarket),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_none_rounded,
                  color: _darkMarket ? Colors.white : C.textDarkPrimary,
                ),
                onPressed: () => setState(() => _tab = 2),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(color: C.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          IconButton(
            tooltip: 'Changer de profil',
            icon: const Icon(Icons.swap_horiz_rounded, color: C.green),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileChoiceScreen()),
            ),
          ),
        ],
      ),
      body: _tab == 0
          ? (_darkMarket ? _buildDarkMarketHome() : _buildLightClientHome())
          : _tab == 1
              ? _buildCatalog()
              : _tab == 2
                  ? _buildTracking()
                  : _buildProfile(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: C.greenRole,
        onPressed: () => setState(() => _tab = 1),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: _darkMarket ? C.bgNavy : Colors.white,
        selectedItemColor: C.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Catalogue'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), label: 'Livraison'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
        ],
      ),
    );
  }
  /// PARTIE 2 : Accueil Client Mode Clair (`01_Accueil_Client_Clair_Categories_Actions.png`)
  Widget _buildLightClientHome() {
    final quickActions = [
      {
        'title': 'Commander\nun produit',
        'icon': Icons.shopping_cart_outlined,
        'color': C.greenRole,
        'tab': 1,
      },
      {
        'title': 'Suivre une\nlivraison',
        'icon': Icons.location_on_outlined,
        'color': C.orangeRole,
        'tab': 2,
      },
      {
        'title': 'Mes chantiers',
        'icon': Icons.construction_rounded,
        'color': C.blueRole,
        'tab': 2,
      },
      {
        'title': 'Mes commandes',
        'icon': Icons.receipt_long_rounded,
        'color': C.purpleRole,
        'tab': 1,
      },
    ];
    final categories = [
      {'name': 'Ciment', 'asset': 'produit_01_sac_ciment_50kg_cpj42_5.png'},
      {'name': 'Fer à béton', 'asset': 'produit_03_fer_a_beton_12mm.png'},
      {'name': 'Gravier', 'asset': 'produit_05_gravier_5_15_granulats.png'},
      {'name': 'Bois', 'asset': 'produit_06_bois_de_coffrage_25mm.png'},
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Bannière héroïque avec photo du camion (`banniere_02_accueil_camion_materiaux.png`)
        Container(
          height: 156,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: C.gradHeroBanner,
            boxShadow: [
              BoxShadow(
                color: C.greenDark.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 175,
                  child: BatixAsset(
                    'banniere_02_accueil_camion_materiaux.png',
                    fit: BoxFit.cover,
                    fallback: const Icon(Icons.local_shipping_rounded, size: 70, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xEE064E3B), Color(0xAA047857), Colors.transparent],
                      stops: [0.0, 0.58, 1.0],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Des matériaux\nau bon endroit,\nau bon moment !',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => setState(() => _tab = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: C.greenLight, width: 1.3),
                            color: Colors.black26,
                          ),
                          child: const Text(
                            'Voir nos services  →',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Grille 2x2 des 4 actions rapides
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: quickActions.map((a) {
            return GestureDetector(
              onTap: () => setState(() => _tab = a['tab'] as int),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: C.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: a['color'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(a['icon'] as IconData, color: Colors.white, size: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      a['title'] as String,
                      style: const TextStyle(
                        color: C.textDarkPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        // Section Nos catégories
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nos catégories',
              style: TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.w900,
                color: C.textDarkPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _tab = 1),
              child: const Text(
                'Voir tout →',
                style: TextStyle(
                  color: C.greenDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: categories.map((c) {
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _cat = c['name']!;
                  _tab = 1;
                }),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: C.borderLight),
                  ),
                  child: Column(
                    children: [
                      BatixAsset(
                        c['asset']!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        c['name']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: C.textDarkPrimary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        // Bannière bascule vers Le Marché Intelligent (Mode Sombre)
        GestureDetector(
          onTap: () => setState(() => _darkMarket = true),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: C.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: C.greenLight),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: C.orangeGold),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Activer le mode "Le Marché Intelligent" (Sombre + Comparateur)',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.5),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: C.greenLight),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Produits populaires',
          style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w900,
            color: C.textDarkPrimary,
          ),
        ),
        const SizedBox(height: 10),
        ...Store.products.take(4).map(_productRow),
        const SizedBox(height: 24),
      ],
    );
  }
  /// PARTIE 3 : Accueil Mode Sombre "Le Marché Intelligent" (`01_Accueil_Marche_Intelligent_Sombre.png`)
  Widget _buildDarkMarketHome() {
    final cats = [
      {'label': 'Tout', 'cat': 'Tous', 'icon': Icons.grid_view_rounded},
      {'label': 'Ciment', 'cat': 'Ciment', 'icon': Icons.inventory_2_rounded},
      {'label': 'Fer', 'cat': 'Fer à béton', 'icon': Icons.linear_scale_rounded},
      {'label': 'Gravier', 'cat': 'Gravier', 'icon': Icons.landscape_rounded},
      {'label': 'Brique', 'cat': 'Brique', 'icon': Icons.view_module_rounded},
    ];
    final featured = [Store.products[0], Store.products[1]];
    final novelties = [Store.products[3], Store.products[5]];
    return BatixScreenBg(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Barre de recherche sombre
          TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70),
              hintText: 'Rechercher un produit...',
              filled: true,
              fillColor: C.bgInput,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: C.border),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Cercles de catégories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: cats.map((c) {
              final selected = _cat == c['cat'];
              return GestureDetector(
                onTap: () => setState(() {
                  _cat = c['cat'] as String;
                  _tab = 1;
                }),
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? C.greenRole : C.bgCard,
                        border: Border.all(
                          color: selected ? C.greenLight : C.borderSubtle,
                          width: 1.6,
                        ),
                      ),
                      child: Icon(
                        c['icon'] as IconData,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      c['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        color: selected ? C.greenLight : Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Produits en vedette
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Produits en vedette',
                style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w800),
              ),
              GestureDetector(
                onTap: () => setState(() => _tab = 1),
                child: const Text(
                  'Voir tout >',
                  style: TextStyle(color: C.greenLight, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: featured.map((p) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: p == featured.first ? 6 : 0, left: p == featured.last ? 6 : 0),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: C.bgCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: C.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BatixAsset(
                        p.id == 'P1' ? 'produit_02_palette_sacs_ciment_cpj42_5.png' : p.asset,
                        height: 95,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        radius: BorderRadius.circular(12),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${p.priceDark} FCFA / ${p.unit}',
                        style: const TextStyle(
                          color: C.orangeGold,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ComparatorScreen(product: p, qty: _qty[p.id] ?? 20),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            gradient: C.gradGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Voir détails',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Nouveautés
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nouveautés',
                style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w800),
              ),
              GestureDetector(
                onTap: () => setState(() => _tab = 1),
                child: const Text(
                  'Voir tout >',
                  style: TextStyle(color: C.greenLight, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: novelties.map((p) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ComparatorScreen(product: p, qty: 10)),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(right: p == novelties.first ? 6 : 0, left: p == novelties.last ? 6 : 0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: C.bgCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: C.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BatixAsset(
                          p.asset,
                          height: 85,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          radius: BorderRadius.circular(12),
                        ),
                        const SizedBox(height: 6),
                        Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text(
                          '${p.priceDark} FCFA / ${p.unit}',
                          style: const TextStyle(color: C.orangeGold, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  /// Catalogue & Liste Produits BTP (`02_Liste_Produits_BTP_Clair.png` & `03_Catalogue_Et_Commandes_Quantites_Panier.png`)
  Widget _buildCatalog() {
    final cats = ['Tous', 'Ciment', 'Fer à béton', 'Gravier', 'Bois', 'Brique', 'Sable'];
    final list = Store.products.where((p) {
      final matchCat = _cat == 'Tous' || p.cat == _cat;
      final matchSearch = _search.isEmpty || p.name.toLowerCase().contains(_search.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            style: TextStyle(color: _darkMarket ? Colors.white : C.textDarkPrimary),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search_rounded, color: _darkMarket ? Colors.white70 : Colors.black54),
              suffixIcon: Icon(Icons.tune_rounded, color: _darkMarket ? C.greenLight : C.textDarkPrimary),
              hintText: 'Rechercher un produit, une catégorie...',
              hintStyle: TextStyle(color: _darkMarket ? Colors.white54 : Colors.black45),
              filled: true,
              fillColor: _darkMarket ? C.bgInput : Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: _darkMarket ? C.border : C.borderLight),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 46,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            children: cats
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _cat == c,
                      selectedColor: C.greenRole,
                      labelStyle: TextStyle(
                        color: _cat == c
                            ? Colors.white
                            : (_darkMarket ? Colors.white70 : C.textDarkPrimary),
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => _cat = c),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: list.map(_productRow).toList(),
          ),
        ),
      ],
    );
  }

  Widget _productRow(Product p) {
    final q = _qty[p.id] ?? 1;
    final price = _darkMarket ? p.priceDark : p.priceLight;
    return batixCard(
      color: _darkMarket ? C.bgCard : Colors.white,
      borderColor: _darkMarket ? C.border : C.borderLight,
      child: Row(
        children: [
          BatixAsset(
            p.asset,
            width: 68,
            height: 68,
            fit: BoxFit.cover,
            radius: BorderRadius.circular(14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                    color: _darkMarket ? Colors.white : C.textDarkPrimary,
                  ),
                ),
                Text(
                  p.sub,
                  style: TextStyle(
                    fontSize: 12,
                    color: _darkMarket ? Colors.white60 : C.textDarkSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$price FCFA / ${p.unit}',
                  style: TextStyle(
                    color: _darkMarket ? C.orangeGold : C.greenDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: _darkMarket ? C.bgInput : C.bgLightInput,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 30),
                            icon: const Icon(Icons.remove, size: 16, color: C.green),
                            onPressed: () => setState(() => _qty[p.id] = max(1, q - 1)),
                          ),
                          Text(
                            '$q',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _darkMarket ? Colors.white : C.textDarkPrimary,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 30),
                            icon: const Icon(Icons.add, size: 16, color: C.green),
                            onPressed: () => setState(() => _qty[p.id] = q + 1),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: C.greenRole,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ComparatorScreen(product: p, qty: q)),
                      ),
                      child: const Text('Ajouter', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// Suivi de livraison Client (`03_Suivi_De_Commande_Temps_Reel_Moussa.png` & `04_Suivi_De_Livraison_Client_Carte.png`)
  Widget _buildTracking() {
    final o = Store.orders.first;
    return BatixScreenBg(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Suivi de commande',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    o.id,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              batixBadge(o.status, C.greenRole),
            ],
          ),
          const SizedBox(height: 12),
          GpsMapCard(
            title: o.dest,
            subtitle: 'Arrivée : 11:35 (30 min)',
            mapAsset: 'carte_gps_02_suivi_camion_vert_sombre.png',
            height: 185,
          ),
          const SizedBox(height: 12),
          const Stepper4Bar(
            step: 2,
            labels: ['Commande\nconfirmée', 'En\npréparation', 'En cours\nde livraison', 'Arrivée\nestimée'],
            times: ['10:24', '10:32', '11:05', '11:35 (30m)'],
          ),
          batixCard(
            child: Column(
              children: [
                Row(
                  children: [
                    const BatixAsset(
                      'avatar_06_chauffeur_livreur_batix.png',
                      width: 52,
                      height: 52,
                      radius: BorderRadius.all(Radius.circular(26)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Chauffeur', style: TextStyle(color: Colors.white60, fontSize: 11.5)),
                          Text(
                            o.driver,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16.5),
                          ),
                          const Text('⭐ 4.9', style: TextStyle(color: C.orangeGold, fontSize: 12.5)),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: C.bgInput,
                      child: IconButton(
                        icon: const Icon(Icons.phone_in_talk_rounded, color: C.greenLight, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Appel vers ${o.driver} (${o.phone})...')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: C.bgInput,
                      child: IconButton(
                        icon: const Icon(Icons.chat_bubble_outline_rounded, color: C.orangeGold, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white12, height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_shipping_rounded, color: C.greenLight),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Véhicule', style: TextStyle(color: Colors.white60, fontSize: 11.5)),
                            Text(o.plate, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    batixBadge('En route', C.greenDark),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: C.greenLight),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Adresse de livraison', style: TextStyle(color: Colors.white60, fontSize: 11.5)),
                          Text(o.dest, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(
                            '${o.phone} • Code secret : ${o.pin}',
                            style: const TextStyle(color: C.orangeGold, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BatixBtn(
            label: "Voir l'itinéraire sur la carte",
            icon: Icons.map_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DeliveryConfirmedCityScreen(order: o)),
            ),
          ),
          const SizedBox(height: 10),
          BatixBtn(
            label: 'Contacter le transporteur',
            icon: Icons.phone_rounded,
            isOrange: true,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Appel direct : ${o.driver} (${o.phone})')),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  /// Mon Profil Client (`07_Mon_Profil_Parametres_Clair.png`)
  Widget _buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        batixCard(
          color: Colors.white,
          borderColor: C.borderLight,
          child: ListTile(
            leading: const CircleAvatar(
              radius: 28,
              backgroundColor: C.bgLightInput,
              child: Icon(Icons.person_rounded, color: C.textDarkPrimary, size: 32),
            ),
            title: const Text(
              'Client Batix',
              style: TextStyle(color: C.textDarkPrimary, fontWeight: FontWeight.w900, fontSize: 16.5),
            ),
            subtitle: const Text('client@batix.com', style: TextStyle(color: C.textDarkSecondary)),
            trailing: batixBadge('Client', C.greenRole),
          ),
        ),
        batixCard(
          color: Colors.white,
          borderColor: C.borderLight,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              _profileOptionTile(Icons.person_outline_rounded, 'Informations personnelles'),
              const Divider(height: 1, color: C.borderLight),
              _profileOptionTile(Icons.location_on_outlined, 'Adresses de livraison'),
              const Divider(height: 1, color: C.borderLight),
              _profileOptionTile(Icons.inventory_2_outlined, 'Mes commandes', onTap: () => setState(() => _tab = 1)),
              const Divider(height: 1, color: C.borderLight),
              _profileOptionTile(Icons.construction_rounded, 'Mes chantiers', onTap: () => setState(() => _tab = 2)),
              const Divider(height: 1, color: C.borderLight),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_none_rounded, color: C.textDarkPrimary),
                title: const Text(
                  'Notifications',
                  style: TextStyle(color: C.textDarkPrimary, fontWeight: FontWeight.w600, fontSize: 14.5),
                ),
                activeColor: C.greenRole,
                value: _notifEnabled,
                onChanged: (v) => setState(() => _notifEnabled = v),
              ),
              const Divider(height: 1, color: C.borderLight),
              _profileOptionTile(Icons.help_outline_rounded, 'Aide & support'),
              const Divider(height: 1, color: C.borderLight),
              _profileOptionTile(Icons.info_outline_rounded, 'À propos de BATIX'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        BatixBtn(
          label: 'Changer de profil (Client / Fournisseur / Livreur / Agent)',
          icon: Icons.swap_horiz_rounded,
          isOrange: true,
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfileChoiceScreen()),
          ),
        ),
      ],
    );
  }

  Widget _profileOptionTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap ?? () {},
      leading: Icon(icon, color: C.textDarkPrimary),
      title: Text(
        title,
        style: const TextStyle(color: C.textDarkPrimary, fontWeight: FontWeight.w600, fontSize: 14.5),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: C.textDarkSecondary),
    );
  }
}
/// Écran Comparateur de Fournisseurs (`02_Produit_Ciment_Comparateur_Fournisseurs.png`)
class ComparatorScreen extends StatefulWidget {
  final Product product;
  final int qty;
  const ComparatorScreen({super.key, required this.product, required this.qty});
  @override
  State<ComparatorScreen> createState() => _ComparatorScreenState();
}

class _ComparatorScreenState extends State<ComparatorScreen> {
  int _selectedIdx = 0;
  late int _qty;
  @override
  void initState() {
    super.initState();
    _qty = widget.qty;
  }
  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final suppliers = [
      {'name': 'Fournisseur A', 'rate': '4.8', 'reviews': '120 avis', 'price': p.priceDark, 'dist': '1,2 km', 'time': '30 min'},
      {'name': 'Fournisseur B', 'rate': '4.5', 'reviews': '66 avis', 'price': p.priceDark + 150, 'dist': '2,5 km', 'time': '1 h'},
      {'name': 'Fournisseur C', 'rate': '4.6', 'reviews': '72 avis', 'price': p.priceDark + 290, 'dist': '4,8 km', 'time': '3 h'},
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.bgDark,
        title: Text('${p.cat} (${p.name})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: BatixScreenBg(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // En-tête produit avec photo extraite du pack
            batixCard(
              child: Row(
                children: [
                  BatixAsset(
                    p.id == 'P1' ? 'produit_02_palette_sacs_ciment_cpj42_5.png' : p.asset,
                    width: 88,
                    height: 80,
                    fit: BoxFit.cover,
                    radius: BorderRadius.circular(14),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(
                          '${p.priceDark} FCFA / ${p.unit}',
                          style: const TextStyle(color: C.orangeGold, fontSize: 15.5, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '⭐ ${p.rating}  (${p.reviews} avis)',
                          style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Sélecteur de quantité
            batixCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quantité (${p.unit}s) :', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: C.greenLight),
                        onPressed: () => setState(() => _qty = max(1, _qty - 5)),
                      ),
                      Text('$_qty', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: C.greenLight),
                        onPressed: () => setState(() => _qty += 5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fournisseurs disponibles', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    Text('📍 Dans votre zone', style: TextStyle(color: C.orangeGold, fontSize: 12.5)),
                  ],
                ),
                Icon(Icons.tune_rounded, color: Colors.white70),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(suppliers.length, (i) {
              final s = suppliers[i];
              final isSel = _selectedIdx == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedIdx = i),
                child: batixCard(
                  borderColor: isSel ? C.greenLight : C.border,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 23,
                        backgroundColor: C.greenRole,
                        child: Icon(Icons.local_shipping_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s['name'] as String,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5),
                            ),
                            Text(
                              '⭐ ${s['rate']} (${s['reviews']})',
                              style: const TextStyle(color: C.orangeGold, fontSize: 12),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${s['price']} FCFA / ${p.unit}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '📍 ${s['dist']}    🕒 ${s['time']}',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSel ? C.greenRole : C.bgInput,
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: C.greenLight),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () => setState(() => _selectedIdx = i),
                        child: Text(isSel ? 'Sélectionné' : 'Sélectionner'),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 10),
            BatixBtn(
              label: 'Confirmer la commande',
              icon: Icons.shopping_cart_checkout_rounded,
              onTap: () {
                final s = suppliers[_selectedIdx];
                final pin = (1000 + Random().nextInt(9000)).toString();
                final order = Order(
                  id: 'CMD-2025-00124',
                  delivId: 'LIV-2025-0055',
                  client: 'Bâtiment Horizon',
                  product: p.name,
                  qty: _qty,
                  unit: p.unit,
                  total: (s['price'] as int) * _qty,
                  supplier: s['name'] as String,
                  driver: 'Moussa',
                  phone: '(+237) 6 57 81 70 43',
                  plate: 'BA-5847-AC',
                  dest: 'Quartier Bastos, Yaoundé',
                  time: '17/10/2026 - 11:35',
                  pin: pin,
                  status: 'En cours',
                  asset: p.asset,
                );
                Store.orders.insert(0, order);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => OrderConfirmedScreen(order: order)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
/// Écran Commande Confirmée (`05_Commande_Confirmee_Sombre_Orange.png`)
class OrderConfirmedScreen extends StatelessWidget {
  final Order order;
  const OrderConfirmedScreen({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BatixScreenBg(
        bgFile: 'bg_06_confirmation_glow_emeraude_1080x2400.png',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: C.gradGreen,
                    boxShadow: [
                      BoxShadow(color: C.green.withOpacity(0.5), blurRadius: 24),
                    ],
                  ),
                  child: const Icon(Icons.check_rounded, size: 58, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Commande confirmée !',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Votre commande a bien été enregistrée.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 24),
                batixCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'N° ${order.id}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.white70),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: order.id));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Numéro de commande copié !')),
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white12),
                      Text(
                        'Total : ${order.total} FCFA',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Code secret de réception (4 chiffres) : ${order.pin}',
                        style: const TextStyle(color: C.orangeGold, fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                BatixBtn(
                  label: 'Voir mes commandes',
                  icon: Icons.arrow_forward_rounded,
                  isOrange: true,
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => DeliveryConfirmedCityScreen(order: order)),
                  ),
                ),
                const SizedBox(height: 12),
                BatixBtn(
                  label: "Retour à l'accueil",
                  icon: Icons.home_outlined,
                  outlined: true,
                  onTap: () => Navigator.pop(context),
                ),
                const Spacer(),
                const BatixLogo(size: 56, showWordmark: false, showSlogan: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/// Écran Livraison Confirmée avec camion au couchant (`04_Livraison_Confirmee_Camion_Ville.png`)
class DeliveryConfirmedCityScreen extends StatelessWidget {
  final Order order;
  const DeliveryConfirmedCityScreen({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BatixScreenBg(
        bgFile: 'bg_06_confirmation_glow_emeraude_1080x2400.png',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const BatixLogo(size: 56, showWordmark: false, subtitle: 'LE MARCHÉ INTELLIGENT'),
                const SizedBox(height: 16),
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: C.gradGreen,
                    boxShadow: [BoxShadow(color: C.green.withOpacity(0.5), blurRadius: 24)],
                  ),
                  child: const Icon(Icons.check_rounded, size: 54, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Livraison confirmée !',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Votre commande a été livrée avec succès.\nMerci de votre confiance !',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                ),
                const SizedBox(height: 18),
                batixCard(
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: C.greenDark,
                          child: Icon(Icons.receipt_long_rounded, color: Colors.white),
                        ),
                        title: Text(
                          'Commande N° ${order.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(order.time, style: const TextStyle(color: Colors.white70)),
                      ),
                      const Divider(color: Colors.white12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: C.greenRole,
                          child: Icon(Icons.inventory_2_rounded, color: C.orangeGold),
                        ),
                        title: const Text('Produit', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${order.qty} ${order.unit} de ${order.product}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.5),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total payé', style: TextStyle(color: Colors.white70)),
                                Text(
                                  '${order.total} FCFA',
                                  style: const TextStyle(color: C.orangeGold, fontWeight: FontWeight.w900, fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                BatixAsset(
                  'banniere_05_camion_batix_ville_couchant.png',
                  height: 95,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  radius: BorderRadius.circular(16),
                ),
                const SizedBox(height: 14),
                BatixBtn(
                  label: "Retour à l'accueil",
                  icon: Icons.home_rounded,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PARTIE 4 : ESPACE FOURNISSEUR (Ciment Horizon - Produits, Excel, Commandes, Flotte)
// ============================================================================
class SupplierWorkspace extends StatefulWidget {
  const SupplierWorkspace({super.key});
  @override
  State<SupplierWorkspace> createState() => _SupplierWorkspaceState();
}

class _SupplierWorkspaceState extends State<SupplierWorkspace> {
  int _tab = 0; // 0: Accueil, 1: Produits, 2: Commandes, 3: Livreurs, 4: Profil
  String _stockFilter = 'Tous';
  String _orderFilter = 'En cours';
  String _driverFilter = 'En activité';
  String _searchProd = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BatixDrawerMenu(
        userName: 'Ciment Horizon',
        userEmail: 'fournisseur@batix.com',
        roleBadge: 'Fournisseur',
        roleColor: C.orangeRole,
        onSelectTab: (i) => setState(() => _tab = i),
      ),
      appBar: AppBar(
        backgroundColor: C.bgDark,
        centerTitle: true,
        title: const BatixLogo(size: 34, showWordmark: false, subtitle: 'ESPACE FOURNISSEUR'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                onPressed: () => setState(() => _tab = 2),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(color: C.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          IconButton(
            tooltip: 'Changer de profil',
            icon: const Icon(Icons.swap_horiz_rounded, color: C.greenLight),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileChoiceScreen()),
            ),
          ),
        ],
      ),
      body: BatixScreenBg(
        child: _tab == 0
            ? _buildOverview()
            : _tab == 1
                ? _buildProducts()
                : _tab == 2
                    ? _buildOrders()
                    : _tab == 3
                        ? _buildDrivers()
                        : _buildSupplierProfile(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: C.bgNavy,
        selectedItemColor: C.greenLight,
        unselectedItemColor: Colors.white54,
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_rounded), label: 'Produits'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Commandes'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping_rounded), label: 'Livreurs'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
        ],
      ),
    );
  }
  /// Onglet 1 : Dashboard Fournisseur Vue d'ensemble (`01_Dashboard_Fournisseur_Vue_Ensemble.png` & `09_Espace_Fournisseur_Synthese_KPIs.png`)
  Widget _buildOverview() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        batixCard(
          child: Row(
            children: [
              const BatixAsset(
                'avatar_06_chauffeur_livreur_batix.png',
                width: 52,
                height: 52,
                radius: BorderRadius.all(Radius.circular(26)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ciment Horizon',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17.5),
                    ),
                    Text('Fournisseur A', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
              batixBadge('En ligne', C.greenRole),
            ],
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Vue d'ensemble", style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w800)),
                Text("Aujourd'hui - 17 Oct 2026", style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
            Text('↗ 12%', style: TextStyle(color: C.greenLight, fontWeight: FontWeight.w900, fontSize: 15)),
          ],
        ),
        const SizedBox(height: 12),
        _kpi("Ventes aujourd'hui", '248 500 FCFA', '12 commandes', C.greenRole, Icons.trending_up_rounded),
        _kpi('Commandes en cours', '7', 'En livraison / préparation', C.blueRole, Icons.local_shipping_rounded),
        _kpi('En attente de confirmation', '3', 'À valider', C.orangeRole, Icons.access_time_rounded),
        _kpi('Livraisons terminées', '9', "Aujourd'hui", C.greenRole, Icons.check_circle_rounded),
        const SizedBox(height: 8),
        const Text('Raccourcis', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Row(
          children: [
            _shortcutBtn('Mes produits', Icons.inventory_2_outlined, () => setState(() => _tab = 1)),
            _shortcutBtn('Commandes', Icons.receipt_long_outlined, () => setState(() => _tab = 2)),
            _shortcutBtn('Livreurs', Icons.local_shipping_outlined, () => setState(() => _tab = 3)),
            _shortcutBtn(
              'Import Excel',
              Icons.table_view_rounded,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupplierExcelImportScreen())),
            ),
          ],
        ),
        const SizedBox(height: 18),
        // Synthèse mensuelle (Planche 10 Écran 5)
        const Text('Synthèse mensuelle', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.75,
          children: [
            _miniStatCard('Mes produits', '${Store.products.length}', C.greenRole, Icons.inventory_2_rounded),
            _miniStatCard('Commandes en cours', '8', C.orangeRole, Icons.assignment_rounded),
            _miniStatCard('Ventes du mois', '1 245 000 FCFA', C.blueRole, Icons.payments_rounded, sub: '+12%'),
            _miniStatCard('Clients actifs', '56', C.blueRole, Icons.groups_rounded),
          ],
        ),
      ],
    );
  }

  Widget _kpi(String title, String val, String sub, Color col, IconData icon) {
    return batixCard(
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundColor: col, child: Icon(icon, color: Colors.white, size: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                const SizedBox(height: 2),
                Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                Text(sub, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shortcutBtn(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: C.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: C.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: C.greenLight, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStatCard(String label, String val, Color col, IconData icon, {String? sub}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: C.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.border),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: col, child: Icon(icon, color: Colors.white, size: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                Text(val, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                if (sub != null) Text(sub, style: const TextStyle(fontSize: 11, color: C.greenLight, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// Onglet 2 : Mes Produits (`02_Mes_Produits_Gestion_Stock.png`)
  Widget _buildProducts() {
    final filters = ['Tous', 'En stock', 'En rupture'];
    final list = Store.products.where((p) {
      if (_stockFilter == 'En stock' && p.stock <= 0) return false;
      if (_stockFilter == 'En rupture' && p.stock > 50) return false;
      if (_searchProd.isNotEmpty && !p.name.toLowerCase().contains(_searchProd.toLowerCase())) return false;
      return true;
    }).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          onChanged: (v) => setState(() => _searchProd = v),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70),
            suffixIcon: const Icon(Icons.filter_list_rounded, color: Colors.white70),
            hintText: 'Rechercher un produit...',
            filled: true,
            fillColor: C.bgInput,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: C.border),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ...filters.map((f) {
              final sel = _stockFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(f),
                  selected: sel,
                  selectedColor: C.greenRole,
                  onSelected: (_) => setState(() => _stockFilter = f),
                ),
              );
            }),
            const Spacer(),
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SupplierExcelImportScreen()),
              ),
              icon: const Icon(Icons.upload_file_rounded, color: C.greenLight, size: 18),
              label: const Text('Excel', style: TextStyle(color: C.greenLight, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...list.map((p) {
          final isLow = p.stock <= p.threshold;
          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SupplierEditProductScreen(product: p)),
              );
              setState(() {});
            },
            child: batixCard(
              child: Row(
                children: [
                  BatixAsset(
                    p.asset,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    radius: BorderRadius.circular(12),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
                        const SizedBox(height: 2),
                        Text('Stock : ${p.stock} ${p.unit}s', style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                        const SizedBox(height: 4),
                        Text(
                          '${p.priceDark} FCFA / ${p.unit}',
                          style: const TextStyle(color: C.orangeGold, fontWeight: FontWeight.w900, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.chevron_right_rounded, color: Colors.white54),
                      const SizedBox(height: 12),
                      batixBadge(
                        isLow ? 'Stock faible' : 'En stock',
                        isLow ? C.orangeRole : C.greenRole,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
  /// Onglet 3 : Mes Commandes Fournisseur (`05_Mes_Commandes_Fournisseur_Statuts.png`)
  Widget _buildOrders() {
    final filters = ['En cours', 'En attente', 'Terminées'];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: filters.map((f) {
            final sel = _orderFilter == f;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(f == 'En cours' ? 'En cours (7)' : f == 'En attente' ? 'En attente (3)' : f),
                selected: sel,
                selectedColor: C.greenRole,
                onSelected: (_) => setState(() => _orderFilter = f),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        ...Store.orders.map((o) {
          Color badgeCol = C.blueRole;
          if (o.status == 'En livraison' || o.status == 'Livrée') badgeCol = C.greenRole;
          if (o.status.contains('attente')) badgeCol = C.orangeRole;
          return batixCard(
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: badgeCol.withOpacity(0.25),
                      child: Icon(
                        o.status.contains('attente')
                            ? Icons.access_time_rounded
                            : Icons.local_shipping_rounded,
                        color: badgeCol,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('#${o.id}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5)),
                              batixBadge(o.status, badgeCol),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('${o.product} (${o.qty} ${o.unit})', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text('${o.total} FCFA', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                          Text(o.time, style: const TextStyle(color: Colors.white54, fontSize: 11.5)),
                        ],
                      ),
                    ),
                  ],
                ),
                if (o.status.contains('attente')) ...[
                  const SizedBox(height: 10),
                  BatixBtn(
                    height: 42,
                    label: 'Confirmer la commande (15 min max)',
                    icon: Icons.check_circle_outline_rounded,
                    onTap: () => setState(() => o.status = 'En préparation'),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
  /// Onglet 4 : Mes Livreurs (`06_Mes_Livreurs_Flotte_Et_Carte.png`)
  Widget _buildDrivers() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: ['En activité', 'Tous'].map((f) {
            final sel = _driverFilter == f;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(f == 'En activité' ? 'En activité (3)' : 'Tous (5)'),
                selected: sel,
                selectedColor: C.greenRole,
                onSelected: (_) => setState(() => _driverFilter = f),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        ...Store.drivers.map((d) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SupplierDriverDetailScreen(driver: d)),
            ),
            child: batixCard(
              child: Row(
                children: [
                  const BatixAsset(
                    'avatar_06_chauffeur_livreur_batix.png',
                    width: 50,
                    height: 50,
                    radius: BorderRadius.all(Radius.circular(25)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
                        Text(d.phone, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.local_shipping_rounded, color: C.greenLight, size: 15),
                            const SizedBox(width: 4),
                            Text(
                              d.status,
                              style: const TextStyle(color: C.greenLight, fontSize: 12.5, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.chevron_right_rounded, color: Colors.white54),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: C.greenRole,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SupplierDriverContactScreen(driver: d)),
                        ),
                        child: const Text('Appeler', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        const Text('Suivi des trajets', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SupplierDriverDetailScreen(driver: Store.drivers.first)),
          ),
          child: const GpsMapCard(
            title: 'Yannick M. • En livraison • 12 min',
            subtitle: 'Voir le trajet →',
            mapAsset: 'carte_gps_02_suivi_camion_vert_sombre.png',
            height: 175,
          ),
        ),
      ],
    );
  }

  Widget _buildSupplierProfile() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        batixCard(
          child: ListTile(
            leading: const CircleAvatar(
              radius: 26,
              backgroundColor: C.orangeRole,
              child: Icon(Icons.factory_rounded, color: Colors.white),
            ),
            title: const Text('Ciment Horizon (Fournisseur A)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Entrepôt Zone Industrielle • Yaoundé / Douala'),
            trailing: batixBadge('Vérifié', C.greenRole),
          ),
        ),
        BatixBtn(
          label: 'Importer un catalogue Excel (.xlsx, .xls)',
          icon: Icons.upload_file_rounded,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SupplierExcelImportScreen()),
          ),
        ),
      ],
    );
  }
}
/// Écran Modifier un produit (`03_Modifier_Un_Produit_Prix_Stock.png`)
class SupplierEditProductScreen extends StatefulWidget {
  final Product product;
  const SupplierEditProductScreen({super.key, required this.product});
  @override
  State<SupplierEditProductScreen> createState() => _SupplierEditProductScreenState();
}

class _SupplierEditProductScreenState extends State<SupplierEditProductScreen> {
  late int _price;
  late int _stock;
  late int _threshold;
  late bool _active;
  late String _category;
  late TextEditingController _descCtrl;
  @override
  void initState() {
    super.initState();
    _price = widget.product.priceDark;
    _stock = widget.product.stock;
    _threshold = widget.product.threshold;
    _active = widget.product.active;
    _category = widget.product.cat;
    _descCtrl = TextEditingController(text: widget.product.desc);
  }
  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(backgroundColor: C.bgDark, title: const Text('Modifier un produit')),
      body: BatixScreenBg(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            batixCard(
              child: Row(
                children: [
                  BatixAsset(
                    p.asset,
                    width: 78,
                    height: 78,
                    fit: BoxFit.cover,
                    radius: BorderRadius.circular(14),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 6),
                        batixBadge('En stock', C.greenRole),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            batixCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _stepperField('Prix unitaire (FCFA)', _price, 100, (v) => setState(() => _price = max(50, v))),
                  const SizedBox(height: 12),
                  _stepperField('Quantité en stock', _stock, 10, (v) => setState(() => _stock = max(0, v))),
                  const SizedBox(height: 12),
                  _stepperField("Seuil d'alerte stock", _threshold, 5, (v) => setState(() => _threshold = max(0, v))),
                  const Divider(color: Colors.white12, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Statut du produit', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: C.greenLight, size: 16),
                          const SizedBox(width: 4),
                          Text(_active ? 'Actif' : 'Inactif', style: const TextStyle(color: C.greenLight)),
                          Switch(
                            value: _active,
                            activeColor: C.greenRole,
                            onChanged: (v) => setState(() => _active = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Catégorie', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _category,
                    dropdownColor: C.bgCard,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: C.bgInput,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: ['Ciment', 'Fer à béton', 'Gravier', 'Bois', 'Brique', 'Sable']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v ?? p.cat),
                  ),
                  const SizedBox(height: 12),
                  const Text('Description', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: C.bgInput,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            BatixBtn(
              label: 'Enregistrer les modifications',
              onTap: () {
                p.priceDark = _price;
                p.stock = _stock;
                p.threshold = _threshold;
                p.active = _active;
                p.cat = _category;
                p.desc = _descCtrl.text;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${p.name} mis à jour avec succès !')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepperField(String label, int val, int step, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: C.bgInput,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.borderSubtle),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$val',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_rounded, color: Colors.white70),
                onPressed: () => onChanged(val - step),
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded, color: C.greenLight),
                onPressed: () => onChanged(val + step),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
/// Écran Importer des produits Excel (`04_Importer_Des_Produits_Excel.png`)
class SupplierExcelImportScreen extends StatelessWidget {
  const SupplierExcelImportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final fields = ['Nom du produit', 'Prix unitaire', 'Quantité en stock', 'Catégorie'];
    return Scaffold(
      appBar: AppBar(backgroundColor: C.bgDark, title: const Text('Importer des produits')),
      body: BatixScreenBg(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            batixCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: C.greenRole.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: C.greenLight),
                    ),
                    child: const Center(
                      child: Text(
                        'X',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: C.greenLight),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Importer une liste Excel',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Ajoutez ou mettez à jour vos produits en\nun seul clic.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  BatixBtn(
                    label: 'Choisir un fichier Excel',
                    icon: Icons.cloud_upload_rounded,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fichier catalogue_batix_2026.xlsx chargé !')),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Formats acceptés : .xlsx, .xls (max 5 Mo)',
                    style: TextStyle(color: Colors.white54, fontSize: 11.5),
                  ),
                ],
              ),
            ),
            batixCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Aperçu des données',
                    style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  ...fields.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: C.greenLight, size: 22),
                          const SizedBox(width: 10),
                          Text(f, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            BatixBtn(
              label: 'Mettre à jour le stock',
              icon: Icons.sync_rounded,
              outlined: true,
              onTap: () {
                for (final p in Store.products) {
                  p.stock += 25;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stock synchronisé (+25 unités par référence) !')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
/// Écran Détails du livreur (`07_Details_Du_Livreur_Suivi_Trajet.png`)
class SupplierDriverDetailScreen extends StatelessWidget {
  final DriverInfo driver;
  const SupplierDriverDetailScreen({super.key, required this.driver});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: C.bgDark, title: const Text('Détails du livreur')),
      body: BatixScreenBg(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            batixCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      const BatixAsset(
                        'avatar_06_chauffeur_livreur_batix.png',
                        width: 64,
                        height: 64,
                        radius: BorderRadius.all(Radius.circular(32)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(driver.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 2),
                            Text(
                              '⭐ ${driver.rating} (${driver.deliveriesCount} livraisons)',
                              style: const TextStyle(color: C.orangeGold, fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            batixBadge(driver.status, C.greenRole),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: BatixBtn(
                          height: 44,
                          label: 'Appeler',
                          icon: Icons.phone_rounded,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SupplierDriverContactScreen(driver: driver)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: BatixBtn(
                          height: 44,
                          label: 'Message',
                          icon: Icons.chat_bubble_outline_rounded,
                          outlined: true,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SupplierDriverContactScreen(driver: driver)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Text('Trajet en cours', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            GpsMapCard(
              title: '${driver.duration} • ${driver.distance}',
              subtitle: driver.status,
              mapAsset: 'carte_gps_02_suivi_camion_vert_sombre.png',
              height: 190,
            ),
            const SizedBox(height: 12),
            batixCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: C.bgInput,
                  child: Icon(Icons.location_on_rounded, color: Colors.white),
                ),
                title: const Text('Prochaine étape • Livraison chez le client', style: TextStyle(color: Colors.white70, fontSize: 12)),
                subtitle: Text(
                  driver.nextStop,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/// Écran Contacter le livreur (`08_Contacter_Le_Livreur_Actions_Rapides.png`)
class SupplierDriverContactScreen extends StatelessWidget {
  final DriverInfo driver;
  const SupplierDriverContactScreen({super.key, required this.driver});
  @override
  Widget build(BuildContext context) {
    final actions = [
      {'title': 'Appeler', 'icon': Icons.phone_rounded, 'color': C.greenRole},
      {'title': 'WhatsApp', 'icon': Icons.chat_rounded, 'color': C.whatsapp},
      {'title': 'Envoyer un\nmessage', 'icon': Icons.sms_rounded, 'color': C.orangeRole},
      {'title': 'Voir le trajet', 'icon': Icons.location_on_rounded, 'color': C.purpleRole},
    ];
    return Scaffold(
      appBar: AppBar(backgroundColor: C.bgDark, title: const Text('Contacter le livreur')),
      body: BatixScreenBg(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              batixCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const BatixAsset(
                      'avatar_06_chauffeur_livreur_batix.png',
                      width: 68,
                      height: 68,
                      radius: BorderRadius.all(Radius.circular(34)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(driver.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text(
                            driver.status,
                            style: const TextStyle(color: C.greenLight, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('📞 ${driver.phone}', style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.08,
                  children: actions.map((a) {
                    return GestureDetector(
                      onTap: () {
                        if (a['title'] == 'Voir le trajet') {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${a['title']} -> ${driver.name} (${driver.phone})')),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: a['color'] as Color,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (a['color'] as Color).withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(a['icon'] as IconData, color: Colors.white, size: 42),
                            const SizedBox(height: 10),
                            Text(
                              a['title'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              BatixBtn(
                label: '←  Retour',
                outlined: true,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PARTIE 5 : ESPACE CHAUFFEUR / LIVRAISON GPS (Bienvenue Moussa + 5 Étapes + Mode Clair)
// ============================================================================
class DriverWorkspace extends StatefulWidget {
  const DriverWorkspace({super.key});
  @override
  State<DriverWorkspace> createState() => _DriverWorkspaceState();
}

class _DriverWorkspaceState extends State<DriverWorkspace> {
  int _tab = 1; // 0: Accueil, 1: Livraisons, 2: Carte, 3: Profil
  bool _lightTransporterView = false; // Bascule vers `07_Espace_Transporteur_Livraison_En_Cours_Clair.png`
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightTransporterView ? C.bgLight : C.bgDark,
      drawer: const BatixDrawerMenu(
        userName: 'Moussa (Chauffeur)',
        userEmail: 'moussa.driver@batix.com',
        roleBadge: 'Transporteur',
        roleColor: C.blueRole,
      ),
      appBar: AppBar(
        backgroundColor: C.bgDark,
        centerTitle: true,
        title: const BatixLogo(size: 34, showWordmark: false, subtitle: 'ESPACE CHAUFFEUR GPS'),
        actions: [
          IconButton(
            tooltip: 'Mode Sombre / Clair Transporteur',
            icon: Icon(
              _lightTransporterView ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: C.orangeGold,
            ),
            onPressed: () => setState(() => _lightTransporterView = !_lightTransporterView),
          ),
          IconButton(
            tooltip: 'Changer de profil',
            icon: const Icon(Icons.swap_horiz_rounded, color: C.greenLight),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileChoiceScreen()),
            ),
          ),
        ],
      ),
      body: _lightTransporterView ? _buildLightTransporterScreen() : _buildDarkDriverWelcome(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: _lightTransporterView ? Colors.white : C.bgNavy,
        selectedItemColor: C.greenRole,
        unselectedItemColor: _lightTransporterView ? Colors.black54 : Colors.white54,
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping_rounded), label: 'Livraisons'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Carte'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
        ],
      ),
    );
  }
  /// Bienvenue Chauffeur (`01_Bienvenue_Chauffeur_Livraisons_Disponibles.png`)
  Widget _buildDarkDriverWelcome() {
    return BatixScreenBg(
      bgFile: 'bg_05_grille_technique_chauffeur_1080x2400.png',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Bonjour, Moussa ! 👋',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Text('En ligne ', style: TextStyle(color: Colors.white70, fontSize: 13.5)),
              Icon(Icons.circle, color: C.greenLight, size: 11),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: C.bgCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: C.greenLight),
            ),
            child: const Text(
              "Prêt pour vos livraisons d'aujourd'hui ? 🚚",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'LIVRAISONS DISPONIBLES',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.6),
          ),
          const Text(
            '3 opportunités proches',
            style: TextStyle(color: Colors.white70, fontSize: 12.5),
          ),
          const SizedBox(height: 12),
          ...Store.orders.take(3).map((o) {
            return batixCard(
              borderColor: o.isUrgent ? C.red.withOpacity(0.6) : C.border,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const BatixAsset(
                        'produit_09_colis_carton_livraison.png',
                        width: 38,
                        height: 38,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'N° ${o.delivId}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                            Text(
                              '${o.product} (${o.qty} ${o.unit})',
                              style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        o.distance,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Colors.white70, size: 17),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          o.dest,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: o.isUrgent ? C.red : C.orangeGold,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          o.eta,
                          style: TextStyle(
                            color: o.isUrgent ? C.red : Colors.white70,
                            fontWeight: o.isUrgent ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: C.greenRole,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DriverDeliveryWizard(order: o)),
                        ),
                        child: const Text('Accepter', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  /// Vue Espace Transporteur Mode Clair (`07_Espace_Transporteur_Livraison_En_Cours_Clair.png` / Planche 10 Écran 6)
  Widget _buildLightTransporterScreen() {
    final o = Store.orders.first;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        batixCard(
          color: Colors.white,
          borderColor: C.borderLight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: C.blueRole,
                    child: Icon(Icons.local_shipping_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Livraison en cours',
                          style: TextStyle(color: C.textDarkPrimary, fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                        Text(
                          'N° ${o.delivId}',
                          style: const TextStyle(color: C.textDarkSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  batixBadge('En cours', C.greenRole),
                ],
              ),
              const Divider(color: C.borderLight, height: 22),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Client', style: TextStyle(color: C.textDarkSecondary, fontSize: 11.5)),
                        Text(o.client, style: const TextStyle(color: C.textDarkPrimary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Point de départ', style: TextStyle(color: C.textDarkSecondary, fontSize: 11.5)),
                        Text(o.origin, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: C.textDarkPrimary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Destination', style: TextStyle(color: C.textDarkSecondary, fontSize: 11.5)),
              Text(o.dest, style: const TextStyle(color: C.textDarkPrimary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const GpsMapCard(
                title: 'Chantier Riviera Golf • En route',
                subtitle: 'GPS Actif',
                mapAsset: 'carte_gps_04_itineraire_mode_clair.png',
                height: 145,
              ),
              const SizedBox(height: 12),
              BatixBtn(
                label: "Voir l'itinéraire",
                icon: Icons.near_me_rounded,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DriverDeliveryWizard(order: o)),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: C.greenRole, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DriverDeliveryWizard(order: o)),
                ),
                icon: const Icon(Icons.check_rounded, color: C.greenRole),
                label: const Text(
                  'Confirmer la livraison',
                  style: TextStyle(color: C.textDarkPrimary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _lightProofBox(Icons.camera_alt_outlined, 'Photo', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => DriverDeliveryWizard(order: o)));
                  }),
                  _lightProofBox(Icons.videocam_outlined, 'Vidéo', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => DriverDeliveryWizard(order: o)));
                  }),
                  _lightProofBox(Icons.draw_outlined, 'Signature', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => DriverDeliveryWizard(order: o)));
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lightProofBox(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 92,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: C.bgLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, color: C.textDarkPrimary),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: C.textDarkPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
/// Parcours Chauffeur en 5 étapes (`02_Etape_1` -> `03_Etape_2` -> `04_Etape_3` -> `05_Etape_4` -> `06_Etape_Finale`)
class DriverDeliveryWizard extends StatefulWidget {
  final Order order;
  const DriverDeliveryWizard({super.key, required this.order});
  @override
  State<DriverDeliveryWizard> createState() => _DriverDeliveryWizardState();
}

class _DriverDeliveryWizardState extends State<DriverDeliveryWizard> {
  int _step = 0; // 0: Détails, 1: GPS 3D, 2: Preuve Photo, 3: Signature + Code 4 cases, 4: Livraison Finalisée 3D
  final ImagePicker _picker = ImagePicker();
  final List<TextEditingController> _pinCtrls = List.generate(4, (_) => TextEditingController());
  final List<Offset?> _signaturePoints = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      _pinCtrls[i].text = widget.order.pin[i];
    }
  }

  Future<void> _takeDirectPhoto(int numPhoto) async {
    try {
      final XFile? img = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      setState(() {
        final path = img?.path ?? 'Caméra_Directe_Photo_$numPhoto.jpg';
        if (numPhoto == 1) widget.order.p1 = path;
        if (numPhoto == 2) widget.order.p2 = path;
        if (numPhoto == 3) widget.order.p3 = path;
      });
    } catch (_) {
      setState(() {
        if (numPhoto == 1) widget.order.p1 = 'Caméra_Directe_Chargement.jpg';
        if (numPhoto == 2) widget.order.p2 = 'Caméra_Directe_Arrivée.jpg';
        if (numPhoto == 3) widget.order.p3 = 'Caméra_Directe_Déchargement.jpg';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.bgDark,
        centerTitle: true,
        title: _step == 0
            ? const Text('Détails de la livraison', style: TextStyle(fontWeight: FontWeight.bold))
            : const BatixLogo(size: 36, showWordmark: false),
        actions: [
          if (_step == 4)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(child: batixBadge('Terminé', C.greenRole)),
            ),
        ],
      ),
      body: BatixScreenBg(
        bgFile: _step == 4
            ? 'bg_06_confirmation_glow_emeraude_1080x2400.png'
            : 'bg_05_grille_technique_chauffeur_1080x2400.png',
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_step > 0 && _step < 4) ...[
              Stepper4Bar(
                step: _step,
                labels: const ['En route', 'Arrivée', 'Livraison', 'Signature'],
              ),
              const SizedBox(height: 10),
            ],
            // ÉTAPE 1 : Détails de la livraison (`02_Etape_1_Details_De_La_Livraison.png`)
            if (_step == 0) ...[
              batixCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const BatixAsset(
                            'produit_09_colis_carton_livraison.png',
                            width: 46,
                            height: 46,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'N° ${o.delivId}',
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                              ),
                              Text(
                                'Client : ${o.client}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                              const Text(
                                'Matériaux de construction',
                                style: TextStyle(color: Colors.white70, fontSize: 12.5),
                              ),
                            ],
                          ),
                        ),
                        batixBadge('À venir', C.greenRole),
                      ],
                    ),
                    const Divider(color: Colors.white12, height: 24),
                    _detailRow(Icons.location_on_outlined, o.dest),
                    const SizedBox(height: 8),
                    _detailRow(Icons.access_time_rounded, '10:30'),
                    const SizedBox(height: 8),
                    _detailRow(Icons.local_shipping_outlined, 'Ciment • Fer • Gravier (${o.qty} ${o.unit})'),
                  ],
                ),
              ),
              const Text('Itinéraire', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              GpsMapCard(
                title: o.dest,
                subtitle: o.distance,
                mapAsset: 'carte_gps_01_itineraire_sombre_3_points.png',
                height: 175,
              ),
              const SizedBox(height: 20),
              BatixBtn(
                label: 'Démarrer la livraison  →',
                onTap: () => setState(() => _step = 1),
              ),
            // ÉTAPE 2 : En route Navigation GPS 3D (`03_Etape_2_En_Route_Navigation_GPS_3D.png`)
            ] else if (_step == 1) ...[
              batixCard(
                child: const Row(
                  children: [
                    Icon(Icons.turn_right_rounded, color: Colors.white, size: 42),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tourner à droite à 500m',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '15 min restantes',
                            style: TextStyle(color: Colors.white70, fontSize: 13.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GpsMapCard(
                title: 'Navigation GPS 3D • Camion BATIX (${o.plate})',
                subtitle: 'En route',
                mapAsset: 'carte_gps_03_navigation_3d_camion_route.png',
                height: 270,
              ),
              const SizedBox(height: 18),
              BatixBtn(
                label: 'Arriver au chantier  →',
                onTap: () => setState(() => _step = 2),
              ),
            // ÉTAPE 3 : Preuve de livraison Photo (`04_Etape_3_Preuve_De_Livraison_Photo.png`)
            ] else if (_step == 2) ...[
              const Text(
                'Preuve de livraison',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              const Text(
                'Prendre une photo de la livraison',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
              ),
              const Text(
                'Preuve obligatoire pour valider la livraison',
                style: TextStyle(color: Colors.white60, fontSize: 12.5),
              ),
              const SizedBox(height: 12),
              Stack(
                children: [
                  BatixAsset(
                    'photo_06_preuve_livraison_palettes_ciment.png',
                    height: 165,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    radius: BorderRadius.circular(18),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.black87,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                        onPressed: () {
                          _takeDirectPhoto(1);
                          _takeDirectPhoto(2);
                          _takeDirectPhoto(3);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              BatixBtn(
                label: 'Prendre une photo (Caméra directe)',
                icon: Icons.camera_alt_outlined,
                outlined: true,
                onTap: () async {
                  await _takeDirectPhoto(1);
                  await _takeDirectPhoto(2);
                  await _takeDirectPhoto(3);
                },
              ),
              const SizedBox(height: 12),
              _photoBtn(1, '1. Photo au chargement (Matricule)', o.p1),
              _photoBtn(2, '2. Photo arrivée chantier', o.p2),
              _photoBtn(3, '3. Photo matériaux déchargés', o.p3),
              const SizedBox(height: 12),
              BatixBtn(
                label: 'Confirmer le déchargement  →',
                onTap: () {
                  if (o.p1 == null || o.p2 == null || o.p3 == null) {
                    setState(() {
                      o.p1 ??= 'Caméra_Directe_Chargement.jpg';
                      o.p2 ??= 'Caméra_Directe_Arrivée.jpg';
                      o.p3 ??= 'Caméra_Directe_Déchargement.jpg';
                    });
                  }
                  setState(() => _step = 3);
                },
              ),
            // ÉTAPE 4 : Signature & Validation Code PIN (`05_Etape_4_Signature_Client_Et_Code_PIN.png`)
            ] else if (_step == 3) ...[
              batixCard(
                color: Colors.white,
                borderColor: C.borderLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Faites signer le client',
                          style: TextStyle(
                            color: C.textDarkPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => setState(() {
                            _signaturePoints.clear();
                            o.signed = false;
                          }),
                          icon: const Icon(Icons.refresh_rounded, size: 16, color: C.textDarkSecondary),
                          label: const Text('Effacer', style: TextStyle(color: C.textDarkSecondary, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _signaturePoints.add(details.localPosition);
                          o.signed = true;
                        });
                      },
                      onPanEnd: (_) => _signaturePoints.add(null),
                      onTap: () => setState(() => o.signed = true),
                      child: Container(
                        height: 115,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: C.borderLight),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (_signaturePoints.isEmpty)
                              Center(
                                child: Opacity(
                                  opacity: o.signed ? 1.0 : 0.78,
                                  child: const BatixAsset(
                                    'ui_05_zone_signature_client_manuscrite.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            CustomPaint(
                              painter: _SignatureCanvasPainter(_signaturePoints),
                            ),
                            const Positioned(
                              right: 10,
                              bottom: 10,
                              child: Icon(Icons.edit_rounded, color: C.textDarkPrimary, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              batixCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Code de validation',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.5),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Le client doit confirmer avec le code secret',
                      style: TextStyle(color: Colors.white70, fontSize: 12.5),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (i) => SizedBox(
                          width: 58,
                          child: TextField(
                            controller: _pinCtrls[i],
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: C.bgInput,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: C.border),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              BatixBtn(
                label: 'Valider et terminer  →',
                onTap: () {
                  o.signed = true;
                  o.status = 'Livrée';
                  setState(() => _step = 4);
                },
              ),
            // ÉTAPE FINALE : Livraison Finalisée 3D (`06_Etape_Finale_Livraison_Finalisee_3D.png` / Planche 07)
            ] else ...[
              const SizedBox(height: 10),
              Center(
                child: BatixAsset(
                  'illustration_04_livraison_finalisee_camion_colis_3d.png',
                  height: 215,
                  fit: BoxFit.contain,
                  fallback: const CircleAvatar(
                    radius: 56,
                    backgroundColor: C.greenRole,
                    child: Icon(Icons.check_rounded, size: 68, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Livraison Finalisée !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                'Merci, la commande a été livrée et\nvalidée avec succès.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
              batixCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const BatixAsset(
                      'produit_09_colis_carton_livraison.png',
                      width: 46,
                      height: 46,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'N° ${o.delivId}',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                          Text('Client : ${o.client}', style: const TextStyle(color: Colors.white70)),
                          const Text(
                            'Heure de validation : 10:45',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded, color: C.greenLight, size: 30),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              BatixBtn(
                label: 'Fermer',
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              BatixBtn(
                label: "Retour à l'accueil",
                outlined: true,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _photoBtn(int idx, String label, String? val) {
    return batixCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          val != null ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
          color: val != null ? C.greenLight : C.orangeGold,
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
        subtitle: Text(
          val != null ? '✓ Capturée ($val)' : 'Aucune photo capturée',
          style: TextStyle(color: val != null ? C.greenLight : Colors.white54, fontSize: 12),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: C.greenRole,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _takeDirectPhoto(idx),
          child: const Text('Caméra'),
        ),
      ),
    );
  }
}

class _SignatureCanvasPainter extends CustomPainter {
  final List<Offset?> points;
  _SignatureCanvasPainter(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = C.textDarkPrimary
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ============================================================================
// CONSOLE AGENT BATIX (Supervision des inscriptions, 3 photos & codes secrets)
// ============================================================================
class AgentWorkspace extends StatelessWidget {
  const AgentWorkspace({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const BatixDrawerMenu(
        userName: 'Agent Contrôle BATIX',
        userEmail: 'agent@batix.com',
        roleBadge: 'Agent BATIX',
        roleColor: C.purpleRole,
      ),
      appBar: AppBar(
        backgroundColor: C.bgDark,
        title: const BatixLogo(size: 34, showWordmark: false, subtitle: 'CONSOLE AGENT BATIX'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, color: C.greenLight),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileChoiceScreen()),
            ),
          ),
        ],
      ),
      body: BatixScreenBg(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Audit des Livraisons, Preuves Photos & Codes Secrets',
              style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              'Contrôle en temps réel des 4 profils, des 3 photos obligatoires et des signatures clients.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 14),
            ...Store.orders.map((o) => batixCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          BatixAsset(
                            o.asset,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            radius: BorderRadius.circular(10),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${o.id} (${o.delivId})',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                                ),
                                Text(
                                  '${o.product} • ${o.qty} ${o.unit} • ${o.total} FCFA',
                                  style: const TextStyle(color: C.orangeGold, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          batixBadge(
                            o.status,
                            o.status == 'Livrée' ? C.greenRole : C.purpleRole,
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white12, height: 18),
                      Text(
                        'Client : ${o.client}  •  Chauffeur : ${o.driver} (${o.plate})\nDestination : ${o.dest}\nCode secret PIN : ${o.pin}  •  Signature : ${o.signed ? "Validée ✍️" : "En attente"}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.4),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
// === FIN DU FICHIER lib/main.dart (100% COMPLET ET PRÊT À COMPILER) ===