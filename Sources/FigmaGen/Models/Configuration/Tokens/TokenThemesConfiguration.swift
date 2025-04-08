import Foundation

struct TokenThemesConfiguration: Codable {
    let themes: [Theme]
    let fallbackTheme: Theme

    init(themes: [Theme], fallbackTheme: Theme) {
        self.themes = themes
        self.fallbackTheme = fallbackTheme
    }
}
