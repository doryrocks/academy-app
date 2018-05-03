//
//  ParticipantsListVM.swift
//  4_week_homework_final
//
//  Created by Dorota Piačeková on 24/04/2018.
//  Copyright © 2018 Etnetera, a. s. All rights reserved.
//

import Foundation
import Kingfisher

// MARK: - ViewModel

enum Row {
    case participant(Participant)
}

protocol ViewModelType {
    typealias Section = (header: String?, rows: [Row], footer: String?)
    typealias Model = [Section]
    var model: Model { get }
    var didUpdateModel: ((Model) -> Void)? { get set }
    func numberOfSections() -> Int
    func numberOfRows(inSection: Int) -> Int
    func modelForSection(_ section: Int) -> Section
    func modelForRow(inSection: Int, atIdx: Int) -> Row
}

extension ViewModelType {
    func numberOfSections() -> Int {
        return model.count
    }
    func numberOfRows(inSection: Int) -> Int {
        return model[inSection].rows.count
    }
    func modelForSection(_ section: Int) -> ViewModelType.Section {
        return model[section]
    }
    func modelForRow(inSection: Int, atIdx: Int) -> Row {
        return model[inSection].rows[atIdx]
    }
}

class ViewModel: ViewModelType {
    var loaded: Bool = false
    private(set) var model: [ViewModelType.Section] = [] {
        didSet {
            didUpdateModel?(model)
        }
    }
    var didUpdateModel: ((Model) -> Void)?
    func loadData(with dataProvider: RemoteDataProviderType) {
        dataProvider.loadParticipants { [weak self] (participants) in
            guard let participants = participants else {
                print("Loading participants has failed.")
                return
            }
            let part = participants.map {
                Row.participant($0)
            }
            self?.loaded = true
            self?.model = [Section(header: nil, rows: part, footer: nil)]
        }
    }
}
