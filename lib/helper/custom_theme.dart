import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    this.iconButtonColor,
    this.backgroundColor,
    this.chatInputAreaBackground,
    this.chatAreaBackground,
    this.bottomNavigationBarThemeBackground,
    this.bottomNavigationBarThemeSelectedIconColor,
    this.bottomNavigationBarThemeUnselectedIconColor,
    this.chatToolbarBackground,
    this.personInfoBackground,
    this.dividerColor,
    this.searchContactColor,
    this.closeButtonColor,
    this.searchContactHighlightColor,
  });

  final Color? iconButtonColor;
  final Color? backgroundColor;
  final Color? chatInputAreaBackground;
  final Color? chatAreaBackground;
  final Color? chatToolbarBackground;
  final Color? bottomNavigationBarThemeBackground;
  final Color? bottomNavigationBarThemeSelectedIconColor;
  final Color? bottomNavigationBarThemeUnselectedIconColor;
  final Color? personInfoBackground;
  final Color? dividerColor;
  final Color? searchContactColor;
  final Color? closeButtonColor;
  final Color? searchContactHighlightColor;

  @override
  ThemeExtension<CustomColors> lerp(
    covariant ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      chatInputAreaBackground: Color.lerp(
        chatInputAreaBackground,
        other.chatInputAreaBackground,
        t,
      ),
      chatToolbarBackground: Color.lerp(
        chatToolbarBackground,
        other.chatToolbarBackground,
        t,
      ),
      iconButtonColor: Color.lerp(iconButtonColor, other.iconButtonColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      bottomNavigationBarThemeBackground: Color.lerp(
        bottomNavigationBarThemeBackground,
        other.bottomNavigationBarThemeBackground,
        t,
      ),
      chatAreaBackground: Color.lerp(
        chatAreaBackground,
        other.chatAreaBackground,
        t,
      ),
      bottomNavigationBarThemeSelectedIconColor: Color.lerp(
        bottomNavigationBarThemeSelectedIconColor,
        other.bottomNavigationBarThemeSelectedIconColor,
        t,
      ),
      bottomNavigationBarThemeUnselectedIconColor: Color.lerp(
        bottomNavigationBarThemeUnselectedIconColor,
        other.bottomNavigationBarThemeUnselectedIconColor,
        t,
      ),
      personInfoBackground: Color.lerp(
        personInfoBackground,
        other.personInfoBackground,
        t,
      ),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      searchContactColor: Color.lerp(
        searchContactColor,
        other.searchContactColor,
        t,
      ),
      closeButtonColor: Color.lerp(closeButtonColor, other.closeButtonColor, t),
      searchContactHighlightColor: Color.lerp(
        searchContactHighlightColor,
        other.searchContactHighlightColor,
        t,
      ),
    );
  }

  static const light = CustomColors(
    iconButtonColor: Color.fromARGB(255, 117, 117, 117),
    backgroundColor: Color.fromARGB(255, 242, 242, 242),
    chatInputAreaBackground: Color.fromARGB(255, 255, 255, 255),
    chatToolbarBackground: Color.fromARGB(255, 247, 247, 247),
    chatAreaBackground: Color.fromARGB(255, 237, 237, 237),
    bottomNavigationBarThemeBackground: Color.fromARGB(255, 247, 247, 247),
    bottomNavigationBarThemeSelectedIconColor: Colors.blue,
    bottomNavigationBarThemeUnselectedIconColor: Colors.black,
    personInfoBackground: Color.fromARGB(255, 237, 237, 237),
    dividerColor: Color.fromARGB(100, 234, 234, 234),
    searchContactColor: Color.fromARGB(255, 255, 255, 255),
    closeButtonColor: Color.fromARGB(255, 169, 169, 169),
    searchContactHighlightColor: Color.fromARGB(255, 84, 186, 111),
  );

  static const dark = CustomColors(
    iconButtonColor: Color.fromARGB(255, 218, 218, 218),
    backgroundColor: Color.fromARGB(255, 30, 30, 30),
    chatInputAreaBackground: Color.fromARGB(255, 50, 50, 50),
    chatToolbarBackground: Color.fromARGB(255, 32, 32, 32),
    chatAreaBackground: Color.fromARGB(255, 40, 40, 40),
    bottomNavigationBarThemeBackground: Color.fromARGB(255, 247, 247, 247),
    bottomNavigationBarThemeSelectedIconColor: Colors.green,
    bottomNavigationBarThemeUnselectedIconColor: Colors.white70,
    personInfoBackground: Color.fromARGB(255, 40, 40, 40),
    dividerColor: Color.fromARGB(100, 234, 234, 234),
    searchContactColor: Color.fromARGB(255, 255, 255, 255),
    closeButtonColor: Color.fromARGB(255, 169, 169, 169),
    searchContactHighlightColor: Color.fromARGB(255, 84, 186, 111),
  );

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? backgroundColor,
    Color? iconButtonColor,
    Color? chatInputAreaBackground,
    Color? bottomNavigationBarThemeBackground,
    Color? chatAreaBackground,
    Color? bottomNavigationBarThemeSelectedIconColor,
    Color? bottomNavigationBarThemeUnselectedIconColor,
    Color? chatToolbarBackground,
    Color? personInfoBackground,
    Color? dividerColor,
    Color? searchContactColor,
    Color? closeButtonColor,
  }) {
    return CustomColors(
      iconButtonColor: iconButtonColor ?? this.iconButtonColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      chatAreaBackground: chatAreaBackground ?? this.chatAreaBackground,
      chatToolbarBackground:
          chatToolbarBackground ?? this.chatToolbarBackground,
      chatInputAreaBackground:
          chatInputAreaBackground ?? this.chatInputAreaBackground,
      bottomNavigationBarThemeBackground:
          bottomNavigationBarThemeBackground ??
          this.bottomNavigationBarThemeBackground,
      bottomNavigationBarThemeSelectedIconColor:
          bottomNavigationBarThemeSelectedIconColor ??
          this.bottomNavigationBarThemeSelectedIconColor,
      bottomNavigationBarThemeUnselectedIconColor:
          bottomNavigationBarThemeUnselectedIconColor ??
          this.bottomNavigationBarThemeUnselectedIconColor,
      personInfoBackground: personInfoBackground ?? this.personInfoBackground,
      dividerColor: dividerColor ?? this.dividerColor,
      searchContactColor: searchContactColor ?? this.searchContactColor,
      closeButtonColor: closeButtonColor ?? this.closeButtonColor,
      searchContactHighlightColor:
          searchContactHighlightColor ?? this.searchContactHighlightColor,
    );
  }
}
