import Foundation

/// Размер корневого элемента `<svg>`, который Figma выгружает равным боксу компонента.
/// Геометрия SF Symbols строится именно от этого бокса, а не от границ видимых путей,
/// чтобы сохранить заложенные в Figma отступы.
struct SVGCanvas: Equatable {

    let width: Double
    let height: Double
}
