import 'package:flutter/material.dart';

void main() => runApp(const KulakanApp());

const ink = Color(0xFF252525);
const muted = Color(0xFF686868);
const line = Color(0xFFD8D8D8);
const soft = Color(0xFFF2F2F2);

class KulakanApp extends StatelessWidget {
  const KulakanApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'KULAKAN',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ink,
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
      ),
    ),
    home: const KulakanShell(),
  );
}

typedef MyApp = KulakanApp;

class Product {
  Product(
    this.name,
    this.price,
    this.unit,
    this.stock, {
    this.favorite = false,
    this.bulk = false,
    this.min = 5,
  });
  final String name;
  final int price;
  final String unit;
  double stock;
  final bool favorite;
  final bool bulk;
  final double min;
}

class Debt {
  Debt(this.name, this.phone, this.balance, this.due);
  final String name;
  final String phone;
  int balance;
  final String due;
}

class KulakanShell extends StatefulWidget {
  const KulakanShell({super.key});
  @override
  State<KulakanShell> createState() => _KulakanShellState();
}

class _KulakanShellState extends State<KulakanShell> {
  int tab = 0;
  bool loggedIn = false;
  bool splashPassed = false;
  bool registering = false;
  bool monthly = false;
  String paymentMethod = 'Tunai';
  String productFilter = 'Favorit';
  String stockFilter = 'Semua';
  String debtFilter = 'Belum lunas';
  final search = TextEditingController();
  final cash = TextEditingController(text: '50000');
  final barcode = TextEditingController(text: '8991001000034');
  final ownerName = TextEditingController();
  final ownerPhone = TextEditingController();
  final shopName = TextEditingController();
  final shopAddress = TextEditingController();
  final products = <Product>[
    Product('Beras medium', 14000, 'kg', 18, favorite: true, bulk: true),
    Product('Gula pasir', 15000, 'kg', 10, favorite: true, bulk: true),
    Product('Minyak goreng', 18000, 'botol', 3, min: 5),
    Product('Mi instan', 3500, 'bungkus', 8, min: 10),
    Product('Telur ayam', 28000, 'kg', 12, bulk: true),
    Product('Kopi sachet', 2000, 'sachet', 35),
  ];
  final cart = <Product, double>{};
  final debts = <Debt>[
    Debt('Bu Siti', '0813 1111 2233', 125000, 'Hari ini'),
    Debt('Pak Budi', '0813 2222 3344', 85000, '7 hari lagi'),
    Debt('Bu Rina', '0813 3333 4455', 75000, '4 hari lagi'),
    Debt('Pak Agus', '0813 4444 5566', 40000, '6 hari lagi'),
  ];
  int transactions = 12;
  int todaySales = 486000;
  int recentTotal = 43000;

