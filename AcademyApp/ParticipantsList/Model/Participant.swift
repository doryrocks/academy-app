import Foundation

class Participant: Decodable {
    let id: Int
    let name: String
    let imageUrl: String
    let scores: [Score]
    
    
    init(id: Int, name: String, imageUrl: String, scores: [Score]) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.scores = scores
    }
}

extension Participant: CustomStringConvertible {
    var description: String {
        return "id: \(id), name: \(name), imageUrl: \(imageUrl), scores: \(scores)"
    }
}
