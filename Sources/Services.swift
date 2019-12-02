//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

final class Services {

    // MARK: - Instance Methods

    private func makeAPIProvider(accessToken: String) -> FigmaAPIProvider {
        return DefaultFigmaAPIProvider(accessToken: accessToken)
    }

    private func makeNodesExtractor() -> NodesExtractor {
        return DefaultNodesExtractor()
    }
}

extension Services: ColorsServices {

    // MARK: - Instance Methods

    func makeColorsProvider(accessToken: String) -> ColorsProvider {
        return DefaultColorsProvider(
            apiProvider: makeAPIProvider(accessToken: accessToken),
            nodesExtractor: makeNodesExtractor()
        )
    }

    func makeColorsRenderer() -> ColorsRenderer {
        return DefaultColorsRenderer()
    }
}

extension Services: TextStylesServices {

    // MARK: - Instance Methods

    func makeTextStylesProvider(accessToken: String) -> TextStylesProvider {
        return DefaultTextStylesProvider(
            apiProvider: makeAPIProvider(accessToken: accessToken),
            nodesExtractor: makeNodesExtractor()
        )
    }

    func makeTextStylesRenderer() -> TextStylesRenderer {
        return DefaultTextStylesRenderer()
    }
}
