import 'package:kaka_tools/kaka_tools.dart';
import 'package:test/test.dart';

void main() {
  test('masks cards, accounts and IBANs but not amounts', () {
    expect(Masking.text('کارت 6037-9912-3456-7890'), 'کارت ••••7890');
    expect(Masking.text('IR12 0170 0000 0012 3456 7890 01'), '••••9001');
    expect(Masking.text('حساب 0320192383104 مبلغ 20,014,500'), 'حساب ••••3104 مبلغ 20,014,500');
    expect(Masking.text('06009'), '06009');
    expect(
      Masking.json({
        'a': ['761670007641552001'],
        'n': 5,
      }),
      {
        'a': ['••••2001'],
        'n': 5,
      },
    );
  });
}
