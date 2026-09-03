import Foundation

/// Применяет равномерный масштаб и вертикальное смещение к данным пути SVG,
/// отображая координаты Figma в координатное пространство символов SF.
struct SVGPathTransformer {

    // MARK: - Nested Types

    private enum Command {

        // Number of parameters in a single parameter group of a command.
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

        // Indexes of the large-arc and sweep flags of an elliptical arc.
        static let arcFlagIndexes = [3, 4]
    }

    // MARK: - Instance Properties

    let scale: Double
    let translationY: Double

    // MARK: - Instance Methods

    func transform(pathData: String) throws -> String {
        var reader = SVGReader(pathData)
        var commands: [String] = []

        while let command = reader.readCommand() {
            let lowercased = Character(command.lowercased())

            guard let arity = Command.arities[lowercased] else {
                throw SVGParserError.invalidPathData(pathData)
            }

            guard arity > 0 else {
                commands.append(String(command))

                continue
            }

            let isAbsolute = command.isUppercase
            var groups: [String] = []

            repeat {
                var parameters: [Double] = []

                for index in 0..<arity {
                    let isFlag = lowercased == "a" && Command.arcFlagIndexes.contains(index)

                    guard let parameter = isFlag ? reader.readFlag() : reader.readNumber() else {
                        throw SVGParserError.invalidPathData(pathData)
                    }

                    parameters.append(parameter)
                }

                let transformedParameters = transformed(
                    parameters: parameters,
                    command: lowercased,
                    isAbsolute: isAbsolute
                )

                groups.append(transformedParameters.map(SVGNumber.string).joined(separator: " "))
            } while reader.hasNumber()

            commands.append(String(command).appending(groups.joined(separator: " ")))
        }

        guard !commands.isEmpty else {
            throw SVGParserError.invalidPathData(pathData)
        }

        return commands.joined(separator: " ")
    }

    private func transformed(
        parameters: [Double],
        command: Character,
        isAbsolute: Bool
    ) -> [Double] {
        switch command {
        case "h":
            return parameters.map { $0 * scale }

        case "v":
            return parameters.map { isAbsolute ? $0 * scale + translationY : $0 * scale }

        case "a":
            var parameters = parameters

            parameters[0] *= scale
            parameters[1] *= scale
            parameters[5] *= scale
            parameters[6] = isAbsolute ? parameters[6] * scale + translationY : parameters[6] * scale

            return parameters

        default:
            return parameters.enumerated().map { index, value in
                guard index.isMultiple(of: 2) else {
                    return isAbsolute ? value * scale + translationY : value * scale
                }

                return value * scale
            }
        }
    }
}
