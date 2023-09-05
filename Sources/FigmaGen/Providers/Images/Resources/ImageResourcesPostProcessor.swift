import Foundation
import PathKit

final class ImageResourcesPostProcessor {

    // MARK: - Instance Methods

    @discardableResult
    private func shell(_ command: String) throws -> String? {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        try task.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()

        return String(data: data, encoding: .utf8)
    }

    // MARK: -

    func execute(postProcessorPath: String, filePath: String) throws {
        let postProcessorPath = Path(postProcessorPath).absolute()
        let filePath = Path(filePath).absolute()

        try shell("\(postProcessorPath) --filePath \(filePath)")
    }
}
