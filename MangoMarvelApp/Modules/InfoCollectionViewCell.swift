//
//  InfoCollectionViewCell.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit

struct InfoCellModel {
    let image: UIImage
    let messasge: String
}

class InfoCollectionViewCell: UICollectionViewCell {

    static let identifier = "InfoCollectionViewCell"

    private var content = ViewFactory.content()
    private var imageView = ViewFactory.image()
    private var body = ViewFactory.body()
    private var model: InfoCellModel = .init(image: UIImage(contentsOfFile: "placeholderImage")!, messasge: "ERRRORRRRRRR")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubViews() {
        contentView.addSubview(content)
        contentView.addSubview(imageView)
        contentView.addSubview(body)

        content.addArrangedSubview(imageView)
        content.addArrangedSubview(body)
    }

    private func setupConstraints() {

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        content.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        content.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

extension InfoCollectionViewCell {

    enum ViewFactory {

        static func content() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fill
            stack.alignment = .center
            stack.spacing = 0
            return stack
        }

        static func image() -> UIImageView {
            let imageview =  UIImageView()
            imageview.contentMode = .scaleAspectFit
            return imageview
        }

        static func body() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }
    }
}
