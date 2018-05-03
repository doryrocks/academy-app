//
//  LoginVM.swift
//  4_week_homework_final
//
//  Created by Dorota Piačeková on 24/04/2018.
//  Copyright © 2018 Etnetera, a. s. All rights reserved.
//

import Foundation

protocol InputVMType {
    func login(email: String, password: String, completion: @escaping (BusinessCardContent?) -> Void)
}

class InputVM: InputVMType {
    private let dataProvider: DataProviderType
    
    init() {
        dataProvider = RemoteDataProvider()
    }
    
    func login(email: String, password: String, completion: @escaping (BusinessCardContent?) -> Void) {
        dataProvider.login(email: email, password: password) { [weak self] credentials in
            if credentials == nil {
                completion(nil)
            } else {
                self?.dataProvider.loadAccount(id: (credentials?.accountId)!, token: (credentials?.accessToken)!) { participant in
                    completion(participant)
                }
            }
        }
    }
    
}
