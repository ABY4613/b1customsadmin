class AppFormatters {
  static String formatCurrency(double amount) {
    // Standard format for Indian Rupees / International USD
    final String priceStr = amount.toStringAsFixed(0);
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final String result = priceStr.replaceAllMapped(reg, (Match m) => '${m[1]},');
    return '₹$result';
  }

  static String formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final String day = date.day.toString().padLeft(2, '0');
    final String month = months[date.month - 1];
    final String year = date.year.toString();
    final String hour = (date.hour % 12 == 0 ? 12 : date.hour % 12).toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour >= 12 ? 'PM' : 'AM';
    return '$month $day, $year • $hour:$minute $period';
  }

  static String generateSku(String category, String title) {
    final catPrefix = category.length >= 2 ? category.substring(0, 2).toUpperCase() : 'EX';
    final titleWords = title.split(' ').where((w) => w.isNotEmpty).toList();
    String code = '01';
    if (titleWords.length >= 2) {
      code = (titleWords[0].substring(0, 1) + titleWords[1].substring(0, 1)).toUpperCase();
    } else if (titleWords.isNotEmpty && titleWords[0].length >= 2) {
      code = titleWords[0].substring(0, 2).toUpperCase();
    }
    final randomNum = (100 + (DateTime.now().millisecondsSinceEpoch % 899)).toString();
    return 'B1-$catPrefix-$code-$randomNum';
  }
}
