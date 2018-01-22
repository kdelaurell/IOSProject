//
//  CountryCell.swift
//  IOSProject
//
//  Created by Kyle De Laurell on 1/6/18.
//  Copyright © 2018 Kyle De Laurell. All rights reserved.
//

import UIKit

class CountryCell: UICollectionViewCell, NibLoadableView {

    //--------------------------------------------------------------------------
    //--------------------Initialize Variables----------------------------------
    //--------------------------------------------------------------------------
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //--------------------------------------------------------------------------
    //--------------------Configure Cell----------------------------------------
    //--------------------------------------------------------------------------
    func configureCell(name: String, photo: UIImage) {
        self.countryName.text = name
        self.countryFlag.image = photo
    }
}
