//
//  UIView+Snapshot.swift
//  SongAnimation
//
//  Created by ljb48229 on 2018/4/4.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

extension UIView {
    func makeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
