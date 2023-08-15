import Foundation
import PathKit

protocol ImagesFolderPathResolving {

    // MARK: - Instance Methods

    func resolveFolderPath(
        groupByFrame: Bool,
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
        parentNodeName: String?,
        isSingleComponent: Bool,
        nodeName: String,
        folderPath: Path
    ) -> Path {
        var folderPath = folderPath

        if groupByFrame, let name = parentNodeName {
            folderPath = folderPath.appending(name.camelized)
        }

        if !isSingleComponent {
            folderPath = folderPath.appending(nodeName.camelized)
        }

        return folderPath
    }

    func resolveFolderPath(
        groupByFrame: Bool,
        setNode: ImageComponentSetRenderedNode,
        folderPath: Path
    ) -> Path {
        resolveFolderPath(
            groupByFrame: groupByFrame,
            parentNodeName: setNode.parentName,
            isSingleComponent: setNode.isSingleComponent,
            nodeName: setNode.name,
            folderPath: folderPath
        )
    }

    func resolveFolderPath(
        groupByFrame: Bool,
        setAsset: ImageComponentSetAsset,
        folderPath: Path
    ) -> Path {
        resolveFolderPath(
            groupByFrame: groupByFrame,
            parentNodeName: setAsset.parentName,
            isSingleComponent: setAsset.isSingleComponent,
            nodeName: setAsset.name,
            folderPath: folderPath
        )
    }
}
