import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that dismisses the on-screen keyboard when a tap occurs outside
/// of a focused text input field within its subtree.
///
/// This is a common and desirable user experience, preventing the keyboard
/// from obscuring content unnecessarily and providing a natural way for
/// users to hide it.
///
/// Example:
/// ```dart
/// class MyFormScreen extends StatelessWidget {
///   const MyFormScreen({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return KeyboardDismisser(
///       child: Scaffold(
///         appBar: AppBar(
///           title: const Text('Keyboard Dismiss Demo'),
///         ),
///         body: Padding(
///           padding: const EdgeInsets.all(16.0),
///           child: Column(
///             children: <Widget>[
///               const TextField(
///                 decoration: InputDecoration(
///                   labelText: 'Username',
///                   border: OutlineInputBorder(),
///                 ),
///               ),
///               const SizedBox(height: 20),
///               const TextField(
///                 decoration: InputDecoration(
///                   labelText: 'Password',
///                   border: OutlineInputBorder(),
///                 ),
///                 obscureText: true,
///               ),
///               const SizedBox(height: 30),
///               ElevatedButton(
///                 onPressed: () {
///                   // Handle login or form submission
///                   print('Submit button pressed!');
///                 },
///                 child: const Text('Login'),
///               ),
///             ],
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
class KeyboardDismisser extends StatelessWidget {
  /// Creates a [KeyboardDismisser] widget.
  ///
  /// The [child] is the widget tree within which taps will trigger
  /// keyboard dismissal.
  const KeyboardDismisser({
    super.key,
    required this.child,
  });

  /// The widget below this widget in the tree.
  ///
  /// Taps on any area outside of a focused text input field within this
  /// [child]'s subtree will cause the keyboard to dismiss.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // [HitTestBehavior.translucent] ensures that the GestureDetector
    // can receive tap events even if there are other widgets on top of it
    // that might otherwise absorb the hit. This is crucial for detecting
    // taps across the entire area covered by KeyboardDismisser.
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // Obtain the current FocusScopeNode, which manages the focus of input fields.
        FocusScopeNode currentFocus = FocusScope.of(context);

        // Check if there's a primary focus (usually a text input field)
        // and if that focused child is not already unfocused.
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          // If a text input field is focused and the tap is outside of it,
          // unfocus the primary focus, which dismisses the keyboard.
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Widget>('child', child));
  }
}
