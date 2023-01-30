//
//  ComicBasicInfoTableViewCell.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 30/1/23.
//

import UIKit

class ComicBasicInfoTableViewCell: UITableViewCell {

    static let identifier = "ComicBasicInfoTableViewCell"

    private var container = ViewFactory.container()
    private var row = ViewFactory.row()

    private var title = ViewFactory.titleLabel()
    private var body = ViewFactory.contentLabel()

    private var pricesContent = ViewFactory.content()
    private var pricesLabel = ViewFactory.titleLabel()
    private var prices = ViewFactory.contentLabel()
    private var idContent = ViewFactory.content()
    private var idLabel = ViewFactory.titleLabel()
    private var id = ViewFactory.contentLabel()
    private var dateReleaseContent = ViewFactory.content()
    private var dateReleaseLabel = ViewFactory.titleLabel()
    private var dateRelease = ViewFactory.contentLabel()

    private var model: ComicDTO?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubViews() {

        contentView.addSubview(container)

        container.addArrangedSubview(title)

        idLabel.text = Constants.Labels.id
        idContent.addArrangedSubview(idLabel)
        idContent.addArrangedSubview(id)
        row.addArrangedSubview(idContent)

        dateReleaseLabel.text = Constants.Labels.dateRelease
        dateReleaseContent.addArrangedSubview(dateReleaseLabel)
        dateReleaseContent.addArrangedSubview(dateRelease)
        row.addArrangedSubview(dateReleaseContent)

        pricesLabel.text = Constants.Labels.price
        pricesContent.addArrangedSubview(pricesLabel)
        pricesContent.addArrangedSubview(prices)
        row.addArrangedSubview(pricesContent)

        container.addArrangedSubview(row)
        container.addArrangedSubview(body)
    }

    private func setupConstraints() {

        container.constrainEdges(
            to: contentView,
            insets: Constants.padding
        )
        container.setContentCompressionResistancePriority(.required, for: .vertical)
        body.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

    }

    func set(model: ComicDTO?) {
        self.model = model
        guard let model = model else { return }

        title.text = model.title
        id.text = String(model.id)
        body.text = model.body
        dateRelease.text = "Dic 23th 2000"
        prices.text = model.price
    }

    private enum Constants {
        static let padding: UIEdgeInsets = .init(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        enum Labels {
            static let id = "ID:"
            static let price = "Price:"
            static let dateRelease = "Release:"
        }
    }
}

extension ComicBasicInfoTableViewCell {

    enum ViewFactory {

        static func container() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fill
            stack.alignment = .fill
            stack.spacing = 16

            return stack
        }

        static func content() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .equalSpacing
            stack.alignment = .leading
            stack.spacing = 0

            return stack
        }

        static func row() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.alignment = .fill
            stack.spacing = 0

            return stack
        }

        static func titleLabel() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16, weight: .black)
            label.numberOfLines = 0
            label.textAlignment = .left

            return label
        }

        static func contentLabel() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13, weight: .light)
            label.numberOfLines = 0
            label.textAlignment = .left

            return label
        }
    }
}
