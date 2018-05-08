import Foundation

class RemoteDataProvider: RemoteDataProviderType {
    func loadAccount(id: Int, token: String, completion: @escaping (BusinessCardContent?) -> Void) {
        var url = getUrl(for: .account)
        url = URL(string: url.absoluteString + "\(id)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(token, forHTTPHeaderField: "AccessToken")
        let urlSession = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let decoder = JSONDecoder()
            let model = try? decoder.decode(BusinessCardContent.self, from: data)
            DispatchQueue.main.async {
                completion(model)
            }
        }
        urlSession.resume()
    }
    func login(email: String, password: String, completion: @escaping (AccountCredentials?) -> Void) {
        let url = getUrl(for: .login)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let login = Login(email, password)
        let data = try? encoder.encode(login)
        urlRequest.httpBody = data
        let urlSession = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let decoder = JSONDecoder()
            let login = try? decoder.decode(AccountCredentials.self, from: data)
            DispatchQueue.main.async {
                completion(login)
            }
        }
        urlSession.resume()
    }
    func loadParticipant(id: Int, completion: @escaping (BusinessCardContent?) -> Void) {
        var url = getUrl(for: .participant)
        url = URL(string: url.absoluteString + "\(id)")!
        let urlSession = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            let decoder = JSONDecoder()
            let model = try? decoder.decode(BusinessCardContent.self, from: data)
            DispatchQueue.main.async {
                completion(model)
            }
        }
        urlSession.resume()
    }
    func loadParticipants(completion: @escaping (_ participants: [Participant]?) -> Void) {
        let url = getUrl(for: .participants)
        let urlSession = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let decoder = JSONDecoder()
            let model = try? decoder.decode([Participant].self, from: data)
            DispatchQueue.main.async {
                completion(model)
            }
        }
        urlSession.resume()
    }
}
