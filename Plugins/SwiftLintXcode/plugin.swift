import Foundation
import PackagePlugin

@main
struct SwiftLintPlugin {

    private func makeBuildCommands(
        inputFiles: [Path],
        packageDirectory: Path,
        workingDirectory: Path,
        tool: PluginContext.Tool
    ) -> [Command] {
        guard !inputFiles.isEmpty else {
            return []
        }

        var arguments = ["--quiet"]

        if let configuration = packageDirectory.firstConfigurationFileInParentDirectories() {
            arguments.append(contentsOf: ["--config", "\(configuration.string)"])
        }

        arguments += inputFiles.map { $0.string }

        let outputFilesDirectory = workingDirectory.appending("Output")

        return [
            .prebuildCommand(
                displayName: "SwiftLint",
                executable: tool.path,
                arguments: arguments,
                outputFilesDirectory: outputFilesDirectory
            )
        ]
    }
}

// MARK: - BuildToolPlugin
extension SwiftLintPlugin: BuildToolPlugin {

    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard ProcessInfo.processInfo.environment["SKIP_SWIFTLINT"] != "YES" else {
            return []
        }

        guard let sourceTarget = target as? SourceModuleTarget else {
            return []
        }

        return makeBuildCommands(
            inputFiles: sourceTarget.sourceFiles(withSuffix: "swift").map { $0.path },
            packageDirectory: context.package.directory,
            workingDirectory: context.pluginWorkDirectory,
            tool: try context.tool(named: "swiftlint")
        )
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

// MARK: - XcodeBuildToolPlugin
extension SwiftLintPlugin: XcodeBuildToolPlugin {

    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        guard ProcessInfo.processInfo.environment["SKIP_SWIFTLINT"] != "YES" else {
            return []
        }

        return makeBuildCommands(
            inputFiles: target.inputFiles
                .filter { $0.type == .source && $0.path.extension == "swift" }
                .map { $0.path },
            packageDirectory: context.xcodeProject.directory,
            workingDirectory: context.pluginWorkDirectory,
            tool: try context.tool(named: "swiftlint")
        )
    }
}
#endif

extension Path {

    /// Safe way to check if the file is accessible from within the current process sandbox.
    private func isAccessible() -> Bool {
        let result = string.withCString { pointer in
            access(pointer, R_OK)
        }

        return result == 0
    }

    /// Scans the receiver, then all of its parents looking for a configuration file with the name ".swiftlint.yml".
    ///
    /// - returns: Path to the configuration file, or nil if one cannot be found.
    func firstConfigurationFileInParentDirectories() -> Path? {
        let defaultConfigurationFileName = ".swiftlint.yml"

        let proposedDirectory = sequence(
            first: self,
            next: { path in
                guard path.stem.count > 1 else {
                    // Check we're not at the root of this filesystem, as `removingLastComponent()`
                    // will continually return the root from itself.
                    return nil
                }

                return path.removingLastComponent()
            }
        ).first { path in
            let potentialConfigurationFile = path.appending(subpath: defaultConfigurationFileName)
            return potentialConfigurationFile.isAccessible()
        }

        return proposedDirectory?.appending(subpath: defaultConfigurationFileName)
    }
}
