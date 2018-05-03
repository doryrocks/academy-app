import Foundation

public class Score: Decodable {
    let value: Int
    let emoji: String
    
    init(value: Int, emoji: String) {
        self.value = value
        self.emoji = emoji
    }
}

extension Score: CustomStringConvertible {
    public var description: String {
        return "\(emoji):\(value)"
    }
}

public class Score2: Decodable {
    let value: Int
    let emoji: String
    let name: String
    
    init(value: Int, emoji: String, name:String) {
        self.value = value
        self.emoji = emoji
        self.name = name
    }
}

extension Score2: CustomStringConvertible {
    public var description: String {
        return "\(emoji):\(value) \(name)"
    }
}
