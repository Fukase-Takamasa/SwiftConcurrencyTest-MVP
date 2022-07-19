//
//  PlaceHolderImageUtil.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 19/7/22.
//

import UIKit

class PlaceHolderImageUtil {
    static func userIconPlaceHolderImage() -> UIImage {
        let systemImageConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular, scale: .default)
        return UIImage(systemName: "person.crop.circle", withConfiguration: systemImageConfig) ?? UIImage()
    }
}
