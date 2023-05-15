//
//  UIImage+Scale.swift
//  PokeGuide
//
//  Created by Beavean on 06.05.2023.
//

import UIKit

extension UIImage {
    func scale(to size: CGSize) -> UIImage {
        let aspectRatio = self.size.width / self.size.height
        var newSize = size
        if aspectRatio > 1 {
            newSize.height = size.width / aspectRatio
        } else {
            newSize.width = size.height * aspectRatio
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
