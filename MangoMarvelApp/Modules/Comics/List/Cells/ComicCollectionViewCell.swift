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
    private var interactionStack = ViewFactory.interaction()
    private var fav = ViewFactory.fav()

    private var constraintSet = false

    private var model: ComicCellViewModel?

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
        contentView.addSubview(interactionStack)
        contentView.addSubview(fav)
        contentView.bringSubviewToFront(content)

        content.addArrangedSubview(title)
        content.addArrangedSubview(body)
        content.addArrangedSubview(interactionStack)

        interactionStack.addArrangedSubview(fav)

        imageView.clipsToBounds = true
        imageView.alpha = Constants.imageOpacity

        fav.addTarget(self, action:  #selector(addFav(button:)), for: .touchUpInside)
    }

    private func setupConstraints() {

        guard !constraintSet else { return }
        constraintSet = true
        imageView.constrainEdges(to: contentView)
        content.constrainEdges(
            to: contentView,
            insets: .init(top: Constants.padding, left: Constants.padding, bottom: Constants.padding, right: Constants.padding)
        )
//        title.setContentHuggingPriority(.defaultLow, for: .vertical)
//        body.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        interactionStack.setContentHuggingPriority(.defaultLow, for: .vertical)
//        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }

    func set(model: ComicCellViewModel?) {
        self.model = model
        guard let model = model else { return }
        title.text = model.dto.title
        body.text = model.dto.body

        fav.setImage(model.favButtonImage, for: .normal)

        if let image = model.image {
            self.imageView.image = image
        } else if let url = model.dto.thumbnailURL {
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


    private func updateDynamicComponents() {
        guard let model = model else { return }
        fav.setImage(model.favButtonImage, for: .normal)
    }

    @objc
    private func addFav(button: UIButton) {
        model?.isFav.toggle()
        updateDynamicComponents()
    }

    private enum Constants {
        static let imageOpacity: CGFloat = 0.3
        static let padding: CGFloat = 10.0
        static let imagePercentage: CGFloat = 0.70
        static let placeholderImage = UIImage(named: "placeholderImage")
    }
}

extension ComicCollectionViewCell {

    enum ViewFactory {

        static func content() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fill
            stack.alignment = .fill
            stack.spacing = 8
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
            label.textColor = .thTitle
            return label
        }

        static func body() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
            label.numberOfLines = 4
            label.textAlignment = .left
            label.textColor = .thBody
            return label
        }

        static func interaction() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.alignment = .trailing
            stack.spacing = 0
            return stack
        }

        static func fav() -> UIButton {
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .black)
            button.titleEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
            button.tintColor = .thFavorite
            return button
        }

        static func spacer() -> UIView {
            UIView()
        }
    }
}
