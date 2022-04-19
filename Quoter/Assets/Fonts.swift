//
//  Fonts.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/17/22.
//

import UIKit

class CustomFont {
    
    func defaultFont(size: CGFloat) -> UIFont {
        UIFont(name: "Arial", size: size)!
    }
    
}

final class LibreBaskerville: CustomFont {
    
    static let styles = LibreBaskerville()
    
    private override init() {}
    
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

final class GoodTimes: CustomFont {
    
    static let styles = GoodTimes()
    
    private override init() {}
    
    func regular(size: CGFloat) -> UIFont {
        UIFont(name: "goodtimesrg", size: size) ?? defaultFont(size: size)
    }
}

class BusinessFonts {
    
    static let fonts = BusinessFonts()
    
    let libreBaskerville = LibreBaskerville.styles
    let goodTimes = GoodTimes.styles
    
    private init() {}
}

class Fonts {
    
    static let businessFonts = BusinessFonts.fonts
    
    private init() {}
    
}
