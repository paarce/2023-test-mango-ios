//
//  File.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 31/1/23.
//

import UIKit

struct Theme {

    enum Colors {
        static let title: UIColor = UIColor(named: "titleColor") ?? .darkText
        static let body: UIColor = UIColor(named: "body") ?? .lightText
        static let subheading: UIColor = UIColor(named: "subheading") ?? .lightText
        static let favorite: UIColor = UIColor(named: "favorite") ?? .lightGray
    }

}

extension UIColor {
    static let thTitle = Theme.Colors.title
    static let thBody = Theme.Colors.body
    static let thSubheading = Theme.Colors.subheading
    static let thFavorite = Theme.Colors.favorite
}
