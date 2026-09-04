import Foundation

/// Переводит данные пути SVG (атрибут `d`) в другое координатное пространство,
/// применяя аффинное преобразование - масштаб мастера SF Symbols вместе с `transform`
/// групп и самого пути.
///
/// Разбор попутно нормализует путь: все команды на выходе абсолютные, `H` и `V` становятся `L`.
/// Иначе поворот, отражение и неравномерный масштаб дали бы неверный результат -
/// горизонтальный отрезок после них перестаёт быть горизонтальным.
struct SVGPathTransformer {

    // MARK: - Nested Types

    private enum Command {

        // Количество параметров в одной группе параметров команды.
        static let arities: [Character: Int] = [
            "m": 2,
            "l": 2,
            "t": 2,
            "h": 1,
            "v": 1,
            "c": 6,
            "s": 4,
            "q": 4,
            "a": 7,
            "z": 0
        ]

        // Индексы флагов large-arc и sweep у эллиптической дуги.
        static let arcFlagIndexes = [3, 4]
    }

    private struct Point {

        static let zero = Self(x: 0.0, y: 0.0)

        let x: Double
        let y: Double
    }

    /// Положение при разборе: текущая точка, от которой отсчитываются относительные команды,
    /// и начало текущего контура, в которое возвращает `z`.
    private struct Cursor {

        var currentPoint: Point = .zero
        var subpathStart: Point = .zero
    }

    // MARK: - Instance Properties

    let transform: SVGTransform

    // MARK: - Instance Methods

    func transform(pathData: String) throws -> String {
        var reader = SVGReader(pathData)
        var cursor = Cursor()
        var commands: [String] = []

        while let commandCharacter = reader.readCommand() {
            commands += try makeCommands(
                for: commandCharacter,
                reader: &reader,
                cursor: &cursor,
                pathData: pathData
            )
        }

        guard !commands.isEmpty, reader.isAtEnd() else {
            throw SVGParserError.invalidPathData(pathData)
        }

        return commands.joined(separator: " ")
    }

    // MARK: -

    /// Разбирает одну букву команды вместе со всеми её группами параметров:
    /// в данных пути команду разрешено не повторять для каждой следующей группы.
    private func makeCommands(
        for commandCharacter: Character,
        reader: inout SVGReader,
        cursor: inout Cursor,
        pathData: String
    ) throws -> [String] {
        let isAbsolute = commandCharacter.isUppercase

        var command = Character(commandCharacter.lowercased())

        guard let arity = Command.arities[command] else {
            throw SVGParserError.invalidPathData(pathData)
        }

        guard arity > 0 else {
            // После закрытия контура текущей становится его начальная точка.
            cursor.currentPoint = cursor.subpathStart

            return ["Z"]
        }

        var commands: [String] = []
        var isFirstGroup = true

        repeat {
            let parameters = try readParameters(
                count: arity,
                isArc: command == "a",
                from: &reader,
                pathData: pathData
            )

            // Повторные группы параметров после moveto по спецификации трактуются как lineto.
            if command == "m", !isFirstGroup {
                command = "l"
            }

            commands.append(
                try makeCommand(
                    command,
                    parameters: parameters,
                    isAbsolute: isAbsolute,
                    currentPoint: &cursor.currentPoint,
                    pathData: pathData
                )
            )

            if command == "m" {
                cursor.subpathStart = cursor.currentPoint
            }

            isFirstGroup = false
        } while reader.hasNumber()

        return commands
    }

    private func readParameters(
        count: Int,
        isArc: Bool,
        from reader: inout SVGReader,
        pathData: String
    ) throws -> [Double] {
        try (0..<count).map { index in
            // Флаги дуги читаются отдельно: их разрешено писать слитно, без разделителей.
            let isFlag = isArc && Command.arcFlagIndexes.contains(index)

            guard let parameter = isFlag ? reader.readFlag() : reader.readNumber() else {
                throw SVGParserError.invalidPathData(pathData)
            }

            return parameter
        }
    }

