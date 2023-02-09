//
//  ComicCreatorTableViewCell.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 30/1/23.
//

import UIKit

struct GridItem {
    let title: String
    let subtitle: String?
}

class ComicGridTableViewCell: UITableViewCell {

    static let identifier = "ComicGridTableViewCell"

    private var container = ViewFactory.container()
    private var heaading = ViewFactory.heading()
    private var grid: UIStackView?
    private var items: [GridItem]?


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

        container.addArrangedSubview(heaading)
    }

    private func setupConstraints() {

        container.constrainEdges(to: contentView, insets: Constants.padding)
    }

    func set(title: String, items: [GridItem]) {
        self.items = items
        heaading.text = title

        if let grid {
            container.removeArrangedSubview(grid)
            grid.removeFromSuperview()
        }

        grid = ViewFactory.container()

        if items.isEmpty {
            let body = ViewFactory.body()
            body.text = "COMICS_DETAIL_SECTION_EMPTY_CONTENT".localized
            grid!.addArrangedSubview(body)

        } else {

            let contents = items.map { content(item: $0) }
            let count = (Float(items.count) / Float(Constants.columns)).rounded(.up)
            for multiply in (0..<Int(count)) {
                let row = ViewFactory.row()
                row.addArrangedSubview(contents[multiply * Constants.columns])
                let next = (multiply * Constants.columns) + 1
                if contents.count > next {
                    row.addArrangedSubview(contents[next])
                }
                grid!.addArrangedSubview(row)
            }
        }

        container.addArrangedSubview(grid!)

    }

    private func content(item: GridItem) -> UIStackView {

        let content = ViewFactory.content()
        let title = ViewFactory.title()
        let body = ViewFactory.body()
        title.text = item.title
        body.text = item.subtitle
        content.addArrangedSubview(title)
        content.addArrangedSubview(body)
        return content
    }

    private enum Constants {
        static let padding: UIEdgeInsets = .init(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        static let columns = 2
    }
}


extension ComicGridTableViewCell {

    enum ViewFactory {

        static func container() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fill
            stack.alignment = .fill
            stack.spacing = 8
            return stack
        }

        static func row() -> UIStackView {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.alignment = .leading
            stack.spacing = 8
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

        static func heading() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16, weight: .black)
            label.numberOfLines = 0
            label.textAlignment = .left
            label.textColor = .thTitle
            return label
        }

        static func title() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            label.numberOfLines = 0
            label.textAlignment = .left
            label.textColor = .thSubheading
            return label
        }

        static func body() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 10, weight: .light)
            label.numberOfLines = 0
            label.textAlignment = .left
            label.textColor = .thBody
            return label
        }
        static func spacer() -> UIView {
            UIView()
        }
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        let views = self.arrangedSubviews.filter({ $0 is UIStackView })
        for view in views {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
