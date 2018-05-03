//
//  PrticipantCell.swift
//  4_week_homework_final
//
//  Created by Dorota Piačeková on 01/05/2018.
//  Copyright © 2018 Etnetera, a. s. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Cell

public class ParticipantCell: UITableViewCell {
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