  int get total =>
      cart.entries.fold(0, (sum, e) => sum + e.key.price * e.value.round());
  int get itemCount => cart.length;
  int get received =>
      int.tryParse(cash.text.replaceAll(RegExp(r'\D'), '')) ?? 0;
  String money(num value) {
    final s = value.round().toString();
    final out = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      out.write(s[i]);
      final left = s.length - i - 1;
      if (left > 0 && left % 3 == 0) out.write('.');
    }
    return 'Rp${out.toString()}';
  }

  @override
  void dispose() {
    search.dispose();
    cash.dispose();
    barcode.dispose();
    ownerName.dispose();
    ownerPhone.dispose();
    shopName.dispose();
    shopAddress.dispose();
    super.dispose();
  }

  void add(Product p) => setState(() => cart[p] = (cart[p] ?? 0) + 1);
  void changeQty(Product p, double delta) => setState(() {
    final next = (cart[p] ?? 0) + delta;
    if (next <= 0) {
      cart.remove(p);
    } else {
      cart[p] = next;
    }
  });

  @override
  Widget build(BuildContext context) {
    if (!splashPassed) return _splash();
    if (registering) return _storeInfo();
    if (!loggedIn) return _login();
    final pages = [_home(), _cashier(), _stock(), _debts(), _report()];
    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: tab,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE7E7E7),
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_basket_outlined),
            selectedIcon: Icon(Icons.shopping_basket),
            label: 'Kasir',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Stok',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'Utang',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Laporan',
          ),
        ],
      ),
    );
  }

  Widget _splash() => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Align(alignment: Alignment.topRight, child: Text('09.41  ▮ ▰')),
            const Spacer(),
            const Icon(Icons.storefront_outlined, size: 58, color: ink),
            const SizedBox(height: 20),
            const Text('KULAKAN', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 2)),
            const SizedBox(height: 10),
            const Text('Kasir, stok, dan catatan utang', style: TextStyle(color: muted, fontSize: 16)),
            const Spacer(),
            SizedBox(width: double.infinity, child: _primary('Mulai', () => setState(() => splashPassed = true))),
            const SizedBox(height: 18),
            const Text('Teman kelola warung setiap hari.', style: TextStyle(color: muted)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );

  Widget _login() => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const Text(
            '09.41                                                       ▮ ▰',
          ),
          const SizedBox(height: 24),
          const Text(
            'KULAKAN',
            style: TextStyle(fontSize: 28, letterSpacing: 1),
          ),
          const Text(
            'Kasir, stok, dan catatan utang',
            style: TextStyle(color: muted, fontSize: 16),
          ),
          const Divider(height: 32),
          const SizedBox(height: 42),
          const Text(
            'Selamat Datang',
            style: TextStyle(fontSize: 27, height: 1.18),
          ),
          const SizedBox(height: 12),
          const Text(
            'Masuk untuk mulai mengelola toko Anda.',
            style: TextStyle(color: muted, fontSize: 17),
          ),
          const SizedBox(height: 28),
          _outline('Lanjutkan dengan Google', () => _message('Login Google belum terhubung pada demo ini')),
          const SizedBox(height: 18),
          const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('atau masuk dengan email', style: TextStyle(color: muted))), Expanded(child: Divider())]),
          const SizedBox(height: 22),
          const Text(
            'Email atau username',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Masukkan email atau username',
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Kata sandi',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '••••••••',
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _message('Bantuan pemulihan kata sandi'),
              child: const Text('Lupa kata sandi?'),
            ),
          ),
          const SizedBox(height: 8),
          _primary('Masuk ke toko', () => setState(() => loggedIn = true)),
          const SizedBox(height: 16),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Baru menggunakan Kulakan?',
              style: TextStyle(color: muted),
            ),
          ),
          const SizedBox(height: 10),
          _outline(
            'Daftarkan toko Anda',
            () => setState(() => registering = true),
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              'Kelola warung lebih rapi, setiap hari.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _storeInfo() => Scaffold(
    appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => registering = false))),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const Text('Lengkapi informasi', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          const Text('Isi informasi pemilik dan toko untuk mulai menggunakan Kulakan.', style: TextStyle(color: muted, fontSize: 16)),
          const SizedBox(height: 28),
          _formField('Nama pemilik', 'Masukkan nama lengkap', ownerName),
          _formField('Nomor telepon', 'Masukkan nomor telepon', ownerPhone, type: TextInputType.phone),
          _formField('Nama toko', 'Contoh: Warung Berkah', shopName),
          _formField('Alamat toko', 'Masukkan alamat toko', shopAddress, lines: 2),
          const SizedBox(height: 12),
          _primary('Simpan dan mulai', () {
            setState(() {
              registering = false;
              loggedIn = true;
            });
          }),
          const SizedBox(height: 18),
          const Text('Informasi toko dapat diubah kembali melalui menu pengaturan.', textAlign: TextAlign.center, style: TextStyle(color: muted)),
        ],
      ),
    ),
  );

  Widget _formField(String label, String hint, TextEditingController controller, {TextInputType? type, int lines = 1}) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextField(controller: controller, keyboardType: type, maxLines: lines, decoration: InputDecoration(border: const OutlineInputBorder(), hintText: hint)),
    ]),
  );

  Widget _home() => ListView(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
    children: [
      _header(
        'Warung Adzqia',
        'Sabtu, 24 Oktober 2026',
        Icons.settings_outlined,
        () => _settings(),
      ),
      const SizedBox(height: 18),
      const Text('Selamat pagi, Bu Mariana.', style: TextStyle(fontSize: 17)),
      const SizedBox(height: 16),
      _card(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Penjualan hari ini'),
            Text(
              money(todaySales),
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$transactions transaksi',
                  style: const TextStyle(color: muted),
                ),
                const Text('Laba Rp108.000'),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tunai\nRp401.000', style: TextStyle(height: 1.6)),
                Text('Utang baru\nRp85.000', style: TextStyle(height: 1.6)),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _primary('Mulai transaksi kasir', () => setState(() => tab = 1)),
      const SizedBox(height: 18),
      const Text('Akses cepat', style: TextStyle(fontSize: 19)),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(child: _outline('Stok masuk', () => _adjustStock())),
          const SizedBox(width: 10),
          Expanded(child: _outline('Catat cicilan', () => _addInstallment())),
        ],
      ),
      const SizedBox(height: 16),
      const InfoBox(
        icon: Icons.warning_amber_outlined,
        text: '2 produk menipis · Minyak goreng dan Mi instan. Periksa stok sebelum belanja.',
      ),
      const SizedBox(height: 20),
      _sectionTitle(
        'Pengingat utang',
        'Lihat semua',
        () => setState(() => tab = 3),
      ),
      _debtRow(debts.first, onTap: () => _debtDetails(debts.first)),
      const SizedBox(height: 14),
      _sectionTitle(
        'Transaksi terakhir',
        'Riwayat',
        () => _message('Riwayat transaksi toko'),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text(
          '#TRX-241026-012',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('09.41 · 2 jenis produk · Tunai'),
        trailing: Text(
          money(recentTotal),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );

  Widget _cashier() {
    final q = search.text.toLowerCase();
    final visible = products
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) &&
              (productFilter == 'Semua' ||
                  productFilter == 'Barang curah' && p.bulk ||
                  productFilter == 'Favorit' && p.favorite),
        )
        .toList();
    return Column(
      children: [
        _header(
          'Kasir',
          'Transaksi baru · Pelanggan umum',
          Icons.settings_outlined,
          () => _message('Pengaturan kasir'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Cari nama / kode',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                onPressed: () => _barcodeDialog(),
                icon: const Icon(Icons.qr_code_scanner),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: ink),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: ink,
                  fixedSize: const Size(52, 52),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: _filterButtons(
            ['Semua', 'Favorit', 'Barang curah'],
            productFilter,
            (v) => setState(() => productFilter = v),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              ...visible.map(
                (p) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    p.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${p.bulk ? 'Curah' : 'Kemasan'} · Stok ${p.stock} ${p.unit}',
                    style: const TextStyle(color: muted),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${money(p.price)}/${p.unit}'),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => add(p),
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: line),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (cart.isNotEmpty) _cartSummary(),
              if (cart.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 22),
                  child: _primary(
                    'Lanjut pembayaran · ${money(total)}',
                    _checkout,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cartSummary() => _card(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Keranjang · $itemCount produk',
              style: const TextStyle(fontSize: 17),
            ),
            TextButton(
              onPressed: () => setState(cart.clear),
              child: const Text('Kosongkan'),
            ),
          ],
        ),
        ...cart.entries.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.key.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${e.value} ${e.key.unit} × ${money(e.key.price)} = ${money(e.key.price * e.value)}',
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _qtyControl(e.key),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total belanja', style: TextStyle(color: muted)),
            Text(
              money(total),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _qtyControl(Product p) => Container(
    decoration: BoxDecoration(
      border: Border.all(color: line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () => changeQty(p, -1),
          icon: const Icon(Icons.remove, size: 18),
        ),
        Text(
          '${cart[p]!.toStringAsFixed(cart[p]! % 1 == 0 ? 0 : 1)} ${p.unit}',
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () => changeQty(p, 1),
          icon: const Icon(Icons.add, size: 18),
        ),
      ],
    ),
  );

  Widget _stock() {
    final q = search.text.toLowerCase();
    final list = products
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) &&
              (stockFilter == 'Semua' || p.stock <= p.min),
        )
        .toList();
    return Column(
      children: [
        _header(
          'Stok produk',
          '6 produk · Satuan sesuai barang',
          Icons.settings_outlined,
          () => _settings(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Row(
            children: [
              Expanded(child: _outline('+ Tambah produk', _addProduct)),
              const SizedBox(width: 10),
              Expanded(child: _outline('Masuk / keluar', _adjustStock)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: TextField(
            controller: search,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Cari produk',
              hintText: 'Nama produk / barcode',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: _filterButtons(
            ['Semua', 'Menipis'],
            stockFilter,
            (v) => setState(() => stockFilter = v),
            label: (v) =>
                v == 'Semua' ? 'Semua (${products.length})' : 'Menipis (2)',
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              if (stockFilter == 'Menipis')
                const InfoBox(
                  icon: Icons.warning_amber_outlined,
                  text: '2 produk mencapai batas minimum. Segera tambah stok Minyak goreng dan Mi instan.',
                ),
              ...list.map(
                (p) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () => _productDetails(p),
                  title: Text(
                    p.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${money(p.price)}/${p.unit} · ${p.bulk ? 'Curah' : 'Kemasan'}${p.favorite ? ' · Favorit' : ''}',
                    style: const TextStyle(color: muted),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${p.stock} ${p.unit}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        p.stock <= p.min ? 'Menipis' : 'Cukup',
                        style: TextStyle(
                          color: p.stock <= p.min ? Colors.deepOrange : muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Stok berkurang otomatis setiap transaksi kasir.',
                  style: TextStyle(color: muted),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _debts() {
    final list = debts
        .where(
          (d) =>
              debtFilter != 'Lunas' &&
              d.balance > 0 &&
              d.name.toLowerCase().contains(search.text.toLowerCase()),
        )
        .toList();
    final outstanding = debts.fold<int>(0, (s, d) => s + d.balance);
    return Column(
      children: [
        _header(
          'Utang pelanggan',
          'Catatan piutang Warung Berkah',
          Icons.settings_outlined,
          () => _settings(),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              _card(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total utang belum lunas'),
                    Text(
                      money(outstanding),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${debts.length} pelanggan · 1 jatuh tempo hari ini',
                      style: const TextStyle(color: muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _primary('+ Catat utang', _newDebt)),
                  const SizedBox(width: 10),
                  Expanded(child: _outline('+ Pelanggan', _addCustomer)),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: search,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Cari pelanggan',
                  hintText: 'Nama / nomor HP',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              _filterButtons(
                ['Belum lunas', 'Jatuh tempo', 'Lunas'],
                debtFilter,
                (v) => setState(() => debtFilter = v),
              ),
              const SizedBox(height: 10),
              const InfoBox(
                icon: Icons.notifications_none,
                text: 'Bu Siti jatuh tempo hari ini. Buka detail pelanggan untuk mengirim pengingat.',
              ),
              ...list.map((d) => _debtRow(d, onTap: () => _debtDetails(d))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _debtRow(Debt d, {VoidCallback? onTap}) => ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(
      '${d.phone} · 24 Okt 2026',
      style: const TextStyle(color: muted),
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          money(d.balance),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(d.due, style: const TextStyle(color: muted)),
      ],
    ),
  );

  Widget _report() => ListView(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
    children: [
      _header(
        'Laporan toko',
        'Diperbarui 24 Okt 2026 · 09.41',
        Icons.settings_outlined,
        () => _settings(),
      ),
      const SizedBox(height: 14),
      _filterButtons(
        ['Harian', 'Bulanan'],
        monthly ? 'Bulanan' : 'Harian',
        (s) => setState(() => monthly = s == 'Bulanan'),
      ),
      const SizedBox(height: 14),
      _card(
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.chevron_left),
            Text(
              '24 Oktober 2026',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
      const SizedBox(height: 14),
      _card(
        Column(
          children: [
            _reportRow('Penjualan hari ini', money(todaySales), bold: true),
            _reportRow('Modal barang terjual', '−Rp378.000'),
            _reportRow('Laba sederhana', 'Rp108.000', bold: true),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '12 transaksi · Tunai Rp401.000 · Utang Rp85.000',
                style: TextStyle(color: muted, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      const Text('Penjualan 6 hari terakhir', style: TextStyle(fontSize: 18)),
      SizedBox(
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [70, 105, 82, 120, 90, 138]
              .asMap()
              .entries
              .map(
                (e) => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 28,
                      height: e.value.toDouble(),
                      color: e.key == 5 ? ink : const Color(0xFFE3E3E3),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'][e.key],
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
      _card(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bulan ini · Oktober 2026',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 10),
            _reportRow('Penjualan · 286 transaksi', 'Rp12.450.000'),
            _reportRow('Modal barang terjual', 'Rp9.730.000'),
            _reportRow('Laba sederhana', 'Rp2.720.000', bold: true),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _card(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rekap utang bulan ini', style: TextStyle(fontSize: 17)),
            _reportRow('Utang tercatat', 'Rp1.250.000'),
            _reportRow('Cicilan / pelunasan diterima', 'Rp925.000'),
            _reportRow(
              'Sisa utang · 4 pelanggan',
              money(debts.fold<int>(0, (s, d) => s + d.balance)),
              bold: true,
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Laba = penjualan − modal barang terjual, belum termasuk biaya toko. Cicilan bukan penjualan baru.',
        style: TextStyle(color: muted, fontSize: 12),
      ),
    ],
  );

  Widget _checkout() => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Pembayaran'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          '$itemCount jenis produk · Pelanggan umum',
          style: const TextStyle(color: muted),
        ),
        const SizedBox(height: 18),
        _card(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total belanja'),
              Text(
                money(total),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...cart.entries.map(
                (e) => _reportRow(
                  '${e.key.name} · ${e.value} ${e.key.unit}',
                  money(e.key.price * e.value),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Metode pembayaran', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        _filterButtons(
          ['Tunai', 'Catat utang'],
          paymentMethod,
          (s) => setState(() => paymentMethod = s),
        ),
        const SizedBox(height: 16),
        if (paymentMethod == 'Tunai') ...[
          const Text(
            'Uang diterima',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: cash,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              prefixText: 'Rp',
              hintText: '0',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _outline(
                  'Uang pas',
                  () => setState(() => cash.text = '$total'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _outline(
                  'Rp50.000',
                  () => setState(() => cash.text = '50000'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _outline(
                  'Rp100.000',
                  () => setState(() => cash.text = '100000'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _card(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kembalian', style: TextStyle(color: muted)),
                Text(
                  money((received - total).clamp(0, 999999999)),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ] else ...[
          DropdownButtonFormField<String>(
            value: debts.isEmpty ? null : debts.first.name,
            decoration: const InputDecoration(
              labelText: 'Pilih pelanggan',
              border: OutlineInputBorder(),
            ),
            items: debts
                .map(
                  (d) => DropdownMenuItem(value: d.name, child: Text(d.name)),
                )
                .toList(),
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Jatuh tempo',
              border: OutlineInputBorder(),
              hintText: 'Pilih tanggal',
            ),
          ),
        ],
        const SizedBox(height: 14),
        const InfoBox(
          icon: Icons.info_outline,
          text: 'Setelah disimpan, transaksi masuk ke riwayat dan stok barang otomatis berkurang.',
        ),
        const SizedBox(height: 18),
        _primary('Selesaikan pembayaran', _finishPayment),
        const SizedBox(height: 10),
        _outline('Kembali ke keranjang', () => Navigator.pop(context)),
      ],
    ),
  );

  void _finishPayment() {
    if (cart.isEmpty) return;
    if (paymentMethod == 'Tunai' && received < total) {
      _message('Uang diterima belum cukup.');
      return;
    }
    setState(() {
      for (final e in cart.entries) {
        e.key.stock = (e.key.stock - e.value).clamp(0, 999999);
      }
      if (paymentMethod == 'Catat utang') debts.first.balance += total;
      transactions++;
      todaySales += total;
      recentTotal = total;
      cart.clear();
      tab = 0;
    });
    Navigator.pop(context);
    _message('Transaksi tersimpan. Terima kasih!');
  }

  Widget _header(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback action,
  ) => Container(
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 14),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: line)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 23)),
              const SizedBox(height: 3),
              Text(subtitle, style: const TextStyle(color: muted)),
            ],
          ),
        ),
        IconButton(onPressed: action, icon: Icon(icon)),
      ],
    ),
  );

  Widget _card(Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: soft,
      border: Border.all(color: line),
      borderRadius: BorderRadius.circular(10),
    ),
    child: child,
  );
  Widget _primary(String text, VoidCallback onPressed) => SizedBox(
    height: 52,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: ink,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
  );
  Widget _outline(String text, VoidCallback onPressed) => SizedBox(
    height: 48,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        side: const BorderSide(color: ink),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
  Widget _filter(
    String text,
    String active,
    ValueChanged<String> select,
  ) => SizedBox(
    height: 44,
    child: OutlinedButton(
      onPressed: () => select(text),
      style: OutlinedButton.styleFrom(
        backgroundColor: text == active
            ? const Color(0xFFE5E5E5)
            : Colors.white,
        foregroundColor: ink,
        side: BorderSide(color: text == active ? ink : const Color(0xFFBDBDBD)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        padding: const EdgeInsets.symmetric(horizontal: 7),
      ),
      child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
    ),
  );
  Widget _filterButtons(
    List<String> values,
    String selected,
    ValueChanged<String> onSelect, {
    String Function(String)? label,
  }) => Row(
    children: values.map((v) {
      final text = label?.call(v) ?? v;
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 6),
          child: _filter(text, v == selected ? text : '', (_) => onSelect(v)),
        ),
      );
    }).toList(),
  );
  Widget _sectionTitle(String title, String action, VoidCallback onTap) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: const TextStyle(fontSize: 18)),
      TextButton(onPressed: onTap, child: Text(action)),
    ],
  );
  Widget _reportRow(String label, String value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: muted)),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );

  Future<void> _barcodeDialog() async {
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan barcode'),
        content: TextField(
          controller: barcode,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Nomor barcode'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, barcode.text),
            child: const Text('Cari produk'),
          ),
        ],
      ),
    );
    if (code != null) {
      add(products.firstWhere((p) => p.name == 'Minyak goreng'));
      _message('Minyak goreng ditambahkan ke keranjang.');
    }
  }

  Future<void> _addProduct() async {
    final name = TextEditingController();
    final price = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah produk'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Nama produk'),
            ),
            TextField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty)
      setState(
        () => products.add(
          Product(name.text.trim(), int.tryParse(price.text) ?? 0, 'pcs', 0),
        ),
      );
  }

  Future<void> _adjustStock() async {
    Product selected = products.first;
    final amount = TextEditingController(text: '10');
    final mode = ValueNotifier<bool>(true);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stok masuk / keluar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<Product>(
              value: selected,
              items: products
                  .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                  .toList(),
              onChanged: (v) {
                if (v != null) selected = v;
              },
            ),
            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah'),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: mode,
              builder: (_, v, __) => SwitchListTile(
                title: Text(v ? 'Stok masuk' : 'Stok keluar'),
                value: v,
                onChanged: (x) => mode.value = x,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (ok == true)
      setState(
        () => selected.stock =
            (selected.stock +
                    (mode.value ? 1 : -1) * (double.tryParse(amount.text) ?? 0))
                .clamp(0, 999999),
      );
  }

  Future<void> _newDebt() async {
    final name = TextEditingController();
    final amount = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Catat utang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Nama pelanggan'),
            ),
            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah utang'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty)
      setState(
        () => debts.add(
          Debt(
            name.text.trim(),
            '-',
            int.tryParse(amount.text) ?? 0,
            'Belum ditentukan',
          ),
        ),
      );
  }

  Future<void> _addCustomer() async {
    final name = TextEditingController();
    final phone = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah pelanggan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: 'Nomor HP'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty)
      setState(
        () =>
            debts.add(Debt(name.text.trim(), phone.text, 0, 'Tidak ada utang')),
      );
  }

  void _debtDetails(Debt d) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              d.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(d.phone, style: const TextStyle(color: muted)),
            const SizedBox(height: 16),
            Text('Sisa utang ${money(d.balance)}'),
            const SizedBox(height: 16),
            _primary('Catat cicilan', () {
              Navigator.pop(context);
              _addInstallment(d);
            }),
            const SizedBox(height: 10),
            _outline('Kirim pengingat', () {
              Navigator.pop(context);
              _message('Pengingat untuk ${d.name} siap dikirim.');
            }),
          ],
        ),
      ),
    ),
  );

  Future<void> _addInstallment([Debt? debt]) async {
    final target = debt ?? debts.first;
    final amount = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cicilan · ${target.name}'),
        content: TextField(
          controller: amount,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Jumlah diterima'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (ok == true)
      setState(
        () =>
            target.balance = (target.balance - (int.tryParse(amount.text) ?? 0))
                .clamp(0, target.balance),
      );
  }

  void _productDetails(Product p) => showModalBottomSheet<void>(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              p.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text('${money(p.price)} per ${p.unit} · Stok ${p.stock} ${p.unit}'),
            const SizedBox(height: 18),
            _primary('Ubah stok', () {
              Navigator.pop(context);
              _adjustStock();
            }),
          ],
        ),
      ),
    ),
  );

  void _settings() => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SettingsPage(
        onLogout: () {
          setState(() => loggedIn = false);
          Navigator.pop(context);
        },
      ),
    ),
  );
  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class InfoBox extends StatelessWidget {
  const InfoBox({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: soft,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(height: 1.35))),
      ],
    ),
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.onLogout});
  final VoidCallback onLogout;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pengaturan toko')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Kelola identitas, akun, dan cadangan',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 20),
        const Text('Identitas toko', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Nama toko',
            border: OutlineInputBorder(),
            hintText: 'Warung Adzqia',
          ),
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Alamat pada struk',
            border: OutlineInputBorder(),
            hintText: 'Kp. Lengis Warung Menteng',
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengaturan toko disimpan')),
          ),
          child: const Text('Simpan pengaturan toko'),
        ),
        const SizedBox(height: 20),
        const Text('Akun pemilik', style: TextStyle(fontSize: 20)),
        const ListTile(title: Text('Pemilik'), trailing: Text('Mariana')),
        const ListTile(title: Text('Nomor HP'), trailing: Text('085710386548')),
        OutlinedButton(onPressed: () {}, child: const Text('Ubah kata sandi')),
        const SizedBox(height: 18),
        const Text('Cadangan data', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 10),
        const Card(
          color: soft,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cadangan terakhir · 23 Okt 2026 · 20.00'),
                SizedBox(height: 10),
                Text(
                  'Termasuk produk, transaksi, stok, dan catatan utang pelanggan.',
                ),
                SizedBox(height: 10),
                Text('Cadangkan data sekarang'),
                SizedBox(height: 10),
                Text('Pulihkan dari cadangan'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: onLogout,
          child: const Text('Keluar dari akun'),
        ),
        const Center(
          child: Text('KULAKAN · Versi 1.0', style: TextStyle(color: muted)),
        ),
      ],
    ),
  );
}
