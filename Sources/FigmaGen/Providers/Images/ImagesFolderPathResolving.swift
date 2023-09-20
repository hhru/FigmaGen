import Foundation
import PathKit

protocol ImagesFolderPathResolving {

    // MARK: - Instance Methods

    func resolveFolderPath(
        groupByFrame: Bool,
        groupByComponentSet: Bool,
        parentNodeName: String?,
        isSingleComponent: Bool,
        nodeName: String,
        folderPath: Path
    ) -> Path
}

extension ImagesFolderPathResolving {

    // MARK: - Instance Methods

    func resolveFolderPath(
        groupByFrame: Bool,
        groupByComponentSet: Bool,
        parentNodeName: String?,
        isSingleComponent: Bool,
        nodeName: String,
        folderPath: Path
    ) -> Path {
        var folderPath = folderPath

        if groupByFrame, let name = parentNodeName {
            folderPath = folderPath.appending(name.camelized)
        }

        if groupByComponentSet, !isSingleComponent {
            folderPath = folderPath.appending(nodeName.camelized)
        }

        return folderPath
    }

    func resolveFolderPath(
        groupByFrame: Bool,
        groupByComponentSet: Bool,
        setNode: ImageComponentSetRenderedNode,
        folderPath: Path
    ) -> Path {
        resolveFolderPath(
            groupByFrame: groupByFrame,
            groupByComponentSet: groupByComponentSet,
            parentNodeName: setNode.parentName,
            isSingleComponent: setNode.type == .component,
            nodeName: setNode.name,
            folderPath: folderPath
        )
    }

    func resolveFolderPath(
        groupByFrame: Bool,
        groupByComponentSet: Bool,
        setAsset: ImageComponentSetAsset,
        folderPath: Path
    ) -> Path {
        resolveFolderPath(
            groupByFrame: groupByFrame,
            groupByComponentSet: groupByComponentSet,
            parentNodeName: setAsset.parentName,
            isSingleComponent: setAsset.nodeType == .component,
            nodeName: setAsset.name,
            folderPath: folderPath
        )
    }
}
