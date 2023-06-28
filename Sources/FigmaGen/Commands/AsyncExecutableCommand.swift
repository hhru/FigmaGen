import Foundation
import SwiftCLI
import Rainbow

protocol AsyncExecutableCommand: Command {

    // MARK: - Instance Methods

    func executeAsyncAndExit() async throws

    func fail(message: String) -> Never
    func succeed(message: String) -> Never
}

extension AsyncExecutableCommand {

    // MARK: - Instance Methods

    func execute() throws {
        _Concurrency.Task {
            try await executeAsyncAndExit()
        }

        RunLoop.main.run()
    }

    func fail(message: String) -> Never {
        stderr <<< message.red

        exit(EXIT_FAILURE)
    }

    func succeed(message: String) -> Never {
        stdout <<< message.green

        exit(EXIT_SUCCESS)
    }
}
