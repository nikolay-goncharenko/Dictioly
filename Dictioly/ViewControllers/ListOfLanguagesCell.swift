//
//  ListOfLanguagesCell.swift
//  Dictioly
//
//  Created by Nikolay Goncharenko on 04.08.2021.
//

import UIKit

class ListOfLanguagesCell: UITableViewCell {
	
	@IBOutlet weak var countryFlag: UIImageView!
	@IBOutlet weak var countryLanguage: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
		countryFlag.layer.cornerRadius = 12.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
