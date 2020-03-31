//
//  CustomTableViewCell.swift
//  QurantinePushUp
//
//  Created by Dawson on 2020-03-31.
//  Copyright © 2020 Dawson. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var pushups: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
