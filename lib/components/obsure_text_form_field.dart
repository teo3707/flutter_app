import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'dart:collection';


class ObscureTextFormField extends FormField<String> {
  ObscureTextFormField({
    Key key,
    this.controller,
    String initialValue,
    FocusNode focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.done,
    TextStyle style,
    TextAlign textAlign = TextAlign.start,
    bool autofocus = false,
    bool obscureText = false,
    bool autocorrect = true,
    bool autovalidate = false,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int maxLength,
    VoidCallback onEditingComplete,
    ValueChanged<String> onFieldSubmitted,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    List<TextInputFormatter> inputFormatters,
    bool enabled,
    Brightness keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
  }) : assert(initialValue == null || controller == null),
        assert(keyboardType != null),
        assert(textInputAction != null),
        assert(textAlign != null),
        assert(autofocus != null),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(autovalidate != null),
        assert(maxLengthEnforced != null),
        assert(scrollPadding != null),
        assert(maxLines == null || maxLines > 0),
        assert(maxLength == null || maxLength > 0),
        super(
        key: key,
        initialValue: controller != null ? controller.text : (initialValue ?? ''),
        onSaved: onSaved,
        validator: validator,
        autovalidate: autovalidate,
        builder: (FormFieldState<String> field) {
          final _ObscureTextFormFieldState state = field;
          final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration())
              .applyDefaults(Theme.of(field.context).inputDecorationTheme);
          return _ObscureTextField(
            controller: state._effectiveController,
            focusNode: focusNode,
            decoration: effectiveDecoration.copyWith(errorText: field.errorText),
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            style: style,
            textAlign: textAlign,
            textCapitalization: textCapitalization,
            autofocus: autofocus,
            obscureText: obscureText,
            autocorrect: autocorrect,
            maxLengthEnforced: maxLengthEnforced,
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: field.didChange,
            onEditingComplete: onEditingComplete,
            onSubmitted: onFieldSubmitted,
            inputFormatters: inputFormatters,
            enabled: enabled,
            scrollPadding: scrollPadding,
            keyboardAppearance: keyboardAppearance,
          );
        },
      );

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController controller;

  @override
  _ObscureTextFormFieldState createState() => new _ObscureTextFormFieldState();

}




class _ObscureTextFormFieldState extends FormFieldState<String> {
  TextEditingController _controller;

  TextEditingController get _effectiveController => widget.controller ?? _controller;

  @override
  ObscureTextFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = new TextEditingController(text: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(ObscureTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = new TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null)
          _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);
  }

}


class _ObscureTextField extends StatefulWidget {
  /// Creates a Material Design text field.
  ///
  /// If [decoration] is non-null (which is the default), the text field requires
  /// one of its ancestors to be a [Material] widget.
  ///
  /// To remove the decoration entirely (including the extra padding introduced
  /// by the decoration to save space for the labels), set the [decoration] to
  /// null.
  ///
  /// The [maxLines] property can be set to null to remove the restriction on
  /// the number of lines. By default, it is one, meaning this is a single-line
  /// text field. [maxLines] must not be zero. If [maxLines] is not one, then
  /// [keyboardType] is ignored, and the [TextInputType.multiline] keyboard
  /// type is used.
  ///
  /// The [maxLength] property is set to null by default, which means the
  /// number of characters allowed in the text field is not restricted. If
  /// [maxLength] is set, a character counter will be displayed below the
  /// field, showing how many characters have been entered and how many are
  /// allowed. After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforced] is set to false. The TextField
  /// enforces the length with a [LengthLimitingTextInputFormatter], which is
  /// evaluated after the supplied [inputFormatters], if any. The [maxLength]
  /// value must be either null or greater than zero.
  ///
  /// If [maxLengthEnforced] is set to false, then more than [maxLength]
  /// characters may be entered, and the error counter and divider will
  /// switch to the [decoration.errorStyle] when the limit is exceeded.
  ///
  /// The [keyboardType], [textAlign], [autofocus], [obscureText], and
  /// [autocorrect] arguments must not be null.
  ///
  /// See also:
  ///
  ///  * [maxLength], which discusses the precise meaning of "number of
  ///    characters" and how it may differ from the intuitive meaning.
  const _ObscureTextField({
    Key key,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    TextInputType keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLines = 1,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
  }) : assert(keyboardType != null),
        assert(textInputAction != null),
        assert(textAlign != null),
        assert(autofocus != null),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(maxLengthEnforced != null),
        assert(scrollPadding != null),
        assert(maxLines == null || maxLines > 0),
        assert(maxLength == null || maxLength > 0),
        keyboardType = maxLines == 1 ? keyboardType : TextInputType.multiline,
        super(key: key);

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController controller;

