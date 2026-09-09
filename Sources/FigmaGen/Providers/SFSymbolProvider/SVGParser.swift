import Foundation

protocol SVGParser {

    func parse(data: Data) throws -> SVGDocument
}
