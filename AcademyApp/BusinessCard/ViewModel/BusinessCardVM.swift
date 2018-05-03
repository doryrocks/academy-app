//
//  BusinessCardVM.swift
//  4_week_homework_final
//
//  Created by Dorota Piačeková on 24/04/2018.
//  Copyright © 2018 Etnetera, a. s. All rights reserved.
//

import Foundation
import UIKit

protocol BusinessCardVMType {
    var content: BusinessCardContent? { get set }
    func loadParticipant(id: Int, completion: @escaping (_ participant: BusinessCardContent?) -> Void)
    func getSlackIconUrl() -> URL
    func getEmailIconUrl() -> URL
    func getPhoneIconUrl() -> URL
}
class BusinessCardVM: BusinessCardVMType {
    
    let displayPadding: CGFloat = 30
    let buttonHeight: CGFloat = 44
    let spacing: (low: CGFloat, mid: CGFloat, high: CGFloat) = (10, 20, 40)
    let fontSize: (medium: CGFloat, large: CGFloat, xLarge: CGFloat) = (14, 18, 24)
    private let scale = UIScreen.main.scale
    
    func getSlackIconUrl() -> URL {
        return URL(string: "https://firebasestorage.googleapis.com/v0/b/etneteramobile.appspot.com/o/ic-slack%2Fic-slack.png?alt=media&token=987d727a-a8fe-4fa4-a30a-0429dc7a9422")!
    }
    
    func getPhoneIconUrl() -> URL {
        return URL(string: "https://firebasestorage.googleapis.com/v0/b/etneteramobile.appspot.com/o/ic-phone%2Fic-phone.png?alt=media&token=9381f051-30e9-4dc8-8126-48f06741b930")!
    }
    
    func getEmailIconUrl() -> URL {
        return URL(string: "https://firebasestorage.googleapis.com/v0/b/etneteramobile.appspot.com/o/ic-email%2Fic-email.png?alt=media&token=de9ae131-fba8-4dd2-a530-2d944443b62b")!
    }
    
    var content: BusinessCardContent?
    private let dataProvider: DataProviderType
    
    init() {
        dataProvider = RemoteDataProvider()
    }
    
    func loadParticipant(id: Int, completion: @escaping (BusinessCardContent?) -> Void) {
        dataProvider.loadParticipant(id: id) { participant in
            completion(participant)
        }
    }
    
   
}
