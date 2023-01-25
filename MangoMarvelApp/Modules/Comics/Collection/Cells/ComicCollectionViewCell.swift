//
//  ComicCollectionViewCell.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit

class ComicCollectionViewCell: UICollectionViewCell {

    static let identifier = "ComicCollectionViewCell"

    private var container = ViewFactory.container()
    private var content = ViewFactory.container()
    private var image = ViewFactory.image()
    private var title = ViewFactory.title()
    private var body = ViewFactory.body()

    private var constraintSet = false

    var model: ComicDTO? {
        didSet {
            setupModel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        setupModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupConstraints()
    }

    private func setupSubViews() {
        contentView.addSubview(container)
        contentView.addSubview(image)
        contentView.addSubview(content)
        contentView.addSubview(title)
        contentView.addSubview(body)

        container.addArrangedSubview(image)
        container.addArrangedSubview(content)

        content.addArrangedSubview(title)
        content.addArrangedSubview(body)
    }

    private func setupConstraints() {

        guard !constraintSet else { return }
        constraintSet = true

        container.constrainEdges(
            to: contentView,
            insets: .init(top: 0, left: Constants.padding, bottom: 0, right: Constants.padding)
        )
        image.heightAnchor.constraint(equalToConstant: contentView.frame.size.height * Constants.imagePercentage).isActive = true
        title.setContentHuggingPriority(.defaultHigh, for: .vertical)
        body.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    private func setupModel() {
        guard let model = model else { return }
        title.text = model.title
        body.text = model.body
    }

    private enum Constants {
        static let padding: CGFloat = 10.0
        static let imagePercentage: CGFloat = 0.75
    }
}

extension ComicCollectionViewCell {

    enum ViewFactory {
        static func container() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fill
            stack.alignment = .fill
            stack.spacing = 0
            return stack
        }

        static func content() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fill
            stack.alignment = .fill
            stack.spacing = 0
            return stack
        }

        static func image() -> UIImageView {
            let imageview =  UIImageView(image: nil)
            imageview.contentMode = .scaleAspectFit
            if #available(iOS 13.0, *) {
                return UIImageView(image: UIImage(systemName: "house"))
            }
            return imageview
        }

        static func title() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            label.numberOfLines = 0
            label.textAlignment = .left
            return label
        }

        static func body() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 10, weight: .light)
            label.textColor = .lightGray
            label.numberOfLines = 0
            label.textAlignment = .left
            return label
        }
    }
}
