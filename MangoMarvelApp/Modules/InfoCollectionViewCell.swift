//
//  InfoCollectionViewCell.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit

struct InfoCellModel {
    let image: UIImage?
    let messasge: String

    init(error: ErrorDTO) {
        image = nil
        messasge = error.message
    }

    init(loadingMessage: String) {
        image = UIImage(named: "loadingIimage")
        messasge = loadingMessage
    }

    init(emptyMessage: String) {
        image = nil
        messasge = emptyMessage
    }
}

class InfoCollectionViewCell: UICollectionViewCell {

    static let identifier = "InfoCollectionViewCell"

    private var content = ViewFactory.content()
    private var imageView = ViewFactory.image()
    private var body = ViewFactory.body()
    private var model: InfoCellModel?

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
        contentView.addSubview(content)
        contentView.addSubview(imageView)
        contentView.addSubview(body)

        content.addArrangedSubview(imageView)
        content.addArrangedSubview(body)
    }

    private func setupConstraints() {

        imageView.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        content.heightAnchor.constraint(equalToConstant: 200).isActive = true
        content.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        content.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -100.0).isActive = true
    }

    func set(model: InfoCellModel?) {
        guard let model = model else { return }
        imageView.image = model.image ?? Constants.placeholderImage
        body.text = model.messasge
    }

    private enum Constants {
        static let placeholderImage = UIImage(contentsOfFile: "placeholderImage")
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
