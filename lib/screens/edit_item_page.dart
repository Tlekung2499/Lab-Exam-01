import 'package:flutter/material.dart';
import '../models/shopping_item.dart';

class EditItemPage extends StatefulWidget {
  final ShoppingItem item;

  const EditItemPage({super.key, required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController = TextEditingController(text: widget.item.quantity.toString());
    _noteController = TextEditingController(text: widget.item.note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขรายการ'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              _buildFieldLabel('ชื่อรายการ'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration(
                  hintText: 'เช่น นม, ไข่, ขนม',
                  icon: Icons.shopping_bag,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อรายการ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Quantity Field
              _buildFieldLabel('จำนวน'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantityController,
                decoration: _buildInputDecoration(
                  hintText: '1',
                  icon: Icons.production_quantity_limits,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกจำนวน';
                  }
                  final qty = int.tryParse(value);
                  if (qty == null || qty < 1) {
                    return 'จำนวนต้องมากกว่า 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Note Field
              _buildFieldLabel('หมายเหตุ (ไม่บังคับ)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: _buildInputDecoration(
                  hintText: 'เช่น แบรนด์, ขนาด, หมายเหตุเพิ่มเติม',
                  icon: Icons.note,
                ),
                maxLines: 3,
                minLines: 2,
              ),
              const SizedBox(height: 32),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ScaleTransition(
                  scale: Tween(begin: 0.9, end: 1.0).animate(
                    CurvedAnimation(
                      parent: ModalRoute.of(context)?.animation ??
                          AlwaysStoppedAnimation(1),
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'อัปเดตรายการ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.item.name = _nameController.text;
      widget.item.quantity = int.parse(_quantityController.text);
      widget.item.note = _noteController.text;
      Navigator.pop(context, widget.item);
    }
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.blue.shade900),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade900, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
