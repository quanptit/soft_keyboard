import 'package:flutter/material.dart';

import '../utils/enums.dart';
import '../utils/key_rows.dart';

class AlphanumericKeyboard extends StatefulWidget {
  const AlphanumericKeyboard({
    required this.controller,
    this.height,
    this.backgroundColor = const Color(0xff0a0a0a),
    this.actionKeyColor = const Color(0xff171717),
    this.alphanumericKeyColor = const Color(0xff2d2d2d),
    this.showSpaceKeyIcon = false,
    this.numericKeyTextStyle,
    this.alphaNumericKeyTextStyle,
    this.spaceKeyIcon,
    this.enterKeyIcon,
    this.backspaceKeyIcon,
    this.symbolsKeyIcon,
    this.alphabetKeyIcon,
    this.capsLockKeyIcon,
    this.capsUnlockKeyIcon,
    this.firstLetterCapitalizationColor = Colors.blue,
    this.keyBorderRadius = 10,
    this.actionKeyIconColor = Colors.white,
    this.onEnterTapped,
    super.key,
  });

  /// The height of the keyboard
  final double? height;

  /// The controller for the text field
  final TextEditingController controller;

  /// The color for the keyboard background
  final Color backgroundColor;

  /// The color for the action keys
  final Color actionKeyColor;

  /// The color for the alphanumeric keys
  final Color alphanumericKeyColor;

  /// Whether to show the space key icon or not, default is false
  final bool showSpaceKeyIcon;

  /// The text style for the numeric keys
  final TextStyle? numericKeyTextStyle;

  /// The text style for the alphabets and symbols keys
  final TextStyle? alphaNumericKeyTextStyle;

  /// The icon to show on space key
  final IconData? spaceKeyIcon;

  /// The icon to show on enter key
  final IconData? enterKeyIcon;

  /// The icon to show on backspace key
  final IconData? backspaceKeyIcon;

  /// The icon to show when alphabets tab is opened
  final IconData? symbolsKeyIcon;

  /// The icon to show when symbols tab is opened
  final IconData? alphabetKeyIcon;

  /// The icon to show when all caps is enabled
  final IconData? capsLockKeyIcon;

  /// The icon to show when all caps is disabled [lowerCase, onlyFirstLetter]
  final IconData? capsUnlockKeyIcon;

  /// The icon color when firstLetterCapitalization is enabled
  final Color firstLetterCapitalizationColor;

  /// The border radius for the keys
  final double keyBorderRadius;

  /// Action key icon color
  final Color actionKeyIconColor;

  /// Callback Function for Enter Key
  final Function()? onEnterTapped;

  @override
  State<AlphanumericKeyboard> createState() => _AlphanumericKeyboardState();
}

class _AlphanumericKeyboardState extends State<AlphanumericKeyboard> {
  Capitalization capitalization = Capitalization.onlyFirstLetter;
  static const double marginKey = 2.5;

  KeyBoardType keyboardType = KeyBoardType.alphanumeric;

