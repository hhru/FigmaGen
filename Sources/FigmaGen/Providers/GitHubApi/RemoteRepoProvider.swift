import Foundation
import PromiseKit

protocol RemoteRepoProvider {

    // MARK: - Instance Methods

    func request<Route: GitHubAPIRoute>(route: Route) -> Promise<Route.Response>
    func request<Route: GitHubAPIRoute>(route: Route) -> Promise<Void> where Route.Response == GitHubAPIEmptyResponse
}
