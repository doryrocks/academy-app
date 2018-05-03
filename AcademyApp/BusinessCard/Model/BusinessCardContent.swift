import Foundation


public class BusinessCardContent: Decodable {
    public let id: Int
    public let name: String
    public let imageUrl: String
    public let slack_id: String
    public let email: String
    public let phone: String
    public let position: String
    public let scores: [Score]

    public init(id: Int, name: String, imageUrl: String, slack_id: String, email: String, phone: String, position: String, scores: [Score]) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.slack_id = slack_id
        self.email = email
        self.phone = phone
        self.position = position
        self.scores = scores
    }
}
