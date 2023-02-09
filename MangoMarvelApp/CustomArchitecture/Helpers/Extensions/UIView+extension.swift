//
//  View+extension.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit

extension UIView {

    @discardableResult
    func constrainEdges(to view2: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            self.leadingAnchor.constraint(equalTo: view2.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: view2.trailingAnchor, constant: -insets.right),
            self.topAnchor.constraint(equalTo: view2.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: view2.bottomAnchor, constant: -insets.bottom)
        ]
        NSLayoutConstraint.activate(constraints)

        return constraints
    }
}
