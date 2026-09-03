import Foundation

/// Роль пути в палитре слоёв. Определяется по id пути, а если его нет - по заливке:
/// чёрная заливка из Figma даёт primary, любая другая - secondary.
enum SFSymbolRole: String {

    case primary
    case secondary
    case tertiary
}
