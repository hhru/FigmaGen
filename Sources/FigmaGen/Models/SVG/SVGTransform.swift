import Foundation

/// Аффинное преобразование SVG в том же виде, в каком его записывает атрибут `transform="matrix(a b c d e f)"`:
///
///     | a c e |
///     | b d f |
///     | 0 0 1 |
///
/// Точка `(x, y)` переходит в `(a * x + c * y + e, b * x + d * y + f)`.
struct SVGTransform: Equatable {

    // MARK: - Type Properties

    static let identity = Self(a: 1.0, b: 0.0, c: 0.0, d: 1.0, e: 0.0, f: 0.0)

    // MARK: - Type Methods

    static func translation(x: Double, y: Double) -> Self {
        Self(a: 1.0, b: 0.0, c: 0.0, d: 1.0, e: x, f: y)
    }

    static func scale(x: Double, y: Double) -> Self {
        Self(a: x, b: 0.0, c: 0.0, d: y, e: 0.0, f: 0.0)
    }

    static func rotation(degrees: Double) -> Self {
        let radians = degrees * .pi / 180.0

        return Self(a: cos(radians), b: sin(radians), c: -sin(radians), d: cos(radians), e: 0.0, f: 0.0)
    }

    static func skewX(degrees: Double) -> Self {
        Self(a: 1.0, b: 0.0, c: tan(degrees * .pi / 180.0), d: 1.0, e: 0.0, f: 0.0)
    }

    static func skewY(degrees: Double) -> Self {
        Self(a: 1.0, b: tan(degrees * .pi / 180.0), c: 0.0, d: 1.0, e: 0.0, f: 0.0)
    }

    // MARK: - Instance Properties

    // Однобуквенные имена взяты из самой спецификации SVG: `matrix(a b c d e f)`.
    // swiftlint:disable identifier_name
    let a: Double
    let b: Double
    let c: Double
    let d: Double
    let e: Double
    let f: Double
    // swiftlint:enable identifier_name

    /// Определитель линейной части. Отрицательный означает, что преобразование зеркалит плоскость,
    /// то есть меняет направление обхода контура на противоположное.
    var determinant: Double {
        a * d - b * c
    }

    /// Длины образов базисных векторов. У подобия (равномерный масштаб с поворотом
    /// и, возможно, отражением) они равны между собой.
    var linearScaleX: Double {
        (a * a + b * b).squareRoot()
    }

    var linearScaleY: Double {
        (c * c + d * d).squareRoot()
    }

    /// `true`, если преобразование переводит любую окружность в окружность, а не в эллипс:
    /// образы базисных векторов равны по длине и остаются перпендикулярными.
    /// Только для таких преобразований дуги пересчитываются в замкнутой форме, см. `SVGPathTransformer`.
    var isSimilarity: Bool {
        let scaleX = linearScaleX
        let scaleY = linearScaleY
        let tolerance = 1e-9 * Swift.max(1.0, scaleX, scaleY)

        return abs(scaleX - scaleY) <= tolerance && abs(a * c + b * d) <= tolerance * Swift.max(1.0, scaleX)
    }

    /// Угол поворота линейной части в радианах. Осмыслен только для подобия.
    var rotation: Double {
        atan2(b, a)
    }

    // MARK: - Instance Methods

    /// Матричное произведение `self * other`. В SVG вложенные преобразования применяются снаружи внутрь,
    /// поэтому список `transform="A B"` и цепочка групп собираются именно в таком порядке.
    func concatenating(_ other: Self) -> Self {
        Self(
            a: a * other.a + c * other.b,
            b: b * other.a + d * other.b,
            c: a * other.c + c * other.d,
            d: b * other.c + d * other.d,
            e: a * other.e + c * other.f + e,
            f: b * other.e + d * other.f + f
        )
    }

    /// Образ точки. Для векторов (относительных смещений) переносить `e` и `f` нельзя.
    func apply(x: Double, y: Double) -> (x: Double, y: Double) {
        (x: a * x + c * y + e, y: b * x + d * y + f)
    }
}
