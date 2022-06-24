import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../logger.dart';

class BaseViewModel extends ChangeNotifier {
  late final String? _title;
  late bool _busy;
  late Logger log;
  bool _isDisposed = false;

  BaseViewModel({
    bool busy = false,
    String? title,
  })  : _busy = busy,
        _title = title {
    log = getLogger(title ?? runtimeType.toString());
  }

  bool get busy => _busy;
  bool get isDisposed => _isDisposed;
  String? get title => _title ?? runtimeType.toString();

  set busy(bool busy) {
    log.i(
      'busy: '
      '$title is entering '
      '${busy ? 'busy' : 'free'} state',
    );
    _busy = busy;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!isDisposed) {
      super.notifyListeners();
    } else {
      log.w('notifyListeners: Notify listeners called after '
          '${title ?? runtimeType.toString()} has been disposed');
    }
  }

  @override
  void dispose() {
    log.i('dispose');
    _isDisposed = true;
    super.dispose();
  }
}
