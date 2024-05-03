import Foundation

struct RemoteRepoConfiguration: Decodable {

    let owner: String
    let repo: String
    let branch: String
    let filePath: String
    let accessToken: String?
}
