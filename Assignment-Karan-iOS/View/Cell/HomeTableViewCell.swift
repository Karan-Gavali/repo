//
//  HomeTableViewCell.swift
//  Assignment-Karan-iOS
//
//  Created by Karan Gavali on 04/12/17.
//  Copyright © 2017 Karan Gavali. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var terretoryLabel: UILabel!
    var title: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Custom Method
    
    func setDto(_ title:String) {
        self.title = title
        setData()
    }
    
    private func setData() {
        terretoryLabel.text = title
    }

}
