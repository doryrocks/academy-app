import Foundation

protocol DataProviderType {
    func loadParticipants(completion: @escaping (_ participants: [Participant]?) -> Void)
    func login(email: String, password: String, completion: @escaping (_ accountCredentials: AccountCredentials?) -> Void)
    func loadParticipant(id: Int, completion: @escaping (_ participant: BusinessCardContent?) -> Void)
    func loadAccount(id: Int, token: String, completion: @escaping (_ participant: BusinessCardContent?) -> Void)
}
