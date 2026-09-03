import Foundation

/// Разбирает атрибут `transform` в аффинную матрицу.
enum SVGTransformParser {

    // MARK: - Nested Types

    private enum Function {

        static let matrix = "matrix"
        static let translate = "translate"
        static let scale = "scale"
        static let rotate = "rotate"
        static let skewX = "skewX"
        static let skewY = "skewY"
    }

    // MARK: - Type Methods

    /// Складывает цепочку преобразований от внешней группы к внутренней.
    /// Порядок важен: `transform` внешнего элемента применяется к результату внутреннего.
    static func transform(from values: [String]) throws -> SVGTransform {
        try values.reduce(.identity) { result, value in
            result.concatenating(try transform(from: value))
        }
    }

    static func transform(from value: String) throws -> SVGTransform {
        var reader = SVGReader(value)
        var result = SVGTransform.identity

        while let name = reader.readIdentifier() {
            guard reader.readCharacter("(") else {
                throw SVGParserError.invalidTransform(value)
            }

            var parameters: [Double] = []

            while let parameter = reader.readNumber() {
                parameters.append(parameter)
            }

            guard reader.readCharacter(")") else {
                throw SVGParserError.invalidTransform(value)
            }

            result = result.concatenating(
                try makeTransform(name: name, parameters: parameters, source: value)
            )
        }

        guard reader.isAtEnd() else {
            throw SVGParserError.invalidTransform(value)
        }

        return result
    }

    // MARK: -

    private static func makeTransform(
        name: String,
        parameters: [Double],
        source: String
    ) throws -> SVGTransform {
        switch (name, parameters.count) {
        case (Function.matrix, 6):
            return SVGTransform(
                a: parameters[0],
                b: parameters[1],
                c: parameters[2],
                d: parameters[3],
                e: parameters[4],
                f: parameters[5]
            )

        case (Function.translate, 1):
            return .translation(x: parameters[0], y: 0.0)

        case (Function.translate, 2):
            return .translation(x: parameters[0], y: parameters[1])

        // У scale с одним параметром масштаб по обеим осям одинаковый.
        case (Function.scale, 1):
            return .scale(x: parameters[0], y: parameters[0])

        case (Function.scale, 2):
            return .scale(x: parameters[0], y: parameters[1])

        case (Function.rotate, 1):
            return .rotation(degrees: parameters[0])

        // rotate с центром - это поворот, обёрнутый в перенос центра в начало координат и обратно.
        case (Function.rotate, 3):
            return SVGTransform
                .translation(x: parameters[1], y: parameters[2])
                .concatenating(.rotation(degrees: parameters[0]))
                .concatenating(.translation(x: -parameters[1], y: -parameters[2]))

        case (Function.skewX, 1):
            return .skewX(degrees: parameters[0])

        case (Function.skewY, 1):
            return .skewY(degrees: parameters[0])

        default:
            throw SVGParserError.invalidTransform(source)
        }
    }
}
