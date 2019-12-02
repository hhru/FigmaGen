//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

protocol FigmaAPIRoute {

    // MARK: - Nested Types

    associatedtype Response: Decodable
    associatedtype Parameters: Encodable

    // MARK: - Instance Properties

    var apiVersion: FigmaAPIVersion { get }
    var httpMethod: FigmaAPIHTTPMethod { get }
    var urlPath: String { get }
    var parameters: Parameters { get }
}

extension FigmaAPIRoute {

    // MARK: - Instance Properties

    var apiVersion: FigmaAPIVersion {
        .v1
    }

    var httpMethod: FigmaAPIHTTPMethod {
        .get
    }
}
