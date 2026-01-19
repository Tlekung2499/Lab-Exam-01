import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shopping_item.dart';
import '../providers/theme_provider.dart';
import 'add_item_page.dart';
import 'edit_item_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ShoppingItem> _items = [];
  final TextEditingController _searchController = TextEditingController();

  List<ShoppingItem> get _filteredItems {
    if (_searchController.text.isEmpty) {
      return _items;
    }
    return _items
        .where((item) =>
            item.name.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();
  }

  void _addNewItem(ShoppingItem item) {
    setState(() {
      _items.add(item);
    });
  }

  void _deleteItem(ShoppingItem item) {
    setState(() {
      _items.remove(item);
    });
  }


  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark
        ? _darkColors
        : _lightColors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: ModalRoute.of(context)?.animation ??
                AlwaysStoppedAnimation(1),
            curve: Curves.easeOut,
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          child: const Icon(Icons.add, color: Colors.black, size: 28),
          onPressed: () async {
            final newItem = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddItemPage()),
            );
            if (newItem != null) {
              _addNewItem(newItem);
            }
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors['primary']!, colors['primaryDark']!],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Text(
                  'รายการซื้อของ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(context, '${_items.length}', 'รายการ'),
                    _buildStatItem(
                      context,
                      '${_items.fold<int>(0, (sum, item) => sum + item.quantity)}',
                      'จำนวน',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'ค้นหารายการ...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          _items.isEmpty ? 'ยังไม่มีรายการ' : 'ไม่พบรายการ',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.grey[400],
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, idx) {
                      final item = _filteredItems[idx];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Dismissible(
                          key: ValueKey(item),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              _editItem(item);
                            } else if (direction == DismissDirection.endToStart) {
                              _deleteItem(item);
                            }
                          },
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${idx + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                              ),
                              subtitle: item.note.isNotEmpty
                                  ? Text(item.note, maxLines: 1, overflow: TextOverflow.ellipsis)
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item.quantity.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: const Row(
                                          children: [
                                            Icon(Icons.edit, size: 18),
                                            SizedBox(width: 8),
                                            Text('แก้ไข'),
                                          ],
                                        ),
                                        onTap: () => _editItem(item),
                                      ),
                                      PopupMenuItem(
                                        child: const Row(
                                          children: [
                                            Icon(Icons.delete, size: 18, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('ลบ', style: TextStyle(color: Colors.red)),
                                          ],
                                        ),
                                        onTap: () => _deleteItem(item),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: Container(
        color: colors['primary'],
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: const Text(
          'tlekung',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _editItem(ShoppingItem item) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditItemPage(item: item)),
    );
    if (updated != null) {
      setState(() {});
    }
  }

  static const Map<String, Color> _lightColors = {
    'primary': Color.fromARGB(255, 25, 118, 210),
    'primaryDark': Color.fromARGB(255, 13, 71, 161),
  };

  static const Map<String, Color> _darkColors = {
    'primary': Color.fromARGB(255, 33, 150, 243),
    'primaryDark': Color.fromARGB(255, 25, 118, 210),
  };

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}