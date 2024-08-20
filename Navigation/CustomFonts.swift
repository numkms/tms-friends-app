//
//  CustomFonts.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 19.08.2024.
//

import Foundation
import UIKit


enum Fonts {
    static let regularText: UIFont = .init(name: "Roboto-Regular", size: 14)!
    static let headingText: UIFont = .init(name: "Roboto-Regular", size: 24)!
}


extension UIFont {
    
    func robotoRegular(with size: CGFloat) -> UIFont  {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
}
