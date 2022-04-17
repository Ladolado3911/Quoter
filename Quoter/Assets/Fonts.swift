//
//  Fonts.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/17/22.
//

import UIKit

final class LibreBaskerville {
    
    static let styles = LibreBaskerville()
    
    private init() {}
    
    func defaultFont(size: CGFloat) -> UIFont {
        UIFont(name: "Arial", size: size)!
    }
    
    func italic(size: CGFloat) -> UIFont {
        UIFont(name: "LibreBaskerville-Italic", size: size) ?? defaultFont(size: size)
    }
    
    func regular(size: CGFloat) -> UIFont {
        UIFont(name: "LibreBaskerville-Regular", size: size) ?? defaultFont(size: size)
    }
    
    func bold(size: CGFloat) -> UIFont {
        UIFont(name: "LibreBaskerville-Bold", size: size) ?? defaultFont(size: size)
    }
}

class BusinessFonts {
    
    static let fonts = BusinessFonts()
    
    let libreBaskerville = LibreBaskerville.styles
    
    private init() {}
}

class Fonts {
    
    static let businessFonts = BusinessFonts.fonts
    
    private init() {}
    
}
