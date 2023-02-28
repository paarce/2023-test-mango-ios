//
//  ComicImagesTableViewCell.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 30/1/23.
//

import UIKit

class ComicImagesTableViewCell: UITableViewCell {

    static let identifier = "ComicImagesTableViewCell"

    private var image = ViewFactory.image()
    private var imageHeight: NSLayoutConstraint?
    private var url: URL?
    private var imageFetched: UIImage?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubViews() {
        contentView.addSubview(image)

        image.image = Constants.placeholderImage
        image.clipsToBounds = true
    }

    private func setupConstraints() {

        image.constrainEdges(to: contentView)
        imageHeight = image.heightAnchor.constraint(equalToConstant: Constants.cellHeight)
        imageHeight?.isActive  = true
    }

    func set(url: URL?) {
        if let url = url {
            UIRemoteImage.downloadImage(from: url, completion: { [weak self] imageFetched in
                self?.set(image: imageFetched)
            })
        } else {
            self.image.image = Constants.placeholderImage
        }
    }

    private func set(image: UIImage?) {

        DispatchQueue.main.async {
            guard let imageSize = image?.size else { return }
            let ratio = imageSize.height / imageSize.width
            self.imageHeight?.constant = ratio * UIScreen.main.bounds.width
            self.imageHeight?.isActive = true
            self.image.image = image ?? Constants.placeholderImage
        }
    }

    private enum Constants {
        static let cellHeight: CGFloat = 300.0
        static let placeholderImage = UIImage(contentsOfFile: "placeholderImage")
    }

}

extension ComicImagesTableViewCell {

    enum ViewFactory {

        static func image() -> UIImageView {
            let imageview =  UIImageView()
            imageview.contentMode = .scaleAspectFill
            return imageview
        }
    }
}