    private func makeCommand(
        _ command: Character,
        parameters: [Double],
        isAbsolute: Bool,
        currentPoint: inout Point,
        pathData: String
    ) throws -> String {
        // Все смещения одной группы отсчитываются от точки, в которой команда началась,
        // поэтому она фиксируется до пересчёта.
        let origin = currentPoint

        func point(_ x: Double, _ y: Double) -> Point {
            isAbsolute ? Point(x: x, y: y) : Point(x: origin.x + x, y: origin.y + y)
        }

        switch command {
        case "m", "l", "t":
            let endPoint = point(parameters[0], parameters[1])

            currentPoint = endPoint

            return makeCommand(Character(command.uppercased()), points: [endPoint])

        case "h":
            let endPoint = Point(x: isAbsolute ? parameters[0] : origin.x + parameters[0], y: origin.y)

            currentPoint = endPoint

            return makeCommand("L", points: [endPoint])

        case "v":
            let endPoint = Point(x: origin.x, y: isAbsolute ? parameters[0] : origin.y + parameters[0])

            currentPoint = endPoint

            return makeCommand("L", points: [endPoint])

        case "c":
            let endPoint = point(parameters[4], parameters[5])

            currentPoint = endPoint

            return makeCommand(
                "C",
                points: [point(parameters[0], parameters[1]), point(parameters[2], parameters[3]), endPoint]
            )

        // Обе команды задают одну контрольную точку и конец. У сглаженной `s` вторая контрольная
        // точка подразумевается отражением предыдущей относительно текущей - аффинное
        // преобразование сохраняет отражения, поэтому восстанавливать её не нужно.
        // По той же причине не нужна и подразумеваемая контрольная точка `t` выше.
        case "s", "q":
            let endPoint = point(parameters[2], parameters[3])

            currentPoint = endPoint

            return makeCommand(
                command == "s" ? "S" : "Q",
                points: [point(parameters[0], parameters[1]), endPoint]
            )

        case "a":
            let endPoint = point(parameters[5], parameters[6])

            currentPoint = endPoint

            return try makeArcCommand(parameters: parameters, endPoint: endPoint, pathData: pathData)

        default:
            throw SVGParserError.invalidPathData(pathData)
        }
    }

    private func makeArcCommand(parameters: [Double], endPoint: Point, pathData: String) throws -> String {
        // Произвольное преобразование превращает окружность в эллипс, и новые радиусы приходится
        // искать разложением матрицы. Подобие такого не требует, а Figma ничего другого не отдаёт,
        // поэтому остальные случаи честно отвергаются, а не пересчитываются неверно.
        guard transform.isSimilarity else {
            throw SVGParserError.unsupportedArcTransform(pathData)
        }

        let scale = transform.linearScaleX
        let isMirrored = transform.determinant < 0.0
        let rotation = transform.rotation * 180.0 / .pi

        // Подобие сохраняет пропорции эллипса: радиусы масштабируются, а наклон складывается
        // с поворотом преобразования. Отражение меняет знак наклона и направление обхода дуги.
        let transformedEndPoint = transform.apply(x: endPoint.x, y: endPoint.y)

        let values = [
            parameters[0] * scale,
            parameters[1] * scale,
            normalizedRotation(isMirrored ? rotation - parameters[2] : rotation + parameters[2]),
            parameters[3],
            isMirrored ? 1.0 - parameters[4] : parameters[4],
            transformedEndPoint.x,
            transformedEndPoint.y
        ]

        return "A".appending(values.map(SVGNumber.string).joined(separator: " "))
    }

    /// Эллипс центрально симметричен, поэтому его наклон определён с точностью до 180°.
    /// Приведение к [0, 180) убирает из вывода отрицательные и избыточные углы.
    private func normalizedRotation(_ degrees: Double) -> Double {
        let rotation = degrees.truncatingRemainder(dividingBy: 180.0)

        return rotation < 0.0 ? rotation + 180.0 : rotation
    }

    private func makeCommand(_ command: Character, points: [Point]) -> String {
        let values = points.flatMap { point -> [Double] in
            let transformedPoint = transform.apply(x: point.x, y: point.y)

            return [transformedPoint.x, transformedPoint.y]
        }

        return String(command).appending(values.map(SVGNumber.string).joined(separator: " "))
    }
}