  /// Controls whether this widget has keyboard focus.
  ///
  /// If null, this widget will create its own [FocusNode].
  final FocusNode focusNode;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration decoration;

  /// The type of keyboard to use for editing the text.
  ///
  /// Defaults to [TextInputType.text]. Must not be null. If
  /// [maxLines] is not one, then [keyboardType] is ignored, and the
  /// [TextInputType.multiline] keyboard type is used.
  final TextInputType keyboardType;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.done]. Must not be null.
  final TextInputAction textInputAction;

  /// Configures how the platform keyboard will select an uppercase or
  /// lowercase keyboard.
  ///
  /// Only supports text keyboards, other keyboard types will ignore this
  /// configuration. Capitalization is locale-aware.
  ///
  /// Defaults to [TextCapitalization.none]. Must not be null.
  ///
  /// See also:
  ///
  ///   * [TextCapitalization], for a description of each capitalization behavior.
  final TextCapitalization textCapitalization;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subhead` text style from the current [Theme].
  final TextStyle style;

  /// How the text being edited should be aligned horizontally.
  ///
  /// Defaults to [TextAlign.start].
  final TextAlign textAlign;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  ///
  /// If true, the keyboard will open as soon as this text field obtains focus.
  /// Otherwise, the keyboard is only shown after the user taps the text field.
  ///
  /// Defaults to false. Cannot be null.
  // See https://github.com/flutter/flutter/issues/7035 for the rationale for this
  // keyboard behavior.
  final bool autofocus;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// When this is set to true, all the characters in the text field are
  /// replaced by U+2022 BULLET characters (•).
  ///
  /// Defaults to false. Cannot be null.
  final bool obscureText;

  /// Whether to enable autocorrection.
  ///
  /// Defaults to true. Cannot be null.
  final bool autocorrect;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  ///
  /// If this is 1 (the default), the text will not wrap, but will scroll
  /// horizontally instead.
  ///
  /// If this is null, there is no limit to the number of lines. If it is not
  /// null, the value must be greater than zero.
  final int maxLines;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// If set, a character counter will be displayed below the
  /// field, showing how many characters have been entered and how many are
  /// allowed. After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforced] is set to false. The TextField
  /// enforces the length with a [LengthLimitingTextInputFormatter], which is
  /// evaluated after the supplied [inputFormatters], if any.
  ///
  /// This value must be either null or greater than zero. If set to null
  /// (the default), there is no limit to the number of characters allowed.
  ///
  /// Whitespace characters (e.g. newline, space, tab) are included in the
  /// character count.
  ///
  /// If [maxLengthEnforced] is set to false, then more than [maxLength]
  /// characters may be entered, but the error counter and divider will
  /// switch to the [decoration.errorStyle] when the limit is exceeded.
  ///
  /// ## Limitations
  ///
  /// The TextField does not currently count Unicode grapheme clusters (i.e.
  /// characters visible to the user), it counts Unicode scalar values, which
  /// leaves out a number of useful possible characters (like many emoji and
  /// composed characters), so this will be inaccurate in the presence of those
  /// characters. If you expect to encounter these kinds of characters, be
  /// generous in the maxLength used.
  ///
  /// For instance, the character "ö" can be represented as '\u{006F}\u{0308}',
  /// which is the letter "o" followed by a composed diaeresis "¨", or it can
  /// be represented as '\u{00F6}', which is the Unicode scalar value "LATIN
  /// SMALL LETTER O WITH DIAERESIS". In the first case, the text field will
  /// count two characters, and the second case will be counted as one
  /// character, even though the user can see no difference in the input.
  ///
  /// Similarly, some emoji are represented by multiple scalar values. The
  /// Unicode "THUMBS UP SIGN + MEDIUM SKIN TONE MODIFIER", "👍🏽", should be
  /// counted as a single character, but because it is a combination of two
  /// Unicode scalar values, '\u{1F44D}\u{1F3FD}', it is counted as two
  /// characters.
  ///
  /// See also:
  ///
  ///  * [LengthLimitingTextInputFormatter] for more information on how it
  ///    counts characters, and how it may differ from the intuitive meaning.
  final int maxLength;

  /// If true, prevents the field from allowing more than [maxLength]
  /// characters.
  ///
  /// If [maxLength] is set, [maxLengthEnforced] indicates whether or not to
  /// enforce the limit, or merely provide a character counter and warning when
  /// [maxLength] is exceeded.
  final bool maxLengthEnforced;

  /// Called when the text being edited changes.
  final ValueChanged<String> onChanged;

  /// Called when the user submits editable content (e.g., user presses the "done"
  /// button on the keyboard).
  ///
  /// The default implementation of [onEditingComplete] executes 2 different
  /// behaviors based on the situation:
  ///
  ///  - When a completion action is pressed, such as "done", "go", "send", or
  ///    "search", the user's content is submitted to the [controller] and then
  ///    focus is given up.
  ///
  ///  - When a non-completion action is pressed, such as "next" or "previous",
  ///    the user's content is submitted to the [controller], but focus is not
  ///    given up because developers may want to immediately move focus to
  ///    another input widget within [onSubmitted].
  ///
  /// Providing [onEditingComplete] prevents the aforementioned default behavior.
  final VoidCallback onEditingComplete;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  final ValueChanged<String> onSubmitted;

  /// Optional input validation and formatting overrides.
  ///
  /// Formatters are run in the provided order when the text input changes.
  final List<TextInputFormatter> inputFormatters;

  /// If false the textfield is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [Decoration.enabled] property.
  final bool enabled;

  /// How thick the cursor will be.
  ///
  /// Defaults to 2.0.
  final double cursorWidth;

  /// How rounded the corners of the cursor should be.
  /// By default, the cursor has a null Radius
  final Radius cursorRadius;

  /// The color to use when painting the cursor.
  final Color cursorColor;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to the brightness of [ThemeData.primaryColorBrightness].
  final Brightness keyboardAppearance;

  /// Configures padding to edges surrounding a [Scrollable] when the Textfield scrolls into view.
  ///
  /// When this widget receives focus and is not completely visible (for example scrolled partially
  /// off the screen or overlapped by the keyboard)
  /// then it will attempt to make itself visible by scrolling a surrounding [Scrollable], if one is present.
  /// This value controls how far from the edges of a [Scrollable] the TextField will be positioned after the scroll.
  ///
  /// Defaults to EdgeInserts.all(20.0).
  final EdgeInsets scrollPadding;

  @override
  _ObscureTextFieldState createState() => new _ObscureTextFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(new DiagnosticsProperty<TextEditingController>('controller', controller, defaultValue: null));
    properties.add(new DiagnosticsProperty<FocusNode>('focusNode', focusNode, defaultValue: null));
    properties.add(new DiagnosticsProperty<InputDecoration>('decoration', decoration));
    properties.add(new DiagnosticsProperty<TextInputType>('keyboardType', keyboardType, defaultValue: TextInputType.text));
    properties.add(new DiagnosticsProperty<TextStyle>('style', style, defaultValue: null));
    properties.add(new DiagnosticsProperty<bool>('autofocus', autofocus, defaultValue: false));
    properties.add(new DiagnosticsProperty<bool>('obscureText', obscureText, defaultValue: false));
    properties.add(new DiagnosticsProperty<bool>('autocorrect', autocorrect, defaultValue: false));
    properties.add(new IntProperty('maxLines', maxLines, defaultValue: 1));
    properties.add(new IntProperty('maxLength', maxLength, defaultValue: null));
    properties.add(new FlagProperty('maxLengthEnforced', value: maxLengthEnforced, ifTrue: 'max length enforced'));
  }
}


class _ObscureTextFieldState extends State<_ObscureTextField> with AutomaticKeepAliveClientMixin {
  final GlobalKey<EditableTextState> _editableTextKey = new GlobalKey<EditableTextState>();

  Set<InteractiveInkFeature> _splashes;
  InteractiveInkFeature _currentSplash;

  TextEditingController _controller;
  TextEditingController get _effectiveController => widget.controller ?? _controller;

  FocusNode _focusNode;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_focusNode ??= new FocusNode());

  bool get needsCounter => widget.maxLength != null
      && widget.decoration != null
      && widget.decoration.counterText == null;

  InputDecoration _getEffectiveDecoration() {
    final InputDecoration effectiveDecoration = (widget.decoration ?? const InputDecoration())
        .applyDefaults(Theme.of(context).inputDecorationTheme)
        .copyWith(
      enabled: widget.enabled,
    );

    if (!needsCounter)
      return effectiveDecoration;

    final String counterText = '${_effectiveController.value.text.runes.length}/${widget.maxLength}';
    if (_effectiveController.value.text.runes.length > widget.maxLength) {
      final ThemeData themeData = Theme.of(context);
      return effectiveDecoration.copyWith(
        errorText: effectiveDecoration.errorText ?? '',
        counterStyle: effectiveDecoration.errorStyle
            ?? themeData.textTheme.caption.copyWith(color: themeData.errorColor),
        counterText: counterText,
      );
    }
    return effectiveDecoration.copyWith(counterText: counterText);
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null)
      _controller = new TextEditingController();
  }

  @override
  void didUpdateWidget(_ObscureTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null)
      _controller = new TextEditingController.fromValue(oldWidget.controller.value);
    else if (widget.controller != null && oldWidget.controller == null)
      _controller = null;
    final bool isEnabled = widget.enabled ?? widget.decoration?.enabled ?? true;
    final bool wasEnabled = oldWidget.enabled ?? oldWidget.decoration?.enabled ?? true;
    if (wasEnabled && !isEnabled) {
      _effectiveFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  void _requestKeyboard() {
    _editableTextKey.currentState?.requestKeyboard();
  }

  void _handleSelectionChanged(TextSelection selection, SelectionChangedCause cause) {
    if (cause == SelectionChangedCause.longPress)
      Feedback.forLongPress(context);
  }

  InteractiveInkFeature _createInkFeature(TapDownDetails details) {
    final MaterialInkController inkController = Material.of(context);
    final BuildContext editableContext = _editableTextKey.currentContext;
    final RenderBox referenceBox = InputDecorator.containerOf(editableContext) ?? editableContext.findRenderObject();
    final Offset position = referenceBox.globalToLocal(details.globalPosition);
    final Color color = Theme.of(context).splashColor;

    InteractiveInkFeature splash;
    void handleRemoved() {
      if (_splashes != null) {
        assert(_splashes.contains(splash));
        _splashes.remove(splash);
        if (_currentSplash == splash)
          _currentSplash = null;
        updateKeepAlive();
      } // else we're probably in deactivate()
    }

    splash = Theme.of(context).splashFactory.create(
      controller: inkController,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: true,
      // TODO(hansmuller): splash clip borderRadius should match the input decorator's border.
      borderRadius: BorderRadius.zero,
      onRemoved: handleRemoved,
    );

    return splash;
  }

  RenderEditable get _renderEditable => _editableTextKey.currentState.renderEditable;

  void _handleTapDown(TapDownDetails details) {
    _renderEditable.handleTapDown(details);
    _startSplash(details);
  }

  void _handleTap() {
    _renderEditable.handleTap();
    _requestKeyboard();
    _confirmCurrentSplash();
  }

  void _handleTapCancel() {
    _cancelCurrentSplash();
  }

  void _handleLongPress() {
    _renderEditable.handleLongPress();
    _confirmCurrentSplash();
  }

  void _startSplash(TapDownDetails details) {
    if (_effectiveFocusNode.hasFocus)
      return;
    final InteractiveInkFeature splash = _createInkFeature(details);
    _splashes ??= new HashSet<InteractiveInkFeature>();
    _splashes.add(splash);
    _currentSplash = splash;
    updateKeepAlive();
  }

  void _confirmCurrentSplash() {
    _currentSplash?.confirm();
    _currentSplash = null;
  }

  void _cancelCurrentSplash() {
    _currentSplash?.cancel();
  }

  @override
  bool get wantKeepAlive => _splashes != null && _splashes.isNotEmpty;

  @override
  void deactivate() {
    if (_splashes != null) {
      final Set<InteractiveInkFeature> splashes = _splashes;
      _splashes = null;
      for (InteractiveInkFeature splash in splashes)
        splash.dispose();
      _currentSplash = null;
    }
    assert(_currentSplash == null);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    assert(debugCheckHasMaterial(context));
    final ThemeData themeData = Theme.of(context);
    final TextStyle style = widget.style ?? themeData.textTheme.subhead;
    final Brightness keyboardAppearance = widget.keyboardAppearance ?? themeData.primaryColorBrightness;
    final TextEditingController controller = _effectiveController;
    final FocusNode focusNode = _effectiveFocusNode;
    final List<TextInputFormatter> formatters = widget.inputFormatters ?? <TextInputFormatter>[];
    if (widget.maxLength != null && widget.maxLengthEnforced)
      formatters.add(new LengthLimitingTextInputFormatter(widget.maxLength));

    Widget child = new RepaintBoundary(
      child: _ObscureEditableText(
        key: _editableTextKey,
        controller: controller,
        focusNode: focusNode,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        style: style,
        textAlign: widget.textAlign,
        autofocus: widget.autofocus,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        maxLines: widget.maxLines,
        selectionColor: themeData.textSelectionColor,
        selectionControls: themeData.platform == TargetPlatform.iOS
            ? cupertinoTextSelectionControls
            : materialTextSelectionControls,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: widget.onSubmitted,
        onSelectionChanged: _handleSelectionChanged,
        inputFormatters: formatters,
        rendererIgnoresPointer: true,
        cursorWidth: widget.cursorWidth,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor ?? Theme.of(context).cursorColor,
        scrollPadding: widget.scrollPadding,
        keyboardAppearance: keyboardAppearance,
      ),
    );

    if (widget.decoration != null) {
      child = new AnimatedBuilder(
        animation: new Listenable.merge(<Listenable>[ focusNode, controller ]),
        builder: (BuildContext context, Widget child) {
          return new InputDecorator(
            decoration: _getEffectiveDecoration(),
            baseStyle: widget.style,
            textAlign: widget.textAlign,
            isFocused: focusNode.hasFocus,
            isEmpty: controller.value.text.isEmpty,
            child: child,
          );
        },
        child: child,
      );
    }

    return new Semantics(
      onTap: () {
        if (!_effectiveController.selection.isValid)
          _effectiveController.selection = new TextSelection.collapsed(offset: _effectiveController.text.length);
        _requestKeyboard();
      },
      child: new IgnorePointer(
        ignoring: !(widget.enabled ?? widget.decoration?.enabled ?? true),
        child: new GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: _handleTapDown,
          onTap: _handleTap,
          onTapCancel: _handleTapCancel,
          onLongPress: _handleLongPress,
          excludeFromSemantics: true,
          child: child,
        ),
      ),
    );
  }
}


class _ObscureEditableText extends EditableText {
  _ObscureEditableText({
    Key key,
    @required TextEditingController controller,
    @required FocusNode focusNode,
    bool obscureText = false,
    bool autocorrect = true,
    @required TextStyle style,
    @required Color cursorColor,
    TextAlign textAlign = TextAlign.start,
    TextDirection textDirection,
    Locale locale,
    double textScaleFactor,
    int maxLines = 1,
    bool autofocus = false,
    Color selectionColor,
    TextSelectionControls selectionControls,
    TextInputType keyboardType,
    TextInputAction textInputAction = TextInputAction.done,
    TextCapitalization textCapitalization = TextCapitalization.none,
    ValueChanged<String> onChanged,
    VoidCallback onEditingComplete,
    ValueChanged<String> onSubmitted,
    SelectionChangedCallback onSelectionChanged,
    List<TextInputFormatter> inputFormatters,
    bool rendererIgnoresPointer = false,
    double cursorWidth = 2.0,
    Radius cursorRadius,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    Brightness keyboardAppearance = Brightness.light,
  }): super(
    key: key,
    controller: controller,
    focusNode: focusNode,
    obscureText: obscureText,
    autocorrect: autocorrect,
    style: style,
    cursorColor: cursorColor,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    textScaleFactor: textScaleFactor,
    maxLines: maxLines,
    autofocus: autofocus,
    selectionColor: selectionColor,
    selectionControls: selectionControls,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    textCapitalization: textCapitalization,
    onChanged: onChanged,
    onEditingComplete: onEditingComplete,
    onSubmitted: onSubmitted,
    onSelectionChanged: onSelectionChanged,
    inputFormatters: inputFormatters,
    rendererIgnoresPointer: rendererIgnoresPointer,
    cursorWidth: cursorWidth,
    cursorRadius: cursorRadius,
    scrollPadding: scrollPadding,
    keyboardAppearance: keyboardAppearance,
  );

  @override
  EditableTextState createState() => _ObscureEditableTextState();
}


class _ObscureEditableTextState extends EditableTextState {

  @override
  TextSpan buildTextSpan() {
    TextSpan textSpan = super.buildTextSpan();
    return TextSpan(style: textSpan.style, text: textSpan.text);
  }
}