import Foundation

struct RemoteFileParameters { 
    let owner: String
    let repo: String
    let branch: String
    let filePath: String
    let accessToken: String?
    let tokenSets: W3CTokenSetsMapping

    init(
        owner: String,
        repo: String,
        branch: String,
        filePath: String,
        accessToken: String?,
        tokenSets: W3CTokenSetsMapping
    ) {
        self.owner = owner
        self.repo = repo
        self.branch = branch
        self.filePath = filePath
        self.accessToken = accessToken
        self.tokenSets = tokenSets
    }
}
