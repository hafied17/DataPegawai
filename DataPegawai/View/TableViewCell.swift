//
//  TableViewCell.swift
//  DataPegawai
//
//  Created by hafied Khalifatul ash.shiddiqi on 22/11/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var subtitleCell: UILabel!
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
