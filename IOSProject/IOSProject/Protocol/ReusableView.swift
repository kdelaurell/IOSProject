//
//  ReusableView.swift
//  IOSProject
//
//  Created by Kyle De Laurell on 1/22/18.
//  Copyright © 2018 Kyle De Laurell. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView : class {}

extension ReusableView where Self: UIView {
    static var reuseID : String{
        return String(describing: self)
    }
}
