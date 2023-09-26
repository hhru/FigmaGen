import Foundation

struct Logger {

    // MARK: - Type Properties

    static let verboseLogKey = "VERBOSE_LOG"

    // MARK: - Instance Properties

    let isSilent: Bool
    let printer: LoggerPrinting

    var isVerbose: Bool {
        ProcessInfo.processInfo.environment[Self.verboseLogKey] != nil
    }

    // MARK: - Initializers

    init(isSilent: Bool = false, printer: LoggerPrinting = DefaultLoggerPrinter()) {
        self.isSilent = isSilent
        self.printer = printer
    }

    // MARK: - Instance Methods

    private func print(_ message: String, terminator: String = "\n", isVerbose: Bool) {
        guard !isSilent else {
            return
        }

        guard !isVerbose || (isVerbose && self.isVerbose) else {
            return
        }

        printer.print(message, terminator: terminator)
    }

    // MARK: -

    func debug(_ items: Any..., separator: String = " ", terminator: String = "\n", isVerbose: Bool = true) {
        let message = items.joinedDescription(separator: separator)
        print(message, terminator: terminator, isVerbose: isVerbose)
    }

    func info(_ items: Any..., separator: String = " ", terminator: String = "\n", isVerbose: Bool = false) {
        let message = items.joinedDescription(separator: separator)
        print(message, terminator: terminator, isVerbose: isVerbose)
    }

    func warning(_ items: Any..., separator: String = " ", terminator: String = "\n", isVerbose: Bool = false) {
        let message = "⚠️ WARNING: \(items.joinedDescription(separator: separator))".yellow
        print(message, terminator: terminator, isVerbose: isVerbose)
    }

    func success(_ items: Any..., separator: String = " ", terminator: String = "\n", isVerbose: Bool = false) {
        let message = "✅ \(items.joinedDescription(separator: separator))".green
        print(message, terminator: terminator, isVerbose: isVerbose)
    }

    func error(_ items: Any..., separator: String = " ", terminator: String = "\n", isVerbose: Bool = false) {
        let message = "🛑 ERROR: \(items.joinedDescription(separator: separator))".red
        print(message, terminator: terminator, isVerbose: isVerbose)
    }
}

// MARK: -

extension Sequence {

    // MARK: - Instance Methods

    fileprivate func joinedDescription(separator: String) -> String {
        map { "\($0)" }.joined(separator: separator)
    }
}
