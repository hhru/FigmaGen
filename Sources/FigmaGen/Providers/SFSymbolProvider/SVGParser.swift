import Foundation

protocol SVGParser {

    func parse(id: String, data: Data) throws -> SVGPathsResult
}
