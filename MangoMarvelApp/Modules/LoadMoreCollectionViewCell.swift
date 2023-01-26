//
//  LoadMoreCollectionViewCell.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import UIKit

class LoadMoreCollectionViewCell: UICollectionViewCell {

    static let identifier = "LoadMoreCollectionViewCell"

    private var body = ViewFactory.body()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupConstraints()
    }

    private func setupSubViews() {
        contentView.addSubview(body)
        body.text = "Loading more..."
    }

    private func setupConstraints() {
        body.constrainEdges(to: contentView)
    }

    enum ViewFactory {
        static func body() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }
    }
}

