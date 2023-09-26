import Foundation

struct DefaultLoggerPrinter: LoggerPrinting {

    // MARK: - LoggerPrinting

    func print(_ message: String, terminator: String) {
        Swift.print(message, terminator: terminator)
    }
}
