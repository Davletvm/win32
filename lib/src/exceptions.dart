// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Exceptions that may be caught or thrown by the win32 library.

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'constants.dart';
import 'int.dart';
import 'kernel32.dart';
import 'string.dart';

int HRESULT(int hr) => hr.toUnsigned(32);

/// Generic COM Exception
class COMException implements Exception {
  int/*!*/ hr;

  COMException(int hr) {
    this.hr = HRESULT(hr);
  }
}

/// Generalized Windows exception
class WindowsException extends COMException {
  WindowsException(int hr) : super(hr);

  /// Converts a Windows error into a friendly string.
  ///
  /// Takes one numeric paramenter, which may be a general Windows error or an
  /// HRESULT, and converts it into a String representation using the Win32
  /// `FormatMessage()` function. For example, `E_INVALIDARG` (0x80070057)
  /// converts to `The parameter is incorrect.`
  String convertWindowsErrorToString(int windowsError) {
    String errorMessage;
    final buffer = allocate<Uint16>(count: 256).cast<Utf16>();

    // If FormatMessage fails, it returns 0; otherwise it returns the number of
    // characters in the buffer.
    final result = FormatMessage(
        FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
        nullptr,
        windowsError,
        0, // default language
        buffer,
        256,
        nullptr);

    if (result == 0) {
      // Failed to get error string
      errorMessage = '';
    } else {
      errorMessage = buffer.unpackString(result);
    }

    free(buffer);

    // Strip off CRLF in the returned error message, if it exists
    if (errorMessage.endsWith('\r\n')) {
      errorMessage = errorMessage.substring(0, errorMessage.length - 2);
    }

    return errorMessage;
  }

  @override
  String toString() =>
      'Error ${hr.toHex(32)}: ${convertWindowsErrorToString(hr)}';
}
