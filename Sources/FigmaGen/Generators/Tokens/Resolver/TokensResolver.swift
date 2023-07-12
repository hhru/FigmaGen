import Foundation

protocol TokensResolver {

    // MARK: - Instance Methods

    /// Resolving references and mathematical expressions in `value` from `tokenValues`.
    ///
    /// Reference example: `{core.space.1-x} + {core.space.1-x} / 2`
    /// where `core.space.1-x == 1` the resolved value would be `1 + 1 / 2`
    /// and after evaluating the mathematical expression, the function will return `1.5`
    ///
    /// - Parameters:
    ///   - value: String value to resolve
    ///   - tokenValues: All token values
    /// - Returns: Resolved value.
    func resolveValue(_ value: String, tokenValues: TokenValues) throws -> String

    /// Resolving references and mathematical expressions in `value` using ``resolveValue(_:tokenValues:)``
    /// and convert `rgba()` to ``Color`` object
    ///
    /// Supported formats:
    /// - `rgba(hex_color, alpha-value-percentage)`
    /// - TO DO: Support more formats
    ///
    /// [Color tokens examples and should be supported later](https://docs.tokens.studio/available-tokens/color-tokens#solid-colors)
    ///
    /// - Parameters:
    ///   - value: Raw `rgba()` with references, e.g.:
    ///     ```
    ///     rgba(
    ///       {color.base.white},
    ///       {semantic.opacity.disabled}
    ///     )
    ///     ```
    ///   - tokenValues: All token values
    /// - Returns: ``Color`` object with values resolved from `rgba()`
    func resolveRGBAColorValue(_ value: String, tokenValues: TokenValues) throws -> Color

    /// Resolving references and mathematical expressions in `value` using ``resolveValue(_:tokenValues:)``
    /// and convert `rgba()` to hex value
    ///
    /// See ``resolveRGBAColorValue(_:tokenValues:)`` for supported formats for `rgba()`
    ///
    /// - Parameters:
    ///   - value: Raw `rgba()` with references, e.g.:
    ///     ```
    ///     rgba(
    ///       {color.base.white},
    ///       {semantic.opacity.disabled}
    ///     )
    ///     ```
    ///     Or simple reference to another color: `{color.base.white}`
    ///   - tokenValues: All token values
    /// - Returns: Hex value of the color
    func resolveHexColorValue(_ value: String, tokenValues: TokenValues) throws -> String

    /// Resolving references and mathematical expressions in `value` using ``resolveValue(_:tokenValues:)``
    /// and convert `linear-gradient()` to ``LinearGradient`` object
    ///
    /// Supported formats:
    /// - `linear-gradient(angle, [hex_color||rgba() length-percentage])`
    ///
    /// [Gradients tokens examples](https://docs.tokens.studio/available-tokens/color-tokens#gradients)
    ///
    /// - Parameters:
    ///   - value: Raw `linear-gradient()` with references, e.g:
    ///     ```
    ///     linear-gradient(
    ///       0deg,
    ///       rgba({color.base.red.50}, {semantic.opacity.transparent}) 0%,
    ///       {color.base.red.50} {semantic.opacity.visible}
    ///     )
    ///     ```
    ///   - tokenValues: All token values
    /// - Returns: ``LinearGradient`` object with values resolved from `linear-gradient()`
    func resolveLinearGradientValue(_ value: String, tokenValues: TokenValues) throws -> LinearGradient
}
