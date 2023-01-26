//
//  ComicCollectionViewCell.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit

class ComicCollectionViewCell: UICollectionViewCell {

    static let identifier = "ComicCollectionViewCell"

    private var content = ViewFactory.content()
    private var imageView = ViewFactory.image()
    private var title = ViewFactory.title()
    private var body = ViewFactory.body()
    private var imageHeightConstraint: NSLayoutConstraint?
    private var imageWidthConstraint: NSLayoutConstraint?

    private var constraintSet = false

    private var model: ComicDTO?

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
        contentView.addSubview(imageView)
        contentView.addSubview(content)
        contentView.addSubview(title)
        contentView.addSubview(body)
        contentView.bringSubviewToFront(content)

        content.addArrangedSubview(title)
        content.addArrangedSubview(body)

        imageView.clipsToBounds = true
        imageView.alpha = 0.5
        body.textColor = .darkGray
    }

    private func setupConstraints() {

        guard !constraintSet else { return }
        constraintSet = true
        imageView.constrainEdges(to: contentView)
        content.constrainEdges(
            to: contentView,
            insets: .init(top: Constants.padding, left: Constants.padding, bottom: Constants.padding, right: Constants.padding)
        )
        title.setContentHuggingPriority(.defaultHigh, for: .vertical)
        body.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    func set(model: ComicDTO?) {
        self.model = model
        guard let model = model else { return }
        title.text = model.title
        body.text = model.body

        if let image = model.image {
            self.imageView.image = image
        } else if let url = model.imageURL {
            //TODO: Include cache https://medium.com/@srits.ashish/how-to-download-image-asynchronously-in-uitableviewcell-using-nscache-abbf02cb1e12
            ImageRemote.downloadImage(from: url, completion: { [weak self] image in
                self?.model?.image = image
                DispatchQueue.main.async {
                    self?.imageView.image = image ?? Constants.placeholderImage
                }
            })
        } else {
            self.imageView.image = Constants.placeholderImage
        }
    }

    func updateConstraints(cellSize: CGSize?) {
        guard let cellSize else { return }
        if imageHeightConstraint == nil {
            imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: cellSize.height)
            imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: cellSize.width)
        } else {
            imageHeightConstraint?.constant = cellSize.height
            imageWidthConstraint?.constant = cellSize.width
        }
//        imageHeightConstraint?.isActive = true
//        imageWidthConstraint?.isActive = true
    }

    private enum Constants {
        static let padding: CGFloat = 10.0
        static let imagePercentage: CGFloat = 0.70
        static let placeholderImage = UIImage(contentsOfFile: "placeholderImage")
    }
}

extension ComicCollectionViewCell {

    enum ViewFactory {

        static func content() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fill
            stack.alignment = .fill
            stack.spacing = 0
            return stack
        }

        static func image() -> UIImageView {
            let imageview =  UIImageView()
            imageview.contentMode = .scaleAspectFill
            return imageview
        }

        static func title() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16, weight: .black)
            label.numberOfLines = 0
            label.textAlignment = .left
            return label
        }

        static func body() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 10, weight: .light)
            label.numberOfLines = 0
            label.textAlignment = .left
            return label
        }
    }
}
