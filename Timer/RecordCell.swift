//
//  RecordCell.swift
//  Timer
//
//  Created by Calvin Chang on 12/03/2018.
//  Copyright © 2018 CalvinChang. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {

    @IBOutlet fileprivate weak var cellTitleLabel: UILabel!

    @IBOutlet fileprivate weak var cellCountLabel: UILabel!

    internal var cellTitle = "" {
        didSet {
            cellTitleLabel?.text = cellTitle
        }
    }

    internal var cellCount = 1 {
        didSet {
            cellCountLabel?.text = "\(cellCount)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Do nothing
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Do nothing
    }
}
