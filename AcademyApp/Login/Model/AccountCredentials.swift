import Foundation

class AccountCredentials: Decodable {
    let accountId: Int
    let accessToken: String
    
    init(accountId: Int, accessToken: String) {
        self.accountId = accountId
        self.accessToken = accessToken
    }
}

extension AccountCredentials: CustomStringConvertible {
    var description: String {
        return "accountId: \(accountId), accessToken: \(accessToken)"
    }
}
