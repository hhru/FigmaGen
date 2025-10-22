import Foundation

struct RemoteFileParameters { 
    let owner: String
    let repo: String
    let branch: String
    let filePath: String
    let accessToken: String?

    init(
        owner: String,
        repo: String,
        branch: String,
        filePath: String,
        accessToken: String?
    ) {
        self.owner = owner
        self.repo = repo
        self.branch = branch
        self.filePath = filePath
        self.accessToken = accessToken
    }
}
