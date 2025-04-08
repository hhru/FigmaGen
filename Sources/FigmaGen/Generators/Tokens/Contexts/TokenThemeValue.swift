import Foundation

struct TokenThemeValue<T> {

    let themeName: String
    let value: T

    init(theme: String, value: T) {
        self.themeName = theme
        self.value = value
    }
}
