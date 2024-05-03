import Foundation
import FigmaGenTools

struct GitHubAPIFileRoute: GitHubAPIRoute {

    typealias Response = GitHubFile

    private let owner: String
    private let repo: String
    private let branch: String
    private let filePath: String

    let accessToken: String?
    var urlPath: String { "\(owner)/\(repo)/\(branch)/\(filePath)" }

    init(owner: String, repo: String, branch: String, filePath: String, accessToken: String?) {
        self.owner = owner
        self.repo = repo
        self.branch = branch
        self.filePath = filePath
        self.accessToken = accessToken
    }
}
