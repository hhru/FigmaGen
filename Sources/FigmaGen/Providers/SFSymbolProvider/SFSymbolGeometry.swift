import Foundation

enum SFSymbolGeometry {

    // Типографские метрики, общие для всех строк шаблона. Cap height равен 0.70459 em - это
    // cap height SF Pro, и он подтверждает, что один em составляет 100 дизайн-единиц:
    // дизайн-бокс высотой emDesignHeight рисуется ровно в кегле шрифта.
    static let capHeight = 70.459
    static let emDesignHeight = 99.5

    // Вертикальные границы направляющих полей, отсчитанные от базовой линии своей строки.
    static let marginGuideTopOffset = 95.215
    static let marginGuideBottomOffset = 24.121

    // Горизонтальные центры колонок начертаний, взятые из подписей
    // раздела "Weight/Scale Variations" шаблона.
    static let weights: [(name: String, centerX: Double)] = [
        (name: "Ultralight", centerX: 559.711),
        (name: "Regular", centerX: 1449.845),
        (name: "Black", centerX: 2933.4)
    ]

    // Базовые линии строк масштабов. Каждый масштаб задан явно и несёт один и тот же рисунок,
    // поэтому SF Symbols ничего не достраивает, и запрошенный приложением image scale
    // не может изменить итоговый размер.
    static let scales: [(name: String, baseline: Double)] = [
        (name: "S", baseline: 696.0),
        (name: "M", baseline: 1126.0),
        (name: "L", baseline: 1556.0)
    ]
}
