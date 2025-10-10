import 'package:logging/logging.dart' as logging;
import 'package:sass/sass.dart' as sass;
import 'package:source_span/source_span.dart';
import 'package:stack_trace/stack_trace.dart';

final class LoggingAdapter implements sass.Logger {
  final logging.Logger _logger;

  LoggingAdapter(this._logger);

  @override
  void debug(String message, SourceSpan span) {
    _logger.fine(span.message(message, color: true));
  }

  @override
  void warn(String message,
      {FileSpan? span, Trace? trace, bool deprecation = false}) {
    final highlightedMessage = switch (span) {
      null => message,
      final span => span.message(message, color: true),
    };

    if (trace == null) {
      _logger.warning(highlightedMessage);
    } else {
      _logger.warning(highlightedMessage, '', trace);
    }
  }
}
