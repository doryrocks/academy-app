import Foundation

enum Endpoint: String {
    case participants = "/api/participants"
    case login = "/api/login"
    case participant = "/api/participant/"
    case account = "/api/account/"
}

protocol RemoteDataProviderType: DataProviderType {
    var baseUrl: String { get }
    func getUrl(for endpoint: Endpoint) -> URL
}

extension RemoteDataProviderType {
    var baseUrl: String {
        return "http://emarest.cz.mass-php-1.mit.etn.cz"
    }
    func getUrl(for endpoint: Endpoint) -> URL {
        return URL(string: baseUrl + endpoint.rawValue)!
    }
}