  // Renders the keyboard rows
  Widget keyboardRow(List<String> keys) {
    List<Widget> childrens = keys
        .map(
          (e) => e == SpecialKey.space.name
              ? actionKey(SpecialKey.space, 4)
              : e.length > 1
                  ? actionKey(SpecialKey.values.firstWhere((element) => element.name == e), 2)
                  : keys[0] == '1'
                      ? numberKey(e, 1)
                      : alphabetKey(e, 1),
        )
        .toList();
    //TODO check 9-10-6 to add space
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: childrens,
    );
  }

  // Renders the number keys
  Widget numberKey(String kKey, int flex) {
    return Flexible(
      flex: flex,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.controller.text += kKey;
          },
          borderRadius: BorderRadius.circular(widget.keyBorderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: widget.alphanumericKeyColor,
              borderRadius: BorderRadius.circular(widget.keyBorderRadius),
            ),
            constraints: const BoxConstraints(
              // minWidth: 30,
              minHeight: 35,
            ),
            margin: const EdgeInsets.all(marginKey),
            child: Center(
              child: Text(
                kKey,
                style: widget.numericKeyTextStyle ??
                    const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Renders the alphabet keys
  Widget alphabetKey(String kKey, int flex) {
    return Flexible(
      flex: flex,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.controller.text += capitalization == Capitalization.lowerCase ? kKey.toLowerCase() : kKey;
            if (capitalization == Capitalization.onlyFirstLetter) {
              setState(() {
                capitalization = Capitalization.lowerCase;
              });
            }
          },
          borderRadius: BorderRadius.circular(widget.keyBorderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: widget.alphanumericKeyColor,
              borderRadius: BorderRadius.circular(widget.keyBorderRadius),
            ),
            constraints: const BoxConstraints(
              minWidth: 30,
              minHeight: 40,
            ),
            margin: const EdgeInsets.all(marginKey),
            child: Center(
              child: Text(
                capitalization == Capitalization.lowerCase ? kKey.toLowerCase() : kKey,
                style: widget.alphaNumericKeyTextStyle ??
                    const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns the icon for the action keys
  Widget? getActionKeyIcon(SpecialKey key) {
    IconData iconData;
    Color iconColor = widget.actionKeyIconColor;
    double iconSize = 24;

    if (key == SpecialKey.capsLock) {
      iconData = capitalization == Capitalization.upperCase
          ? widget.capsLockKeyIcon ?? Icons.arrow_circle_up
          : widget.capsUnlockKeyIcon ?? Icons.arrow_upward;

      if (capitalization == Capitalization.onlyFirstLetter) {
        iconColor = widget.firstLetterCapitalizationColor;
      }
    } else if (key == SpecialKey.backspace) {
      iconData = widget.backspaceKeyIcon ?? Icons.backspace_outlined;
    } else if (key == SpecialKey.space) {
      iconData = widget.spaceKeyIcon ?? Icons.space_bar;
      if (widget.showSpaceKeyIcon == false) {
        iconColor = widget.actionKeyColor;
      }
    } else if (key == SpecialKey.enter) {
      iconData = widget.enterKeyIcon ?? Icons.keyboard_return;
    } else {
      iconData = keyboardType == KeyBoardType.alphanumeric
          ? widget.symbolsKeyIcon ?? Icons.emoji_symbols
          : widget.alphabetKeyIcon ?? Icons.abc;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: iconSize,
    );
  }

  // Renders the action keys
  Widget actionKey(SpecialKey kKey, int flex) {
    return Flexible(
      flex: flex,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (kKey == SpecialKey.backspace) {
              if (widget.controller.text.isNotEmpty) {
                widget.controller.text = widget.controller.text.substring(0, widget.controller.text.length - 1);
              }
            } else if (kKey == SpecialKey.space) {
              widget.controller.text += ' ';
            } else if (kKey == SpecialKey.enter) {
              if (widget.onEnterTapped != null) {
                widget.onEnterTapped!();
              } else {
                widget.controller.text += '\n';
              }
            } else if (kKey == SpecialKey.capsLock) {
              setState(() {
                switch (capitalization) {
                  case Capitalization.lowerCase:
                    capitalization = Capitalization.onlyFirstLetter;
                    break;
                  case Capitalization.onlyFirstLetter:
                    capitalization = Capitalization.upperCase;
                    break;
                  case Capitalization.upperCase:
                    capitalization = Capitalization.lowerCase;
                    break;
                }
              });
            } else if (kKey == SpecialKey.symbols) {
              setState(() {
                if (keyboardType == KeyBoardType.alphanumeric) {
                  keyboardType = KeyBoardType.symbols;
                } else {
                  keyboardType = KeyBoardType.alphanumeric;
                }
              });
            }
          },
          borderRadius: BorderRadius.circular(widget.keyBorderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: widget.actionKeyColor,
              borderRadius: BorderRadius.circular(widget.keyBorderRadius),
            ),
            constraints: const BoxConstraints(
              minWidth: 30,
              minHeight: 40,
            ),
            margin: const EdgeInsets.all(marginKey),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: getActionKeyIcon(kKey),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      color: widget.backgroundColor,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          keyboardRow(KeyRows.numbersRow),
          keyboardRow(keyboardType == KeyBoardType.alphanumeric ? KeyRows.alphabetsTopRow : KeyRows.symbolsTopRow),
          keyboardRow3(
              keyboardType == KeyBoardType.alphanumeric ? KeyRows.alphabetsMiddleRow : KeyRows.symbolsMiddleRow),
          keyboardType == KeyBoardType.alphanumeric
              ? keyboardRow4(KeyRows.alphabetsBottomRow)
              : keyboardRow4Sym(KeyRows.symbolsBottomRow),
          keyboardRow5(KeyRows.lastRow),
        ],
      ),
    );
  }

  Widget keyboardRow3(List<String> keys) {
    List<Widget> childrens = keys
        .map(
          (e) => e.length > 1
              ? actionKey(SpecialKey.values.firstWhere((element) => element.name == e), 3)
              : keys[0] == '1'
                  ? numberKey(e, 2)
                  : alphabetKey(e, 2),
        )
        .toList();
    childrens.insert(0, Spacer(flex: 1));
    childrens.add(Spacer(flex: 1));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: childrens,
    );
  }

  Widget keyboardRow4Sym(List<String> keys) {
    List<Widget> childrens = keys
        .map(
          (e) => e.length > 1
              ? actionKey(SpecialKey.values.firstWhere((element) => element.name == e), 3)
              : keys[0] == '1'
                  ? numberKey(e, 2)
                  : alphabetKey(e, 2),
        )
        .toList();
    childrens.insert(0, Spacer(flex: 1));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: childrens,
    );
  }

  Widget keyboardRow4(List<String> keys) {
    List<Widget> childrens = keys
        .map(
          (e) => e.length > 1
              ? actionKey(SpecialKey.values.firstWhere((element) => element.name == e), 3)
              : keys[0] == '1'
                  ? numberKey(e, 2)
                  : alphabetKey(e, 2),
        )
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: childrens,
    );
  }

  Widget keyboardRow5(List<String> keys) {
    List<Widget> childrens = keys
        .map(
          (e) => e == SpecialKey.space.name
              ? actionKey(SpecialKey.space, 10)
              : e.length > 1
                  ? actionKey(SpecialKey.values.firstWhere((element) => element.name == e), 3)
                  : keys[0] == '1'
                      ? numberKey(e, 2)
                      : alphabetKey(e, 2),
        )
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: childrens,
    );
  }
}
