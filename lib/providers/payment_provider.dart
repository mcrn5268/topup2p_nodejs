import 'package:flutter/foundation.dart';
import 'package:topup2p_nodejs/models/payment_model.dart';

class PaymentProvider with ChangeNotifier {
  final List<Payment> _payments = [];

  List<Payment> get payments => _payments;

  void addPayment(Payment payment, {bool notify = true}) {
    _payments.add(payment);
    if (notify) {
      notifyListeners();
    }
  }

  void clearPayments({bool notify = true}) {
    _payments.clear();
    if (notify) {
      notifyListeners();
    }
  }

  void addAllPayments(List<Payment> payments, {bool notify = true}) {
    _payments.addAll(payments);
    if (notify) {
      notifyListeners();
    }
  }

  void updatePayment(Payment payment,
      {String? accountname,
      String? accountnumber,
      bool? isEnabled,
      bool notify = true}) {
    int index = _payments.indexOf(payment);
    _payments[index].accountname = accountname ?? payment.accountname;
    _payments[index].accountnumber = accountnumber ?? payment.accountnumber;
    _payments[index].isEnabled = isEnabled ?? payment.isEnabled;
    if (notify) {
      notifyListeners();
    }
  }

  void updatePaymentList(List<Payment> paymentsFromWallet) {
    if (_payments.length != paymentsFromWallet.length) {
      _payments.clear();
      _payments.addAll(paymentsFromWallet);
      notifyListeners();
    } else {
      bool isEqual = true;
      for (int i = 0; i < _payments.length; i++) {
        if (_payments[i] != (paymentsFromWallet[i])) {
          isEqual = false;
          break;
        }
      }
      if (!isEqual) {
        _payments.clear();
        _payments.addAll(paymentsFromWallet);
        notifyListeners();
      }
    }
  }

  void printAllPayments() {
    for (Payment payment in _payments) {
      if (kDebugMode) {
        print('Payment Name: ${payment.paymentname}');
        print('Payment Image: ${payment.paymentimage}');
        print('Account Name: ${payment.accountname}');
        print('Account Number: ${payment.accountnumber}');
        print('Is Enabled: ${payment.isEnabled}');
      }
    }
  }
}
