//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import PromiseKit

protocol FigmaAPIProvider {

    // MARK: - Instance Methods

    func request<Route: FigmaAPIRoute>(route: Route) -> Promise<Route.Response>
}
