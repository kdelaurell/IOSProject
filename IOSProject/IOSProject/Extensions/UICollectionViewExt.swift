//
//  UICollectionViewExt.swift
//  IOSProject
//
//  Created by Kyle De Laurell on 1/22/18.
//  Copyright © 2018 Kyle De Laurell. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) where  T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseID)
    }
    
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseID)")
        }
        return cell
    }
}

extension UICollectionViewCell: ReusableView {}
