//
//  WordListCell.swift
//  Dictioly
//
//  Created by Nikolay Goncharenko on 27.07.2021.
//

import UIKit

class WordListCell: UITableViewCell {

	@IBOutlet weak var nameOfWordListLabel: UILabel!
	@IBOutlet weak var flagImageFromLeftSide: UIImageView!
	@IBOutlet weak var rightArrow: UILabel!
	@IBOutlet weak var flagImageFromRightSide: UIImageView!
	@IBOutlet weak var countItemsLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		flagImageFromLeftSide.layer.borderWidth = 0.1
		flagImageFromLeftSide.layer.cornerRadius = 10
		flagImageFromLeftSide.tintColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		
		flagImageFromRightSide.layer.borderWidth = 0.1
		flagImageFromRightSide.layer.cornerRadius = 10
		flagImageFromRightSide.tintColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
