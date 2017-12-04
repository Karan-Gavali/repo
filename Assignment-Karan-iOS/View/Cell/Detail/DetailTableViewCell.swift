//
//  DetailTableViewCell.swift
//  Assignment-Karan-iOS
//
//  Created by Karan Gavali on 04/12/17.
//  Copyright © 2017 Karan Gavali. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setWeatherValue(_ value:String, _ index:Int) {
        detailLabel.text = value
        monthLabel.text = Params.getMonth(index: index + 1)
    }

}
